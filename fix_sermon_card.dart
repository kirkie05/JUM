import 'dart:io';

void main() {
  final file = File('lib/features/sermons/presentation/widgets/sermon_card.dart');
  var content = file.readAsStringSync();
  content = content.replaceAll(
    'sourceUrl: sermon.mediaUrl,',
    "sourceUrl: (sermon.type == 'video' && sermon.youtubeVideoId != null && sermon.youtubeVideoId!.isNotEmpty) ? 'https://www.youtube.com/watch?v=\${sermon.youtubeVideoId}' : sermon.mediaUrl,"
  );
  file.writeAsStringSync(content);

  final file2 = File('lib/features/sermons/presentation/widgets/mini_player_bar.dart');
  var content2 = file2.readAsStringSync();
  content2 = content2.replaceAll(
    'sourceUrl: sermon.mediaUrl,',
    "sourceUrl: (sermon.type == 'video' && sermon.youtubeVideoId != null && sermon.youtubeVideoId!.isNotEmpty) ? 'https://www.youtube.com/watch?v=\${sermon.youtubeVideoId}' : sermon.mediaUrl,"
  );
  file2.writeAsStringSync(content2);
  
  print("Fixed SermonCard and MiniPlayerBar");
}
