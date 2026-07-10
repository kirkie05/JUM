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

  Stream<List<MessageModel>> watchGroupConversation(String conversationId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .map((maps) {
          final msgs = maps.map((m) => MessageModel.fromJson(m)).toList();
          msgs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          return msgs;
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

  Future<void> sendMessage({
    required String senderId,
    required String body,
    String? receiverId,
    String? conversationId,
  }) async {
    String? activeConversationId = conversationId;

    if (activeConversationId == null && receiverId != null) {
      final existingMessages = await _supabase
          .from('messages')
          .select('conversation_id')
          .or('and(sender_id.eq.$senderId,receiver_id.eq.$receiverId),and(sender_id.eq.$receiverId,receiver_id.eq.$senderId)')
          .limit(1);

      if (existingMessages != null && (existingMessages as List).isNotEmpty) {
        activeConversationId = existingMessages[0]['conversation_id'] as String?;
      }

      if (activeConversationId == null) {
        final newConversation = await _supabase
            .from('conversations')
            .insert({
              'is_group': false,
            })
            .select('id')
            .single();
        activeConversationId = newConversation['id'] as String?;
      }
    }

    await _supabase.from('messages').insert({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'conversation_id': activeConversationId,
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

  Future<List<UserModel>> fetchContacts() async {
    final res = await _supabase
        .from('profiles')
        .select();
    return (res as List).map((u) => UserModel.fromJson(u)).toList();
  }
}

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepository(ref.watch(supabaseClientProvider));
});
