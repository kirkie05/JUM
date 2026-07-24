import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
// Removed duplicate current_user_provider
import '../../data/repositories/community_repository.dart';
import '../../data/providers/community_provider.dart';
import '../../data/models/post_model.dart';
import '../../../../shared/widgets/jum_app_bar.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_text_field.dart';
import '../../../../shared/widgets/jum_avatar.dart';
import '../../../../shared/widgets/jum_error_state.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../../../shared/widgets/jum_empty_state.dart';
import '../../../messaging/data/providers/messaging_providers.dart';
import '../../../messaging/data/repositories/messaging_repository.dart';
import '../../../auth/data/providers/auth_provider.dart';
import 'community_feed_screen.dart';

// -------------------------------------------------------------
// STANDALONE CREATE POST SCREEN
// -------------------------------------------------------------
class CreatePostScreen extends ConsumerStatefulWidget {
  final String? groupId;
  const CreatePostScreen({Key? key, this.groupId}) : super(key: key);

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _postController = TextEditingController();
  File? _mediaFile;
  String? _mediaType;
  bool _isLoading = false;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(String type) async {
    final picker = ImagePicker();
    if (type == 'image') {
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _mediaFile = File(image.path);
          _mediaType = 'image';
        });
      }
    } else if (type == 'video') {
      final video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _mediaFile = File(video.path);
          _mediaType = 'video';
        });
      }
    } else if (type == 'audio') {
      final result = await FilePicker.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _mediaFile = File(result.files.single.path!);
          _mediaType = 'audio';
        });
      }
    }
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.image_outlined, color: AppColors.primary),
                title: const Text('Add Image', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia('image');
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_collection_outlined, color: AppColors.primary),
                title: const Text('Add Video', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia('video');
                },
              ),
              ListTile(
                leading: const Icon(Icons.audiotrack_outlined, color: AppColors.primary),
                title: const Text('Add Sound / Audio', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia('audio');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _publishPost() async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to publish a post.'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final body = _postController.text.trim();
    if (body.isEmpty && _mediaFile == null) return;

    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    try {
      await ref.read(createPostNotifierProvider.notifier).submit(
        body: body,
        mediaFile: _mediaFile,
        mediaType: _mediaType,
        groupId: widget.groupId,
      );

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Post published successfully!'), backgroundColor: AppColors.success),
      );
      if (mounted) {
        router.pop();
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to publish post: $e'), backgroundColor: Colors.redAccent),
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
                    Container(
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
                            widget.groupId != null ? 'Members Only' : 'Public Feed',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
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
                    child: _mediaType == 'image'
                        ? Image.file(_mediaFile!, height: 180, width: double.infinity, fit: BoxFit.cover)
                        : Container(
                            height: 100,
                            width: double.infinity,
                            color: AppColors.surface2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _mediaType == 'video' ? Icons.play_circle_fill_rounded : Icons.audiotrack_rounded,
                                  color: AppColors.primary,
                                  size: 36,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _mediaFile!.path.split('/').last,
                                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                Expanded(
                  child: JumCard(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    backgroundColor: AppColors.surface,
                    child: InkWell(
                      onTap: () => _showAttachmentOptions(context),
                      child: const Column(
                        children: [
                          Icon(Icons.attach_file_rounded, color: AppColors.primary, size: 24.0),
                          Gap(6),
                          Text(
                            'Attach Media',
                            style: TextStyle(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SMALL GROUPS DIRECTORY / LIST SCREEN
// -------------------------------------------------------------
class GroupsListScreen extends ConsumerStatefulWidget {
  const GroupsListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GroupsListScreen> createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends ConsumerState<GroupsListScreen> {
  void _createGroupDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    bool isCreating = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: const Text('Create New Group', style: TextStyle(fontFamily: 'Outfit', color: AppColors.textPrimary)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  JumTextField(
                    label: 'Group Name',
                    controller: nameController,
                    hint: 'e.g. Levites Choir',
                  ),
                  const Gap(12),
                  JumTextField(
                    label: 'Description',
                    controller: descController,
                    hint: 'Brief group mission statement',
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                ),
                ElevatedButton(
                  onPressed: isCreating
                      ? null
                      : () async {
                          final name = nameController.text.trim();
                          final desc = descController.text.trim();
                          if (name.isEmpty) return;

                          setDialogState(() => isCreating = true);
                          try {
                            final currentUser = ref.read(currentUserProvider).value;
                            if (currentUser == null) throw Exception('Must be logged in');

                            await ref.read(communityRepositoryProvider).createGroup(
                                  name: name,
                                  description: desc,
                                  leaderId: currentUser.id,
                                );

                            ref.invalidate(groupsListProvider);
                            if (context.mounted) Navigator.pop(context);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to create group: $e'), backgroundColor: Colors.redAccent),
                              );
                            }
                          } finally {
                            setDialogState(() => isCreating = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: isCreating
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Create', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupsListProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final isAdmin = currentUser != null && (currentUser.role == 'admin' || currentUser.role == 'super_admin' || currentUser.role == 'leader');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'Small Groups',
        showBack: true,
      ),
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return JumEmptyState(
              title: 'No Groups Available',
              subtitle: 'Check back later or ask an administrator to create a group.',
              icon: Icons.group_work_outlined,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24.0),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              final groupId = group['id'] as String;
              final groupName = group['name'] as String;
              final groupDesc = group['description'] as String? ?? 'No description provided.';
              
              final membersList = group['group_members'] as List<dynamic>? ?? [];
              final isJoined = currentUser != null && membersList.any((m) => m['user_id'] == currentUser.id);

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
                              groupName,
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
                              '${membersList.length} Members',
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
                        groupDesc,
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
                          if (!isJoined)
                            Expanded(
                              child: JumButton(
                                label: 'Join Group',
                                onPressed: currentUser == null
                                    ? null
                                    : () async {
                                        await ref.read(communityRepositoryProvider).joinGroup(groupId, currentUser.id);
                                        ref.invalidate(groupsListProvider);
                                      },
                              ),
                            )
                          else ...[
                            Expanded(
                              child: JumButton(
                                label: 'View Feed',
                                onPressed: () => context.push('/community/groups/feed?id=$groupId&name=${Uri.encodeComponent(groupName)}'),
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  // Fetch group conversation
                                  final conversationsRes = await Supabase.instance.client
                                      .from('conversations')
                                      .select('id')
                                      .eq('group_id', groupId)
                                      .maybeSingle()
                                      .catchError((_) => null);
                                  
                                  final convId = conversationsRes?['id'] as String?;
                                  if (context.mounted && convId != null) {
                                    context.push('/community/groups/chat/$convId?name=${Uri.encodeComponent(groupName)}');
                                  } else {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Group Chat conversation not found.'), backgroundColor: Colors.redAccent),
                                      );
                                    }
                                  }
                                },
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
                        ],
                      ),
                      if (isJoined) ...[
                        const Gap(8),
                        TextButton(
                          onPressed: () async {
                            await ref.read(communityRepositoryProvider).leaveGroup(groupId, currentUser.id);
                            ref.invalidate(groupsListProvider);
                          },
                          child: const Text('Leave Group', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => JumShimmer.list(),
        error: (e, st) => Center(child: JumErrorState(message: 'Failed to load groups list', onRetry: () => ref.invalidate(groupsListProvider))),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('New Group', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: _createGroupDialog,
            )
          : null,
    );
  }
}

// -------------------------------------------------------------
// SMALL GROUP DISCUSSION FEED SCREEN
// -------------------------------------------------------------
class GroupFeedScreen extends ConsumerStatefulWidget {
  final String groupId;
  final String groupName;
  const GroupFeedScreen({Key? key, required this.groupId, required this.groupName}) : super(key: key);

  @override
  ConsumerState<GroupFeedScreen> createState() => _GroupFeedScreenState();
}

class _GroupFeedScreenState extends ConsumerState<GroupFeedScreen> {
  void _deletePost(String id) async {
    try {
      await ref.read(communityRepositoryProvider).deletePost(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted!'), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent));
      }
    }
  }

  void _confirmRepost(PostModel post) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Repost', style: TextStyle(fontFamily: 'Outfit', color: AppColors.textPrimary)),
          content: Text('Would you like to repost this message from ${post.authorName ?? "Member"} to the community feed?', style: const TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final user = ref.read(authNotifierProvider).value;
                if (user == null) return;
                
                try {
                  await ref.read(communityRepositoryProvider).createPost(
                    userId: user.id,
                    body: 'Reposted',
                    repostOfId: post.id,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reposted successfully!'), backgroundColor: AppColors.success),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to repost: $e'), backgroundColor: Colors.redAccent),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Repost', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
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
                    const Text('Group Member', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
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

          if (post.repostOfId != null && post.repostedPost != null) ...[
            const SizedBox(height: AppSizes.paddingMd),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        backgroundImage: post.repostedPost!.authorAvatarUrl != null
                            ? CachedNetworkImageProvider(post.repostedPost!.authorAvatarUrl!)
                            : null,
                        child: post.repostedPost!.authorAvatarUrl == null
                            ? Text(
                                post.repostedPost!.authorName?.substring(0, 1).toUpperCase() ?? 'M',
                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primary),
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post.repostedPost!.authorName ?? 'Member',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.repostedPost!.body,
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary),
                  ),
                  if (post.repostedPost!.mediaUrl != null && post.repostedPost!.mediaUrl!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: post.repostedPost!.mediaType == 'image'
                          ? CachedNetworkImage(
                              imageUrl: post.repostedPost!.mediaUrl!,
                              fit: BoxFit.cover, height: 120, width: double.infinity,
                            )
                          : post.repostedPost!.mediaType == 'video'
                              ? JumVideoPlayer(url: post.repostedPost!.mediaUrl!)
                              : JumAudioPlayer(url: post.repostedPost!.mediaUrl!),
                    ),
                  ],
                ],
              ),
            ),
          ],

          if (post.mediaUrl != null && post.mediaUrl!.isNotEmpty && post.mediaType != null) ...[
            const SizedBox(height: AppSizes.paddingMd),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: post.mediaType == 'image'
                  ? CachedNetworkImage(
                      imageUrl: post.mediaUrl!,
                      fit: BoxFit.cover, height: 220, width: double.infinity,
                    )
                  : post.mediaType == 'video'
                      ? JumVideoPlayer(url: post.mediaUrl!)
                      : JumAudioPlayer(url: post.mediaUrl!),
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
                icon: Icons.repeat_rounded,
                color: AppColors.textMuted,
                label: 'Repost',
                onTap: () => _confirmRepost(post),
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

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(communityFeedProvider(groupId: widget.groupId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: JumAppBar(
        title: widget.groupName,
        showBack: true,
      ),
      body: postsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return JumEmptyState(
              title: 'No posts yet',
              subtitle: 'Be the first to share something with this group!',
              icon: Icons.forum_outlined,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24.0),
            itemCount: posts.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildPostCard(posts[i]),
              );
            },
          );
        },
        loading: () => JumShimmer.list(),
        error: (e, st) => Center(child: JumErrorState(message: 'Failed to load group feed.', onRetry: () => ref.invalidate(communityFeedProvider(groupId: widget.groupId)))),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => context.push('/community/create-post?groupId=${widget.groupId}'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// -------------------------------------------------------------
// SMALL GROUP REAL-TIME CHAT SCREEN
// -------------------------------------------------------------
class GroupChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String groupName;

  const GroupChatScreen({
    Key? key,
    required this.conversationId,
    required this.groupName,
  }) : super(key: key);

  @override
  ConsumerState<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends ConsumerState<GroupChatScreen> {
  final _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _send() async {
    final txt = _msgController.text.trim();
    if (txt.isEmpty) return;

    _msgController.clear();
    try {
      await ref.read(sendMessageNotifierProvider.notifier).sendGroupMessage(
        conversationId: widget.conversationId,
        body: txt,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dt) {
    final localDt = dt.toLocal();
    final hour = localDt.hour == 0 ? 12 : (localDt.hour > 12 ? localDt.hour - 12 : localDt.hour);
    final minute = localDt.minute.toString().padLeft(2, '0');
    final amPm = localDt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(groupConversationProvider(widget.conversationId));
    final currentUser = ref.watch(currentUserProvider).value;
    final currentUserId = currentUser?.id ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: JumAppBar(
        title: widget.groupName,
        showBack: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => JumShimmer.list(),
              error: (err, _) {
                debugPrint('[GROUP_CHAT] Error loading messages: $err');
                return Center(
                  child: JumErrorState(
                    message: 'Failed to load messages. Please try again.',
                    onRetry: () => ref.invalidate(groupConversationProvider(widget.conversationId)),
                  ),
                );
              },
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet. Say hello to start the fellowship!',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(24.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final m = messages[index];
                    final isMe = m.senderId == currentUserId;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16.0),
                            topRight: const Radius.circular(16.0),
                            bottomLeft: isMe ? const Radius.circular(16.0) : Radius.zero,
                            bottomRight: isMe ? Radius.zero : const Radius.circular(16.0),
                          ),
                          border: Border.all(color: AppColors.border, width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              const Text(
                                'Group Member',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              ),
                            if (!isMe) const Gap(4),
                            Text(
                              m.body,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.0,
                                color: isMe ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            const Gap(4),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                _formatDateTime(m.createdAt),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.0,
                                  color: isMe ? Colors.white70 : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
