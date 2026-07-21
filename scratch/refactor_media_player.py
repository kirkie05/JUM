import re

with open('lib/features/media/presentation/screens/media_player_screen.dart', 'r') as f:
    content = f.read()

# 1. Imports
content = content.replace("import 'package:youtube_player_flutter/youtube_player_flutter.dart';", 
"""import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';""")

# 2. State variables
content = content.replace("late YoutubePlayerController _ytController;",
"""VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  final _yt = YoutubeExplode();
  String _thumbnailUrl = '';
  String _videoTitle = '';
  Duration _videoDuration = Duration.zero;""")

# 3. Initialization
init_old = """  void _initializePlayer() {
    final rawVideoId = YoutubePlayer.convertUrlToId(widget.item.sourceUrl) ?? '';
    
    _ytController = YoutubePlayerController(
      initialVideoId: rawVideoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        isLive: widget.item.isLive,
        showLiveFullscreenButton: true,
        forceHD: false,
        enableCaption: false,
        useHybridComposition: true,
      ),
    )..addListener(_playerListener);
  }"""

init_new = """  Future<void> _initializePlayer() async {
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
  }"""
content = content.replace(init_old, init_new)

# 4. Listener
listener_old = """  void _playerListener() async {
    if (!mounted) return;
    
    if (_ytController.value.hasError) {
      print('YOUTUBE PLAYER ERROR: ${_ytController.value.errorCode}');
    }
    
    if (!_ytController.value.isReady) return;

    if (!_isInitialized) {
      setState(() {
        _isInitialized = true;
      });

      // Automatically resume progress
      if (!_hasResumedProgress && !widget.item.isLive) {
        _hasResumedProgress = true;
        final repo = ref.read(mediaRepositoryProvider);
        final progress = await repo.getPlaybackProgress(widget.item.id);
        if (progress != null) {
          final positionMs = progress['positionMs'] as int? ?? 0;
          final durationMs = _ytController.metadata.duration.inMilliseconds;
          if (positionMs > 0 && positionMs < (durationMs - 5000)) {
            _ytController.seekTo(Duration(milliseconds: positionMs));
            
            // Show resume message
            if (mounted) {
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
    }
  }"""
listener_new = """  void _playerListener() {
    if (!mounted || _videoPlayerController == null) return;
    if (_videoPlayerController!.value.hasError) {
      debugPrint('VIDEO PLAYER ERROR: ${_videoPlayerController!.value.errorDescription}');
    }
    setState(() {}); // Update custom controls
  }"""
content = content.replace(listener_old, listener_new)

# 5. Save progress
content = content.replace("_ytController.value.position.inMilliseconds", "_videoPlayerController?.value.position.inMilliseconds ?? 0")
content = content.replace("_ytController.metadata.duration.inMilliseconds", "_videoPlayerController?.value.duration.inMilliseconds ?? 0")

# 6. Seek relative
seek_rel_old = """  void _seekRelative(int seconds) {
    final current = _ytController.value.position;
    var target = current + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    _ytController.seekTo(target);
  }"""
seek_rel_new = """  void _seekRelative(int seconds) {
    if (_videoPlayerController == null) return;
    final current = _videoPlayerController!.value.position;
    var target = current + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    _videoPlayerController!.seekTo(target);
  }"""
content = content.replace(seek_rel_old, seek_rel_new)

# 7. Dispose
dispose_old = """  @override
  void dispose() {
    // Save progress one last time on close
    _saveCurrentProgress();
    _progressSaveTimer?.cancel();
    
    // Reset Orientations
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    _ytController.removeListener(_playerListener);
    _ytController.dispose();
    super.dispose();
  }"""
dispose_new = """  @override
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
  }"""
content = content.replace(dispose_old, dispose_new)

# 8. Build method (remove YoutubePlayerBuilder)
content = re.sub(r'return YoutubePlayerBuilder\([\s\S]*?builder: \(context, player\) \{[\s\S]*?return Scaffold\(', 'return Scaffold(', content)
content = content.replace('            children: [\n                // YouTube Player\n                player,', 
"""            children: [
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
                      ),""")

# 9. Custom controls - change value listenable
content = content.replace("valueListenable: _ytController,", "valueListenable: _videoPlayerController ?? ValueNotifier(VideoPlayerValue(duration: Duration.zero)),")
content = content.replace("final bool isPlaying = _ytController.value.isPlaying;", "final bool isPlaying = _videoPlayerController?.value.isPlaying ?? false;")
content = content.replace("_ytController.pause();", "_videoPlayerController?.pause();")
content = content.replace("_ytController.play();", "_videoPlayerController?.play();")
content = content.replace("initialValue: _ytController.value.playbackRate,", "initialValue: _videoPlayerController?.value.playbackRate ?? 1.0,")
content = content.replace("${_ytController.value.playbackRate}x", "${_videoPlayerController?.value.playbackRate ?? 1.0}x")
content = content.replace("_ytController.setPlaybackRate(speed);", "_videoPlayerController?.setPlaybackRate(speed);")

# 10. Notes timestamp
content = content.replace("_ytController.value.position.inSeconds", "_videoPlayerController?.value.position.inSeconds ?? 0")
content = content.replace("_ytController.seekTo(Duration(seconds: note.timestampSeconds));", "_videoPlayerController?.seekTo(Duration(seconds: note.timestampSeconds));")

# 11. End of build method bracket cleanup
# The YoutubePlayerBuilder had an extra `    );` at the very end of the build method.
content = re.sub(r'          \),\n        \);\n      \},\n    \);\n  \}', '          ),\n        );\n  }', content)


with open('lib/features/media/presentation/screens/media_player_screen.dart', 'w') as f:
    f.write(content)

