import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
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
  late String _viewId;
  html.IFrameElement? _iframe;

  @override
  void initState() {
    super.initState();
    _viewId = 'youtube-iframe-${widget.videoId}';
    
    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = 'https://www.youtube.com/embed/${widget.videoId}?autoplay=1&enablejsapi=1&start=${widget.initialPosition.inSeconds}'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'autoplay; encrypted-media; picture-in-picture'
        ..allowFullscreen = true;
      _iframe = iframe;
      return iframe;
    });
  }

  void seekTo(Duration position) {
    _iframe?.contentWindow?.postMessage('{"event":"command","func":"seekTo","args":[${position.inSeconds},true]}', '*');
  }

  void play() {
    _iframe?.contentWindow?.postMessage('{"event":"command","func":"playVideo","args":[]}', '*');
  }

  void pause() {
    _iframe?.contentWindow?.postMessage('{"event":"command","func":"pauseVideo","args":[]}', '*');
  }

  void setPlaybackSpeed(double speed) {
    _iframe?.contentWindow?.postMessage('{"event":"command","func":"setPlaybackRate","args":[$speed]}', '*');
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewId);
  }
}
