import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  final channelId = 'UCWBgDZHCDAExvnULHkhtc-A';
  final feedUrl = 'https://www.youtube.com/feeds/videos.xml?channel_id=$channelId';
  try {
    final response = await dio.get<String>(feedUrl);
    final xml = response.data ?? '';
    print('RSS XML Length: ${xml.length}');
    print('Contains entry: ${xml.contains('<entry>') || xml.contains('entry')}');
    if (xml.length > 500) {
      print('First 500 chars: ${xml.substring(0, 500)}');
    } else {
      print('XML: $xml');
    }
  } catch (e) {
    print('Error: $e');
  }
}
