import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../data/models/media_item.dart';
import '../../data/models/media_note_model.dart';
import '../../data/providers/media_provider.dart';
import '../../data/providers/media_notes_provider.dart';

class MediaPlayerScreen extends ConsumerStatefulWidget {
  const MediaPlayerScreen({super.key, required this.item});

  final MediaItem item;

  @override
  ConsumerState<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends ConsumerState<MediaPlayerScreen> {
  // YouTube Player Controller
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  final _yt = YoutubeExplode();
  String _thumbnailUrl = '';
  String _videoTitle = '';
  Duration _videoDuration = Duration.zero;
  bool _isInitialized = false;

  // Platform Channel for PiP
  static const _pipChannel = MethodChannel('com.jumministry.jum/pip');

  // Fullscreen State
  bool _isFullScreen = false;

  // Track if progress was resumed once
  bool _hasResumedProgress = false;

  // Periodic Timer to save watching progress (throttled to avoid heavy writes)
  Timer? _progressSaveTimer;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    
    // Periodically save watching progress
    _progressSaveTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _saveCurrentProgress();
    });
  }

  Future<void> _initializePlayer() async {
    try {
      String videoUrl = widget.item.sourceUrl;
      String? ytVideoId = VideoId.parseVideoId(widget.item.sourceUrl);
      
      if (ytVideoId != null) {
        _thumbnailUrl = 'https://img.youtube.com/vi/$ytVideoId/hqdefault.jpg';
        final video = await _yt.videos.get(ytVideoId);
        _videoTitle = video.title;
        _videoDuration = video.duration ?? Duration.zero;
        
        final manifest = await _yt.videos.streamsClient.getManifest(ytVideoId);
        final streamInfo = manifest.muxed.withHighestBitrate();
        videoUrl = streamInfo.url.toString();
      } else {
        _videoTitle = widget.item.title;
      }

      if (!mounted) return;

      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _videoPlayerController!.initialize();
      
      _videoPlayerController!.addListener(_playerListener);

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        allowedScreenSleep: false,
        allowFullScreen: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey[300]!,
        ),
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        
        // Auto resume
        if (!_hasResumedProgress && !widget.item.isLive) {
          _hasResumedProgress = true;
          final repo = ref.read(mediaRepositoryProvider);
          final progress = await repo.getPlaybackProgress(widget.item.id);
          if (progress != null) {
            final positionMs = progress['positionMs'] as int? ?? 0;
            final durationMs = _videoPlayerController!.value.duration.inMilliseconds;
            if (positionMs > 0 && positionMs < (durationMs - 5000)) {
              _videoPlayerController!.seekTo(Duration(milliseconds: positionMs));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Resumed from ${_formatSeconds(positionMs ~/ 1000)}'),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint('[PLAYER] Init error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading video stream.')),
        );
      }
    }
  }

  void _playerListener() {
    if (!mounted || _videoPlayerController == null) return;
    if (_videoPlayerController!.value.hasError) {
      debugPrint('VIDEO PLAYER ERROR: ${_videoPlayerController!.value.errorDescription}');
    }
    setState(() {}); // Update custom controls
  }

  Future<void> _saveCurrentProgress() async {
    if (!mounted || widget.item.isLive || !_isInitialized) return;

    final positionMs = _videoPlayerController?.value.position.inMilliseconds ?? 0;
    final durationMs = _videoPlayerController?.value.duration.inMilliseconds ?? 0;
    
    if (positionMs <= 0 || durationMs <= 0) return;

    final completion = positionMs / durationMs;
    final repo = ref.read(mediaRepositoryProvider);
    
    await repo.savePlaybackProgress(
      videoId: widget.item.id,
      positionMs: positionMs,
      completionPercentage: completion,
    );

    // Auto-refresh the Continue Watching provider to reflect the newest positions in UI
    ref.invalidate(continueWatchingProvider);
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  Future<void> _enterPiPMode() async {
    try {
      await _pipChannel.invokeMethod('enterPip');
    } on PlatformException catch (e) {
      debugPrint('[PLAYER] PiP Platform Error: $e');
    }
  }

  void _seekRelative(int seconds) {
    if (_videoPlayerController == null) return;
    final current = _videoPlayerController!.value.position;
    var target = current + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    _videoPlayerController!.seekTo(target);
  }

  void _shareSermon() {
    Share.share(
      'Watch "${widget.item.title}" on YouTube:\n${widget.item.sourceUrl}\n\n- via Jesus Unhindered Ministry App',
      subject: widget.item.title,
    );
  }

  Future<void> _openYouTube() async {
    final uri = Uri.parse(widget.item.sourceUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to launch YouTube.')),
        );
      }
    }
  }

  String _formatSeconds(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      final hours = twoDigits(duration.inHours);
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _saveCurrentProgress();
    _progressSaveTimer?.cancel();
    
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    _videoPlayerController?.removeListener(_playerListener);
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(mediaNotesProvider(widget.item.id));
    final currentUserId = ref.watch(currentUserProvider).value?.id;

    return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Playing Teaching',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Picture in Picture',
                icon: const Icon(Icons.picture_in_picture_alt_rounded, color: Colors.black),
                onPressed: _enterPiPMode,
              ),
              IconButton(
                tooltip: 'Share Sermon',
                icon: const Icon(Icons.share_outlined, color: Colors.black),
                onPressed: _shareSermon,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Video Player
                _isInitialized && _chewieController != null
                    ? AspectRatio(
                        aspectRatio: _videoPlayerController!.value.aspectRatio > 0 ? _videoPlayerController!.value.aspectRatio : 16 / 9,
                        child: Chewie(controller: _chewieController!),
                      )
                    : AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.black,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (_thumbnailUrl.isNotEmpty)
                                CachedNetworkImage(
                                  imageUrl: _thumbnailUrl,
                                  fit: BoxFit.cover,
                                  color: Colors.black45,
                                  colorBlendMode: BlendMode.darken,
                                ),
                              const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ),

                // Video Player Custom Controller Row (Play/Pause, Replay 10s, Forward 10s, speed, Fullscreen)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.replay_10_rounded, color: Colors.black87),
                        onPressed: () => _seekRelative(-10),
                      ),
                      !_isInitialized
                          ? const IconButton(
                              icon: Icon(Icons.play_arrow_rounded, color: Colors.grey, size: 30),
                              onPressed: null,
                            )
                          : ValueListenableBuilder(
                              valueListenable: _videoPlayerController ?? ValueNotifier(VideoPlayerValue(duration: Duration.zero)),
                              builder: (context, val, _) {
                                final bool isPlaying = _videoPlayerController?.value.isPlaying ?? false;
                                return IconButton(
                                  icon: Icon(
                                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    color: Colors.black87,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    if (isPlaying) {
                                      _videoPlayerController?.pause();
                                    } else {
                                      _videoPlayerController?.play();
                                    }
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                      IconButton(
                        icon: const Icon(Icons.forward_10_rounded, color: Colors.black87),
                        onPressed: () => _seekRelative(10),
                      ),
                      const Spacer(),
                      // Playback speed selector button
                      PopupMenuButton<double>(
                        initialValue: _videoPlayerController?.value.playbackSpeed ?? 1.0,
                        tooltip: 'Playback Speed',
                        icon: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${_videoPlayerController?.value.playbackSpeed ?? 1.0}x',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        onSelected: (speed) {
                          _videoPlayerController?.setPlaybackSpeed(speed);
                          setState(() {});
                        },
                        itemBuilder: (context) => [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((s) {
                          return PopupMenuItem(
                            value: s,
                            child: Text('${s}x'),
                          );
                        }).toList(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.fullscreen_rounded, color: Colors.black87),
                        onPressed: _toggleFullScreen,
                      ),
                    ],
                  ),
                ),

                const Gap(16),

                // Video details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.3,
                        ),
                      ),
                      const Gap(8),
                      Row(
                        children: [
                          if (widget.item.isLive) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'LIVE BROADCAST',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Gap(10),
                          ],
                          if (widget.item.publishedAt != null)
                            Text(
                              'Published: ${DateFormat('MMMM d, yyyy').format(widget.item.publishedAt!)}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      const Gap(16),

                      // Open on YouTube Action Card
                      InkWell(
                        onTap: _openYouTube,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEB), // Pale red
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFFCCCC)),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.open_in_new_rounded, color: Color(0xFFFF0000), size: 20),
                              Gap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Watch directly on YouTube',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF990000),
                                      ),
                                    ),
                                    Text(
                                      'Join live chat, comment, and support the ministry channel.',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        color: Color(0xFFCC3333),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: Color(0xFFFF0000)),
                            ],
                          ),
                        ),
                      ),

                      const Gap(24),

                      // Synchronized Sermon Notes Interface
                      _buildNotesPanel(notesAsync, currentUserId, isDark: false),

                      const Gap(24),

                      // Description
                      if (widget.item.description != null && widget.item.description!.isNotEmpty) ...[
                        const Text(
                          'Sermon Description',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          widget.item.description!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Color(0xFF4B5563),
                            height: 1.5,
                          ),
                        ),
                        const Gap(24),
                      ],

                      // Related Videos
                      _buildRelatedVideosSection(),

                      const Gap(40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Widget _buildNotesPanel(
    AsyncValue<List<MediaNoteModel>> notesAsync,
    String? currentUserId, {
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.note_alt_rounded, color: AppColors.primary, size: 20),
                  Gap(8),
                  Text(
                    'PERSONAL NOTES',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _addNoteDialog(currentUserId),
                icon: const Icon(Icons.add, size: 14, color: Colors.white),
                label: ValueListenableBuilder(
                  valueListenable: _videoPlayerController ?? ValueNotifier(VideoPlayerValue(duration: Duration.zero)),
                  builder: (context, VideoPlayerValue val, _) {
                    final time = val.position.inSeconds;
                    return Text(
                      'Note @ ${_formatSeconds(time)}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const Gap(16),

          // Notes List Content
          notesAsync.when(
            data: (notes) {
              if (notes.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'Capture key moments of the teaching by typing notes at specific timestamps.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notes.length,
                separatorBuilder: (_, __) => const Divider(color: Color(0xFFF3F4F6), height: 16),
                itemBuilder: (context, index) {
                  final note = notes[index];
                  final timestampStr = _formatSeconds(note.timestampSeconds);

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timestamp seeker chip
                      InkWell(
                        onTap: () {
                          _videoPlayerController?.seekTo(Duration(seconds: note.timestampSeconds));
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.play_arrow_rounded, size: 12, color: AppColors.primary),
                              const Gap(2),
                              Text(
                                timestampStr,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.text,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Actions (Edit/Delete)
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.grey),
                        onPressed: () => _editNoteDialog(note),
                      ),
                      const Gap(8),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.redAccent),
                        onPressed: () {
                          ref.read(mediaNotesProvider(widget.item.id).notifier).deleteNote(note.id);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'Failed to load notes. Please verify your authentication status.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.error, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addNoteDialog(String? currentUserId) {
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please register/login to create personal notes.')),
      );
      return;
    }

    final controller = TextEditingController();
    final timestamp = _videoPlayerController?.value.position.inSeconds ?? 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Note @ ${_formatSeconds(timestamp)}',
          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          autofocus: true,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Type your sermon reflection here...',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                ref.read(mediaNotesProvider(widget.item.id).notifier).addNote(
                      userId: currentUserId,
                      videoId: widget.item.id,
                      timestampSeconds: timestamp,
                      text: text,
                    );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size.zero,
            ),
            child: const Text('Save Reflection', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editNoteDialog(MediaNoteModel note) {
    final controller = TextEditingController(text: note.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Edit Note',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          autofocus: true,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                ref.read(mediaNotesProvider(widget.item.id).notifier).editNote(note.id, text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size.zero,
            ),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedVideosSection() {
    final mediaListAsync = ref.watch(mediaListProvider);

    return mediaListAsync.when(
      data: (state) {
        final related = state.items.where((v) => v.id != widget.item.id).take(4).toList();
        if (related.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Related Teachings',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Gap(12),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: related.length,
                itemBuilder: (context, index) {
                  final v = related[index];
                  return GestureDetector(
                    onTap: () {
                      // Save progress before replacement
                      _saveCurrentProgress();
                      // Navigate to new player
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaPlayerScreen(item: v),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: v.thumbnailUrl ?? '',
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(color: Colors.grey[200]),
                                errorWidget: (_, __, ___) => Container(color: Colors.grey[200]),
                              ),
                            ),
                          ),
                          const Gap(6),
                          Text(
                            v.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
