import 'package:flutter/material.dart';

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
  void seekTo(Duration position) {}
  void play() {}
  void pause() {}
  void setPlaybackSpeed(double speed) {}

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Platform not supported'));
  }
}
