import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_avatar.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_empty_state.dart';
import '../../data/providers/messaging_providers.dart';

class MessagingHomeScreen extends ConsumerWidget {
  const MessagingHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentConversationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded, color: AppColors.accent),
            onPressed: () => _showContactPicker(context, ref),
          ),
        ],
      ),
      body: recentAsync.when(
        data: (recentList) {
          if (recentList.isEmpty) {
            return JumEmptyState(
              title: 'No conversations yet',
              subtitle: 'Tap the compose icon in the top right to start messaging members of your church.',
              icon: Icons.chat_bubble_outline_rounded,
              actionLabel: 'Find Contacts',
              onAction: () => _showContactPicker(context, ref),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            itemCount: recentList.length,
            itemBuilder: (context, index) {
              final item = recentList[index];
              final peer = item.peer;
              final lastMsg = item.lastMessage;
              final unread = item.unreadCount;

              final formattedTime = '${lastMsg.createdAt.hour.toString().padLeft(2, '0')}:${lastMsg.createdAt.minute.toString().padLeft(2, '0')}';

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
                child: InkWell(
                  onTap: () => context.push('/messaging/${peer.id}'),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  child: JumCard(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      child: Row(
                        children: [
                          JumAvatar(
                            initials: peer.name.isNotEmpty ? peer.name.substring(0, 2).toUpperCase() : 'U',
                            imageUrl: peer.avatarUrl,
                            size: 50.0,
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      peer.name,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      formattedTime,
                                      style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                                const Gap(4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        lastMsg.body,
                                        style: AppTextStyles.body.copyWith(
                                          color: unread > 0 ? AppColors.textPrimary : AppColors.textSecondary,
                                          fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (unread > 0) ...[
                                      const Gap(8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.accent,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '$unread',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, st) => const Center(child: Text('Failed to load conversations', style: TextStyle(color: AppColors.error))),
      ),
    );
  }

  void _showContactPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final contactsAsync = ref.watch(contactsProvider);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg, vertical: AppSizes.paddingMd),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Text(
                    'New Conversation',
                    style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  const Gap(16),
                  Expanded(
                    child: contactsAsync.when(
                      data: (contactsList) {
                        if (contactsList.isEmpty) {
                          return const Center(
                            child: Text('No church members found.', style: TextStyle(color: AppColors.textSecondary)),
                          );
                        }

                        return ListView.builder(
                          itemCount: contactsList.length,
                          itemBuilder: (context, index) {
                            final contact = contactsList[index];
                            return ListTile(
                              leading: JumAvatar(
                                initials: contact.name.isNotEmpty ? contact.name.substring(0, 2).toUpperCase() : 'U',
                                imageUrl: contact.avatarUrl,
                              ),
                              title: Text(contact.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                              subtitle: Text(contact.role.toUpperCase(), style: const TextStyle(color: AppColors.accent, fontSize: 11)),
                              onTap: () {
                                Navigator.pop(context);
                                context.push('/messaging/${contact.id}');
                              },
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                      error: (e, st) => const Center(child: Text('Failed to load contacts', style: TextStyle(color: AppColors.error))),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
