import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final channelId = 'UCWBgDZHCDAExvnULHkhtc-A';
  try {
    final channel = await yt.channels.get(channelId);
    print('Channel Title: ${channel.title}');
    final uploads = await yt.channels.getUploads(channelId).take(5).toList();
    print('getUploads returned ${uploads.length} videos.');
    for (var v in uploads) {
      print('Video ID: ${v.id.value}, Title: ${v.title}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    yt.close();
  }
}
