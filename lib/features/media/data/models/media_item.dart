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
  final String? duration; // Duration in seconds or formatted string (e.g. MM:SS)
  final int? viewCount;
  final bool isLive;

  const MediaItem({
    required this.id,
    required this.type,
    required this.title,
    required this.sourceName,
    required this.sourceUrl,
    this.thumbnailUrl,
    this.description,
    this.publishedAt,
    this.duration,
    this.viewCount,
    this.isLive = false,
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
      'duration': duration,
      'viewCount': viewCount,
      'isLive': isLive,
    };
  }

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as String? ?? '',
      type: MediaItemType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MediaItemType.video,
      ),
      title: json['title'] as String? ?? '',
      sourceName: json['sourceName'] as String? ?? json['source_name'] as String? ?? 'YouTube',
      sourceUrl: json['sourceUrl'] as String? ?? json['source_url'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? json['thumbnail_url'] as String?,
      description: json['description'] as String?,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'] as String)
          : (json['published_at'] != null ? DateTime.tryParse(json['published_at'] as String) : null),
      duration: json['duration']?.toString(),
      viewCount: json['viewCount'] as int? ?? json['view_count'] as int?,
      isLive: json['isLive'] as bool? ?? json['is_live'] as bool? ?? false,
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
