import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  try {
    final video = await yt.videos.get('dQw4w9WgXcQ');
    print('maxResUrl type: ${video.thumbnails.maxResUrl.runtimeType}');
    print('lowResUrl type: ${video.thumbnails.lowResUrl.runtimeType}');
  } catch (e) {
    print('Error: $e');
  } finally {
    yt.close();
  }
}
