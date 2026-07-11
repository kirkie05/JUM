import 'package:dio/dio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final dio = Dio();
  final yt = YoutubeExplode();
  final channelId = 'UCWBgDZHCDAExvnULHkhtc-A';
  final feedUrl = 'https://www.youtube.com/feeds/videos.xml?channel_id=$channelId';
  
  try {
    final response = await dio.get<String>(feedUrl);
    final xml = response.data ?? '';
    final entries = RegExp(r'<entry>([\s\S]*?)<\/entry>', multiLine: true).allMatches(xml);
    print('Found ${entries.length} entries in RSS feed.');
    
    final List<String> videoIds = [];
    for (var match in entries) {
      final entry = match.group(1) ?? '';
      final videoIdMatch = RegExp(r'<yt:videoId>([^<]+)<\/yt:videoId>').firstMatch(entry);
      final videoId = videoIdMatch?.group(1);
      if (videoId != null && videoId.isNotEmpty) {
        videoIds.add(videoId);
      }
    }
    
    print('Extract video IDs: $videoIds');
    for (var id in videoIds.take(3)) {
      final video = await yt.videos.get(id);
      print('Video: ID=${video.id.value}, Title=${video.title}, Duration=${video.duration}, Uploaded=${video.uploadDate}');
      print('  Thumbnail Low: ${video.thumbnails.lowResUrl}');
      print('  Thumbnail Med: ${video.thumbnails.mediumResUrl}');
      print('  Thumbnail High: ${video.thumbnails.highResUrl}');
      print('  Thumbnail Std: ${video.thumbnails.standardResUrl}');
      print('  Thumbnail Max: ${video.thumbnails.maxResUrl}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    yt.close();
  }
}
