import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../../core/providers/current_user_provider.dart';
import '../models/sermon_model.dart';
import '../repositories/sermon_repository.dart';

part 'sermon_provider.g.dart';

@riverpod
Future<List<SermonModel>> sermons(SermonsRef ref) {
  final churchId = ref.watch(currentUserProvider).value?.churchId ?? 'jum-church-1';
  return ref.watch(sermonRepositoryProvider).fetchAll(churchId);
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
  VideoPlayerController? _videoController;
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

  VideoPlayerController? get videoController => _videoController;

  void _cleanup() {
    _audioPositionSub?.cancel();
    _audioDurationSub?.cancel();
    _audioStateSub?.cancel();
    _audioPlayer?.dispose();
    _audioPlayer = null;

    _videoController?.dispose();
    _videoController = null;
  }

  Future<void> play(SermonModel sermon) async {
    _cleanup();

    state = SermonPlayerState(
      sermon: sermon,
      isPlaying: true,
      speed: 1.0,
    );

    if (sermon.type == 'video') {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(sermon.mediaUrl));
      _videoController!.addListener(_videoListener);
      try {
        await _videoController!.initialize();
        await _videoController!.play();
        state = state.copyWith(
          duration: _videoController!.value.duration,
          isPlaying: _videoController!.value.isPlaying,
        );
      } catch (e) {
        state = state.copyWith(isPlaying: false);
      }
    } else {
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
    }
  }

  void _videoListener() {
    if (_videoController == null) return;
    state = state.copyWith(
      position: _videoController!.value.position,
      duration: _videoController!.value.duration,
      isPlaying: _videoController!.value.isPlaying,
    );
  }

  Future<void> pause() async {
    if (state.sermon?.type == 'video') {
      await _videoController?.pause();
    } else {
      await _audioPlayer?.pause();
    }
    state = state.copyWith(isPlaying: false);
  }

  Future<void> resume() async {
    if (state.sermon == null) return;
    if (state.sermon!.type == 'video') {
      await _videoController?.play();
    } else {
      await _audioPlayer?.resume();
    }
    state = state.copyWith(isPlaying: true);
  }

  Future<void> seek(Duration position) async {
    if (state.sermon?.type == 'video') {
      await _videoController?.seekTo(position);
    } else {
      await _audioPlayer?.seek(position);
    }
    state = state.copyWith(position: position);
  }

  Future<void> setSpeed(double speed) async {
    if (state.sermon?.type == 'video') {
      await _videoController?.setPlaybackSpeed(speed);
    } else {
      await _audioPlayer?.setPlaybackRate(speed);
    }
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
        final churchId = ref.read(currentUserProvider).value?.churchId ?? 'jum-church-1';
        final results = await ref.read(sermonRepositoryProvider).search(churchId, q);
        state = SermonSearchState(query: q, results: results, isLoading: false);
      } catch (e) {
        state = SermonSearchState(query: q, results: const [], isLoading: false);
      }
    });
  }
}
