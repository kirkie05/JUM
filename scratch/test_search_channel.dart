import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final channelId = 'UCWBgDZHCDAExvnULHkhtc-A';
  
  try {
    print('Searching channel by name:');
    final searchResult = await yt.search.search('Jesus Unhindered Ministry');
    print('Found search results: ${searchResult.length}');
    for (var v in searchResult.take(5)) {
      print(' - Video: ${v.title} (ID: ${v.id.value}) by ${v.author}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    yt.close();
  }
}
