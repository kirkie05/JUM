import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final channelId = 'UCWBgDZHCDAExvnULHkhtc-A';
  final playlistIdStr = 'UU' + channelId.substring(2);
  print('Playlist ID: $playlistIdStr');
  
  try {
    final playlistId = PlaylistId(playlistIdStr);
    final playlist = await yt.playlists.get(playlistId);
    print('Playlist Title: ${playlist.title}');
    
    final videos = await yt.playlists.getVideos(playlistId).take(5).toList();
    print('Found ${videos.length} videos in uploads playlist.');
    
    for (var v in videos) {
      print('Playlist Video Item: ID=${v.id.value}, Title=${v.title}, Date=${v.uploadDate}');
      // Fetch details
      final details = await yt.videos.get(v.id);
      print('Details Video: ID=${details.id.value}, Date=${details.uploadDate}, Duration=${details.duration}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    yt.close();
  }
}
