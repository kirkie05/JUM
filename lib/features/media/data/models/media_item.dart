import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MediaItemType { video, audio }

class MediaItem {
  final String id;
  final MediaItemType type;
  final String title;
  final String sourceName;
  final String sourceUrl;
  final String? thumbnailUrl;
  final String? description;
  final DateTime? publishedAt;
  final DateTime? endsAt;
  final String? duration;
  final int? viewCount;
  final bool isLive;
  final int? viewerCount;

  const MediaItem({
    required this.id,
    required this.type,
    required this.title,
    required this.sourceName,
    required this.sourceUrl,
    this.thumbnailUrl,
    this.description,
    this.publishedAt,
    this.endsAt,
    this.duration,
    this.viewCount,
    this.isLive = false,
    this.viewerCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'sourceName': sourceName,
      'sourceUrl': sourceUrl,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'publishedAt': publishedAt?.toIso8601String(),
      'endsAt': endsAt?.toIso8601String(),
      'duration': duration,
      'viewCount': viewCount,
      'isLive': isLive,
      'viewerCount': viewerCount,
    };
  }

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as String,
      type: MediaItemType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MediaItemType.video,
      ),
      title: json['title'] as String,
      sourceName: json['sourceName'] as String,
      sourceUrl: json['sourceUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      description: json['description'] as String?,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'] as String)
          : null,
      endsAt: json['endsAt'] != null
          ? DateTime.tryParse(json['endsAt'] as String)
          : null,
      duration: json['duration'] as String?,
      viewCount: json['viewCount'] as int?,
      isLive: json['isLive'] as bool? ?? false,
      viewerCount: json['viewerCount'] as int?,
    );
  }
}

class MediaChannelConfig {
  final String youtubeUrl;
  final String mixlrUrl;
  final String youtubeChannelId;
  final String mixlrUsername;

  const MediaChannelConfig({
    required this.youtubeUrl,
    required this.mixlrUrl,
    required this.youtubeChannelId,
    required this.mixlrUsername,
  });

  static Future<MediaChannelConfig> fromEnvOrPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    final envYtUrl = dotenv.env['YOUTUBE_CHANNEL_URL'];
    final envMixlrUrl = dotenv.env['MIXLR_URL'];
    final envYtId = dotenv.env['YOUTUBE_CHANNEL_ID'];
    final envMixlrUsername = dotenv.env['MIXLR_USERNAME'];

    final savedYtUrl = prefs.getString('media_youtube_channel_url');
    final savedMixlrUrl = prefs.getString('media_mixlr_channel_url');
    final savedYtId = prefs.getString('media_youtube_channel_id');
    final savedMixlrUsername = prefs.getString('media_mixlr_username');

    return MediaChannelConfig(
      youtubeUrl: (envYtUrl ?? savedYtUrl ?? defaults.youtubeUrl).trim(),
      mixlrUrl: (envMixlrUrl ?? savedMixlrUrl ?? defaults.mixlrUrl).trim(),
      youtubeChannelId: (envYtId ?? savedYtId ?? defaults.youtubeChannelId).trim(),
      mixlrUsername: (envMixlrUsername ?? savedMixlrUsername ?? defaults.mixlrUsername).trim(),
    );
  }

  static const defaults = MediaChannelConfig(
    youtubeUrl: 'https://www.youtube.com/@jesusunhinderedministry',
    mixlrUrl: 'https://jesus-unhindered-ministry.mixlr.com/',
    youtubeChannelId: 'UCWBgDZHCDAExvnULHkhtc-A',
    mixlrUsername: 'jesus-unhindered-ministry',
  );
}

