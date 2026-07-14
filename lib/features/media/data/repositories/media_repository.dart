import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/media_item.dart';
import '../services/youtube_service.dart';

class MediaRepository {
  final YoutubeService _youtubeService;
  final SupabaseClient _supabase;

  static const String _localCacheKey = 'youtube_videos_local_cache';

  MediaRepository(this._youtubeService, this._supabase);

  /// Synchronize the local database (Supabase) with the latest videos from the channel.
  /// Also updates the local offline cache.
  Future<void> syncYoutubeMedia() async {
    try {
      debugPrint('[MEDIA_REPO] Syncing YouTube media...');
      // 1. Check for live stream and upsert if found
      final liveStream = await _youtubeService.checkLiveStream();
      if (liveStream != null) {
        await _supabase.from('youtube_videos').upsert({
          'id': liveStream.id,
          'title': liveStream.title,
          'description': liveStream.description,
          'thumbnail_url': liveStream.thumbnailUrl,
          'duration': liveStream.duration,
          'published_at': liveStream.publishedAt?.toIso8601String(),
          'source_name': liveStream.sourceName,
          'source_url': liveStream.sourceUrl,
          'is_live': true,
          'view_count': liveStream.viewCount,
        });
      }

      // 2. Fetch uploads and upsert into Supabase
      final uploads = await _youtubeService.fetchChannelUploads(count: 50);
      for (final video in uploads) {
        await _supabase.from('youtube_videos').upsert({
          'id': video.id,
          'title': video.title,
          'description': video.description,
          'thumbnail_url': video.thumbnailUrl,
          'duration': video.duration,
          'published_at': video.publishedAt?.toIso8601String(),
          'source_name': video.sourceName,
          'source_url': video.sourceUrl,
          'is_live': false, // active stream check was done separately
          'view_count': video.viewCount,
        });
      }

      // 3. Update the local cache with the latest synced uploads for offline use
      final prefs = await SharedPreferences.getInstance();
      final localList = uploads.map((e) => e.toJson()).toList();
      if (liveStream != null) {
        localList.insert(0, liveStream.toJson());
      }
      await prefs.setString(_localCacheKey, json.encode(localList));
      debugPrint('[MEDIA_REPO] Sync completed successfully.');
    } catch (e) {
      debugPrint('[MEDIA_REPO] Sync failed: $e');
      // Re-throw if there is no offline cache to let user know sync failed
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey(_localCacheKey)) {
        rethrow;
      }
    }
  }

  /// Fetch videos paginated from the Supabase cache (which is our single source of truth).
  /// Falls back to local SharedPreferences cache if offline.
  Future<List<MediaItem>> fetchMedia({
    required int limit,
    required int offset,
  }) async {
    try {
      debugPrint('[MEDIA_REPO] Fetching media from Supabase (offset: $offset, limit: $limit)...');
      final response = await _supabase
          .from('youtube_videos')
          .select()
          .order('is_live', ascending: false) // Live streams first
          .order('published_at', ascending: false) // Newest first
          .range(offset, offset + limit - 1);

      final List rows = response as List;
      final items = rows.map((row) => MediaItem.fromJson(row as Map<String, dynamic>)).toList();
      
      // Update local cache if we are on the first page
      if (offset == 0 && items.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_localCacheKey, json.encode(items.map((e) => e.toJson()).toList()));
      }
      
      return items;
    } catch (e) {
      debugPrint('[MEDIA_REPO] Fetch from Supabase failed, attempting offline cache: $e');
      
      // Fallback to local offline cache
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_localCacheKey);
      if (cachedJson != null) {
        try {
          final List decoded = json.decode(cachedJson);
          final allCached = decoded.map((item) => MediaItem.fromJson(item)).toList();
          
          // Paginate manually from local cache
          if (offset < allCached.length) {
            final end = (offset + limit) < allCached.length ? (offset + limit) : allCached.length;
            return allCached.sublist(offset, end);
          }
          return [];
        } catch (parseError) {
          debugPrint('[MEDIA_REPO] Error parsing local offline cache: $parseError');
        }
      }
      
      // If no cache exists, throw the original error
      throw Exception('Unable to reach server. Please check your internet connection.');
    }
  }

  /// Check if the channel is currently live (queries local/Supabase cache first).
  Future<MediaItem?> fetchLiveStream() async {
    try {
      final response = await _supabase
          .from('youtube_videos')
          .select()
          .eq('is_live', true)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        return MediaItem.fromJson(response);
      }
    } catch (e) {
      debugPrint('[MEDIA_REPO] Error fetching live status: $e');
    }
    return null;
  }

  /// Fetch a single video detail from local/Supabase cache.
  Future<MediaItem?> fetchVideoDetails(String videoId) async {
    try {
      final response = await _supabase
          .from('youtube_videos')
          .select()
          .eq('id', videoId)
          .maybeSingle();

      if (response != null) {
        return MediaItem.fromJson(response);
      }
    } catch (e) {
      debugPrint('[MEDIA_REPO] Error fetching video details: $e');
    }
    
    // Fallback: Check offline cache
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_localCacheKey);
      if (cachedJson != null) {
        final List decoded = json.decode(cachedJson);
        final cachedItems = decoded.map((item) => MediaItem.fromJson(item)).toList();
        for (final item in cachedItems) {
          if (item.id == videoId) return item;
        }
      }
    } catch (_) {}
    
    return null;
  }

  // -------------------------------------------------------------
  // PLAYBACK PROGRESS TRACKING (CONTINUE WATCHING)
  // -------------------------------------------------------------

  /// Save playback progress for a video.
  Future<void> savePlaybackProgress({
    required String videoId,
    required int positionMs,
    required double completionPercentage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final progressMap = {
      'positionMs': positionMs,
      'completionPercentage': completionPercentage,
      'lastViewed': DateTime.now().toIso8601String(),
    };
    await prefs.setString('playback_progress_$videoId', json.encode(progressMap));
    
    // Maintain a list of in-progress video IDs to query "Continue Watching" efficiently
    final inProgressList = prefs.getStringList('in_progress_videos_list') ?? [];
    if (!inProgressList.contains(videoId)) {
      inProgressList.add(videoId);
      await prefs.setStringList('in_progress_videos_list', inProgressList);
    }
  }

  /// Retrieve playback progress for a specific video.
  Future<Map<String, dynamic>?> getPlaybackProgress(String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('playback_progress_$videoId');
    if (jsonStr != null) {
      try {
        return json.decode(jsonStr) as Map<String, dynamic>;
      } catch (_) {}
    }
    return null;
  }

  /// Fetch all videos that are currently in progress.
  Future<List<Map<String, dynamic>>> getInProgressVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final inProgressList = prefs.getStringList('in_progress_videos_list') ?? [];
    
    final List<Map<String, dynamic>> results = [];
    final List<String> completedList = [];

    for (final videoId in inProgressList) {
      final progress = await getPlaybackProgress(videoId);
      if (progress != null) {
        final completion = progress['completionPercentage'] as double? ?? 0.0;
        // If completed (e.g. > 95%), remove from list of active continue watching
        if (completion >= 0.95) {
          completedList.add(videoId);
        } else {
          results.add({
            'videoId': videoId,
            ...progress,
          });
        }
      }
    }

    if (completedList.isNotEmpty) {
      inProgressList.removeWhere((id) => completedList.contains(id));
      await prefs.setStringList('in_progress_videos_list', inProgressList);
    }

    // Sort by last viewed (newest first)
    results.sort((a, b) {
      final aDate = DateTime.tryParse(a['lastViewed'] ?? '') ?? DateTime.now();
      final bDate = DateTime.tryParse(b['lastViewed'] ?? '') ?? DateTime.now();
      return bDate.compareTo(aDate);
    });

    return results;
  }

  /// Clear progress of a completed or deleted item.
  Future<void> removePlaybackProgress(String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('playback_progress_$videoId');
    final inProgressList = prefs.getStringList('in_progress_videos_list') ?? [];
    if (inProgressList.contains(videoId)) {
      inProgressList.remove(videoId);
      await prefs.setStringList('in_progress_videos_list', inProgressList);
    }
  }

  /// Legacy configurations & methods for compilation compatibility with admin screen
  Future<MediaChannelConfig> loadChannelConfig() async {
    return MediaChannelConfig.fromEnvOrPrefs();
  }

  Future<List<MediaItem>> fetchMixlrAudio(String username) async {
    return [];
  }

  Future<MediaItem?> fetchMixlrSchedule(String username) async {
    return null;
  }

  void dispose() {
    _youtubeService.dispose();
  }
}
