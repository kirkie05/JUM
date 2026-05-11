import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../data/repositories/community_repository.dart';
import '../../../../shared/widgets/jum_app_bar.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_text_field.dart';
import '../../../../shared/widgets/jum_avatar.dart';

// -------------------------------------------------------------
// STANDALONE CREATE POST SCREEN
// -------------------------------------------------------------
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _postController = TextEditingController();
  File? _mediaFile;
  String? _mediaType;
  bool _isLoading = false;
  String _selectedScope = 'Public Feed';

  void _publishPost() async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to publish a post.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final body = _postController.text.trim();
    if (body.isEmpty && _mediaFile == null) return;

    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    try {
      await ref.read(communityRepositoryProvider).createPost(
        userId: currentUser.id,
        churchId: currentUser.churchId ?? 'default_church',
        body: body,
        mediaUrl: _mediaFile?.path,
        mediaType: _mediaType,
      );

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Post published successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      if (mounted) {
        router.pop();
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to publish post: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;
    final userName = currentUser?.name ?? 'JUM Member';
    final userInitials = userName.isNotEmpty 
        ? userName.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : 'JM';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: JumAppBar(
        title: 'Create Post',
        showBack: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              width: 90.0,
              height: 36.0,
              child: JumButton(
                label: 'Publish',
                onPressed: _isLoading ? null : _publishPost,
                isLoading: _isLoading,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                JumAvatar(
                  initials: userInitials,
                  imageUrl: currentUser?.avatarUrl,
                  size: 48.0,
                ),
                const Gap(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Gap(4),
                    // Scope selector
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedScope = _selectedScope == 'Public Feed' ? 'Members Only' : 'Public Feed';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.surface2,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.public_rounded, size: 12.0, color: AppColors.primary),
                            const Gap(4),
                            Text(
                              _selectedScope,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const Gap(2),
                            const Icon(Icons.arrow_drop_down_rounded, size: 14.0, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(24),
            TextField(
              controller: _postController,
              maxLines: 8,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: "What's on your mind? Share a testimony, scriptural insight, or prayer request...",
                hintStyle: TextStyle(color: AppColors.textSecondary),
                border: InputBorder.none,
              ),
            ),
            const Gap(16),
            if (_mediaFile != null) ...[
              const SizedBox(height: AppSizes.paddingMd),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    child: _mediaType == 'video'
                        ? Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.black54,
                            child: const Center(
                              child: Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 48),
                            ),
                          )
                        : Image.file(_mediaFile!, height: 180, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => setState(() {
                          _mediaFile = null;
                          _mediaType = null;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const Gap(24),
            const Divider(color: AppColors.border),
            const Gap(16),
            const Text(
              'ADD TO YOUR POST',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 1.0,
              ),
            ),
            const Gap(12),
            Row(
              children: [
                _buildAttachmentButton(
                  icon: Icons.image_outlined,
                  label: 'Photo',
                  onTap: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _mediaFile = File(image.path);
                        _mediaType = 'image';
                      });
                    }
                  },
                ),
                const Gap(12),
                _buildAttachmentButton(
                  icon: Icons.video_collection_outlined,
                  label: 'Video',
                  onTap: () async {
                    final picker = ImagePicker();
                    final video = await picker.pickVideo(source: ImageSource.gallery);
                    if (video != null) {
                      setState(() {
                        _mediaFile = File(video.path);
                        _mediaType = 'video';
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return Expanded(
      child: JumCard(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        backgroundColor: AppColors.surface,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 24.0),
              const Gap(6),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SMALL GROUPS DIRECTORY / LIST SCREEN
// -------------------------------------------------------------
class GroupsListScreen extends StatelessWidget {
  const GroupsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groups = [
      {
        'name': 'Grace & Mercy Fellowship',
        'desc': 'Weekly study on growing in grace, mercy, and prayer.',
        'members': '28 Members',
        'nextMeeting': 'Today, 6:00 PM',
        'isJoined': true,
      },
      {
        'name': 'Youth On Fire',
        'desc': 'Passionate young believers seeking revival in Lagos.',
        'members': '45 Members',
        'nextMeeting': 'Friday, 5:30 PM',
        'isJoined': false,
      },
      {
        'name': 'Men of Valor',
        'desc': 'Empowering men to lead spiritually in homes & marketplaces.',
        'members': '18 Members',
        'nextMeeting': 'Saturday, 8:00 AM',
        'isJoined': false,
      },
      {
        'name': 'Women of Wisdom',
        'desc': 'Nurturing prayer warriors, wives, and professional leaders.',
        'members': '32 Members',
        'nextMeeting': 'Sunday, 4:00 PM',
        'isJoined': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'Small Groups',
        showBack: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: JumCard(
              backgroundColor: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          group['name'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.surface2,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          group['members'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    group['desc'] as String,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.0,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 14.0, color: AppColors.textMuted),
                      const Gap(6),
                      Text(
                        'Next: ${group['nextMeeting']}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: JumButton(
                          label: 'View Feed',
                          onPressed: () => context.push('/community/groups/feed'),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push('/community/groups/chat'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                          ),
                          child: const Text(
                            'Group Chat',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------
// SMALL GROUP DISCUSSION FEED SCREEN
// -------------------------------------------------------------
class GroupFeedScreen extends StatefulWidget {
  const GroupFeedScreen({Key? key}) : super(key: key);

  @override
  State<GroupFeedScreen> createState() => _GroupFeedScreenState();
}

class _GroupFeedScreenState extends State<GroupFeedScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      'author': 'Brother John',
      'role': 'Group Leader',
      'avatar': 'https://picsum.photos/seed/john/100/100',
      'time': '2 hours ago',
      'body': 'Looking forward to seeing everyone tonight! We are reading Ephesians 4. Don\'t forget to write down your favorite verses.',
      'likes': 14,
      'isLiked': false,
    },
    {
      'author': 'Sister Ruth',
      'role': 'Prayer Secretary',
      'avatar': 'https://picsum.photos/seed/ruth/100/100',
      'time': 'Yesterday',
      'body': 'Urgent prayer request: Sister Grace\'s father is in the hospital. Let\'s lift him up in powerful prayers today.',
      'likes': 22,
      'isLiked': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'Youth On Fire Feed',
        showBack: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: JumCard(
              backgroundColor: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          post['avatar']!,
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['author']!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Gap(2),
                            Text(
                              '${post['role']!} • ${post['time']!}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  Text(
                    post['body']!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const Gap(16),
                  const Divider(color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            post['isLiked'] = !post['isLiked'];
                            post['likes'] += post['isLiked'] ? 1 : -1;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              post['isLiked'] ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              color: post['isLiked'] ? AppColors.error : AppColors.textSecondary,
                              size: 18.0,
                            ),
                            const Gap(6),
                            Text(
                              '${post['likes']} likes',
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 13.0, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.comment_outlined, size: 18.0, color: AppColors.textSecondary),
                          const Gap(6),
                          const Text(
                            'Comment',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 13.0, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => context.push('/community/create-post'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// -------------------------------------------------------------
// SMALL GROUP REAL-TIME CHAT SCREEN
// -------------------------------------------------------------
class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({Key? key}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _msgController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'Brother John',
      'isMe': false,
      'body': 'Good evening saints! Let\'s begin our virtual fellowship now.',
      'time': '6:00 PM',
    },
    {
      'sender': 'Sister Ruth',
      'isMe': false,
      'body': 'Praise God! I\'m online and ready.',
      'time': '6:02 PM',
    },
    {
      'sender': 'Emmanuel',
      'isMe': true,
      'body': 'Amen! Excited to dive into Ephesians tonight.',
      'time': '6:03 PM',
    },
  ];

  void _send() {
    final txt = _msgController.text.trim();
    if (txt.isEmpty) return;
    setState(() {
      _messages.add({
        'sender': 'Emmanuel',
        'isMe': true,
        'body': txt,
        'time': '6:05 PM',
      });
      _msgController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'Youth On Fire Chat',
        showBack: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                return Align(
                  alignment: m['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: m['isMe'] ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16.0),
                        topRight: const Radius.circular(16.0),
                        bottomLeft: m['isMe'] ? const Radius.circular(16.0) : Radius.zero,
                        bottomRight: m['isMe'] ? Radius.zero : const Radius.circular(16.0),
                      ),
                      border: Border.all(color: AppColors.border, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!m['isMe'])
                          Text(
                            m['sender']!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        if (!m['isMe']) const Gap(4),
                        Text(
                          m['body']!,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            color: m['isMe'] ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const Gap(4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            m['time']!,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10.0,
                              color: m['isMe'] ? Colors.white70 : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 24.0,
              right: 12.0,
              top: 12.0,
              bottom: MediaQuery.of(context).padding.bottom + 12.0,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: JumTextField(
                    label: 'Message',
                    hint: 'Type a message...',
                    controller: _msgController,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
