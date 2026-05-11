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

  // Helper to parse and build text with highlighted hashtags matching the slothui layout
  Widget _buildBodyText(String text) {
    final List<String> words = text.split(' ');
    final List<InlineSpan> spans = [];

    for (var i = 0; i < words.length; i++) {
      final word = words[i];
      final isHashtag = word.startsWith('#');
      
      spans.add(
        TextSpan(
          text: '$word${i == words.length - 1 ? "" : " "}',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1.5,
            fontWeight: isHashtag ? FontWeight.w600 : FontWeight.normal,
            color: isHashtag ? Colors.indigoAccent : AppColors.textPrimary,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  // Generates a professional community-centric role/title for the subtitle header, matching slothui style
  String _getUserSubtitle(String? authorName) {
    if (authorName == null || authorName.isEmpty) return 'Community Member, JUM';
    final name = authorName.toLowerCase();
    if (name.contains('joseph') || name.contains('pastor')) return 'Lead Pastor, JUM';
    if (name.contains('admin')) return 'Church Administrator';
    if (name.contains('worship') || name.contains('sarah')) return 'Worship Coordinator';
    if (name.contains('volunteer') || name.contains('david')) return 'Outreach Volunteer';
    return 'Active Member, JUM';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isMyPost = currentUser?.id == post.userId;
    
    return JumCard(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Role, Subtitle, and 3-dot Menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              JumAvatar(
                imageUrl: post.authorAvatarUrl,
                initials: post.authorName?.isNotEmpty == true ? post.authorName![0] : 'U',
                size: 42,
              ),
              const SizedBox(width: AppSizes.paddingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName ?? 'Unknown Member',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getUserSubtitle(post.authorName),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (isMyPost)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz_rounded, color: AppColors.textSecondary),
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
                )
              else
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded, size: 20, color: AppColors.textMuted),
                  onPressed: () {},
                ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMd),
          
          // Body content with parsed hashtags
          _buildBodyText(post.body),
          
          // Media with Rounded Corners (circular 16) matching slothui
          if (post.mediaUrl != null && post.mediaUrl!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.paddingMd),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: post.mediaUrl!,
                fit: BoxFit.cover,
                height: 220,
                width: double.infinity,
                placeholder: (context, url) => Container(
                  height: 220,
                  color: AppColors.surface2,
                  child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 220,
                  color: AppColors.surface2,
                  child: const Center(child: Icon(Icons.error_outline_rounded, color: AppColors.textMuted)),
                ),
              ),
            ),
          ],
          
          const SizedBox(height: AppSizes.paddingMd),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 8),
          
          // Actions: Like, Comment, Share, Bookmark with Counters
          PostActionsRow(post: post),
        ],
      ),
    );
  }
}
