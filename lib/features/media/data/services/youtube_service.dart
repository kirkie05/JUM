import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yte;
import 'package:dio/dio.dart';
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

    // Get the uploads playlist of the channel
    final uploadsList = await _yt.channels.getUploads(channelId).take(count).toList();

    final List<MediaItem> items = [];
    for (final video in uploadsList) {
      String durationStr = '';
      if (video.duration != null) {
        final minutes = video.duration!.inMinutes;
        final seconds = video.duration!.inSeconds.remainder(60).toString().padLeft(2, '0');
        durationStr = '$minutes:$seconds';
      }

      items.add(MediaItem(
        id: 'youtube-${video.id.value}',
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
