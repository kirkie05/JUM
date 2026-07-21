import 'dart:io';

void main() {
  final file = File('lib/features/media/presentation/screens/media_player_screen.dart');
  var content = file.readAsStringSync();
  
  // 1. Remove manual full-screen toggling logic
  content = content.replaceAll('''
  void _toggleFullScreen() {
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
  }
''', '''
  void _toggleFullScreen() {
    _ytController.toggleFullScreenMode();
  }
''');

  // 2. Change the build method to use YoutubePlayerBuilder
  final buildStart = content.indexOf('  @override\n  Widget build(BuildContext context) {');
  final buildCodeBlock = content.substring(buildStart);
  
  // We need to rewrite the start of the build method
  final oldBuildStart = '''
  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: WillPopScope(
          onWillPop: () async {
            if (_isFullScreen) {
              _toggleFullScreen();
              return false;
            }
            return true;
          },
          child: Column(
            children: [
              // YouTube Player Container
              Container(
                color: Colors.black,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: !_isInitialized
                      ? const Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        )
                      : YoutubePlayer(
                          controller: _ytController,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: AppColors.primary,
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final notesAsync = ref.watch(mediaNotesProvider(widget.item.id));
    final currentUserId = ref.watch(currentUserProvider).value?.id;

    return Scaffold(
''';

  final newBuildStart = '''
  @override
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
''';

  content = content.replaceFirst(oldBuildStart, newBuildStart);

  // 3. Replace the old player section in the scaffold body with `player,`
  final oldPlayerSection = '''
            // YouTube Player Container
            Container(
              color: Colors.black,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: !_isInitialized
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    : YoutubePlayer(
                        controller: _ytController,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: AppColors.primary,
                      ),
              ),
            ),
''';

  final newPlayerSection = '''
            // YouTube Player Container
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
''';

  content = content.replaceFirst(oldPlayerSection, newPlayerSection);

  // 4. Add the closing braces for YoutubePlayerBuilder at the end of the build method.
  // The end of the build method is `    );\n  }\n`
  final oldBuildEnd = '''
    );
  }

  Widget _buildNotesPanel(
''';

  final newBuildEnd = '''
    );
      },
    );
  }

  Widget _buildNotesPanel(
''';

  content = content.replaceFirst(oldBuildEnd, newBuildEnd);

  file.writeAsStringSync(content);
  print("Updated media_player_screen.dart");
}
