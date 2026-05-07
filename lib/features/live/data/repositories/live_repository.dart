import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/stream_model.dart';

part 'live_repository.g.dart';

class LiveRepository {
  final SupabaseClient _supabase;
  LiveRepository(this._supabase);

  Stream<List<LiveStreamModel>> watchActive(String churchId) {
    return _supabase
        .from('live_streams')
        .stream(primaryKey: ['id'])
        .eq('church_id', churchId)
        .map((rows) => rows.map((row) => LiveStreamModel.fromJson(row)).toList());
  }

  Future<void> sendChatMessage({
    required String streamId,
    required String userId,
    required String userName,
    String? userAvatarUrl,
    required String body,
  }) async {
    await _supabase.from('live_chat_messages').insert({
      'stream_id': streamId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar_url': userAvatarUrl,
      'body': body,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<StreamMessage>> watchChat(String streamId) {
    return _supabase
        .from('live_chat_messages')
        .stream(primaryKey: ['id'])
        .eq('stream_id', streamId)
        .order('created_at', ascending: false)
        .map((rows) => rows.map((row) => StreamMessage.fromJson(row)).toList());
  }
}

@riverpod
LiveRepository liveRepository(LiveRepositoryRef ref) {
  return LiveRepository(ref.watch(supabaseClientProvider));
}
