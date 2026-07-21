import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yte;
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as hp;
import 'package:html/dom.dart';
import '../models/media_item.dart';

class YoutubeService {
  final _yt = yte.YoutubeExplode();
  final _dio = Dio();

  /// Resolve the Channel ID dynamically from the environment configuration.
  /// If only a Channel URL is provided, automatically resolve the Channel ID.
  Future<String?> resolveChannelId() async {
    final envId = dotenv.env['YOUTUBE_CHANNEL_ID'];
    if (envId != null && envId.trim().isNotEmpty) {
      return envId.trim();
    }

    final envUrl = dotenv.env['YOUTUBE_CHANNEL_URL'];
    if (envUrl == null || envUrl.trim().isEmpty) {
      return null;
    }

    try {
      final url = envUrl.trim();
      // If it contains a handle @name
      final handleMatch = RegExp(r'@([a-zA-Z0-9_\-\.]+)').firstMatch(url);
      if (handleMatch != null) {
        final handle = handleMatch.group(0)!; // e.g. @jesusunhinderedministry
        final channel = await _yt.channels.getByHandle(handle);
        return channel.id.value;
      }

      // If it is a direct channel ID url like /channel/UC...
      final channelIdMatch = RegExp(r'channel/(UC[a-zA-Z0-9_\-]+)').firstMatch(url);
      if (channelIdMatch != null) {
        return channelIdMatch.group(1);
      }

      // If it is a custom URL or username url
      final userMatch = RegExp(r'user/([a-zA-Z0-9_\-]+)').firstMatch(url);
      if (userMatch != null) {
        final channel = await _yt.channels.getByUsername(userMatch.group(1)!);
        return channel.id.value;
      }
    } catch (e) {
      debugPrint('[YOUTUBE_SERVICE] Error resolving Channel ID: $e');
    }
    return null;
  }

  List<Element> _descendants(Element element) {
    final list = <Element>[];
    for (final child in element.children) {
      list.add(child);
      list.addAll(_descendants(child));
    }
    return list;
  }

  Future<List<MediaItem>> fetchRssUploads(String channelIdStr, String channelTitle) async {
    final List<MediaItem> items = [];
    try {
      final url = 'https://www.youtube.com/feeds/videos.xml?channel_id=$channelIdStr';
      final response = await _dio.get<String>(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );
      if (response.data != null) {
        final document = hp.parse(response.data);
        final entries = document.getElementsByTagName('entry');
        for (final entry in entries) {
          String? title;
          String? videoId;
          DateTime? publishedAt;
          String? thumbnailUrl;
          String? description;

          for (final child in entry.children) {
            if (child.localName == 'title') {
              title = child.text;
            } else if (child.localName == 'yt:videoid') {
              videoId = child.text;
            } else if (child.localName == 'published') {
              publishedAt = DateTime.tryParse(child.text);
            }
          }

          for (final descendant in _descendants(entry)) {
            if (descendant.localName == 'media:thumbnail') {
              thumbnailUrl = descendant.attributes['url'];
            } else if (descendant.localName == 'media:description') {
              description = descendant.text;
            }
          }

          if (videoId != null && title != null) {
            items.add(MediaItem(
              id: 'youtube-$videoId',
              type: MediaItemType.video,
              title: title,
              sourceName: channelTitle,
              sourceUrl: 'https://www.youtube.com/watch?v=$videoId',
              thumbnailUrl: thumbnailUrl ?? 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg',
              description: description,
              publishedAt: publishedAt,
              duration: '',
              isLive: false,
            ));
          }
        }
      }
    } catch (e) {
      debugPrint('[YOUTUBE_SERVICE] Error fetching RSS uploads: $e');
    }
    return items;
  }

  /// Fetch videos uploaded to the configured channel.
  Future<List<MediaItem>> fetchChannelUploads({int count = 50}) async {
    final channelIdStr = await resolveChannelId();
    if (channelIdStr == null) {
      throw Exception('Could not resolve YouTube Channel ID from environment variables.');
    }

    final channelId = yte.ChannelId(channelIdStr);
    
    // Retrieve channel metadata to get channel title/author
    String channelTitle = 'Jesus Unhindered Ministry';
    try {
      final channel = await _yt.channels.get(channelId);
      channelTitle = channel.title;
    } catch (e) {
      debugPrint('[YOUTUBE_SERVICE] Could not fetch channel title, using default: $e');
    }

    final List<MediaItem> items = [];

    // 1. Try RSS feed first to get the absolute latest videos instantly
    try {
      final rssItems = await fetchRssUploads(channelIdStr, channelTitle);
      items.addAll(rssItems);
      debugPrint('[YOUTUBE_SERVICE] Fetched ${rssItems.length} videos from RSS feed.');
    } catch (e) {
      debugPrint('[YOUTUBE_SERVICE] RSS fetch failed: $e');
    }

    final existingIds = items.map((e) => e.id).toSet();

    // 2. Attempt standard uploads playlist fetch to get additional videos
    try {
      final uploadsList = await _yt.channels.getUploads(channelId).take(count).toList();
      for (final video in uploadsList) {
        final videoId = 'youtube-${video.id.value}';
        if (existingIds.contains(videoId)) continue;

        String durationStr = '';
        if (video.duration != null) {
          final minutes = video.duration!.inMinutes;
          final seconds = video.duration!.inSeconds.remainder(60).toString().padLeft(2, '0');
          durationStr = '$minutes:$seconds';
        }

        items.add(MediaItem(
          id: videoId,
          type: MediaItemType.video,
          title: video.title,
          sourceName: video.author.isNotEmpty ? video.author : channelTitle,
          sourceUrl: 'https://www.youtube.com/watch?v=${video.id.value}',
          thumbnailUrl: video.thumbnails.highResUrl.isNotEmpty
              ? video.thumbnails.highResUrl
              : video.thumbnails.mediumResUrl,
          description: video.description,
          publishedAt: video.uploadDate,
          duration: durationStr,
          viewCount: video.engagement.viewCount,
          isLive: video.isLive,
        ));
        existingIds.add(videoId);
      }
    } catch (e) {
      debugPrint('[YOUTUBE_SERVICE] Error fetching direct uploads list: $e');
    }

    // 3. Fallback: Use search client if direct uploads and RSS returned nothing
    if (items.isEmpty) {
      debugPrint('[YOUTUBE_SERVICE] Direct uploads and RSS empty. Falling back to handle-based search scraper...');
      try {
        final envUrl = dotenv.env['YOUTUBE_CHANNEL_URL'];
        final handle = envUrl != null && envUrl.contains('@')
            ? '@' + envUrl.split('@').last.split('/').first
            : '@jesusunhinderedministry';

        final searchList = await _yt.search.search(handle);
        for (final video in searchList) {
          if (video.channelId.value == channelIdStr) {
            final videoId = 'youtube-${video.id.value}';
            if (existingIds.contains(videoId)) continue;

            String durationStr = '';
            if (video.duration != null) {
              final minutes = video.duration!.inMinutes;
              final seconds = video.duration!.inSeconds.remainder(60).toString().padLeft(2, '0');
              durationStr = '$minutes:$seconds';
            }

            items.add(MediaItem(
              id: videoId,
              type: MediaItemType.video,
              title: video.title,
              sourceName: video.author.isNotEmpty ? video.author : channelTitle,
              sourceUrl: 'https://www.youtube.com/watch?v=${video.id.value}',
              thumbnailUrl: video.thumbnails.highResUrl.isNotEmpty
                  ? video.thumbnails.highResUrl
                  : video.thumbnails.mediumResUrl,
              description: video.description,
              publishedAt: video.uploadDate,
              duration: durationStr,
              viewCount: video.engagement.viewCount,
              isLive: video.isLive,
            ));
            existingIds.add(videoId);
          }
        }
      } catch (searchError) {
        debugPrint('[YOUTUBE_SERVICE] Fallback search scraper failed: $searchError');
      }
    }

    return items;
  }

  /// Check if the channel is currently broadcasting a live stream.
  /// Uses a HTTP redirect check on the channel's "/live" endpoint which redirects
  /// to the live video watch page if a broadcast is active.
  Future<MediaItem?> checkLiveStream() async {
    final channelId = await resolveChannelId();
    if (channelId == null) return null;

    try {
      final liveUrl = 'https://www.youtube.com/channel/$channelId/live';
      
      // Perform GET request with redirect following disabled to check if we are redirected to /watch?v=
      final response = await _dio.get<String>(
        liveUrl,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status != null && status < 400,
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );

      // Check if location header points to a watch url
      final location = response.headers.value('location');
      if (location != null && location.contains('watch?v=')) {
        final uri = Uri.parse(location);
        final videoId = uri.queryParameters['v'];
        if (videoId != null && videoId.isNotEmpty) {
          final video = await _yt.videos.get(videoId);
          if (video.isLive) {
            return MediaItem(
              id: 'youtube-${video.id.value}',
              type: MediaItemType.video,
              title: video.title,
              sourceName: video.author,
              sourceUrl: 'https://www.youtube.com/watch?v=${video.id.value}',
              thumbnailUrl: video.thumbnails.highResUrl,
              description: video.description,
              publishedAt: video.uploadDate ?? DateTime.now(),
              isLive: true,
              viewCount: video.engagement.viewCount,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('[YOUTUBE_SERVICE] Error checking live stream: $e');
    }

    // Fallback: search for active live streams on the channel
    try {
      final searchResults = await _yt.search.search('live', filter: yte.TypeFilters.video);
      for (final result in searchResults) {
        final video = await _yt.videos.get(result.id);
        if (video.isLive && video.channelId.value == channelId) {
          return MediaItem(
            id: 'youtube-${video.id.value}',
            type: MediaItemType.video,
            title: video.title,
            sourceName: video.author,
            sourceUrl: 'https://www.youtube.com/watch?v=${video.id.value}',
            thumbnailUrl: video.thumbnails.highResUrl,
            description: video.description,
            publishedAt: video.uploadDate ?? DateTime.now(),
            isLive: true,
            viewCount: video.engagement.viewCount,
          );
        }
      }
    } catch (e) {
      debugPrint('[YOUTUBE_SERVICE] Fallback live stream search failed: $e');
    }

    return null;
  }

  void dispose() {
    _yt.close();
    _dio.close();
  }
}
