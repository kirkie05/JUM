import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../../shared/widgets/jum_avatar.dart';
import '../../data/providers/messaging_providers.dart';
import '../../data/repositories/messaging_repository.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/message_bubble.dart';

class ConversationScreen extends ConsumerWidget {
  final String peerId;

  const ConversationScreen({
    Key? key,
    required this.peerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserProvider).value?.id ?? '';
    final messagesAsync = ref.watch(conversationProvider(peerId));
    final contactsAsync = ref.watch(contactsProvider);

    final peerUser = contactsAsync.maybeWhen(
      data: (list) => list.firstWhere((u) => u.id == peerId, orElse: () => list.first),
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            JumAvatar(
              initials: peerUser != null && peerUser.name.isNotEmpty ? peerUser.name.substring(0, 2).toUpperCase() : 'U',
              imageUrl: peerUser?.avatarUrl,
              size: 36.0,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peerUser?.name ?? 'Chat',
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  Text(
                    peerUser?.role.toUpperCase() ?? 'MEMBER',
                    style: const TextStyle(fontSize: 10.0, color: AppColors.accent, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 16),
                        Text('No messages yet', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted)),
                        const SizedBox(height: 4),
                        Text('Send a message to start the conversation.', style: AppTextStyles.body.copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                  );
                }

                final reversedMessages = messages.reversed.toList();

                // Proactively mark unread messages as read
                for (final msg in messages) {
                  if (msg.receiverId == currentUserId && msg.readAt == null) {
                    ref.read(messagingRepositoryProvider).markRead(msg.id);
                  }
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: reversedMessages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: reversedMessages[index],
                      currentUserId: currentUserId,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
              error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.error))),
            ),
          ),
          ChatInputBar(
            onSend: (body) {
              ref.read(sendMessageNotifierProvider.notifier).send(peerId, body);
            },
          ),
        ],
      ),
    );
  }
}
