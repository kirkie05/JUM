import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/jum_empty_state.dart';
import '../../../../shared/widgets/jum_error_state.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../../auth/data/providers/auth_provider.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/community_repository.dart';

class CommunityFeedScreen extends ConsumerStatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  ConsumerState<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends ConsumerState<CommunityFeedScreen> {
  final _bodyController = TextEditingController();
  File? _mediaFile;
  bool _isPosting = false;

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _mediaFile = File(image.path));
    }
  }

  Future<void> _submitPost() async {
    final bodyText = _bodyController.text.trim();
    if (bodyText.isEmpty && _mediaFile == null) return;
    
    final user = ref.read(authNotifierProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to post.')),
      );
      return;
    }

    setState(() => _isPosting = true);

    try {
      // TODO: Handle media upload to storage bucket
      String? mediaUrl;

      await ref.read(communityRepositoryProvider).createPost(
        userId: user.id,
        body: bodyText,
        mediaUrl: mediaUrl,
      );

      if (mounted) {
        setState(() {
          _bodyController.clear();
          _mediaFile = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post published successfully!'),
            backgroundColor: AppColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  Future<void> _deletePost(String id) async {
    try {
      await ref.read(communityRepositoryProvider).deletePost(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post deleted!'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd, vertical: 12),
      child: Row(
        children: [
          const Text(
            'Community Feed',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.people_alt_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                const Text(
                  'Live',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComposerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd, vertical: 8),
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file_rounded, color: AppColors.textMuted, size: 22),
                onPressed: _pickImage,
              ),
              Expanded(
                child: TextField(
                  controller: _bodyController,
                  maxLines: null,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: "What's on your mind right now?",
                    hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  ),
                ),
              ),
            ],
          ),
          if (_mediaFile != null) ...[
            const SizedBox(height: 10),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_mediaFile!, height: 140, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => _mediaFile = null),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const Divider(height: 20, color: AppColors.divider),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.sentiment_satisfied_alt_outlined, color: AppColors.textMuted, size: 22),
                onPressed: () {
                  _bodyController.text += ' 😊';
                  _bodyController.selection = TextSelection.fromPosition(TextPosition(offset: _bodyController.text.length));
                },
              ),
              const Spacer(),
              _isPosting
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                  : ElevatedButton.icon(
                      onPressed: _submitPost,
                      icon: const Icon(Icons.send_rounded, size: 13, color: Colors.white),
                      label: const Text('Post', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        minimumSize: const Size(80, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodyText(String text) {
    final List<String> words = text.split(' ');
    final List<InlineSpan> spans = [];
    for (var i = 0; i < words.length; i++) {
      final word = words[i];
      final isHashtag = word.startsWith('#');
      spans.add(TextSpan(
        text: '$word${i == words.length - 1 ? "" : " "}',
        style: TextStyle(
          fontFamily: 'Inter', fontSize: 14, height: 1.5,
          fontWeight: isHashtag ? FontWeight.w600 : FontWeight.normal,
          color: isHashtag ? Colors.indigoAccent : AppColors.textPrimary,
        ),
      ));
    }
    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildPostCard(PostModel post) {
    final currentUser = ref.watch(authNotifierProvider).value;
    final isYourPost = currentUser != null && currentUser.id == post.userId;
    final authorName = post.authorName ?? 'Member';
    final hasAvatarUrl = post.authorAvatarUrl != null && post.authorAvatarUrl!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: const BoxDecoration(color: AppColors.surface2, shape: BoxShape.circle),
                child: ClipOval(
                  child: hasAvatarUrl
                      ? CachedNetworkImage(
                          imageUrl: post.authorAvatarUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (c, e, s) => Center(child: Text(authorName[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                        )
                      : Center(child: Text(authorName[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                ),
              ),
              const SizedBox(width: AppSizes.paddingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(authorName, style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text('Community Member', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (isYourPost)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                  onPressed: () => _deletePost(post.id),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMd),
          _buildBodyText(post.body),
          if (post.mediaUrl != null && post.mediaUrl!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.paddingMd),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: post.mediaUrl!,
                fit: BoxFit.cover, height: 220, width: double.infinity,
              ),
            ),
          ],
          const SizedBox(height: AppSizes.paddingMd),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionItem(
                icon: (post.isLikedByMe ?? false) ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
                color: (post.isLikedByMe ?? false) ? AppColors.primary : AppColors.textMuted,
                label: '${post.likesCount}',
                onTap: () {
                  if (currentUser != null) {
                    ref.read(communityRepositoryProvider).toggleLike(post.id, currentUser.id);
                  }
                },
              ),
              _buildActionItem(
                icon: Icons.chat_bubble_outline_rounded,
                color: AppColors.textMuted,
                label: 'Comment',
                onTap: () => _showCommentsBottomSheet(post),
              ),
              _buildActionItem(
                icon: Icons.share_outlined,
                color: AppColors.textMuted,
                label: 'Share',
                onTap: () => Share.share('Check this JUM Post: ${post.body}'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({required IconData icon, required Color color, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: AppSizes.paddingXs),
            Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: color, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(PostModel post) {
    final currentUser = ref.read(authNotifierProvider).value;
    if (currentUser == null) return;

    final commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg))),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textMuted.withOpacity(0.3), borderRadius: BorderRadius.circular(2)))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Comments', style: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          IconButton(icon: const Icon(Icons.close, color: AppColors.textMuted), onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    Expanded(
                      child: FutureBuilder<List<CommentModel>>(
                        future: ref.read(communityRepositoryProvider).fetchComments(post.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return JumShimmer.list();
                          }
                          final comments = snapshot.data ?? [];
                          if (comments.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppColors.textMuted.withOpacity(0.5)),
                                  const SizedBox(height: 12),
                                  const Text('No comments yet.', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textMuted)),
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.all(AppSizes.paddingMd),
                            itemCount: comments.length,
                            itemBuilder: (context, idx) {
                              final comment = comments[idx];
                              final authorName = comment.authorName ?? 'Member';
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppColors.primary.withOpacity(0.1),
                                      backgroundImage: comment.authorAvatarUrl != null ? CachedNetworkImageProvider(comment.authorAvatarUrl!) : null,
                                      child: comment.authorAvatarUrl == null ? Text(authorName[0].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)) : null,
                                    ),
                                    const SizedBox(width: AppSizes.paddingSm),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(authorName, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                          const SizedBox(height: 4),
                                          Text(comment.body, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textPrimary, height: 1.3)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'Write a comment...',
                                filled: true, fillColor: AppColors.surface2,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingSm),
                          GestureDetector(
                            onTap: () async {
                              final text = commentController.text.trim();
                              if (text.isEmpty) return;
                              await ref.read(communityRepositoryProvider).addComment(post.id, currentUser.id, text);
                              setSheetState(() => commentController.clear());
                            },
                            child: const CircleAvatar(radius: 20, backgroundColor: AppColors.primary, child: Icon(Icons.send_rounded, color: Colors.white, size: 18)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final postsStream = ref.watch(communityRepositoryProvider).watchFeed();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: StreamBuilder<List<PostModel>>(
                stream: postsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return JumShimmer.list();
                  }
                  if (snapshot.hasError) {
                    debugPrint('[COMMUNITY_FEED] Stream error: ${snapshot.error}');
                    return Center(
                      child: JumErrorState(
                        message: 'Failed to load community feed.',
                        onRetry: () {
                          setState(() {});
                        },
                      ),
                    );
                  }
                  
                  final posts = snapshot.data ?? [];
                  if (posts.isEmpty) {
                    return ListView(
                      padding: const EdgeInsets.only(bottom: AppSizes.paddingXl),
                      children: [
                        _buildComposerCard(),
                        const SizedBox(height: 24),
                        const JumEmptyState(
                          title: 'No posts yet',
                          subtitle: 'Be the first to share something with the community!',
                          icon: Icons.forum_outlined,
                        ),
                      ],
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: AppSizes.paddingXl),
                    itemCount: posts.length + 1,
                    itemBuilder: (context, i) {
                      if (i == 0) return _buildComposerCard();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd, vertical: 8),
                        child: _buildPostCard(posts[i - 1]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
