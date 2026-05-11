import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/media_item.dart';

class MediaPlayerScreen extends StatefulWidget {
  const MediaPlayerScreen({super.key, required this.item});

  final MediaItem item;

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  YoutubePlayerController? _ytController;
  VideoPlayerController? _vpController;
  bool _isInitialized = false;

  final _noteController = TextEditingController();
  SharedPreferences? _prefs;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _loadNote();
  }

  void _initializePlayer() {
    final url = widget.item.sourceUrl;
    if (widget.item.type == MediaItemType.video &&
        (url.contains('youtube') || url.contains('youtu.be'))) {
      final videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId != null) {
        _ytController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            enableCaption: false,
            useHybridComposition: true,
          ),
        );
        _isInitialized = true;
      }
    } else {
      _vpController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
            _vpController?.play();
          }
        }).catchError((e) {
          debugPrint('Video Player Init Error: $e');
        });
    }
  }

  Future<void> _loadNote() async {
    _prefs = await SharedPreferences.getInstance();
    final noteKey = 'media_note_${widget.item.id}';
    final savedText = _prefs?.getString(noteKey) ?? '';
    setState(() {
      _noteController.text = savedText;
    });
  }

  Future<void> _saveNote(String text) async {
    if (_prefs == null) return;
    final noteKey = 'media_note_${widget.item.id}';
    setState(() => _isSaving = true);
    await _prefs?.setString(noteKey, text);
    setState(() => _isSaving = false);
  }

  void _shareNote() {
    final noteText = _noteController.text;
    final content =
        'Note on "${widget.item.title}":\n\n$noteText\n\n- via Jesus Unhindered Ministry app';
    Share.share(content, subject: 'My Sermon Notes: ${widget.item.title}');
  }

  @override
  void dispose() {
    _ytController?.dispose();
    _vpController?.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0A0A0A) : AppColors.background;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _ytController ?? YoutubePlayerController(initialVideoId: ''),
        showVideoProgressIndicator: true,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.accent,
          handleColor: AppColors.accent,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                tooltip: 'Share Note',
                icon: const Icon(Icons.share_outlined),
                onPressed: _shareNote,
              ),
              const Gap(12),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: _buildPlayerView(player),
                  ),
                ),
                const Gap(24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      const Gap(8),
                      Row(
                        children: [
                          if (widget.item.isLive) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'LIVE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Gap(12),
                          ],
                          Text(
                            widget.item.type == MediaItemType.video
                                ? 'Video'
                                : 'Audio stream',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: isDark
                                  ? Colors.white60
                                  : AppColors.textSecondary,
                            ),
                          ),
                          if (widget.item.viewCount != null) ...[
                            const Gap(8),
                            Text(
                              '•',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white38
                                    : AppColors.textSecondary,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              '${widget.item.viewCount} views',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: isDark
                                    ? Colors.white60
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Divider(height: 40, color: Colors.white12),

                      // Notes Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white10 : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'TAKE NOTES',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                    color: AppColors.accent,
                                  ),
                                ),
                                if (_isSaving)
                                  const SizedBox(
                                    height: 12,
                                    width: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.grey,
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                              ],
                            ),
                            const Gap(12),
                            TextField(
                              controller: _noteController,
                              maxLines: null,
                              minLines: 4,
                              onChanged: _saveNote,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Write your thoughts here...',
                                hintStyle: TextStyle(
                                  color: isDark ? Colors.white38 : Colors.black38,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),

                      if (widget.item.description != null &&
                          widget.item.description!.isNotEmpty) ...[
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          widget.item.description!,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: isDark
                                ? Colors.white70
                                : AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerView(Widget ytPlayer) {
    if (_ytController != null) {
      return ytPlayer;
    }

    if (_vpController != null) {
      if (!_isInitialized) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        );
      }

      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (widget.item.type == MediaItemType.video)
            VideoPlayer(_vpController!)
          else
            Stack(
              fit: StackFit.expand,
              children: [
                if (widget.item.thumbnailUrl != null)
                  Opacity(
                    opacity: 0.3,
                    child: CachedNetworkImage(
                      imageUrl: widget.item.thumbnailUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.graphic_eq, size: 40),
                  ),
                ),
              ],
            ),
          _VideoControls(
            controller: _vpController!,
            isVideo: widget.item.type == MediaItemType.video,
          ),
        ],
      );
    }

    return const Center(
      child: Text('Unsupported media format'),
    );
  }
}

class _VideoControls extends StatefulWidget {
  const _VideoControls({required this.controller, this.isVideo = false});
  final VideoPlayerController controller;
  final bool isVideo;

  @override
  State<_VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<_VideoControls> {
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  void _listener() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  void _seekRelative(int seconds) {
    final current = widget.controller.value.position;
    final target = current + Duration(seconds: seconds);
    widget.controller.seekTo(target);
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.controller.value;
    final isPlaying = value.isPlaying;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          VideoProgressIndicator(
            widget.controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: AppColors.accent,
              bufferedColor: Colors.white24,
              backgroundColor: Colors.white10,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10_rounded,
                    color: Colors.white, size: 24),
                onPressed: () => _seekRelative(-10),
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () {
                  isPlaying
                      ? widget.controller.pause()
                      : widget.controller.play();
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10_rounded,
                    color: Colors.white, size: 24),
                onPressed: () => _seekRelative(10),
              ),
              const Spacer(),
              Text(
                _formatDuration(value.position),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const Text(' / ',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              Text(
                _formatDuration(value.duration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              if (widget.isVideo) ...[
                const Gap(8),
                IconButton(
                  icon: Icon(
                    _isFullScreen
                        ? Icons.fullscreen_exit_rounded
                        : Icons.fullscreen_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Simple state-driven toggle for demo. Fullscreen requires overlay
                    setState(() => _isFullScreen = !_isFullScreen);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Toggled Fullscreen Mode')),
                    );
                  },
                ),
              ],
              const Gap(12),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
