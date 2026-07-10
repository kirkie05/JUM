import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/parser.dart' show parseFragment;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yte;
import 'package:dio/dio.dart';
import '../models/media_item.dart';

class YoutubeService {
  final _yt = yte.YoutubeExplode();
  final _dio = Dio();

  static const String _videosCacheKey = 'youtube_videos_cache';
  static const String _playlistsCacheKey = 'youtube_playlists_cache';

  String get _channelId {
    return (dotenv.env['YOUTUBE_CHANNEL_ID'] ?? MediaChannelConfig.defaults.youtubeChannelId).trim();
  }

  String get _channelTitle {
    return "Jesus Unhindered Ministry";
  }

  String _decodeHtml(String text) {
    try {
      return parseFragment(text).text ?? text;
    } catch (_) {
      return text;
    }
  }

  // Parse YouTube RSS Feed for immediate retrieval of latest 15 videos
  Future<List<MediaItem>> fetchLatestVideos({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Return cache immediately if available and forceRefresh is false
    if (!forceRefresh) {
      final cachedJson = prefs.getString(_videosCacheKey);
      if (cachedJson != null) {
        try {
          final List decoded = json.decode(cachedJson);
          return decoded.map((item) => MediaItem.fromJson(item)).toList();
        } catch (e) {
          debugPrint('[YT_SERVICE] Error decoding cached videos: $e');
        }
      }
    }

    // 2. Fetch live data
    try {
      final feedUrl = 'https://www.youtube.com/feeds/videos.xml?channel_id=$_channelId';
      final response = await _dio.get<String>(
        feedUrl,
        options: Options(
          receiveTimeout: const Duration(seconds: 8),
          sendTimeout: const Duration(seconds: 8),
        ),
      );

      final xml = response.data ?? '';
      final parsedEntries = _parseRssFeed(xml);

      final List<MediaItem> items = [];
      for (final entry in parsedEntries) {
        final videoId = entry['id']!;
        final title = _decodeHtml(entry['title']!);
        final description = _decodeHtml(entry['description']!);
        final publishedStr = entry['published']!;
        final publishedAt = DateTime.tryParse(publishedStr) ?? DateTime.now();
        final thumbnailUrl = entry['thumbnail']!;

        // Retrieve duration and view counts from details cache
        final detailCacheKey = 'yt_detail_$videoId';
        final cachedDetailStr = prefs.getString(detailCacheKey);
        String? duration;
        int? viewCount;

        if (cachedDetailStr != null) {
          try {
            final Map detail = json.decode(cachedDetailStr);
            duration = detail['duration'];
            viewCount = detail['viewCount'];
          } catch (_) {}
        }

        items.add(MediaItem(
          id: 'youtube-$videoId',
          type: MediaItemType.video,
          title: title,
          sourceName: _channelTitle,
          sourceUrl: 'https://www.youtube.com/watch?v=$videoId',
          thumbnailUrl: thumbnailUrl,
          description: description,
          publishedAt: publishedAt,
          duration: duration,
          viewCount: viewCount,
        ));
      }

      // 3. Save to cache
      final itemsJson = json.encode(items.map((e) => e.toJson()).toList());
      await prefs.setString(_videosCacheKey, itemsJson);

      // 4. Lazy load detailed info (durations, views) in the background
      _lazyLoadVideoDetails(items);

      return items;
    } catch (e) {
      debugPrint('[YT_SERVICE] Live fetch failed, returning cache if exists: $e');
      // If network fails, try to load cache anyway
      final cachedJson = prefs.getString(_videosCacheKey);
      if (cachedJson != null) {
        final List decoded = json.decode(cachedJson);
        return decoded.map((item) => MediaItem.fromJson(item)).toList();
      }
      return [];
    }
  }

  // Parses entries from RSS XML
  List<Map<String, String>> _parseRssFeed(String xml) {
    final List<Map<String, String>> entries = [];
    final matches = RegExp(r'<entry>([\s\S]*?)<\/entry>', multiLine: true).allMatches(xml);

    for (final match in matches) {
      final entry = match.group(1) ?? '';
      
      final videoIdMatch = RegExp(r'<yt:videoId>([^<]+)<\/yt:videoId>').firstMatch(entry);
      final titleMatch = RegExp(r'<title>([^<]+)<\/title>').firstMatch(entry);
      final descriptionMatch = RegExp(r'<media:description>([^<]+)<\/media:description>').firstMatch(entry);
      final publishedMatch = RegExp(r'<published>([^<]+)<\/published>').firstMatch(entry);
      final thumbnailMatch = RegExp(r'<media:thumbnail\s+url="([^"]+)"').firstMatch(entry);

      final videoId = videoIdMatch?.group(1) ?? '';
      final title = titleMatch?.group(1) ?? '';
      final description = descriptionMatch?.group(1) ?? '';
      final published = publishedMatch?.group(1) ?? '';
      final thumbnailUrl = thumbnailMatch?.group(1) ?? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

      if (videoId.isNotEmpty) {
        entries.add({
          'id': videoId,
          'title': title,
          'description': description,
          'published': published,
          'thumbnail': thumbnailUrl,
        });
      }
    }
    return entries;
  }

  // Load detailed video parameters from YouTube Explode asynchronously
  Future<void> _lazyLoadVideoDetails(List<MediaItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    bool cacheUpdated = false;

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final videoId = item.id.replaceFirst('youtube-', '');
      final detailCacheKey = 'yt_detail_$videoId';

      if (prefs.containsKey(detailCacheKey)) continue;

      try {
        final video = await _yt.videos.get(videoId);
        final rawDuration = video.duration;
        String formattedDuration = '';
        if (rawDuration != null) {
          final minutes = rawDuration.inMinutes;
          final seconds = rawDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
          formattedDuration = '$minutes:$seconds';
        }

        final views = video.engagement.viewCount;

        // Cache details
        final detailsMap = {
          'duration': formattedDuration,
          'viewCount': views,
        };
        await prefs.setString(detailCacheKey, json.encode(detailsMap));

        // Update list in place
        items[i] = MediaItem(
          id: item.id,
          type: item.type,
          title: item.title,
          sourceName: item.sourceName,
          sourceUrl: item.sourceUrl,
          thumbnailUrl: item.thumbnailUrl,
          description: item.description,
          publishedAt: item.publishedAt,
          duration: formattedDuration,
          viewCount: views,
        );

        cacheUpdated = true;
      } catch (e) {
        debugPrint('[YT_SERVICE] Failed to lazy load details for video $videoId: $e');
      }
    }

    if (cacheUpdated) {
      final itemsJson = json.encode(items.map((e) => e.toJson()).toList());
      await prefs.setString(_videosCacheKey, itemsJson);
    }
  }

  // Fetch Playlists/Series matching the channel
  Future<List<MediaItem>> fetchPlaylists({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh) {
      final cachedJson = prefs.getString(_playlistsCacheKey);
      if (cachedJson != null) {
        try {
          final List decoded = json.decode(cachedJson);
          return decoded.map((item) => MediaItem.fromJson(item)).toList();
        } catch (_) {}
      }
    }

    try {
      final results = await _yt.search.search(_channelTitle, filter: yte.TypeFilters.playlist);
      final filteredPlaylists = results.where((p) => p.author.toLowerCase().contains(_channelTitle.toLowerCase())).toList();

      final items = filteredPlaylists.map((p) {
        return MediaItem(
          id: 'yt-playlist-${p.id.value}',
          type: MediaItemType.video,
          title: p.title,
          sourceName: _channelTitle,
          sourceUrl: 'https://www.youtube.com/playlist?list=${p.id.value}',
          thumbnailUrl: p.thumbnails.mediumResUrl,
          description: 'Playlist containing series of teachings and services.',
          publishedAt: DateTime.now(),
        );
      }).toList();

      final itemsJson = json.encode(items.map((e) => e.toJson()).toList());
      await prefs.setString(_playlistsCacheKey, itemsJson);

      return items;
    } catch (e) {
      debugPrint('[YT_SERVICE] Fetch playlists failed: $e');
      final cachedJson = prefs.getString(_playlistsCacheKey);
      if (cachedJson != null) {
        final List decoded = json.decode(cachedJson);
        return decoded.map((item) => MediaItem.fromJson(item)).toList();
      }
      return [];
    }
  }

  // Check if live stream is running
  Future<MediaItem?> checkLiveStream() async {
    try {
      final searchResults = await _yt.search.search('$_channelTitle live', filter: yte.TypeFilters.video);
      for (final result in searchResults) {
        if (result.author.toLowerCase().contains(_channelTitle.toLowerCase())) {
          // Double check if live
          final video = await _yt.videos.get(result.id);
          if (video.isLive) {
            return MediaItem(
              id: 'youtube-${video.id.value}',
              type: MediaItemType.video,
              title: video.title,
              sourceName: _channelTitle,
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
      debugPrint('[YT_SERVICE] Live stream check failed: $e');
    }
    return null;
  }

  // Search videos matching query
  Future<List<MediaItem>> search(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final searchResults = await _yt.search.search('$_channelTitle $query', filter: yte.TypeFilters.video);
      final List<MediaItem> items = [];
      for (final v in searchResults) {
        if (v.author.toLowerCase().contains(_channelTitle.toLowerCase())) {
          items.add(MediaItem(
            id: 'youtube-${v.id.value}',
            type: MediaItemType.video,
            title: v.title,
            sourceName: _channelTitle,
            sourceUrl: 'https://www.youtube.com/watch?v=${v.id.value}',
            thumbnailUrl: v.thumbnails.mediumResUrl,
            description: '',
            publishedAt: v.uploadDate ?? DateTime.now(),
          ));
        }
      }
      return items;
    } catch (e) {
      debugPrint('[YT_SERVICE] Search failed: $e');
      return [];
    }
  }

  // Helper method to retrieve single video details (cached or live)
  Future<MediaItem?> fetchVideoDetails(String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    final detailCacheKey = 'yt_detail_$videoId';
    
    String? duration;
    int? viewCount;

    final cachedDetailStr = prefs.getString(detailCacheKey);
    if (cachedDetailStr != null) {
      try {
        final Map detail = json.decode(cachedDetailStr);
        duration = detail['duration'];
        viewCount = detail['viewCount'];
      } catch (_) {}
    }

    try {
      final video = await _yt.videos.get(videoId);
      final title = video.title;
      final description = video.description;
      final publishedAt = video.uploadDate ?? DateTime.now();
      final thumbnailUrl = video.thumbnails.highResUrl;
      
      if (duration == null) {
        final rawDuration = video.duration;
        if (rawDuration != null) {
          final minutes = rawDuration.inMinutes;
          final seconds = rawDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
          duration = '$minutes:$seconds';
        }
      }
      viewCount ??= video.engagement.viewCount;

      // Save back to cache
      await prefs.setString(detailCacheKey, json.encode({
        'duration': duration,
        'viewCount': viewCount,
      }));

      return MediaItem(
        id: 'youtube-$videoId',
        type: MediaItemType.video,
        title: title,
        sourceName: _channelTitle,
        sourceUrl: 'https://www.youtube.com/watch?v=$videoId',
        thumbnailUrl: thumbnailUrl,
        description: description,
        publishedAt: publishedAt,
        duration: duration,
        viewCount: viewCount,
      );
    } catch (e) {
      debugPrint('[YT_SERVICE] Fetch video details failed: $e');
    }
    return null;
  }

  // Auto-categorize based on title/description keywords
  String getCategory(MediaItem item) {
    final title = item.title.toLowerCase();
    final desc = item.description?.toLowerCase() ?? '';

    if (title.contains('sunday service') || title.contains('sunday worship') || title.contains('fellowship')) {
      return 'Sunday Services';
    } else if (title.contains('bible study') || title.contains('study') || title.contains('spiritual vigilance')) {
      return 'Bible Study';
    } else if (title.contains('conference') || title.contains('summit') || title.contains('annual')) {
      return 'Conferences';
    } else if (title.contains('prayer') || title.contains('vigil') || title.contains('intercession')) {
      return 'Prayer';
    } else if (title.contains('leadership') || title.contains('leader')) {
      return 'Leadership';
    } else if (title.contains('youth') || title.contains('power')) {
      return 'Youth';
    } else if (title.contains('worship') || title.contains('carol') || title.contains('songs')) {
      return 'Worship';
    } else {
      return 'Special Messages';
    }
  }

  void dispose() {
    _yt.close();
    _dio.close();
  }
}
