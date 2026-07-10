import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart' as jab;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/media_item.dart';
import '../repositories/media_repository.dart';
import '../services/youtube_service.dart';

final youtubeServiceProvider = Provider<YoutubeService>((ref) {
  final service = YoutubeService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  final repo = MediaRepository(Dio());
  ref.onDispose(() {
    repo.dispose();
  });
  return repo;
});

final mediaChannelConfigProvider = FutureProvider<MediaChannelConfig>((ref) {
  return ref.watch(mediaRepositoryProvider).loadChannelConfig();
});

final mediaFeedProvider = FutureProvider<List<MediaItem>>((ref) {
  return ref.watch(mediaRepositoryProvider).fetchMedia();
});

final youtubeVideosProvider = FutureProvider<List<MediaItem>>((ref) async {
  final ytService = ref.watch(youtubeServiceProvider);
  return ytService.fetchLatestVideos();
});

final youtubePlaylistsProvider = FutureProvider<List<MediaItem>>((ref) async {
  final ytService = ref.watch(youtubeServiceProvider);
  return ytService.fetchPlaylists();
});

final youtubeLiveStreamProvider = FutureProvider<MediaItem?>((ref) async {
  final ytService = ref.watch(youtubeServiceProvider);
  
  final timer = Timer(const Duration(minutes: 2), () {
    ref.invalidateSelf();
  });
  ref.onDispose(() => timer.cancel());

  return ytService.checkLiveStream();
});

final youtubeSearchProvider = FutureProvider.family<List<MediaItem>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final ytService = ref.watch(youtubeServiceProvider);
  return ytService.search(query);
});

final mixlrAudioProvider = FutureProvider<List<MediaItem>>((ref) async {
  final config = await ref.watch(mediaChannelConfigProvider.future);
  
  final timer = Timer(const Duration(minutes: 5), () {
    ref.invalidateSelf();
  });
  ref.onDispose(() => timer.cancel());

  return ref.watch(mediaRepositoryProvider).fetchMixlrAudio(config.mixlrUsername);
});

final mixlrLiveStreamProvider = FutureProvider<MediaItem?>((ref) async {
  final list = await ref.watch(mixlrAudioProvider.future);
  return list.where((item) => item.isLive).firstOrNull;
});

final mixlrScheduleProvider = FutureProvider<MediaItem?>((ref) async {
  final config = await ref.watch(mediaChannelConfigProvider.future);
  return ref.watch(mediaRepositoryProvider).fetchMixlrSchedule(config.mixlrUsername);
});

// -------------------------------------------------------------
// MIXLR AUDIO PLAYER STATE & NOTIFIER
// -------------------------------------------------------------

class MixlrPlayerState {
  final MediaItem? currentItem;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool isBuffering;
  final String? errorMessage;

  const MixlrPlayerState({
    this.currentItem,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isBuffering = false,
    this.errorMessage,
  });

  MixlrPlayerState copyWith({
    MediaItem? currentItem,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? isBuffering,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MixlrPlayerState(
      currentItem: currentItem ?? this.currentItem,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isBuffering: isBuffering ?? this.isBuffering,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class MixlrPlayerNotifier extends StateNotifier<MixlrPlayerState> {
  MixlrPlayerNotifier() : super(const MixlrPlayerState()) {
    _init();
  }

  final AudioPlayer _player = AudioPlayer();
  StreamSubscription? _playerStateSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;

  void _init() {
    _playerStateSub = _player.playerStateStream.listen((state) {
      final isPlaying = state.playing;
      final processingState = state.processingState;
      
      this.state = this.state.copyWith(
        isPlaying: isPlaying,
        isBuffering: processingState == ProcessingState.buffering || processingState == ProcessingState.loading,
      );
    });

    _positionSub = _player.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
      _savePosition(pos);
    });

    _durationSub = _player.durationStream.listen((dur) {
      if (dur != null) {
        state = state.copyWith(duration: dur);
      }
    });
  }

  Future<void> playItem(MediaItem item) async {
    if (state.currentItem?.id == item.id && _player.audioSource != null) {
      if (!state.isPlaying) {
        await play();
      }
      return;
    }

    state = state.copyWith(currentItem: item, errorMessage: null, clearError: true);
    
    try {
      final source = AudioSource.uri(
        Uri.parse(item.sourceUrl),
        tag: jab.MediaItem(
          id: item.id,
          album: item.sourceName,
          title: item.title,
          artUri: item.thumbnailUrl != null ? Uri.parse(item.thumbnailUrl!) : null,
        ),
      );
      
      await _player.setAudioSource(source);
      
      if (!item.isLive) {
        final savedPos = await _loadPosition(item.id);
        if (savedPos > Duration.zero) {
          await _player.seek(savedPos);
        }
      }

      await _player.play();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Unable to load audio stream: $e');
    }
  }

  Future<void> play() async {
    try {
      await _player.play();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Play error: $e');
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> seek(Duration pos) async {
    await _player.seek(pos);
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> _savePosition(Duration pos) async {
    final item = state.currentItem;
    if (item == null || item.isLive) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mixlr_position_${item.id}', pos.inMilliseconds);
  }

  Future<Duration> _loadPosition(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt('mixlr_position_$id') ?? 0;
    return Duration(milliseconds: ms);
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _player.dispose();
    super.dispose();
  }
}

final mixlrPlayerProvider = StateNotifierProvider<MixlrPlayerNotifier, MixlrPlayerState>((ref) {
  return MixlrPlayerNotifier();
});

