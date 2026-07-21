import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sermon_model.dart';
import '../../../media/data/providers/media_provider.dart';
import '../repositories/sermon_repository.dart';

part 'sermon_provider.g.dart';

@riverpod
Future<List<SermonModel>> sermons(SermonsRef ref) {
  return ref.watch(sermonRepositoryProvider).fetchAll();
}

@riverpod
class LatestSermon extends _$LatestSermon {
  static const _cacheKey = 'cached_latest_sermon';

  @override
  FutureOr<SermonModel?> build() async {
    // 1. Try to load cached sermon immediately
    _loadCache().then((cached) {
      if (cached != null && state.value == null) {
        state = AsyncValue.data(cached);
      }
    });

    // 2. Perform database and YouTube matches
    return _fetchLatest();
  }

  Future<SermonModel?> _fetchLatest() async {
    SermonModel? latest;
    try {
      final dbSermon = await ref.read(sermonRepositoryProvider).fetchLatestSermon();
      latest = dbSermon;
    } catch (e) {
      debugPrint('[SERMON_PROVIDER] Error fetching latest sermon from repo: $e');
    }

    try {
      final mediaRepo = ref.read(mediaRepositoryProvider);
      final mediaItems = await mediaRepo.fetchMedia(limit: 50, offset: 0);
      if (mediaItems.isNotEmpty) {
        final latestMedia = mediaItems.first;
        if (latest == null || (latestMedia.publishedAt != null && latestMedia.publishedAt!.isAfter(latest.publishedAt))) {
          final ytId = latestMedia.id.replaceFirst('youtube-', '');
          latest = SermonModel(
            id: latestMedia.id,
            title: latestMedia.title,
            description: latestMedia.description ?? '',
            speaker: 'Jesus Unhindered Ministry',
            mediaUrl: latestMedia.sourceUrl,
            thumbnailUrl: latestMedia.thumbnailUrl ?? '',
            type: 'video',
            durationSeconds: _parseDurationString(latestMedia.duration),
            publishedAt: latestMedia.publishedAt ?? DateTime.now(),
            youtubeVideoId: ytId,
          );
        }
      }
    } catch (e) {
      debugPrint('[SERMON_PROVIDER] Error matching latest media sermon: $e');
    }

    if (latest == null) {
      try {
        latest = ref.read(sermonRepositoryProvider).getSeededFallbackSermon();
      } catch (e) {
        debugPrint('[SERMON_PROVIDER] Error getting fallback sermon: $e');
      }
    }

    if (latest != null) {
      _saveCache(latest);
    }
    return latest;
  }

  Future<SermonModel?> _loadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataStr = prefs.getString(_cacheKey);
      if (dataStr != null) {
        return SermonModel.fromJson(jsonDecode(dataStr) as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('[SERMON_PROVIDER] Error loading cached latest sermon: $e');
    }
    return null;
  }

  Future<void> _saveCache(SermonModel sermon) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(sermon.toJson()));
    } catch (e) {
      debugPrint('[SERMON_PROVIDER] Error caching latest sermon: $e');
    }
  }
}

final sermonDetailProvider = FutureProvider.family<SermonModel?, String>((ref, id) async {
  if (id.startsWith('youtube-')) {
    final ytId = id.replaceFirst('youtube-', '');
    final mediaRepo = ref.watch(mediaRepositoryProvider);
    final video = await mediaRepo.fetchVideoDetails(id);
    if (video != null) {
      return SermonModel(
        id: id,
        title: video.title,
        description: video.description ?? '',
        speaker: 'Jesus Unhindered Ministry',
        mediaUrl: video.sourceUrl,
        thumbnailUrl: video.thumbnailUrl ?? '',
        type: 'video',
        durationSeconds: _parseDurationString(video.duration),
        publishedAt: video.publishedAt ?? DateTime.now(),
        youtubeVideoId: ytId,
      );
    }
    return null;
  } else {
    final repo = ref.watch(sermonRepositoryProvider);
    // Convert stream to future by taking first emission
    return repo.watchSermon(id).first;
  }
});

int _parseDurationString(String? duration) {
  if (duration == null || duration.isEmpty) return 0;
  final parts = duration.split(':');
  if (parts.length == 2) {
    final m = int.tryParse(parts[0]) ?? 0;
    final s = int.tryParse(parts[1]) ?? 0;
    return m * 60 + s;
  } else if (parts.length == 3) {
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    final s = int.tryParse(parts[2]) ?? 0;
    return h * 3600 + m * 60 + s;
  }
  return 0;
}

// -------------------------------------------------------------
// SERMON PLAYER STATE & NOTIFIER
// -------------------------------------------------------------
class SermonPlayerState {
  final SermonModel? sermon;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final double speed;

  const SermonPlayerState({
    this.sermon,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isPlaying = false,
    this.speed = 1.0,
  });

  SermonPlayerState copyWith({
    SermonModel? sermon,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    double? speed,
  }) {
    return SermonPlayerState(
      sermon: sermon ?? this.sermon,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      speed: speed ?? this.speed,
    );
  }
}

@riverpod
class SermonPlayerNotifier extends _$SermonPlayerNotifier {
  AudioPlayer? _audioPlayer;
  StreamSubscription? _audioPositionSub;
  StreamSubscription? _audioDurationSub;
  StreamSubscription? _audioStateSub;

  @override
  SermonPlayerState build() {
    ref.onDispose(() {
      _cleanup();
    });
    return const SermonPlayerState();
  }

  void _cleanup() {
    _audioPositionSub?.cancel();
    _audioDurationSub?.cancel();
    _audioStateSub?.cancel();
    _audioPlayer?.dispose();
    _audioPlayer = null;
  }

  Future<void> play(SermonModel sermon) async {
    _cleanup();

    state = SermonPlayerState(
      sermon: sermon,
      isPlaying: true,
      speed: 1.0,
    );

    // Note: YouTube video sermons are handled entirely by YoutubePlayerController
    // in the UI (sermon_player_screen.dart). This notifier only manages audio sermons.
    if (sermon.type == 'audio') {
      _audioPlayer = AudioPlayer();
      _audioPlayer!.setReleaseMode(ReleaseMode.stop);
      
      _audioPositionSub = _audioPlayer!.onPositionChanged.listen((p) {
        state = state.copyWith(position: p);
      });
      _audioDurationSub = _audioPlayer!.onDurationChanged.listen((d) {
        state = state.copyWith(duration: d);
      });
      _audioStateSub = _audioPlayer!.onPlayerStateChanged.listen((s) {
        state = state.copyWith(isPlaying: s == PlayerState.playing);
      });

      try {
        await _audioPlayer!.setPlaybackRate(state.speed);
        await _audioPlayer!.play(UrlSource(sermon.mediaUrl));
        state = state.copyWith(isPlaying: true);
      } catch (e) {
        state = state.copyWith(isPlaying: false);
      }
    } else {
      // Video handled in UI via YoutubePlayerController — nothing to do here
      state = state.copyWith(isPlaying: false);
    }
  }

  Future<void> pause() async {
    await _audioPlayer?.pause();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> resume() async {
    if (state.sermon == null) return;
    await _audioPlayer?.resume();
    state = state.copyWith(isPlaying: true);
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer?.seek(position);
    state = state.copyWith(position: position);
  }

  Future<void> setSpeed(double speed) async {
    await _audioPlayer?.setPlaybackRate(speed);
    state = state.copyWith(speed: speed);
  }

  void skipForward15() {
    final target = state.position + const Duration(seconds: 15);
    if (target < state.duration) {
      seek(target);
    } else {
      seek(state.duration);
    }
  }

  void skipBack15() {
    final target = state.position - const Duration(seconds: 15);
    if (target > Duration.zero) {
      seek(target);
    } else {
      seek(Duration.zero);
    }
  }

  void stop() {
    _cleanup();
    state = const SermonPlayerState();
  }
}

// -------------------------------------------------------------
// SERMON SEARCH STATE & NOTIFIER
// -------------------------------------------------------------
class SermonSearchState {
  final String query;
  final List<SermonModel> results;
  final bool isLoading;

  const SermonSearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
  });
}

@riverpod
class SermonSearchNotifier extends _$SermonSearchNotifier {
  Timer? _debounceTimer;

  @override
  SermonSearchState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return const SermonSearchState();
  }

  void search(String q) {
    _debounceTimer?.cancel();
    if (q.isEmpty) {
      state = const SermonSearchState();
      return;
    }
    state = SermonSearchState(query: q, results: state.results, isLoading: true);
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      try {
        final results = await ref.read(sermonRepositoryProvider).search(q);
        state = SermonSearchState(query: q, results: results, isLoading: false);
      } catch (e) {
        state = SermonSearchState(query: q, results: const [], isLoading: false);
      }
    });
  }
}
