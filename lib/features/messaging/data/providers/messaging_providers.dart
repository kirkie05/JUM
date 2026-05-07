import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/message_model.dart';
import '../repositories/messaging_repository.dart';

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

  Future<void> send(String receiverId, String body) async {
    state = const AsyncValue.loading();
    try {
      final currentUser = ref.read(currentUserProvider).value;
      if (currentUser == null) throw Exception('No user logged in');
      await ref.read(messagingRepositoryProvider).sendMessage(currentUser.id, receiverId, body);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

class RecentConversation {
  final UserModel peer;
  final MessageModel lastMessage;
  final int unreadCount;

  RecentConversation({
    required this.peer,
    required this.lastMessage,
    required this.unreadCount,
  });
}

@riverpod
Stream<List<RecentConversation>> recentConversations(RecentConversationsRef ref) {
  final currentUser = ref.watch(currentUserProvider).value;
  if (currentUser == null) return Stream.value([]);

  return ref.watch(messagingRepositoryProvider).watchAllMessages(currentUser.id).asyncMap((messages) async {
    final contacts = await ref.watch(messagingRepositoryProvider).fetchContacts(currentUser.churchId);
    final contactMap = {for (var c in contacts) c.id: c};

    final map = <String, List<MessageModel>>{};
    for (var msg in messages) {
      final peerId = msg.senderId == currentUser.id ? msg.receiverId : msg.senderId;
      map.putIfAbsent(peerId, () => []).add(msg);
    }

    final list = <RecentConversation>[];
    for (var entry in map.entries) {
      final peerId = entry.key;
      final peerMsgs = entry.value;
      final peerUser = contactMap[peerId];
      if (peerUser == null) continue;

      final lastMsg = peerMsgs.last;
      final unreadCount = peerMsgs.where((m) => m.receiverId == currentUser.id && m.readAt == null).length;

      list.add(RecentConversation(
        peer: peerUser,
        lastMessage: lastMsg,
        unreadCount: unreadCount,
      ));
    }

    list.sort((a, b) => b.lastMessage.createdAt.compareTo(a.lastMessage.createdAt));
    return list;
  });
}

@riverpod
Future<List<UserModel>> contacts(ContactsRef ref) {
  final currentUser = ref.watch(currentUserProvider).value;
  if (currentUser == null) return Future.value([]);
  return ref.watch(messagingRepositoryProvider).fetchContacts(currentUser.churchId);
}
