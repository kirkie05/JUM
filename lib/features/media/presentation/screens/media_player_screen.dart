import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yte;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/media_stream_resolver.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../data/models/media_item.dart';
import '../../data/models/media_note_model.dart';
import '../../data/providers/media_provider.dart';
import '../../data/providers/media_notes_provider.dart';
import '../widgets/youtube_player_mobile.dart';

class MediaPlayerScreen extends ConsumerStatefulWidget {
  const MediaPlayerScreen({super.key, required this.item});

  final MediaItem item;

  @override
  ConsumerState<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends ConsumerState<MediaPlayerScreen> {
  // Native Video Player controllers
  VideoPlayerController? _vpController;
  bool _isInitialized = false;

  // Platform Channel for native PiP
  static const _pipChannel = MethodChannel('com.jumministry.jum/pip');

  // Shared preferences cache
  SharedPreferences? _prefs;

  // Fullscreen state
  bool _isFullScreen = false;

  // YouTube resume position state
  Duration _ytInitialPosition = Duration.zero;
  Duration _currentYtPosition = Duration.zero;
  bool _isYtPositionLoaded = false;

  // GlobalKey for YouTube player control
  final GlobalKey<JumYoutubePlayerState> _ytPlayerKey = GlobalKey<JumYoutubePlayerState>();

  bool get _isYoutubeVideo {
    final url = widget.item.sourceUrl;
    return widget.item.type == MediaItemType.video &&
        (url.contains('youtube.com') || url.contains('youtu.be'));
  }

  @override
  void initState() {
    super.initState();
    
    if (_isYoutubeVideo) {
      _loadYtPosition().then((pos) {
        if (mounted) {
          setState(() {
            _ytInitialPosition = pos;
            _currentYtPosition = pos;
            _isYtPositionLoaded = true;
          });
        }
      });
    } else if (widget.item.type == MediaItemType.video) {
      _initializeNativeVideoPlayer();
    } else {
      // Audio stream - mixlr or podcast
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mixlrPlayerProvider.notifier).playItem(widget.item);
      });
    }
  }

  Future<void> _initializeNativeVideoPlayer() async {
    final url = widget.item.sourceUrl;
    try {
      final playableUrl = await MediaStreamResolver.resolveNativeStreamUrl(url);
      _vpController = VideoPlayerController.networkUrl(Uri.parse(playableUrl));
      await _vpController!.initialize();
      _vpController!.addListener(_nativePlayerListener);

      final savedPos = await _loadNativePosition();
      if (savedPos > Duration.zero && savedPos < _vpController!.value.duration) {
        await _vpController!.seekTo(savedPos);
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _vpController?.play();
      }
    } catch (e) {
      debugPrint('Video Player Init Error: $e');
    }
  }

  void _nativePlayerListener() {
    if (_vpController == null || !mounted) return;
    _saveNativePosition(_vpController!.value.position);
  }

  Future<Duration> _loadYtPosition() async {
    _prefs ??= await SharedPreferences.getInstance();
    final ms = _prefs?.getInt('yt_position_${widget.item.id}') ?? 0;
    return Duration(milliseconds: ms);
  }

  Future<void> _saveYtPosition(Duration pos) async {
    if (widget.item.isLive) return;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setInt('yt_position_${widget.item.id}', pos.inMilliseconds);
  }

  Future<Duration> _loadNativePosition() async {
    _prefs ??= await SharedPreferences.getInstance();
    final ms = _prefs?.getInt('native_position_${widget.item.id}') ?? 0;
    return Duration(milliseconds: ms);
  }

  Future<void> _saveNativePosition(Duration pos) async {
    if (widget.item.isLive) return;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setInt('native_position_${widget.item.id}', pos.inMilliseconds);
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
      debugPrint('Error entering PiP mode: $e');
    }
  }

  int _getCurrentPositionSeconds() {
    if (_isYoutubeVideo) {
      return _currentYtPosition.inSeconds;
    } else if (_vpController != null) {
      return _vpController!.value.position.inSeconds;
    }
    return 0;
  }

  void _seekTo(Duration position) {
    if (_isYoutubeVideo) {
      _ytPlayerKey.currentState?.seekTo(position);
    } else {
      _vpController?.seekTo(position);
    }
  }

  void _shareNotes(List<MediaNoteModel> notes) {
    if (notes.isEmpty) return;
    final buffer = StringBuffer('Sermon Notes on "${widget.item.title}":\n\n');
    for (var note in notes) {
      final timeStr = _formatSeconds(note.timestampSeconds);
      buffer.writeln('[$timeStr] ${note.text}');
    }
    buffer.writeln('\n- via Jesus Unhindered Ministry App');
    Share.share(buffer.toString(), subject: 'Sermon Notes: ${widget.item.title}');
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _vpController?.removeListener(_nativePlayerListener);
    _vpController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0C0F14) : AppColors.background;

    if (_isFullScreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _buildPlayerView(),
              ),
            ),
            Positioned(
              top: 24,
              left: 24,
              child: ClipOval(
                child: Container(
                  color: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                    onPressed: _toggleFullScreen,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final notesAsync = ref.watch(mediaNotesProvider(widget.item.id));

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 32, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          notesAsync.maybeWhen(
            data: (notes) => IconButton(
              tooltip: 'Share Notes',
              icon: Icon(Icons.share_outlined, color: isDark ? Colors.white : Colors.black87),
              onPressed: () => _shareNotes(notes),
            ),
            orElse: () => const SizedBox.shrink(),
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
                child: _buildPlayerView(),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Gap(12),
                      ],
                      Text(
                        widget.item.type == MediaItemType.video ? 'Video' : 'Audio stream',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white60 : AppColors.textSecondary,
                        ),
                      ),
                      if (widget.item.viewCount != null) ...[
                        const Gap(8),
                        Text(
                          '•',
                          style: TextStyle(
                            color: isDark ? Colors.white38 : AppColors.textSecondary,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          '${widget.item.viewCount} views',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: isDark ? Colors.white60 : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Gap(12),
                  // Speaker/Preacher
                  Row(
                    children: [
                      const Icon(Icons.person_rounded, size: 16, color: AppColors.primary),
                      const Gap(6),
                      Text(
                        _getSpeaker(),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  // Publication Date
                  if (widget.item.publishedAt != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textSecondary),
                        const Gap(6),
                        Text(
                          'Published: ${widget.item.publishedAt!.toIso8601String().split('T').first}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: isDark ? Colors.white60 : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                  ],
                  // Action Row (Share Video & Watch on YouTube)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Share.share(
                              'Watch "${widget.item.title}" on YouTube:\n${widget.item.sourceUrl}\n\n- via Jesus Unhindered Ministry App',
                              subject: widget.item.title,
                            );
                          },
                          icon: const Icon(Icons.share_rounded, size: 16),
                          label: const Text('Share Video', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? Colors.white70 : AppColors.textPrimary,
                            side: BorderSide(color: isDark ? Colors.white24 : AppColors.border),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final uri = Uri.parse(widget.item.sourceUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Could not launch YouTube link.')),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.open_in_new_rounded, size: 16),
                          label: const Text('Watch on YouTube', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF0000), // YouTube Red
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 40, color: Colors.white12),

                  // Synchronized Note-Taking Interface
                  _buildNotesInterface(isDark),
                  const Gap(24),

                  if (widget.item.description != null && widget.item.description!.isNotEmpty) ...[
                    Text(
                      'Description',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      widget.item.description!,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: isDark ? Colors.white70 : AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                  _buildRelatedVideos(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSpeaker() {
    final title = widget.item.title.toLowerCase();
    if (title.contains('kingsley') || title.contains('aniche')) {
      return 'Pastor Kingsley Aniche';
    }
    return widget.item.sourceName.isNotEmpty ? widget.item.sourceName : 'Jesus Unhindered Ministry';
  }

  Widget _buildRelatedVideos(bool isDark) {
    final videosAsync = ref.watch(youtubeVideosProvider);

    return videosAsync.when(
      data: (videos) {
        final related = videos.where((v) => v.id != widget.item.id).take(4).toList();
        if (related.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(32),
            Text(
              'Related Videos',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const Gap(12),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: related.length,
                itemBuilder: (context, index) {
                  final v = related[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaPlayerScreen(item: v),
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: v.thumbnailUrl ?? '',
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Container(color: Colors.black26),
                              ),
                            ),
                          ),
                          const Gap(6),
                          Text(
                            v.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimary,
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

  Widget _buildNotesInterface(bool isDark) {
    final notesAsync = ref.watch(mediaNotesProvider(widget.item.id));
    final currentUser = ref.watch(currentUserProvider).value;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131A22) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.note_alt_rounded, color: AppColors.primary, size: 20),
                  const Gap(8),
                  Text(
                    'SERMON NOTES',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white70 : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddNoteDialog(currentUser),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(
                  'Add Note @ ${_formatSeconds(_getCurrentPositionSeconds())}',
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Gap(16),
          notesAsync.when(
            data: (notes) {
              if (notes.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No notes captured yet. Add a note at a specific timestamp!',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: isDark ? Colors.white30 : Colors.grey.shade400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notes.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 16),
                itemBuilder: (context, index) {
                  final note = notes[index];
                  final timeStr = _formatSeconds(note.timestampSeconds);

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _seekTo(Duration(seconds: note.timestampSeconds)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.play_arrow_rounded, size: 12, color: AppColors.primary),
                              const Gap(4),
                              Text(
                                timeStr,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
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
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: isDark ? Colors.white70 : Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
                        onPressed: () => _showEditNoteDialog(note),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                        onPressed: () => _deleteNote(note.id),
                      ),
                    ],
                  );
                },
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Failed to load notes: $err',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(dynamic currentUser) {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add notes.')),
      );
      return;
    }

    final textController = TextEditingController();
    final timestamp = _getCurrentPositionSeconds();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131A22),
        title: Text(
          'Add Note at ${_formatSeconds(timestamp)}',
          style: const TextStyle(color: Colors.white, fontFamily: 'Inter', fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: textController,
          maxLines: 4,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
          decoration: const InputDecoration(
            hintText: 'Enter note content...',
            hintStyle: TextStyle(color: Colors.white30),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              final text = textController.text.trim();
              if (text.isNotEmpty) {
                ref.read(mediaNotesProvider(widget.item.id).notifier).addNote(
                      userId: currentUser.id,
                      videoId: widget.item.id,
                      timestampSeconds: timestamp,
                      text: text,
                    );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Save Note', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(MediaNoteModel note) {
    final textController = TextEditingController(text: note.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131A22),
        title: const Text(
          'Edit Note',
          style: TextStyle(color: Colors.white, fontFamily: 'Inter', fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: textController,
          maxLines: 4,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
          decoration: const InputDecoration(
            hintText: 'Enter note content...',
            hintStyle: TextStyle(color: Colors.white30),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              final text = textController.text.trim();
              if (text.isNotEmpty) {
                ref.read(mediaNotesProvider(widget.item.id).notifier).editNote(note.id, text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteNote(String noteId) {
    ref.read(mediaNotesProvider(widget.item.id).notifier).deleteNote(noteId);
  }

  Widget _buildPlayerView() {
    if (_isYoutubeVideo) {
      if (!_isYtPositionLoaded) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        );
      }

      final ytId = yte.VideoId.parseVideoId(widget.item.sourceUrl) ?? '';
      return JumYoutubePlayer(
        key: _ytPlayerKey,
        videoId: ytId,
        isLive: widget.item.isLive,
        initialPosition: _ytInitialPosition,
        onPositionChanged: (pos) {
          _currentYtPosition = pos;
          _saveYtPosition(pos);
        },
      );
    }

    if (widget.item.type == MediaItemType.video) {
      if (!_isInitialized) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        );
      }

      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(_vpController!),
          _VideoControls(
            controller: _vpController!,
            isVideo: true,
            isFullScreen: _isFullScreen,
            onFullScreenToggle: _toggleFullScreen,
            onPiPToggle: _enterPiPMode,
          ),
        ],
      );
    }

    // Audio Playback UI (Riverpod Player)
    final playerState = ref.watch(mixlrPlayerProvider);
    final playerNotifier = ref.read(mixlrPlayerProvider.notifier);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.item.thumbnailUrl != null)
          Opacity(
            opacity: 0.3,
            child: CachedNetworkImage(
              imageUrl: widget.item.thumbnailUrl!,
              fit: BoxFit.cover,
              cacheKey: 'thumbnail_${widget.item.id.startsWith('youtube-') ? widget.item.id.substring(8) : widget.item.id}',
            ),
          ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.graphic_eq, size: 40, color: Colors.white),
            ),
            const Gap(16),
            if (playerState.isBuffering)
              const CircularProgressIndicator(color: AppColors.accent)
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      playerState.isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (playerState.isPlaying) {
                        playerNotifier.pause();
                      } else {
                        playerNotifier.playItem(widget.item);
                      }
                    },
                  ),
                ],
              ),
              if (!widget.item.isLive) ...[
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Slider(
                        activeColor: AppColors.accent,
                        inactiveColor: Colors.white24,
                        value: playerState.position.inSeconds.toDouble(),
                        max: playerState.duration.inSeconds.toDouble() > 0
                            ? playerState.duration.inSeconds.toDouble()
                            : 100.0,
                        onChanged: (val) {
                          playerNotifier.seek(Duration(seconds: val.toInt()));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatSeconds(playerState.position.inSeconds),
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            _formatSeconds(playerState.duration.inSeconds),
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ],
    );
  }
}

class _VideoControls extends StatefulWidget {
  const _VideoControls({
    required this.controller,
    this.isVideo = false,
    required this.isFullScreen,
    required this.onFullScreenToggle,
    required this.onPiPToggle,
  });

  final VideoPlayerController controller;
  final bool isVideo;
  final bool isFullScreen;
  final VoidCallback onFullScreenToggle;
  final VoidCallback onPiPToggle;

  @override
  State<_VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<_VideoControls> {
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
    var target = current + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    if (target > widget.controller.value.duration) target = widget.controller.value.duration;
    widget.controller.seekTo(target);
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.controller.value;
    final isPlaying = value.isPlaying;
    final remaining = value.duration - value.position;

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
                icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 24),
                onPressed: () => _seekRelative(-10),
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () {
                  isPlaying ? widget.controller.pause() : widget.controller.play();
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 24),
                onPressed: () => _seekRelative(10),
              ),
              const Spacer(),
              if (widget.isVideo) ...[
                IconButton(
                  tooltip: 'Picture in Picture',
                  icon: const Icon(Icons.picture_in_picture_alt_rounded, color: Colors.white, size: 20),
                  onPressed: widget.onPiPToggle,
                ),
                const Gap(8),
              ],
              PopupMenuButton<double>(
                initialValue: value.playbackSpeed,
                tooltip: 'Playback Speed',
                icon: Text(
                  '${value.playbackSpeed}x',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                color: Colors.black87,
                onSelected: (speed) => widget.controller.setPlaybackSpeed(speed),
                itemBuilder: (context) => [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((s) {
                  return PopupMenuItem(
                    value: s,
                    child: Text('${s}x', style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
              const Gap(8),
              Text(
                '${_formatDuration(value.position)} / ${_formatDuration(value.duration)} (-${_formatDuration(remaining)})',
                style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Inter'),
              ),
              if (widget.isVideo) ...[
                const Gap(8),
                IconButton(
                  icon: Icon(
                    widget.isFullScreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                    color: Colors.white,
                  ),
                  onPressed: widget.onFullScreenToggle,
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
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      final hours = twoDigits(duration.inHours);
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
