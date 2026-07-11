import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final channelId = 'UCWBgDZHCDAExvnULHkhtc-A';
  // Replace UC with UU at start of channel ID
  final uploadsPlaylistId = 'UUWBgDZHCDAExvnULHkhtc-A';
  
  try {
    print('Testing channel ID: $channelId');
    final playlist = await yt.playlists.get(uploadsPlaylistId);
    print('Playlist Title: ${playlist.title}');
    final videos = await yt.playlists.getVideos(playlist.id).take(10).toList();
    print('Found ${videos.length} videos in uploads playlist.');
    for (var v in videos) {
      print('Video Title: ${v.title} (ID: ${v.id.value})');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    yt.close();
  }
}
