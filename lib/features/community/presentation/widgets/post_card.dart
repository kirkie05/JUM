import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/models/post_model.dart';
import '../../data/repositories/community_repository.dart';
import 'post_actions_row.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_avatar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/providers/current_user_provider.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;
  
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isMyPost = currentUser?.id == post.userId;
    
    return JumCard(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              JumAvatar(
                imageUrl: post.authorAvatarUrl,
                initials: post.authorName?.isNotEmpty == true ? post.authorName![0] : 'U',
                size: 40,
              ),
              const SizedBox(width: AppSizes.paddingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName ?? 'Unknown',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      timeago.format(post.createdAt),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (isMyPost)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary),
                  onSelected: (value) {
                    if (value == 'delete') {
                      ref.read(communityRepositoryProvider).deletePost(post.id);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMd),
          
          // Body
          Text(
            post.body,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          
          // Media
          if (post.mediaUrl != null && post.mediaUrl!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.paddingMd),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: CachedNetworkImage(
                imageUrl: post.mediaUrl!,
                fit: BoxFit.cover,
                height: 220,
                width: double.infinity,
                placeholder: (context, url) => Container(
                  height: 220,
                  color: AppColors.surface2,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 220,
                  color: AppColors.surface2,
                  child: const Center(child: Icon(Icons.error, color: AppColors.textMuted)),
                ),
              ),
            ),
          ],
          
          const SizedBox(height: AppSizes.paddingMd),
          
          // Actions
          PostActionsRow(post: post),
        ],
      ),
    );
  }
}
