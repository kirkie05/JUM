import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/jum_app_bar.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';

// -------------------------------------------------------------
// REPLAY LIST SCREEN
// -------------------------------------------------------------
class ReplayListScreen extends StatelessWidget {
  const ReplayListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final replays = [
      {
        'title': 'Anointing for Breakthrough',
        'pastor': 'Pastor Kingsley',
        'date': 'May 3, 2026',
        'duration': '1:14:22',
        'views': '1.2k views',
        'image': 'https://picsum.photos/seed/breakthrough/400/225',
      },
      {
        'title': 'The Power of Divine Fellowship',
        'pastor': 'Pastor Kingsley',
        'date': 'April 26, 2026',
        'duration': '58:15',
        'views': '980 views',
        'image': 'https://picsum.photos/seed/fellowship/400/225',
      },
      {
        'title': 'Living Unhindered & Free',
        'pastor': 'Pastor Kingsley',
        'date': 'April 19, 2026',
        'duration': '1:05:40',
        'views': '1.5k views',
        'image': 'https://picsum.photos/seed/free/400/225',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'Past Broadcast Replays',
        showBack: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: replays.length,
        itemBuilder: (context, index) {
          final item = replays[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: JumCard(
              padding: EdgeInsets.zero,
              backgroundColor: AppColors.surface,
              child: InkWell(
                onTap: () => context.push('/media/video-player'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppSizes.radiusLg),
                            topRight: Radius.circular(AppSizes.radiusLg),
                          ),
                          child: Image.network(
                            item['image']!,
                            height: 180.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 12.0,
                          right: 12.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              item['duration']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Positioned.fill(
                          child: Center(
                            child: CircleAvatar(
                              radius: 28.0,
                              backgroundColor: Colors.black45,
                              child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Gap(6),
                          Row(
                            children: [
                              Text(
                                item['pastor']!,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13.0,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const Gap(8),
                              const Icon(Icons.circle, size: 4.0, color: AppColors.textMuted),
                              const Gap(8),
                              Text(
                                item['views']!,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13.0,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------
// AUDIO PLAYER SCREEN
// -------------------------------------------------------------
class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool _isPlaying = false;
  double _playbackPosition = 255.0; // 4 mins 15 secs
  final double _totalDuration = 1960.0; // 32 mins 40 secs
  double _volume = 0.8;

  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'Now Playing',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(16),
            // Premium rotating disc art container
            Center(
              child: Container(
                width: 240.0,
                height: 240.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 30.0,
                      offset: const Offset(0, 15),
                    )
                  ],
                  border: Border.all(color: AppColors.border, width: 4.0),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://picsum.photos/seed/audioart/400/400',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Gap(32),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Walking in Victory & Faith',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(6),
                  const Text(
                    'Pastor Kingsley • JUM Sermons',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(32),
            // Waveform scrubber slider
            JumCard(
              backgroundColor: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.border,
                      thumbColor: AppColors.primary,
                      trackHeight: 4.0,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 0.0,
                      max: _totalDuration,
                      value: _playbackPosition,
                      onChanged: (value) {
                        setState(() {
                          _playbackPosition = value;
                        });
                      },
                    ),
                  ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_playbackPosition),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.0),
                      ),
                      Text(
                        '-${_formatDuration(_totalDuration - _playbackPosition)}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(32),
            // Interactive Playback Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay_10_rounded, size: 32.0, color: AppColors.primary),
                  onPressed: () {
                    setState(() {
                      _playbackPosition = (_playbackPosition - 10).clamp(0.0, _totalDuration);
                    });
                  },
                ),
                const Gap(16),
                CircleAvatar(
                  radius: 36.0,
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 40.0,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                  ),
                ),
                const Gap(16),
                IconButton(
                  icon: const Icon(Icons.forward_10_rounded, size: 32.0, color: AppColors.primary),
                  onPressed: () {
                    setState(() {
                      _playbackPosition = (_playbackPosition + 10).clamp(0.0, _totalDuration);
                    });
                  },
                ),
              ],
            ),
            const Gap(32),
            // Volume control
            Row(
              children: [
                const Icon(Icons.volume_down_rounded, color: AppColors.textSecondary),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.border,
                      thumbColor: AppColors.primary,
                      trackHeight: 3.0,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0),
                    ),
                    child: Slider(
                      value: _volume,
                      onChanged: (val) => setState(() => _volume = val),
                    ),
                  ),
                ),
                const Icon(Icons.volume_up_rounded, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// VIDEO PLAYER SCREEN
// -------------------------------------------------------------
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _isPlaying = true;
  double _position = 120.0;
  final double _duration = 3600.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Sermon Broadcast', style: TextStyle(color: Colors.white, fontFamily: 'Inter', fontWeight: FontWeight.bold)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Immersive Full Frame Video Area
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    'https://picsum.photos/seed/sermonvideo/800/450',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  // Control overlay
                  Positioned(
                    bottom: 20.0,
                    left: 20.0,
                    right: 20.0,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32.0,
                          ),
                          onPressed: () => setState(() => _isPlaying = !_isPlaying),
                        ),
                        Expanded(
                          child: Slider(
                            activeColor: Colors.white,
                            inactiveColor: Colors.white24,
                            value: _position,
                            max: _duration,
                            onChanged: (val) => setState(() => _position = val),
                          ),
                        ),
                        const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 28.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sermon details below player
          Expanded(
            flex: 4,
            child: Container(
              color: AppColors.background,
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Anointing for Breakthrough',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Gap(8),
                    const Text(
                      'Pastor Kingsley • Sunday Broadcast Replay',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Gap(16),
                    const Divider(color: AppColors.border),
                    const Gap(16),
                    const Text(
                      'SERMON DESCRIPTION',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const Gap(8),
                    const Text(
                      'In this powerful sermon, Pastor Kingsley preaches on the importance of having the divine anointing to overcome current obstacles and align with God\'s true plan for your life, family, and workplace.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        color: AppColors.textPrimary,
                        height: 1.5,
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
  }
}

// -------------------------------------------------------------
// PODCAST LIST SCREEN
// -------------------------------------------------------------
class PodcastListScreen extends StatelessWidget {
  const PodcastListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final podcasts = [
      {
        'title': 'Unhindered Grace Podcast',
        'host': 'Pastor Kingsley & Team',
        'episodes': '14 Episodes',
        'image': 'https://picsum.photos/seed/grace/300/300',
      },
      {
        'title': 'Kingdom Wisdom Daily',
        'host': 'JUM Ministers',
        'episodes': '32 Episodes',
        'image': 'https://picsum.photos/seed/wisdom/300/300',
      },
      {
        'title': 'The Faith Builder Show',
        'host': 'Pastor Kingsley',
        'episodes': '8 Episodes',
        'image': 'https://picsum.photos/seed/faith/300/300',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'JUM Podcast Directory',
        showBack: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.72,
        ),
        itemCount: podcasts.length,
        itemBuilder: (context, index) {
          final pod = podcasts[index];
          return JumCard(
            padding: EdgeInsets.zero,
            backgroundColor: AppColors.surface,
            child: InkWell(
              onTap: () => context.push('/media/podcast-episode'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.radiusLg),
                        topRight: Radius.circular(AppSizes.radiusLg),
                      ),
                      child: Image.network(
                        pod['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pod['title']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(4),
                        Text(
                          pod['host']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: AppColors.surface2,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            pod['episodes']!,
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
// PODCAST EPISODE PLAYER SCREEN
// -------------------------------------------------------------
class PodcastEpisodePlayerScreen extends StatefulWidget {
  const PodcastEpisodePlayerScreen({Key? key}) : super(key: key);

  @override
  State<PodcastEpisodePlayerScreen> createState() => _PodcastEpisodePlayerScreenState();
}

class _PodcastEpisodePlayerScreenState extends State<PodcastEpisodePlayerScreen> {
  bool _isPlaying = false;
  double _position = 180.0;
  final double _duration = 1420.0;

  String _format(double sec) {
    final m = (sec / 60).floor();
    final s = (sec % 60).floor();
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'Podcast Player',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            JumCard(
              backgroundColor: AppColors.surface,
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/seed/grace/150/150',
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Gap(16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unhindered Grace',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Gap(4),
                        Text(
                          'Ep. 3: Radical Generosity',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),
            JumCard(
              backgroundColor: AppColors.surface,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Slider(
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.border,
                    value: _position,
                    max: _duration,
                    onChanged: (val) => setState(() => _position = val),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_format(_position), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.0)),
                      Text('-${_format(_duration - _position)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.0)),
                    ],
                  ),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous_rounded, size: 36.0, color: AppColors.primary),
                        onPressed: () {},
                      ),
                      const Gap(16),
                      CircleAvatar(
                        radius: 32.0,
                        backgroundColor: AppColors.primary,
                        child: IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 36.0,
                          ),
                          onPressed: () => setState(() => _isPlaying = !_isPlaying),
                        ),
                      ),
                      const Gap(16),
                      IconButton(
                        icon: const Icon(Icons.skip_next_rounded, size: 36.0, color: AppColors.primary),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(32),
            const Text(
              'EPISODE DESCRIPTION & STUDY NOTES',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 1.0,
              ),
            ),
            const Gap(12),
            const Text(
              'In this third episode of the Unhindered Grace Podcast, Pastor Kingsley speaks with ministers about what radical generosity looks like in the modern age, drawing scripture references from Acts 2 and detailing practical keys to support missions work.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// STREAM SCHEDULE SCREEN
// -------------------------------------------------------------
class StreamScheduleScreen extends StatelessWidget {
  const StreamScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final schedules = [
      {
        'title': 'Mid-Week Faith Injection',
        'day': 'Wednesday',
        'time': '7:00 PM',
        'host': 'Pastor Kingsley',
        'countdown': 'Starts in 1 day',
      },
      {
        'title': 'Friday Night Prayer Fire',
        'day': 'Friday',
        'time': '10:00 PM',
        'host': 'Prayer Band Leaders',
        'countdown': 'Starts in 3 days',
      },
      {
        'title': 'Sunday Thanksgiving Worship',
        'day': 'Sunday',
        'time': '9:00 AM',
        'host': 'JUM Ministers',
        'countdown': 'Starts in 5 days',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'Virtual Stream Schedule',
        showBack: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final sched = schedules[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: JumCard(
              backgroundColor: AppColors.surface,
              child: Row(
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(Icons.wifi_tethering_rounded, color: AppColors.primary),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sched['title']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          '${sched['day']!} at ${sched['time']!} • with ${sched['host']!}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          sched['countdown']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  IconButton(
                    icon: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reminder set for ${sched['title']}'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
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
// SERVICE SCHEDULE SCREEN
// -------------------------------------------------------------
class ServiceScheduleScreen extends StatelessWidget {
  const ServiceScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'title': 'First Service: Dawn Grace',
        'time': '7:30 AM - 9:00 AM',
        'details': 'Early morning praise, word, and holy communion.',
      },
      {
        'title': 'Second Service: Victory Power',
        'time': '9:30 AM - 11:30 AM',
        'details': 'Main worship service with full kids church active.',
      },
      {
        'title': 'Third Service: Unhindered Fire',
        'time': '12:00 PM - 1:30 PM',
        'details': 'Special deliverance, youth-centered message, and prayers.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'Weekly Physical Services',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            JumCard(
              backgroundColor: AppColors.primary,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JUM CATHEDRAL',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Gap(6),
                  Text(
                    'Join Us This Sunday',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Gap(8),
                  Text(
                    '12, Unhindered Avenue, JUM Headquarters, Lagos, Nigeria.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(32),
            const Text(
              'SUNDAY SERVICE TIMES',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 1.0,
              ),
            ),
            const Gap(16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final s = services[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: JumCard(
                    backgroundColor: AppColors.surface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              s['title']!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Icon(Icons.access_time_rounded, size: 18.0, color: AppColors.textSecondary),
                          ],
                        ),
                        const Gap(6),
                        Text(
                          s['time']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          s['details']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Gap(16),
            JumButton(
              label: 'Check In to Service',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully checked into Cathedral Service!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
