import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class MockComment {
  final String id;
  final String authorName;
  final String authorRole;
  final String? authorAvatarUrl;
  final String body;
  final DateTime createdAt;

  MockComment({
    required this.id,
    required this.authorName,
    required this.authorRole,
    this.authorAvatarUrl,
    required this.body,
    required this.createdAt,
  });
}

// Rich model representation of a high-fidelity JUM Mock Post
class MockPost {
  final String id;
  final String authorName;
  final String authorRole;
  final String? authorAvatarUrl;
  final String body;
  final String? mediaUrl;
  final File? mediaFile;
  int likesCount;
  bool isLiked;
  int commentsCount;
  int sharesCount;
  int bookmarksCount;
  bool isBookmarked;
  final List<MockComment> comments;

  MockPost({
    required this.id,
    required this.authorName,
    required this.authorRole,
    this.authorAvatarUrl,
    required this.body,
    this.mediaUrl,
    this.mediaFile,
    required this.likesCount,
    this.isLiked = false,
    required this.commentsCount,
    required this.sharesCount,
    required this.bookmarksCount,
    this.isBookmarked = false,
    required this.comments,
  });
}

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  final _bodyController = TextEditingController();
  File? _mediaFile;
  bool _isPosting = false;

  // Fully interactive in-memory list of premium church mock posts matching slothui design
  late final List<MockPost> _posts;

  @override
  void initState() {
    super.initState();
    _posts = [
      MockPost(
        id: '1',
        authorName: 'Pastor Joseph',
        authorRole: 'Lead Pastor, JUM',
        authorAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=150',
        body: 'What an incredible Sunday service! Thank you to everyone who joined us for worship and fellowship. Remember, we are unhindered in our faith and called to be a light to the world. Let\'s keep sharing the good news! #sundayworship #jumministry #blessed #faith #fellowship',
        mediaUrl: 'https://images.unsplash.com/photo-1438029071396-1e831a7fa6d8?auto=format&fit=crop&q=80&w=800',
        likesCount: 142,
        isLiked: false,
        commentsCount: 2,
        sharesCount: 187,
        bookmarksCount: 12,
        isBookmarked: false,
        comments: [
          MockComment(
            id: 'c1',
            authorName: 'David Miller',
            authorRole: 'Outreach Volunteer',
            authorAvatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=150',
            body: 'Amen! Such a powerful word from Pastor Joseph today.',
            createdAt: DateTime.now().subtract(const Duration(hours: 4)),
          ),
          MockComment(
            id: 'c2',
            authorName: 'Sarah Jenkins',
            authorRole: 'Worship Coordinator',
            authorAvatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150',
            body: 'So blessed to be part of the JUM family!',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ],
      ),
      MockPost(
        id: '2',
        authorName: 'Sarah Jenkins',
        authorRole: 'Worship Coordinator, JUM',
        authorAvatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150',
        body: 'Excited for our upcoming night of worship this Wednesday! We are practicing some new songs that will truly bless you. Come with an open heart to receive. See you there! #nightofworship #praiseandworship #jummusic #holyspirit #worship',
        likesCount: 98,
        isLiked: true,
        commentsCount: 1,
        sharesCount: 56,
        bookmarksCount: 8,
        isBookmarked: true,
        comments: [
          MockComment(
            id: 'c3',
            authorName: 'Pastor Joseph',
            authorRole: 'Lead Pastor, JUM',
            authorAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=150',
            body: 'Can\'t wait for Wednesday night worship! Preparing my heart too.',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
        ],
      ),
      MockPost(
        id: '3',
        authorName: 'David Miller',
        authorRole: 'Outreach Volunteer, JUM',
        authorAvatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=150',
        body: 'Our food bank outreach yesterday was a massive success! We served over 120 families in the local community. Huge shoutout to all the volunteers who sacrificed their Saturday morning. God is moving in our city! #communityoutreach #serve #loveinaction #faith',
        mediaUrl: 'https://images.unsplash.com/photo-1541872703-74c5e44368f9?auto=format&fit=crop&q=80&w=800',
        likesCount: 215,
        isLiked: false,
        commentsCount: 1,
        sharesCount: 312,
        bookmarksCount: 45,
        isBookmarked: false,
        comments: [
          MockComment(
            id: 'c4',
            authorName: 'Sarah Jenkins',
            authorRole: 'Worship Coordinator',
            authorAvatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150',
            body: 'God is truly moving in our community.',
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
      ),
    ];
  }

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

  void _submitPost() {
    final bodyText = _bodyController.text.trim();
    if (bodyText.isEmpty && _mediaFile == null) return;

    setState(() => _isPosting = true);
    
    // Simulate interactive post insertion in real-time
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _posts.insert(
            0,
            MockPost(
              id: DateTime.now().toString(),
              authorName: 'You',
              authorRole: 'Active Member, JUM',
              body: bodyText,
              mediaFile: _mediaFile,
              likesCount: 0,
              isLiked: false,
              commentsCount: 0,
              sharesCount: 0,
              bookmarksCount: 0,
              isBookmarked: false,
              comments: [],
            ),
          );
          _bodyController.clear();
          _mediaFile = null;
          _isPosting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post published successfully to the feed!'),
            backgroundColor: AppColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _deletePost(String id) {
    setState(() {
      _posts.removeWhere((p) => p.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post deleted successfully!'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
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
                Text(
                  'Active',
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
          // Input row: Paperclip + TextField
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file_rounded, color: AppColors.textMuted, size: 22),
                onPressed: _pickImage,
                tooltip: 'Attach Image',
              ),
              Expanded(
                child: TextField(
                  controller: _bodyController,
                  maxLines: null,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
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
          
          // Image Preview if selected
          if (_mediaFile != null) ...[
            const SizedBox(height: 10),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _mediaFile!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => _mediaFile = null),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
          
          const Divider(height: 20, color: AppColors.divider),
          
          // Action Buttons: Emoji + Mic + "Post" Send Button
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.sentiment_satisfied_alt_outlined, color: AppColors.textMuted, size: 22),
                onPressed: () {
                  _bodyController.text += ' 😊';
                  _bodyController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _bodyController.text.length),
                  );
                },
                tooltip: 'Add Emoji',
              ),
              IconButton(
                icon: const Icon(Icons.mic_none_outlined, color: AppColors.textMuted, size: 22),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Voice posting coming soon!'),
                      backgroundColor: AppColors.primary,
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                tooltip: 'Record Audio',
              ),
              const Spacer(),
              _isPosting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    )
                  : ElevatedButton.icon(
                      onPressed: _submitPost,
                      icon: const Icon(Icons.send_rounded, size: 13, color: Colors.white),
                      label: const Text(
                        'Post',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        minimumSize: const Size(80, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
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

  Widget _buildPostCard(MockPost post) {
    final hasAvatarUrl = post.authorAvatarUrl != null && post.authorAvatarUrl!.isNotEmpty;
    final isYourPost = post.authorName == 'You';

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
          // Header: Avatar, Name, Role and Action Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.surface2,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: hasAvatarUrl
                      ? Image.network(
                          post.authorAvatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              post.authorName[0],
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 14),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            post.authorName[0],
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 14),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: AppSizes.paddingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.authorRole,
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
              if (isYourPost)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                  onPressed: () => _deletePost(post.id),
                )
              else
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded, size: 20, color: AppColors.textMuted),
                  onPressed: () {},
                ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMd),
          
          // Body text with parsed and colored hashtags
          _buildBodyText(post.body),
          
          // Image attachments
          if (post.mediaFile != null) ...[
            const SizedBox(height: AppSizes.paddingMd),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                post.mediaFile!,
                fit: BoxFit.cover,
                height: 220,
                width: double.infinity,
              ),
            ),
          ] else if (post.mediaUrl != null && post.mediaUrl!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.paddingMd),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                post.mediaUrl!,
                fit: BoxFit.cover,
                height: 220,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 220,
                    color: AppColors.surface2,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: AppColors.surface2,
                  child: const Center(
                    child: Icon(Icons.broken_image_outlined, color: AppColors.textMuted),
                  ),
                ),
              ),
            ),
          ],
          
          const SizedBox(height: AppSizes.paddingMd),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 8),
          
          // Action Row: Likes, Comments, Shares, Bookmarks with full dynamic click actions!
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Like
              _buildActionItem(
                icon: post.isLiked ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
                color: post.isLiked ? AppColors.primary : AppColors.textMuted,
                label: '${post.likesCount}',
                onTap: () {
                  setState(() {
                    post.isLiked = !post.isLiked;
                    post.likesCount += post.isLiked ? 1 : -1;
                  });
                },
              ),
              
              // Comment
              _buildActionItem(
                icon: Icons.chat_bubble_outline_rounded,
                color: AppColors.textMuted,
                label: '${post.commentsCount}',
                onTap: () => _showCommentsBottomSheet(post),
              ),
              
              // Share
              _buildActionItem(
                icon: Icons.share_outlined,
                color: AppColors.textMuted,
                label: '${post.sharesCount}',
                onTap: () {
                  setState(() {
                    post.sharesCount += 1;
                  });
                  Share.share('Check this JUM Post: ${post.body}');
                },
              ),
              
              // Bookmark
              _buildActionItem(
                icon: post.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                color: post.isBookmarked ? AppColors.primary : AppColors.textMuted,
                label: '${post.bookmarksCount}',
                onTap: () {
                  setState(() {
                    post.isBookmarked = !post.isBookmarked;
                    post.bookmarksCount += post.isBookmarked ? 1 : -1;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(post.isBookmarked ? 'Bookmarked!' : 'Removed Bookmark!'),
                      backgroundColor: AppColors.primary,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
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
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(MockPost post) {
    final commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusLg),
                  topRight: Radius.circular(AppSizes.radiusLg),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handlebar / Indicator
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textMuted.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    
                    // Sheet Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Comments (${post.comments.length})',
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppColors.textMuted),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    
                    // Comments List or Empty State
                    Expanded(
                      child: post.comments.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppColors.textMuted.withOpacity(0.5)),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'No comments yet.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Be the first to share your thoughts!',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(AppSizes.paddingMd),
                              itemCount: post.comments.length,
                              itemBuilder: (context, idx) {
                                final comment = post.comments[idx];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Comment Avatar
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: AppColors.primary.withOpacity(0.1),
                                        backgroundImage: comment.authorAvatarUrl != null
                                            ? CachedNetworkImageProvider(comment.authorAvatarUrl!)
                                            : null,
                                        child: comment.authorAvatarUrl == null
                                            ? Text(
                                                comment.authorName[0].toUpperCase(),
                                                style: const TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: AppSizes.paddingSm),
                                      
                                      // Comment Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        comment.authorName,
                                                        style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.textPrimary,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '• ${comment.authorRole}',
                                                        style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 11,
                                                          color: AppColors.textMuted,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  _formatCommentTime(comment.createdAt),
                                                  style: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 10,
                                                    color: AppColors.textMuted,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              comment.body,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 13,
                                                color: AppColors.textPrimary,
                                                height: 1.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    
                    // Input Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Write a comment...',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: AppColors.textMuted,
                                ),
                                filled: true,
                                fillColor: AppColors.surface2,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingSm),
                          GestureDetector(
                            onTap: () {
                              final text = commentController.text.trim();
                              if (text.isEmpty) return;
                              
                              final newComment = MockComment(
                                id: DateTime.now().toString(),
                                authorName: 'You',
                                authorRole: 'Active Member',
                                body: text,
                                createdAt: DateTime.now(),
                              );
                              
                              setState(() {
                                post.comments.add(newComment);
                                post.commentsCount = post.comments.length;
                              });
                              
                              setSheetState(() {
                                commentController.clear();
                              });
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Comment added!'),
                                  backgroundColor: AppColors.primary,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primary,
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
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

  String _formatCommentTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingXl),
                itemCount: _posts.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    // Top Composer Card directly in-line
                    return _buildComposerCard();
                  }
                  
                  final post = _posts[i - 1];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMd,
                      vertical: 8,
                    ),
                    child: _buildPostCard(post),
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
