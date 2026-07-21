import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:jum/core/services/supabase_service.dart';
import '../models/media_item.dart';
import '../repositories/media_repository.dart';
import '../services/youtube_service.dart';

part 'media_provider.g.dart';

final youtubeServiceProvider = Provider<YoutubeService>((ref) {
  final service = YoutubeService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  final repo = MediaRepository(
    ref.watch(youtubeServiceProvider),
    ref.watch(supabaseClientProvider),
  );
  ref.onDispose(() {
    repo.dispose();
  });
  return repo;
});

class MediaListState {
  final List<MediaItem> items;
  final bool isLoading;
  final bool isSyncing;
  final String? errorMessage;
  final int offset;
  final bool hasMore;

  const MediaListState({
    this.items = const [],
    this.isLoading = false,
    this.isSyncing = false,
    this.errorMessage,
    this.offset = 0,
    this.hasMore = true,
  });

  MediaListState copyWith({
    List<MediaItem>? items,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    int? offset,
    bool? hasMore,
  }) {
    return MediaListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessage: errorMessage,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

@riverpod
class MediaList extends _$MediaList {
  static const int _pageSize = 15;

  @override
  FutureOr<MediaListState> build() async {
    final repo = ref.watch(mediaRepositoryProvider);
    
    // Background sync YouTube uploads on initial load
    _syncInBackground();

    try {
      final items = await repo.fetchMedia(limit: _pageSize, offset: 0);
      return MediaListState(
        items: items,
        isLoading: false,
        hasMore: items.length >= _pageSize,
        offset: items.length,
      );
    } catch (e) {
      return MediaListState(
        items: const [],
        isLoading: false,
        errorMessage: e.toString(),
        hasMore: false,
      );
    }
  }

  Future<void> _syncInBackground() async {
    try {
      final repo = ref.read(mediaRepositoryProvider);
      await repo.syncYoutubeMedia();
      // Silently update the state once synced without invalidating self (avoids loops)
      final items = await repo.fetchMedia(limit: _pageSize, offset: 0);
      state = AsyncValue.data(MediaListState(
        items: items,
        isLoading: false,
        hasMore: items.length >= _pageSize,
        offset: items.length,
      ));
      // Force refresh the latest sermon card on home screen
      ref.invalidate(latestMediaVideoProvider);
    } catch (e) {
      debugPrint('[MEDIA_PROVIDER] Background sync failed: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(mediaRepositoryProvider);
      try {
        await repo.syncYoutubeMedia();
        ref.invalidate(latestMediaVideoProvider);
      } catch (e) {
        debugPrint('[MEDIA_PROVIDER] Refresh sync failed: $e');
      }
      final items = await repo.fetchMedia(limit: _pageSize, offset: 0);
      return MediaListState(
        items: items,
        isLoading: false,
        hasMore: items.length >= _pageSize,
        offset: items.length,
      );
    });
  }

  Future<void> loadMore() async {
    final currentData = state.value;
    if (currentData == null || currentData.isLoading || !currentData.hasMore) return;

    state = AsyncValue.data(currentData.copyWith(isLoading: true));
    
    state = await AsyncValue.guard(() async {
      final repo = ref.read(mediaRepositoryProvider);
      final newItems = await repo.fetchMedia(limit: _pageSize, offset: currentData.offset);
      
      return currentData.copyWith(
        items: [...currentData.items, ...newItems],
        isLoading: false,
        hasMore: newItems.length >= _pageSize,
        offset: currentData.offset + newItems.length,
      );
    });
  }
}

/// Provider for the Latest Sermon card on the Home Screen.
/// Always returns the newest video uploaded to the configured channel.
final latestMediaVideoProvider = FutureProvider<MediaItem?>((ref) async {
  final repo = ref.watch(mediaRepositoryProvider);
  
  // Fetch the newest from Supabase directly (updates instantly via background invalidation)
  try {
    final items = await repo.fetchMedia(limit: 1, offset: 0);
    if (items.isNotEmpty) return items.first;
  } catch (_) {}

  return null;
});

class ContinueWatchingItem {
  final MediaItem item;
  final int positionMs;
  final double completionPercentage;
  final DateTime lastViewed;

  ContinueWatchingItem({
    required this.item,
    required this.positionMs,
    required this.completionPercentage,
    required this.lastViewed,
  });
}

/// Provider for list of in-progress media items (Continue Watching).
final continueWatchingProvider = FutureProvider<List<ContinueWatchingItem>>((ref) async {
  final repo = ref.watch(mediaRepositoryProvider);
  final list = await repo.getInProgressVideos();
  
  final List<ContinueWatchingItem> results = [];
  for (final progress in list) {
    final videoId = progress['videoId'] as String;
    final item = await repo.fetchVideoDetails(videoId);
    if (item != null) {
      results.add(ContinueWatchingItem(
        item: item,
        positionMs: progress['positionMs'] as int? ?? 0,
        completionPercentage: progress['completionPercentage'] as double? ?? 0.0,
        lastViewed: DateTime.tryParse(progress['lastViewed'] ?? '') ?? DateTime.now(),
      ));
    }
  }
  return results;
});

/// Legacy compatibility providers for administrative screen integration.
final mediaChannelConfigProvider = FutureProvider<MediaChannelConfig>((ref) {
  return ref.watch(mediaRepositoryProvider).loadChannelConfig();
});

final mediaFeedProvider = FutureProvider<List<MediaItem>>((ref) async {
  return ref.watch(mediaRepositoryProvider).fetchMedia(limit: 50, offset: 0);
});

final youtubeVideosProvider = FutureProvider<List<MediaItem>>((ref) async {
  return ref.watch(mediaRepositoryProvider).fetchMedia(limit: 50, offset: 0);
});

final mixlrAudioProvider = FutureProvider<List<MediaItem>>((ref) async {
  final config = await ref.watch(mediaChannelConfigProvider.future);
  return ref.watch(mediaRepositoryProvider).fetchMixlrAudio(config.mixlrUsername);
});
