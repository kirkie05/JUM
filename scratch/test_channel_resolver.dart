import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  try {
    print('Testing getByHandle with @jesusunhinderedministry...');
    final channel = await yt.channels.getByHandle('https://www.youtube.com/@jesusunhinderedministry');
    print('Resolved channel ID: ${channel.id.value}');
    print('Resolved channel title: ${channel.title}');
  } catch (e) {
    print('Failed with absolute URL, trying handle string only...');
    try {
      final channel = await yt.channels.getByHandle('@jesusunhinderedministry');
      print('Resolved channel ID: ${channel.id.value}');
      print('Resolved channel title: ${channel.title}');
    } catch (e2) {
      print('Failed handle search: $e2');
    }
  } finally {
    yt.close();
  }
}
