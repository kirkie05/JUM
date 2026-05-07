import 'package:flutter/material.dart';

import 'sermon_library_screen.dart';
import 'sermon_player_screen.dart';

class SermonListScreen extends StatelessWidget {
  const SermonListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SermonLibraryScreen();
  }
}

class SermonDetailScreen extends StatelessWidget {
  final String sermonId;
  const SermonDetailScreen({Key? key, required this.sermonId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SermonPlayerScreen(sermonId: sermonId);
  }
}
