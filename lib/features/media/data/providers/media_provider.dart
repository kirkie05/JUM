import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/media_item.dart';
import '../repositories/media_repository.dart';

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  return MediaRepository(Dio());
});

final mediaChannelConfigProvider = FutureProvider<MediaChannelConfig>((ref) {
  return ref.watch(mediaRepositoryProvider).loadChannelConfig();
});

final mediaFeedProvider = FutureProvider<List<MediaItem>>((ref) {
  return ref.watch(mediaRepositoryProvider).fetchMedia();
});

final youtubeVideosProvider = FutureProvider<List<MediaItem>>((ref) async {
  final config = await ref.watch(mediaChannelConfigProvider.future);
  return ref
      .watch(mediaRepositoryProvider)
      .fetchYoutubeVideos(config.youtubeUrl);
});

final mixlrAudioProvider = FutureProvider<List<MediaItem>>((ref) async {
  final config = await ref.watch(mediaChannelConfigProvider.future);
  return ref.watch(mediaRepositoryProvider).fetchMixlrAudio(config.mixlrUrl);
});
