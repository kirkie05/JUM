import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/current_user_provider.dart';
import '../models/stream_model.dart';
import '../repositories/live_repository.dart';

part 'live_provider.g.dart';

@riverpod
Stream<List<LiveStreamModel>> liveStreamsStream(LiveStreamsStreamRef ref) {
  return ref.watch(liveRepositoryProvider).watchActive();
}

@riverpod
Stream<List<StreamMessage>> liveChatStream(LiveChatStreamRef ref, String streamId) {
  return ref.watch(liveRepositoryProvider).watchChat(streamId);
}
