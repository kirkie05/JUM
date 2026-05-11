import 'package:flutter/material.dart';

import '../../../media/presentation/screens/media_library_screen.dart';
import 'sermon_player_screen.dart';

class SermonListScreen extends StatelessWidget {
  const SermonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediaLibraryScreen();
  }
}

class SermonDetailScreen extends StatelessWidget {
  final String sermonId;
  const SermonDetailScreen({super.key, required this.sermonId});

  @override
  Widget build(BuildContext context) {
    return SermonPlayerScreen(sermonId: sermonId);
  }
}
