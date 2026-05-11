import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../../shared/widgets/jum_card.dart';
import '../../data/models/sermon_model.dart';
import '../../data/providers/sermon_provider.dart';

class SermonPlayerScreen extends ConsumerStatefulWidget {
  final String sermonId;

  const SermonPlayerScreen({
    Key? key,
    required this.sermonId,
  }) : super(key: key);

  @override
  ConsumerState<SermonPlayerScreen> createState() => _SermonPlayerScreenState();
}

class _SermonPlayerScreenState extends ConsumerState<SermonPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePlayback();
    });
  }

  void _initializePlayback() {
    final playerState = ref.read(sermonPlayerNotifierProvider);
    if (playerState.sermon?.id != widget.sermonId) {
      final sermonsList = ref.read(sermonsProvider).value;
      final sermon = sermonsList?.firstWhere(
            (s) => s.id == widget.sermonId,
            orElse: () => _fallbackSermon(),
          ) ??
          _fallbackSermon();
      ref.read(sermonPlayerNotifierProvider.notifier).play(sermon);
    }
  }

  SermonModel _fallbackSermon() {
    return SermonModel(
      id: widget.sermonId,
      churchId: 'jum-church-1',
      title: 'Living Unhindered',
      description: 'A powerful message on living unhindered in the grace of God.',
      speaker: 'Pastor Kingsley',
      mediaUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      thumbnailUrl: 'https://picsum.photos/400/300',
      type: 'audio',
      durationSeconds: 2712,
      publishedAt: DateTime.now(),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60);
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _openNotesBottomSheet(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final noteKey = 'sermon_note_${widget.sermonId}';
    final existingNote = prefs.getString(noteKey) ?? '';
    final controller = TextEditingController(text: existingNote);

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 24.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Sermon Notes',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Gap(16),
              TextField(
                controller: controller,
                maxLines: 6,
                style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
                decoration: InputDecoration(
                  hintText: 'Take down some notes...',
                  hintStyle: const TextStyle(color: Color(0xFF8E8E8E), fontFamily: 'Inter'),
                  filled: true,
                  fillColor: const Color(0xFF1F1F1F),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.white, width: 1.0),
                  ),
                ),
              ),
              const Gap(16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await prefs.setString(noteKey, controller.text);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Note saved successfully!'),
                        backgroundColor: Color(0xFF1F1F1F),
                      ),
                    );
                  }
                },
                child: const Text('Save Note', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
              ),
            ],
          ),
        );
      },
    );
  }

  void _downloadSermon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sermon downloading to local storage...'),
        backgroundColor: Color(0xFF1F1F1F),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(sermonPlayerNotifierProvider);
    final notifier = ref.read(sermonPlayerNotifierProvider.notifier);

    final sermon = playerState.sermon ?? _fallbackSermon();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          sermon.type == 'video' ? 'Video Sermon' : 'Audio Sermon',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notes_rounded, color: Colors.white),
            onPressed: () => _openNotesBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            onPressed: _downloadSermon,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFF1F1F1F),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (sermon.type == 'video') ...[
                // Video Player Container
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.0),
                    ),
                    child: notifier.videoController != null
                        ? VideoPlayerWidget(
                            controller: notifier.videoController!,
                            playerState: playerState,
                            notifier: notifier,
                          )
                        : const AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Center(child: CircularProgressIndicator(color: Colors.white)),
                          ),
                  ),
                ),
                const Gap(24),
              ] else ...[
                // Audio Player visual card (280px container)
                Center(
                  child: Container(
                    height: 280,
                    width: 280,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1F1F),
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.0),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: Image.network(
                            sermon.thumbnailUrl,
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: const Color(0xFF1F1F1F),
                              child: const Icon(Icons.music_note_rounded, size: 80, color: Colors.white),
                            ),
                          ),
                        ),
                        // Waveform animation mock overlay
                        if (playerState.isPlaying)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black54,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return AnimatedContainer(
                                    duration: Duration(milliseconds: 200 + (index * 100)),
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: 8,
                                    height: playerState.isPlaying ? 40.0 + (index * 8) % 30 : 15,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const Gap(32),
              ],

              // Metadata
              Text(
                sermon.title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                sermon.speaker,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0,
                  color: Color(0xFF8E8E8E),
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(24),

              // Audio Controls (SeekBar and Controls shown in single Column below meta)
              if (sermon.type == 'audio') ...[
                // Seek bar
                Slider(
                  value: playerState.position.inSeconds.toDouble(),
                  max: playerState.duration.inSeconds.toDouble(),
                  onChanged: (val) {
                    notifier.seek(Duration(seconds: val.toInt()));
                  },
                  activeColor: Colors.white,
                  inactiveColor: const Color(0xFF1F1F1F),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(playerState.position),
                        style: const TextStyle(color: Color(0xFF8E8E8E), fontSize: 12, fontFamily: 'Inter'),
                      ),
                      Text(
                        _formatDuration(playerState.duration),
                        style: const TextStyle(color: Color(0xFF8E8E8E), fontSize: 12, fontFamily: 'Inter'),
                      ),
                    ],
                  ),
                ),
                const Gap(24),

                // Control bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Speed selector
                    PopupMenuButton<double>(
                      initialValue: playerState.speed,
                      icon: Text(
                        '${playerState.speed}x',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Inter'),
                      ),
                      color: const Color(0xFF161616),
                      onSelected: (val) => notifier.setSpeed(val),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 0.75, child: Text('0.75x', style: TextStyle(color: Colors.white))),
                        const PopupMenuItem(value: 1.0, child: Text('1.0x', style: TextStyle(color: Colors.white))),
                        const PopupMenuItem(value: 1.25, child: Text('1.25x', style: TextStyle(color: Colors.white))),
                        const PopupMenuItem(value: 1.5, child: Text('1.5x', style: TextStyle(color: Colors.white))),
                        const PopupMenuItem(value: 2.0, child: Text('2.0x', style: TextStyle(color: Colors.white))),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay_10_rounded, size: 36, color: Colors.white),
                      onPressed: () => notifier.skipBack15(),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (playerState.isPlaying) {
                          notifier.pause();
                        } else {
                          notifier.resume();
                        }
                      },
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: Icon(
                          playerState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10_rounded, size: 36, color: Colors.white),
                      onPressed: () => notifier.skipForward15(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop_rounded, size: 28, color: Color(0xFF8E8E8E)),
                      onPressed: () => notifier.stop(),
                    ),
                  ],
                ),
              ],

              const Gap(32),
              // Description Card
              JumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sermon Description',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      sermon.description,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        color: Color(0xFF8E8E8E),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final SermonPlayerState playerState;
  final SermonPlayerNotifier notifier;

  const VideoPlayerWidget({
    Key? key,
    required this.controller,
    required this.playerState,
    required this.notifier,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60);
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GestureDetector(
        onTap: () {
          setState(() => _showControls = !_showControls);
          if (_showControls) _startHideTimer();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(widget.controller),
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.black54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10_rounded, size: 36, color: Colors.white),
                          onPressed: () {
                            _startHideTimer();
                            widget.notifier.skipBack15();
                          },
                        ),
                        const Gap(24),
                        GestureDetector(
                          onTap: () {
                            _startHideTimer();
                            if (widget.playerState.isPlaying) {
                              widget.notifier.pause();
                            } else {
                              widget.notifier.resume();
                            }
                          },
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white,
                            child: Icon(
                              widget.playerState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Gap(24),
                        IconButton(
                          icon: const Icon(Icons.forward_10_rounded, size: 36, color: Colors.white),
                          onPressed: () {
                            _startHideTimer();
                            widget.notifier.skipForward15();
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                              trackHeight: 3.0,
                            ),
                            child: Slider(
                              value: widget.playerState.position.inSeconds.toDouble(),
                              max: widget.playerState.duration.inSeconds.toDouble(),
                              onChanged: (val) {
                                _startHideTimer();
                                widget.notifier.seek(Duration(seconds: val.toInt()));
                              },
                              activeColor: Colors.white,
                              inactiveColor: Colors.white24,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(widget.playerState.position),
                                  style: const TextStyle(color: Colors.white, fontSize: 11),
                                ),
                                Text(
                                  _formatDuration(widget.playerState.duration),
                                  style: const TextStyle(color: Colors.white, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
