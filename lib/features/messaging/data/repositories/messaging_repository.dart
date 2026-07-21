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

  Future<List<String>> fetchUserConversationIds(String userId) async {
    // 1. Get private conversations from conversation_members
    final privateRes = await _supabase
        .from('conversation_members')
        .select('conversation_id')
        .eq('user_id', userId)
        .catchError((_) => <dynamic>[]);
        
    final privateIds = (privateRes as List).map((r) => r['conversation_id'] as String).toList();

    // 2. Get group conversations from group_members
    final groupRes = await _supabase
        .from('group_members')
        .select('group_id')
        .eq('user_id', userId)
        .catchError((_) => <dynamic>[]);
        
    final groupIds = (groupRes as List).map((r) => r['group_id'] as String).toList();

    final List<String> allConversationIds = [...privateIds];
    if (groupIds.isNotEmpty) {
      final conversationsRes = await _supabase
          .from('conversations')
          .select('id')
          .inFilter('group_id', groupIds)
          .catchError((_) => <dynamic>[]);
      allConversationIds.addAll((conversationsRes as List).map((r) => r['id'] as String));
    }

    return allConversationIds;
  }

  Stream<List<MessageModel>> watchAllMessages(String userId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .asyncMap((maps) async {
          final activeIds = await fetchUserConversationIds(userId);
          final msgs = maps.map((m) => MessageModel.fromJson(m)).toList();
          return msgs.where((msg) => activeIds.contains(msg.conversationId)).toList();
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
      // 1. Check if a private conversation already exists between sender and receiver in conversation_members
      final existingRes = await _supabase
          .from('conversation_members')
          .select('conversation_id')
          .eq('user_id', senderId)
          .catchError((_) => <dynamic>[]);
      
      final senderConvIds = (existingRes as List).map((r) => r['conversation_id'] as String).toSet();
      
      if (senderConvIds.isNotEmpty) {
        final matchRes = await _supabase
            .from('conversation_members')
            .select('conversation_id')
            .eq('user_id', receiverId)
            .inFilter('conversation_id', senderConvIds.toList())
            .catchError((_) => <dynamic>[]);
        
        if ((matchRes as List).isNotEmpty) {
          activeConversationId = matchRes[0]['conversation_id'] as String?;
        }
      }

      // 2. If it doesn't exist, create a new conversation and add both members
      if (activeConversationId == null) {
        final newConversation = await _supabase
            .from('conversations')
            .insert({'is_group': false})
            .select('id')
            .single();
        activeConversationId = newConversation['id'] as String?;

        if (activeConversationId != null) {
          await _supabase.from('conversation_members').insert([
            {'conversation_id': activeConversationId, 'user_id': senderId},
            {'conversation_id': activeConversationId, 'user_id': receiverId},
          ]);
        }
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

  // Invite non-user by email
  Future<void> inviteNonUser({
    required String conversationId,
    required String email,
    required String invitedBy,
  }) async {
    await _supabase.from('conversation_invitations').insert({
      'conversation_id': conversationId,
      'email': email,
      'invited_by': invitedBy,
    });
    print('[NOTIFICATION] Sent invitation email to non-user: $email for conversation: $conversationId');
  }

  // Process pending invitations on signup/login
  Future<void> processPendingInvitations(String email, String userId) async {
    final invites = await _supabase
        .from('conversation_invitations')
        .select('conversation_id')
        .eq('email', email)
        .catchError((_) => <dynamic>[]);
        
    if ((invites as List).isNotEmpty) {
      final List<Map<String, dynamic>> membersToInsert = invites.map((invite) {
        return {
          'conversation_id': invite['conversation_id'] as String,
          'user_id': userId,
        };
      }).toList();

      await _supabase.from('conversation_members').insert(membersToInsert).catchError((_) {});
      await _supabase.from('conversation_invitations').delete().eq('email', email).catchError((_) {});
    }
  }
}

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepository(ref.watch(supabaseClientProvider));
});
