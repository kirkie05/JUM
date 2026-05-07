import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../../shared/widgets/jum_app_bar.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../data/models/stream_model.dart';
import '../../data/providers/live_provider.dart';
import '../../data/repositories/live_repository.dart';

class LiveWatchScreen extends ConsumerStatefulWidget {
  final String streamId;

  const LiveWatchScreen({
    Key? key,
    required this.streamId,
  }) : super(key: key);

  @override
  ConsumerState<LiveWatchScreen> createState() => _LiveWatchScreenState();
}

class _LiveWatchScreenState extends ConsumerState<LiveWatchScreen> {
  VideoPlayerController? _controller;
  bool _isPlayerInitialized = false;
  bool _showEndedOverlay = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    final streams = ref.read(liveStreamsStreamProvider).value;
    final stream = streams?.firstWhere(
          (s) => s.id == widget.streamId,
          orElse: () => _fallbackStream(),
        ) ??
        _fallbackStream();

    final url = 'https://stream.mux.com/${stream.muxPlaybackId}.m3u8';
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await _controller!.initialize();
      await _controller!.play();
      if (mounted) {
        setState(() {
          _isPlayerInitialized = true;
          _showEndedOverlay = stream.status == 'ended';
        });
      }
    } catch (e) {
      debugPrint('Error initializing live video: $e');
    }
  }

  LiveStreamModel _fallbackStream() {
    return LiveStreamModel(
      id: widget.streamId,
      churchId: 'jum-church-1',
      muxStreamId: 'mux-stream-1',
      muxPlaybackId: 'v69ElvZnALSpU7vS68v8500602',
      title: 'Sunday Victory Service',
      status: 'active',
      scheduledAt: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _watchReplay() async {
    setState(() {
      _showEndedOverlay = false;
    });
    await _controller?.seekTo(Duration.zero);
    await _controller?.play();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 720;

    final streamsAsync = ref.watch(liveStreamsStreamProvider);
    final stream = streamsAsync.value?.firstWhere(
          (s) => s.id == widget.streamId,
          orElse: () => _fallbackStream(),
        ) ??
        _fallbackStream();

    final videoWidget = AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isPlayerInitialized) VideoPlayer(_controller!),
            if (!_isPlayerInitialized)
              const Center(child: CircularProgressIndicator(color: AppColors.accent)),
            if (_showEndedOverlay)
              Container(
                color: Colors.black87,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam_off_rounded, size: 64, color: AppColors.error),
                      const Gap(16),
                      Text(
                        'This Live Stream Has Ended',
                        style: AppTextStyles.h2.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const Gap(24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                        onPressed: _watchReplay,
                        icon: const Icon(Icons.replay_rounded, color: Colors.black),
                        label: const Text('Watch Replay', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    final detailsWidget = Padding(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: stream.status == 'active' ? AppColors.error : AppColors.surface2,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  stream.status == 'active' ? 'LIVE' : 'ENDED',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
              const Gap(12),
              const Icon(Icons.remove_red_eye_rounded, size: 16, color: AppColors.textSecondary),
              const Gap(6),
              Text(
                '142 Viewers',
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const Gap(12),
          Text(
            stream.title,
            style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          const Gap(8),
          Text(
            'Welcome to our interactive live stream. Connect with believers across the globe. Type your prayer requests and praise reports below.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );

    final chatWidget = LiveChatWidget(streamId: widget.streamId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: JumAppBar(
        title: stream.title,
        showBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.accent),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing live stream link...'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
        ],
      ),
      body: isMobile
          ? Column(
              children: [
                videoWidget,
                detailsWidget,
                const Divider(height: 1, color: AppColors.border),
                Expanded(child: chatWidget),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        videoWidget,
                        detailsWidget,
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, color: AppColors.border),
                SizedBox(
                  width: 360,
                  child: chatWidget,
                ),
              ],
            ),
    );
  }
}

class LiveChatWidget extends ConsumerStatefulWidget {
  final String streamId;

  const LiveChatWidget({
    Key? key,
    required this.streamId,
  }) : super(key: key);

  @override
  ConsumerState<LiveChatWidget> createState() => _LiveChatWidgetState();
}

class _LiveChatWidgetState extends ConsumerState<LiveChatWidget> {
  final TextEditingController _chatController = TextEditingController();

  void _sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    final user = ref.read(currentUserProvider).value;
    final String userId = user?.id ?? 'guest-123';
    final String userName = user?.name ?? 'Guest User';
    final String? userAvatarUrl = user?.avatarUrl;

    _chatController.clear();

    try {
      await ref.read(liveRepositoryProvider).sendChatMessage(
            streamId: widget.streamId,
            userId: userId,
            userName: userName,
            userAvatarUrl: userAvatarUrl,
            body: text,
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
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatStreamAsync = ref.watch(liveChatStreamProvider(widget.streamId));

    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // Chat Header
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.accent, size: 20),
                const Gap(8),
                Text(
                  'Live Chat',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Messages Stream
          Expanded(
            child: chatStreamAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Chat error: $err')),
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'Welcome to Live Chat!\nSay something to start.',
                      style: TextStyle(color: AppColors.textMuted),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.paddingMd),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.accent,
                            backgroundImage: msg.userAvatarUrl != null ? NetworkImage(msg.userAvatarUrl!) : null,
                            child: msg.userAvatarUrl == null
                                ? Text(msg.userName.substring(0, 1).toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold))
                                : null,
                          ),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.userName,
                                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                                ),
                                const Gap(2),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface2,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    msg.body,
                                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                                  ),
                                ),
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

          // Input Row
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: AppColors.surface2,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const Gap(8),
                CircleAvatar(
                  backgroundColor: AppColors.accent,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


