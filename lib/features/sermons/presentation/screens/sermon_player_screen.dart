import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
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
  YoutubePlayerController? _ytController;
  String? _initializedVideoId;

  @override
  void dispose() {
    _ytController?.dispose();
    super.dispose();
  }

  void _ensureYoutubeController(String videoId) {
    if (_initializedVideoId == videoId) return;
    _ytController?.dispose();
    _initializedVideoId = videoId;
    _ytController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        showLiveFullscreenButton: true,
        isLive: false,
        forceHD: false,
        enableCaption: false,
        useHybridComposition: true,
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60);
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _openNotesBottomSheet(BuildContext ctx) async {
    final prefs = await SharedPreferences.getInstance();
    final noteKey = 'sermon_note_${widget.sermonId}';
    final existingNote = prefs.getString(noteKey) ?? '';
    final controller = TextEditingController(text: existingNote);

    if (!ctx.mounted) return;

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (bsContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 24.0,
            bottom: MediaQuery.of(bsContext).viewInsets.bottom + 24.0,
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
                  if (bsContext.mounted) {
                    Navigator.pop(bsContext);
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                        content: Text('Note saved successfully!'),
                        backgroundColor: Color(0xFF1F1F1F),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Save Note',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDownloadSnackbar(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text('Sermon is being prepared for offline access...'),
        backgroundColor: Color(0xFF1F1F1F),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sermonDetailAsync = ref.watch(sermonDetailProvider(widget.sermonId));

    return sermonDetailAsync.when(
      data: (sermon) {
        if (sermon == null) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'Sermon not found',
                style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
              ),
            ),
          );
        }

        // --- YouTube / Video Sermon ---
        if (sermon.type == 'video' && sermon.youtubeVideoId != null) {
          _ensureYoutubeController(sermon.youtubeVideoId!);
          return _buildYoutubeScreen(context, sermon);
        }

        // --- Audio Sermon ---
        return _buildAudioScreen(context, sermon);
      },
      loading: () => Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: JumShimmer.list(),
        ),
      ),
      error: (err, st) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_rounded, color: Colors.white38, size: 48),
                const Gap(16),
                const Text(
                  'Failed to load sermon.',
                  style: TextStyle(color: Colors.white, fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                Text(
                  err.toString(),
                  style: const TextStyle(color: Color(0xFF8E8E8E), fontFamily: 'Inter', fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // YOUTUBE VIDEO PLAYER SCREEN
  // ─────────────────────────────────────────────────────────────────
  Widget _buildYoutubeScreen(BuildContext context, SermonModel sermon) {
    if (_ytController == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _ytController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.white,
        progressColors: const ProgressBarColors(
          playedColor: Colors.white,
          handleColor: Colors.white,
          bufferedColor: Colors.white38,
          backgroundColor: Colors.white10,
        ),
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true, colors: const ProgressBarColors(
            playedColor: Colors.white,
            handleColor: Colors.white,
            bufferedColor: Colors.white38,
            backgroundColor: Colors.white10,
          )),
          RemainingDuration(),
          const PlaybackSpeedButton(),
          FullScreenButton(),
        ],
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            title: const Text(
              'Video Sermon',
              style: TextStyle(
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
                icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
                tooltip: 'Sermon Notes',
                onPressed: () => _openNotesBottomSheet(context),
              ),
              IconButton(
                icon: const Icon(Icons.download_rounded, color: Colors.white),
                tooltip: 'Download',
                onPressed: () => _showDownloadSnackbar(context),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(color: const Color(0xFF1F1F1F), height: 1.0),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The embedded YouTube player (handles its own aspect ratio)
              player,

              // Scrollable details below the player
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          sermon.title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Gap(6),
                        // Speaker & date row
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded,
                                size: 14, color: Color(0xFF8E8E8E)),
                            const Gap(4),
                            Text(
                              sermon.speaker,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.0,
                                color: Color(0xFF8E8E8E),
                              ),
                            ),
                            const Gap(10),
                            const Icon(Icons.calendar_today_rounded,
                                size: 12, color: Color(0xFF8E8E8E)),
                            const Gap(4),
                            Text(
                              _formatPublishedDate(sermon.publishedAt),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.0,
                                color: Color(0xFF8E8E8E),
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),

                        // Quick-action chips
                        Wrap(
                          spacing: 10,
                          children: [
                            _ActionChip(
                              icon: Icons.edit_note_rounded,
                              label: 'Take Notes',
                              onTap: () => _openNotesBottomSheet(context),
                            ),
                            _ActionChip(
                              icon: Icons.share_rounded,
                              label: 'Share',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Share link copied!'),
                                    backgroundColor: Color(0xFF1F1F1F),
                                  ),
                                );
                              },
                            ),
                            _ActionChip(
                              icon: Icons.download_rounded,
                              label: 'Download',
                              onTap: () => _showDownloadSnackbar(context),
                            ),
                          ],
                        ),
                        const Gap(24),

                        // Description card
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
                              const Gap(10),
                              Text(
                                sermon.description.isNotEmpty
                                    ? sermon.description
                                    : 'No description available for this sermon.',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.0,
                                  color: Color(0xFF8E8E8E),
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // AUDIO PLAYER SCREEN
  // ─────────────────────────────────────────────────────────────────
  Widget _buildAudioScreen(BuildContext context, SermonModel sermon) {
    final playerState = ref.watch(sermonPlayerNotifierProvider);
    final notifier = ref.read(sermonPlayerNotifierProvider.notifier);

    // Kick off audio playback if not already loaded
    if (playerState.sermon?.id != sermon.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.play(sermon);
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Audio Sermon',
          style: TextStyle(
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
            icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
            tooltip: 'Sermon Notes',
            onPressed: () => _openNotesBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            onPressed: () => _showDownloadSnackbar(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFF1F1F1F), height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Album art with waveform animation
              Center(
                child: Container(
                  height: 280,
                  width: 280,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.05),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
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
                            child: const Icon(Icons.music_note_rounded, size: 80, color: Colors.white38),
                          ),
                        ),
                      ),
                      if (playerState.isPlaying)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (i) {
                                return AnimatedContainer(
                                  duration: Duration(milliseconds: 250 + i * 80),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 6,
                                  height: 20.0 + (i % 3) * 18.0,
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

              // Title & speaker
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
              const Gap(32),

              // Progress slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                  trackHeight: 3.0,
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                ),
                child: Slider(
                  value: playerState.position.inSeconds
                      .toDouble()
                      .clamp(0.0, playerState.duration.inSeconds.toDouble()),
                  max: playerState.duration.inSeconds.toDouble() > 0
                      ? playerState.duration.inSeconds.toDouble()
                      : 1.0,
                  onChanged: (val) {
                    notifier.seek(Duration(seconds: val.toInt()));
                  },
                  activeColor: Colors.white,
                  inactiveColor: const Color(0xFF1F1F1F),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

              // Playback controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Speed selector
                  PopupMenuButton<double>(
                    initialValue: playerState.speed,
                    icon: Text(
                      '${playerState.speed}x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                    color: const Color(0xFF161616),
                    onSelected: (val) => notifier.setSpeed(val),
                    itemBuilder: (context) => [0.75, 1.0, 1.25, 1.5, 2.0]
                        .map((s) => PopupMenuItem(
                              value: s,
                              child: Text('${s}x',
                                  style: const TextStyle(color: Colors.white)),
                            ))
                        .toList(),
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
                        playerState.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
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
              const Gap(32),

              // Description card
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
                      sermon.description.isNotEmpty
                          ? sermon.description
                          : 'No description available for this sermon.',
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

  String _formatPublishedDate(DateTime dt) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month]} ${dt.day}, ${dt.year}';
  }
}

// ─────────────────────────────────────────────────────────────────
// HELPER: Quick-action chip
// ─────────────────────────────────────────────────────────────────
class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white70),
            const Gap(6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
