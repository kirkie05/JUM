import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  // A popular playlist ID: PLBCF2DAC6FFB574DE (Taylor Swift)
  final playlistId = PlaylistId('PLBCF2DAC6FFB574DE');
  try {
    final playlist = await yt.playlists.get(playlistId);
    print('Playlist Title: ${playlist.title}');
    final videos = await yt.playlists.getVideos(playlistId).take(5).toList();
    print('Found ${videos.length} videos in Taylor Swift playlist.');
    for (var v in videos) {
      print('Video Title: ${v.title}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    yt.close();
  }
}
