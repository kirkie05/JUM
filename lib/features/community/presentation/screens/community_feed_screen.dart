import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/jum_empty_state.dart';
import '../../../../shared/widgets/jum_error_state.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../../auth/data/providers/auth_provider.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/community_repository.dart';
import '../../data/providers/community_provider.dart';

// -------------------------------------------------------------
// INLINE AUDIO PLAYER
// -------------------------------------------------------------
class JumAudioPlayer extends StatefulWidget {
  final String url;
  const JumAudioPlayer({Key? key, required this.url}) : super(key: key);

  @override
  State<JumAudioPlayer> createState() => _JumAudioPlayerState();
}

class _JumAudioPlayerState extends State<JumAudioPlayer> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setSourceUrl(widget.url);

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) {
        setState(() {
          _duration = dur;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) {
        setState(() {
          _position = pos;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
              color: AppColors.primary,
              size: 40,
            ),
            onPressed: () {
              if (_isPlaying) {
                _audioPlayer.pause();
              } else {
                _audioPlayer.resume();
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Audio Attachment',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.divider,
                    thumbColor: AppColors.primary,
                  ),
                  child: Slider(
                    min: 0.0,
                    max: _duration.inMilliseconds.toDouble() > 0 
                        ? _duration.inMilliseconds.toDouble() 
                        : 1.0,
                    value: _position.inMilliseconds.toDouble().clamp(
                          0.0,
                          _duration.inMilliseconds.toDouble() > 0 
                              ? _duration.inMilliseconds.toDouble() 
                              : 1.0,
                        ),
                    onChanged: (val) {
                      _audioPlayer.seek(Duration(milliseconds: val.toInt()));
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// INLINE VIDEO PLAYER
// -------------------------------------------------------------
class JumVideoPlayer extends StatefulWidget {
  final String url;
  const JumVideoPlayer({Key? key, required this.url}) : super(key: key);

  @override
  State<JumVideoPlayer> createState() => _JumVideoPlayerState();
}

class _JumVideoPlayerState extends State<JumVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _chewieController = ChewieController(
              videoPlayerController: _videoController!,
              aspectRatio: _videoController!.value.aspectRatio,
              autoPlay: false,
              looping: false,
              materialProgressColors: ChewieProgressColors(
                playedColor: AppColors.primary,
                handleColor: AppColors.primary,
                backgroundColor: Colors.grey,
                bufferedColor: Colors.grey.shade300,
              ),
            );
          });
        }
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController != null && _videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Chewie(controller: _chewieController!),
      );
    }
    return Container(
      height: 200,
      color: Colors.black12,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

// -------------------------------------------------------------
// COMMUNITY FEED SCREEN
// -------------------------------------------------------------
class CommunityFeedScreen extends ConsumerStatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  ConsumerState<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends ConsumerState<CommunityFeedScreen> {
  final _bodyController = TextEditingController();
  File? _mediaFile;
  String? _mediaType;
  bool _isPosting = false;

  @override
  void dispose() {
    _bodyController.dispose();
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
      await ref.read(createPostNotifierProvider.notifier).submit(
        body: bodyText,
        mediaFile: _mediaFile,
        mediaType: _mediaType,
      );

      if (mounted) {
        setState(() {
          _bodyController.clear();
          _mediaFile = null;
          _mediaType = null;
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
            child: const Row(
              children: [
                Icon(Icons.people_alt_rounded, size: 14, color: AppColors.primary),
                SizedBox(width: 4),
                Text(
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
                onPressed: () => _showAttachmentOptions(context),
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
                  child: _mediaType == 'image'
                      ? Image.file(_mediaFile!, height: 140, width: double.infinity, fit: BoxFit.cover)
                      : Container(
                          height: 80,
                          width: double.infinity,
                          color: AppColors.surface2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _mediaType == 'video' ? Icons.play_circle_fill_rounded : Icons.audiotrack_rounded,
                                color: AppColors.primary,
                                size: 32,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _mediaFile!.path.split('/').last,
                                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _mediaFile = null;
                      _mediaType = null;
                    }),
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
                    const Text('Community Member', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
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

          // Repost rendering
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

          // Media attachments of parent post
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
                icon: Icons.chat_bubble_outline_rounded,
                color: AppColors.textMuted,
                label: 'Comment',
                onTap: () => _showCommentsBottomSheet(post),
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
    final postsAsync = ref.watch(communityFeedProvider(groupId: null));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: postsAsync.when(
                data: (posts) {
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
                loading: () => JumShimmer.list(),
                error: (e, st) {
                  debugPrint('[COMMUNITY_FEED] Provider error: $e');
                  return Center(
                    child: JumErrorState(
                      message: 'Failed to load community feed.',
                      onRetry: () => ref.invalidate(communityFeedProvider(groupId: null)),
                    ),
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
