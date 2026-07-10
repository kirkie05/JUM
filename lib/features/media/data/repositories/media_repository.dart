import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/youtube_service.dart';
import '../models/media_item.dart';

class MediaRepository {
  MediaRepository(this._dio);

  final Dio _dio;
  final YoutubeService _youtubeService = YoutubeService();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<MediaChannelConfig> loadChannelConfig() async {
    return MediaChannelConfig.fromEnvOrPrefs();
  }

  Future<List<MediaItem>> fetchMedia({bool forceRefresh = false}) async {
    // 1. Try to sync latest from YouTube
    try {
      final ytVideos = await _youtubeService.fetchLatestVideos(count: 20);
      
      // Sync to Supabase
      for (final video in ytVideos) {
        await _supabase.from('youtube_videos').upsert({
          'id': 'youtube-${video.id}',
          'title': video.title,
          'description': video.description,
          'thumbnail_url': video.thumbnailUrl,
          'duration': video.duration?.inSeconds.toString(),
          'published_at': video.publishedAt?.toIso8601String(),
          'source_name': video.author,
          'source_url': 'https://www.youtube.com/watch?v=${video.id}',
          'is_live': video.isLive,
        });
      }
    } catch (e) {
      print('Failed to sync YouTube videos, using cache: $e');
    }

    // 2. Fetch from Supabase (which acts as the single source of truth/cache)
    try {
      final response = await _supabase
          .from('youtube_videos')
          .select()
          .order('published_at', ascending: false)
          .limit(50);

      return (response as List).map((data) {
        return MediaItem(
          id: data['id'],
          type: MediaItemType.video,
          title: data['title'] ?? '',
          sourceName: data['source_name'] ?? 'YouTube',
          sourceUrl: data['source_url'] ?? '',
          thumbnailUrl: data['thumbnail_url'],
          description: data['description'],
          publishedAt: data['published_at'] != null ? DateTime.tryParse(data['published_at']) : null,
          isLive: data['is_live'] ?? false,
        );
      }).toList();
    } catch (e) {
      print('Failed to fetch from Supabase cache: $e');
      return [];
    }
  }

  Future<List<MediaItem>> fetchYoutubeVideos(String channelId) async {
    return fetchMedia();
  }

  Future<List<MediaItem>> fetchYoutubePlaylists(String channelId) async {
    return [];
  }

  Future<MediaItem?> checkYoutubeLive(String channelId) async {
    final media = await fetchMedia();
    try {
      return media.firstWhere((m) => m.isLive);
    } catch (_) {
      return null;
    }
  }

  Future<List<MediaItem>> fetchMixlrAudio(String username) async {
    try {
      // Mixlr API requires users endpoint
      final res = await _dio.get('https://api.mixlr.com/users/$username/broadcasts');
      
      final data = res.data;
      final broadcasts = data['broadcasts'] as List? ?? [];

      return broadcasts.map((b) {
        return MediaItem(
          id: 'mixlr-${b['id']}',
          type: MediaItemType.audio,
          title: b['title'] ?? 'Audio Broadcast',
          sourceName: username,
          sourceUrl: b['streams']?['progressive']?['url'] ?? '',
          thumbnailUrl: b['artwork_url'],
          publishedAt: b['starts_at'] != null ? DateTime.tryParse(b['starts_at']) : null,
          isLive: false,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<MediaItem?> fetchMixlrSchedule(String username) async {
    try {
      final res = await _dio.get('https://api.mixlr.com/users/$username/events');
      final events = res.data['events'] as List?;
      if (events == null || events.isEmpty) return null;
      
      final nextEvent = events.first;
      return MediaItem(
        id: 'mixlr-event-${nextEvent['id']}',
        type: MediaItemType.audio,
        title: nextEvent['title'] ?? 'Scheduled Broadcast',
        sourceName: username,
        sourceUrl: '',
        thumbnailUrl: nextEvent['artwork_url'],
        publishedAt: nextEvent['starts_at'] != null ? DateTime.tryParse(nextEvent['starts_at']) : null,
        isLive: false,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> clearCache() async {
    // API cache strategy managed differently, mostly rely on Dio/HTTP cache or simple refetch
  }

  void dispose() {
    _dio.close();
  }
}
