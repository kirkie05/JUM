import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  final playlistId = 'UUWBgDZHCDAExvnULHkhtc-A';
  final feedUrl = 'https://www.youtube.com/feeds/videos.xml?playlist_id=$playlistId';
  try {
    final response = await dio.get<String>(feedUrl);
    final xml = response.data ?? '';
    print('Playlist RSS XML Length: ${xml.length}');
    print('Contains entry: ${xml.contains('<entry>') || xml.contains('entry')}');
    if (xml.contains('<entry>')) {
      final entriesCount = RegExp(r'<entry>').allMatches(xml).length;
      print('Entries count: $entriesCount');
    }
  } catch (e) {
    print('Error: $e');
  }
}
