import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  try {
    final videoId = 'bQV5J-8KQdc';
    print('Resolving stream manifest...');
    final manifest = await yt.videos.streams.getManifest(videoId);
    if (manifest.muxed.isNotEmpty) {
      final first = manifest.muxed.first;
      print('First stream info properties:');
      print('- Bitrate: ${first.bitrate}');
      print('- QualityLabel: ${first.videoQualityLabel}');
      print('- Resolution: ${first.videoResolution}');
      print('- Size: ${first.size}');
      
      // Let's select the one with the highest bitrate or highest resolution width/height
      final bestStream = manifest.muxed.reduce((curr, next) {
        return curr.bitrate.bitsPerSecond > next.bitrate.bitsPerSecond ? curr : next;
      });
      print('Selected best stream URL: ${bestStream.url}');
    } else {
      print('Muxed list is empty!');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    yt.close();
  }
}
