import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/media_item.dart';

class MediaRepository {
  MediaRepository(this._dio);

  final Dio _dio;

  static const _youtubeUrlKey = 'media_youtube_channel_url';
  static const _mixlrUrlKey = 'media_mixlr_channel_url';

  Future<MediaChannelConfig> loadChannelConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return MediaChannelConfig(
      youtubeUrl:
          prefs.getString(_youtubeUrlKey) ??
          MediaChannelConfig.defaults.youtubeUrl,
      mixlrUrl:
          prefs.getString(_mixlrUrlKey) ?? MediaChannelConfig.defaults.mixlrUrl,
    );
  }

  Future<void> saveChannelConfig(MediaChannelConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_youtubeUrlKey, config.youtubeUrl.trim()),
      prefs.setString(_mixlrUrlKey, config.mixlrUrl.trim()),
    ]);
  }

  Future<List<MediaItem>> fetchMedia() async {
    final config = await loadChannelConfig();
    final results = await Future.wait([
      fetchYoutubeVideos(config.youtubeUrl),
      fetchMixlrAudio(config.mixlrUrl),
    ]);
    return [...results[0], ...results[1]]..sort((a, b) {
      if (a.isLive != b.isLive) return a.isLive ? -1 : 1;
      final aDate = a.publishedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.publishedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
  }

  Future<List<MediaItem>> fetchYoutubeVideos(String channelUrl) async {
    final channelId = await _resolveYoutubeChannelId(channelUrl);
    final feedUrl =
        'https://www.youtube.com/feeds/videos.xml?channel_id=$channelId';
    final response = await _dio.get<String>(feedUrl);
    final xml = response.data ?? '';
    final author =
        _decode(_firstTag(xml, 'title')) ?? 'Jesus Unhindered Ministry';
    final entries = RegExp(
      r'<entry>([\s\S]*?)<\/entry>',
      multiLine: true,
    ).allMatches(xml);

    return entries
        .map((match) {
          final entry = match.group(1) ?? '';
          final videoId = _firstTag(entry, 'yt:videoId') ?? '';
          final title = _decode(_firstTag(entry, 'title')) ?? 'YouTube video';
          final publishedAt = DateTime.tryParse(
            _firstTag(entry, 'published') ?? '',
          );
          final thumbnail = _firstAttribute(entry, 'media:thumbnail', 'url');
          final description = _decode(_firstTag(entry, 'media:description'));
          final views = int.tryParse(
            _firstAttribute(entry, 'media:statistics', 'views') ?? '',
          );

          return MediaItem(
            id: 'youtube-$videoId',
            type: MediaItemType.video,
            title: title,
            sourceName: author,
            sourceUrl: 'https://www.youtube.com/watch?v=$videoId',
            thumbnailUrl: thumbnail,
            description: description,
            publishedAt: publishedAt,
            viewCount: views,
          );
        })
        .where((item) => item.id != 'youtube-')
        .toList();
  }

  Future<List<MediaItem>> fetchMixlrAudio(String channelUrl) async {
    final slug = _mixlrSlug(channelUrl);
    try {
      final viewResponse = await _dio.get<Map<String, dynamic>>(
        'https://apicdn.mixlr.com/v3/channel_view/$slug',
      );
      final viewData = viewResponse.data ?? const {};
      final isLive = viewData['live'] == true;
      final channelId = viewData['channel_id'];
      final title = (viewData['channel_name'] ?? 'Jesus Unhindered Ministry')
          .toString();
      final logoUrl = viewData['profile_image_url']?.toString();
      final about = viewData['about_me']?.toString();

      final items = <MediaItem>[];

      if (isLive && channelId != null) {
        items.add(
          MediaItem(
            id: 'mixlr-$slug-live',
            type: MediaItemType.audio,
            title: '$title is live now',
            sourceName: 'Mixlr',
            sourceUrl: 'https://edge.mixlr.com/channel/$channelId',
            thumbnailUrl: logoUrl,
            description: about,
            isLive: true,
          ),
        );
      }

      final recordings = await _fetchMixlrRecordings(slug);
      items.addAll(recordings);

      // If no items at all, at least show the offline channel
      if (items.isEmpty) {
        items.add(
          MediaItem(
            id: 'mixlr-$slug-offline',
            type: MediaItemType.audio,
            title: '$title channel',
            sourceName: 'Mixlr',
            sourceUrl: 'https://edge.mixlr.com/channel/$channelId',
            thumbnailUrl: logoUrl,
            description: about,
            isLive: false,
          ),
        );
      }

      return items;
    } catch (_) {
      return const [];
    }
  }

  Future<List<MediaItem>> _fetchMixlrRecordings(String slug) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://apicdn.mixlr.com/v3/channels/$slug/recordings?page[size]=20',
      );
      final dataList = response.data?['data'] as List? ?? const [];
      final included = response.data?['included'] as List? ?? const [];

      return dataList.map((rawItem) {
        final item = rawItem as Map;
        final attrs = (item['attributes'] as Map?) ?? const {};
        final rels = (item['relationships'] as Map?) ?? const {};

        final audioRef = (rels['audio']?['data'] as Map?) ?? const {};
        final audioId = audioRef['id'];

        String? audioUrl;
        if (audioId != null) {
          // Use dynamic cast explicitly to permit orElse resulting in null
          final audioEntity = included.cast<dynamic>().firstWhere(
            (inc) =>
                inc is Map && inc['id'] == audioId && inc['type'] == 'audio',
            orElse: () => null,
          );
          audioUrl =
              (audioEntity as Map?)?['attributes']?['url']?.toString() ??
              attrs['url']?.toString();
        }

        audioUrl ??= attrs['url']?.toString();

        final thumbMap = attrs['media']?['artwork']?['image'] as Map?;
        final thumb = thumbMap?['medium'] ?? thumbMap?['small'];

        return MediaItem(
          id: 'mixlr-rec-${item['id']}',
          type: MediaItemType.audio,
          title: (attrs['title'] ?? 'Mixlr broadcast').toString(),
          sourceName: 'Mixlr',
          sourceUrl: audioUrl ?? '',
          thumbnailUrl: thumb?.toString(),
          description: attrs['description']?.toString(),
          publishedAt: DateTime.tryParse(
            (attrs['starts_at'] ?? attrs['created_at'] ?? '').toString(),
          ),
        );
      }).where((item) => item.sourceUrl.isNotEmpty).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<String> _resolveYoutubeChannelId(String channelUrl) async {
    final direct = RegExp(r'(UC[\w-]{20,})').firstMatch(channelUrl);
    if (direct != null) return direct.group(1)!;

    final normalized = channelUrl.startsWith('http')
        ? channelUrl
        : 'https://www.youtube.com/${channelUrl.replaceFirst(RegExp(r'^/+'), '')}';
    final response = await _dio.get<String>(normalized);
    final page = response.data ?? '';
    final feed = RegExp(
      r'https:\/\/www\.youtube\.com\/feeds\/videos\.xml\?channel_id=(UC[\w-]+)',
    ).firstMatch(page);
    if (feed != null) return feed.group(1)!;

    final channelId = RegExp(r'"channelId":"(UC[\w-]+)"').firstMatch(page);
    if (channelId != null) return channelId.group(1)!;

    throw StateError('Unable to resolve YouTube channel from $channelUrl');
  }

  String _mixlrSlug(String channelUrl) {
    final uri = Uri.tryParse(channelUrl.trim());
    if (uri == null) return channelUrl.trim();
    if (uri.host.endsWith('.mixlr.com')) {
      return uri.host.split('.').first;
    }
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return segments.isEmpty ? channelUrl.trim() : segments.first;
  }

  String? _firstTag(String source, String tag) {
    final match = RegExp(
      '<$tag>([\\s\\S]*?)<\\/$tag>',
      multiLine: true,
    ).firstMatch(source);
    return match?.group(1);
  }

  String? _firstAttribute(String source, String tag, String attribute) {
    final match = RegExp(
      '<$tag\\b[^>]*\\b$attribute="([^"]*)"',
      multiLine: true,
    ).firstMatch(source);
    return _decode(match?.group(1));
  }

  String? _decode(String? value) {
    return value
        ?.replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .trim();
  }
}
