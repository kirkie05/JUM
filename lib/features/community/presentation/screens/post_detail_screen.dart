import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/community_provider.dart';
import '../../data/repositories/community_repository.dart';
import '../widgets/post_card.dart';
import '../../../../shared/widgets/jum_app_bar.dart';
import '../../../../shared/widgets/jum_text_field.dart';
import '../../../../shared/widgets/jum_avatar.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../../../shared/widgets/jum_error_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/providers/current_user_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentController = TextEditingController();

  void _submitComment() async {
    final body = _commentController.text.trim();
    if (body.isEmpty) return;

    final user = ref.read(currentUserProvider).value;
    if (user != null) {
      await ref.read(communityRepositoryProvider).addComment(widget.postId, user.id, body);
      _commentController.clear();
      // Invalidate to refresh comments
      ref.invalidate(postCommentsProvider(widget.postId));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ideally we would fetch the specific post here or pass it along, 
    // but we can just show the comments if we don't have the post directly.
    // For simplicity, we just fetch the feed to find the post.
    final feedAsync = ref.watch(communityFeedProvider);
    final post = feedAsync.value?.where((p) => p.id == widget.postId).firstOrNull;

    return Scaffold(
      appBar: const JumAppBar(title: 'Post Details', showBack: true),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                if (post != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      child: PostCard(post: post),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMd, vertical: AppSizes.paddingSm),
                    child: Text(
                      'Comments',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                ref.watch(postCommentsProvider(widget.postId)).when(
                      data: (comments) {
                        if (comments.isEmpty) {
                          return SliverToBoxAdapter(
                            child: const Padding(
                              padding: EdgeInsets.all(AppSizes.paddingMd),
                              child: Center(
                                child: Text('No comments yet.', style: TextStyle(color: AppColors.textSecondary)),
                              ),
                            ),
                          );
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final comment = comments[i];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd, vertical: AppSizes.paddingSm),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    JumAvatar(
                                      imageUrl: comment.authorAvatarUrl,
                                      initials: comment.authorName != null && comment.authorName!.isNotEmpty ? comment.authorName!.substring(0, 1) : 'U',
                                      size: 32,
                                    ),
                                    const SizedBox(width: AppSizes.paddingSm),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(AppSizes.paddingSm),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface2,
                                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  comment.authorName ?? 'Unknown',
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                ),
                                                Text(
                                                  timeago.format(comment.createdAt),
                                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              comment.body,
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: comments.length,
                          ),
                        );
                      },
                      loading: () => SliverToBoxAdapter(child: JumShimmer.list(count: 3)),
                      error: (e, _) => SliverToBoxAdapter(child: JumErrorState(onRetry: () => ref.invalidate(postCommentsProvider(widget.postId)))),
                    ),
              ],
            ),
          ),
          
          // Bottom Comment Input
          Container(
            padding: EdgeInsets.only(
              left: AppSizes.paddingMd,
              right: AppSizes.paddingSm,
              top: AppSizes.paddingSm,
              bottom: MediaQuery.of(context).padding.bottom + AppSizes.paddingSm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: JumTextField(
                    label: 'Comment',
                    hint: 'Add a comment...',
                    controller: _commentController,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.accent),
                  onPressed: _submitComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
