import re

with open('lib/features/media/presentation/screens/media_player_screen.dart', 'r') as f:
    content = f.read()

# Replace manual full screen toggle
content = content.replace('''  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }''', '''  void _toggleFullScreen() {
    _ytController.toggleFullScreenMode();
  }''')

# We need to find the `Widget build` method entirely and rewrite it.
# We'll use regex to find the start of `Widget build` down to `Widget _buildNotesPanel`.

pattern = re.compile(r'  @override\n  Widget build\(BuildContext context\) \{.*?(?=  Widget _buildNotesPanel\()', re.DOTALL)

new_build = '''  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(mediaNotesProvider(widget.item.id));
    final currentUserId = ref.watch(currentUserProvider).value?.id;

    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      },
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      },
      player: YoutubePlayer(
        controller: _ytController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primary,
        topActions: [
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _ytController.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      builder: (context, player) {
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
                // YouTube Player
                !_isInitialized
                    ? AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.black,
                          child: const Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        ),
                      )
                    : player,

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
                              valueListenable: _ytController,
                              builder: (context, val, _) {
                                final bool isPlaying = _ytController.value.isPlaying;
                                return IconButton(
                                  icon: Icon(
                                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    color: Colors.black87,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    if (isPlaying) {
                                      _ytController.pause();
                                    } else {
                                      _ytController.play();
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
                        initialValue: _playbackRate,
                        tooltip: 'Playback Speed',
                        icon: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${_playbackRate.toStringAsFixed(1).replaceFirst('.0', '')}x',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        onSelected: _setPlaybackRate,
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
      },
    );
  }

'''

content = pattern.sub(new_build, content)

with open('lib/features/media/presentation/screens/media_player_screen.dart', 'w') as f:
    f.write(content)
print("Updated successfully")
