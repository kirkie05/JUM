import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/message_model.dart';
import '../repositories/messaging_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'messaging_providers.g.dart';

@riverpod
Stream<List<MessageModel>> conversation(ConversationRef ref, String peerId) {
  final currentUser = ref.watch(currentUserProvider).value;
  if (currentUser == null) return const Stream.empty();
  return ref.watch(messagingRepositoryProvider).watchConversation(currentUser.id, peerId);
}

@riverpod
class SendMessageNotifier extends _$SendMessageNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> send({
    required String receiverId,
    required String body,
    String? conversationId,
    String? replyToId,
    List<File>? files,
  }) async {
    state = const AsyncValue.loading();
    try {
      final currentUser = ref.read(currentUserProvider).value;
      if (currentUser == null) throw Exception('No user logged in');
      
      final repo = ref.read(messagingRepositoryProvider);
      List<Map<String, dynamic>>? attachments;
      if (files != null && files.isNotEmpty) {
        attachments = [];
        final uploadPathId = conversationId ?? 'new_chat_${currentUser.id}';
        
        for (final file in files) {
          final fileName = file.path.split('/').last;
          final fileSize = await file.length();
          final url = await repo.uploadAttachment(file, uploadPathId, fileName);
          attachments.add({
            'url': url,
            'type': 'image',
            'size': fileSize,
            'name': fileName,
          });
        }
      }

      await repo.sendMessage(
        senderId: currentUser.id,
        receiverId: receiverId,
        body: body,
        conversationId: conversationId,
        replyToId: replyToId,
        attachments: attachments,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendGroupMessage({
    required String conversationId,
    required String body,
    List<File>? files,
  }) async {
    state = const AsyncValue.loading();
    try {
      final currentUser = ref.read(currentUserProvider).value;
      if (currentUser == null) throw Exception('No user logged in');
      
      final repo = ref.read(messagingRepositoryProvider);
      List<Map<String, dynamic>>? attachments;
      if (files != null && files.isNotEmpty) {
        attachments = [];
        for (final file in files) {
          final fileName = file.path.split('/').last;
          final fileSize = await file.length();
          final url = await repo.uploadAttachment(file, conversationId, fileName);
          attachments.add({
            'url': url,
            'type': 'image',
            'size': fileSize,
            'name': fileName,
          });
        }
      }

      await repo.sendMessage(
        senderId: currentUser.id,
        conversationId: conversationId,
        body: body,
        attachments: attachments,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
Stream<List<MessageModel>> groupConversation(GroupConversationRef ref, String conversationId) {
  return ref.watch(messagingRepositoryProvider).watchGroupConversation(conversationId);
}

class RecentConversation {
  final String id;
  final String title;
  final String? avatarUrl;
  final MessageModel lastMessage;
  final int unreadCount;
  final bool isGroup;
  final String? peerId;

  RecentConversation({
    required this.id,
    required this.title,
    this.avatarUrl,
    required this.lastMessage,
    required this.unreadCount,
    required this.isGroup,
    this.peerId,
  });
}

@riverpod
Stream<List<RecentConversation>> recentConversations(RecentConversationsRef ref) {
  final currentUser = ref.watch(currentUserProvider).value;
  if (currentUser == null) return Stream.value([]);

  return ref.watch(messagingRepositoryProvider).watchAllMessages(currentUser.id).asyncMap((messages) async {
    final contacts = await ref.watch(messagingRepositoryProvider).fetchContacts();
    final contactMap = {for (var c in contacts) c.id: c};

    final map = <String, List<MessageModel>>{};
    for (var msg in messages) {
      if (msg.conversationId != null) {
        map.putIfAbsent(msg.conversationId!, () => []).add(msg);
      }
    }

    final conversationIds = map.keys.toList();
    final List<dynamic> conversationsRes = conversationIds.isNotEmpty
        ? await Supabase.instance.client
            .from('conversations')
            .select('*, groups(name)')
            .inFilter('id', conversationIds)
            .catchError((_) => <dynamic>[])
        : [];
        
    final conversationsMap = {for (var c in conversationsRes) c['id'] as String: c};

    final list = <RecentConversation>[];
    for (var entry in map.entries) {
      final convId = entry.key;
      final peerMsgs = entry.value;
      final lastMsg = peerMsgs.last;
      
      final convDetails = conversationsMap[convId];
      if (convDetails == null) continue;

      final isGroup = convDetails['is_group'] as bool? ?? false;
      final unreadCount = peerMsgs.where((m) => m.receiverId == currentUser.id && m.readAt == null).length;

      if (isGroup) {
        final groupName = convDetails['name'] ?? convDetails['groups']?['name'] ?? 'Group Chat';
        list.add(RecentConversation(
          id: convId,
          title: groupName,
          lastMessage: lastMsg,
          unreadCount: unreadCount,
          isGroup: true,
        ));
      } else {
        final peerId = lastMsg.senderId == currentUser.id ? lastMsg.receiverId : lastMsg.senderId;
        if (peerId == null) continue;
        final peerUser = contactMap[peerId];
        if (peerUser == null) continue;

        list.add(RecentConversation(
          id: convId,
          title: peerUser.name,
          avatarUrl: peerUser.avatarUrl,
          lastMessage: lastMsg,
          unreadCount: unreadCount,
          isGroup: false,
          peerId: peerId,
        ));
      }
    }

    list.sort((a, b) => b.lastMessage.createdAt.compareTo(a.lastMessage.createdAt));
    return list;
  });
}

@riverpod
Future<List<UserModel>> contacts(ContactsRef ref) {
  final currentUser = ref.watch(currentUserProvider).value;
  if (currentUser == null) return Future.value([]);
  return ref.watch(messagingRepositoryProvider).fetchContacts();
}
