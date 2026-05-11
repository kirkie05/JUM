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
    this.viewCount,
    this.isLive = false,
  });
}

class MediaChannelConfig {
  final String youtubeUrl;
  final String mixlrUrl;

  const MediaChannelConfig({required this.youtubeUrl, required this.mixlrUrl});

  static const defaults = MediaChannelConfig(
    youtubeUrl: 'https://www.youtube.com/@jesusunhinderedministry',
    mixlrUrl: 'https://jesus-unhindered-ministry.mixlr.com/',
  );
}
