import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/post_model.dart';
import '../../data/repositories/community_repository.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/providers/current_user_provider.dart';

class PostActionsRow extends ConsumerWidget {
  final PostModel post;
  
  const PostActionsRow({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isLiked = post.isLikedByMe ?? false;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Like Action
        _ActionItem(
          icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isLiked ? AppColors.accent : AppColors.textMuted,
          label: '${post.likesCount}',
          onTap: () {
            if (currentUser != null) {
              ref.read(communityRepositoryProvider).toggleLike(post.id, currentUser.id);
            }
          },
        ),
        
        // Comment Action
        _ActionItem(
          icon: Icons.chat_bubble_outline_rounded,
          color: AppColors.textMuted,
          label: 'Comment', // Could show commentCount if available in model
          onTap: () {
            context.push('/community/${post.id}');
          },
        ),
        
        // Share Action
        _ActionItem(
          icon: Icons.ios_share_rounded,
          color: AppColors.textMuted,
          label: 'Share',
          onTap: () {
            Share.share('Check this out on JUM: ${post.body}');
          },
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: AppSizes.paddingXs),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
