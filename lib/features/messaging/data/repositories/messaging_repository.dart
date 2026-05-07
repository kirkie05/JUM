import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/message_model.dart';

class MessagingRepository {
  final SupabaseClient _supabase;
  MessagingRepository(this._supabase);

  Stream<List<MessageModel>> watchConversation(String userId, String peerId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .map((maps) {
          final msgs = maps.map((m) => MessageModel.fromJson(m)).toList();
          final filtered = msgs.where((msg) =>
              (msg.senderId == userId && msg.receiverId == peerId) ||
              (msg.senderId == peerId && msg.receiverId == userId)).toList();
          filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          return filtered;
        });
  }

  Stream<List<MessageModel>> watchAllMessages(String userId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .map((maps) {
          final msgs = maps.map((m) => MessageModel.fromJson(m)).toList();
          return msgs.where((msg) => msg.senderId == userId || msg.receiverId == userId).toList();
        });
  }

  Future<void> sendMessage(String senderId, String receiverId, String body) async {
    await _supabase.from('messages').insert({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'body': body,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> markRead(String messageId) async {
    await _supabase
        .from('messages')
        .update({'read_at': DateTime.now().toIso8601String()})
        .eq('id', messageId);
  }

  Future<List<UserModel>> fetchContacts(String churchId) async {
    final res = await _supabase
        .from('users')
        .select()
        .eq('church_id', churchId);
    return (res as List).map((u) => UserModel.fromJson(u)).toList();
  }
}

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepository(ref.watch(supabaseClientProvider));
});
