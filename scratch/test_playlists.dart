import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final file = File('scratch/playlists_output.txt');
  file.writeAsStringSync('Testing started\n');

  final yt = YoutubeExplode();
  final query = 'Jesus Unhindered Ministry';
  
  try {
    file.writeAsStringSync('Searching for query: $query\n', mode: FileMode.append);
    final results = await yt.search.search(
      query,
      filter: TypeFilters.playlist,
    );
    file.writeAsStringSync('Found playlists: ${results.length}\n', mode: FileMode.append);
    for (var p in results) {
      file.writeAsStringSync(' - Playlist: ${p.title} (ID: ${p.id})\n', mode: FileMode.append);
    }
  } catch (e, stack) {
    file.writeAsStringSync('Error: $e\n$stack\n', mode: FileMode.append);
  } finally {
    yt.close();
    file.writeAsStringSync('Testing finished\n', mode: FileMode.append);
  }
}
