import 'package:dio/dio.dart';
import 'package:html/parser.dart' as hp;
import 'package:html/dom.dart';

List<Element> _descendants(Element element) {
  final list = <Element>[];
  for (final child in element.children) {
    list.add(child);
    list.addAll(_descendants(child));
  }
  return list;
}

void main() async {
  final dio = Dio();
  try {
    final channelId = 'UCWBgDZHCDAExvnULHkhtc-A';
    final url = 'https://www.youtube.com/feeds/videos.xml?channel_id=$channelId';
    final response = await dio.get<String>(url);
    
    final document = hp.parse(response.data);
    final entries = document.getElementsByTagName('entry');
    print('Found ${entries.length} entries in RSS feed:');
    
    for (final entry in entries) {
      String? title;
      String? videoId;
      String? published;
      String? thumbnailUrl;
      String? description;

      for (final child in entry.children) {
        if (child.localName == 'title') {
          title = child.text;
        } else if (child.localName == 'yt:videoid') {
          videoId = child.text;
        } else if (child.localName == 'published') {
          published = child.text;
        }
      }

      for (final descendant in _descendants(entry)) {
        if (descendant.localName == 'media:thumbnail') {
          thumbnailUrl = descendant.attributes['url'];
        } else if (descendant.localName == 'media:description') {
          description = descendant.text;
        }
      }

      print('- Title: $title');
      print('  VideoID: $videoId');
      print('  Published: $published');
      print('  Thumbnail: $thumbnailUrl');
      print('  Description Length: ${description?.length ?? 0}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    dio.close();
  }
}
