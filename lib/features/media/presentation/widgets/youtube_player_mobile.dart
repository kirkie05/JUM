import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class JumYoutubePlayer extends StatefulWidget {
  final String videoId;
  final bool isLive;
  final Duration initialPosition;
  final Function(Duration)? onPositionChanged;
  final Function(bool)? onPlayStateChanged;

  const JumYoutubePlayer({
    super.key,
    required this.videoId,
    required this.isLive,
    this.initialPosition = Duration.zero,
    this.onPositionChanged,
    this.onPlayStateChanged,
  });

  @override
  State<JumYoutubePlayer> createState() => JumYoutubePlayerState();
}

class JumYoutubePlayerState extends State<JumYoutubePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        isLive: widget.isLive,
        startAt: widget.initialPosition.inSeconds,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (!mounted) return;
    if (widget.onPositionChanged != null) {
      widget.onPositionChanged!(_controller.value.position);
    }
    if (widget.onPlayStateChanged != null) {
      widget.onPlayStateChanged!(_controller.value.isPlaying);
    }
  }

  void seekTo(Duration position) {
    _controller.seekTo(position);
  }

  void play() {
    _controller.play();
  }

  void pause() {
    _controller.pause();
  }

  void setPlaybackSpeed(double speed) {
    _controller.setPlaybackRate(speed);
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.red,
      progressColors: const ProgressBarColors(
        playedColor: Colors.red,
        handleColor: Colors.redAccent,
      ),
    );
  }
}
