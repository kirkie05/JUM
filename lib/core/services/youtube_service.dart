import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeVideoData {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final Duration? duration;
  final DateTime? publishedAt;
  final String author;
  final bool isLive;

  YoutubeVideoData({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    this.duration,
    this.publishedAt,
    required this.author,
    this.isLive = false,
  });
}

class YoutubeService {
  final YoutubeExplode _yt = YoutubeExplode();

  Future<String?> resolveChannelId() async {
    final envId = dotenv.env['YOUTUBE_CHANNEL_ID'];
    if (envId != null && envId.trim().isNotEmpty) {
      return envId.trim();
    }

    final envUrl = dotenv.env['YOUTUBE_CHANNEL_URL'];
    if (envUrl == null || envUrl.trim().isEmpty) {
      return null;
    }

    try {
      final channel = await _yt.channels.getByHandle(envUrl.trim());
      return channel.id.value;
    } catch (e) {
      // Fallback if URL is not a handle but we can parse it differently
      final handleMatch = RegExp(r'@([a-zA-Z0-9_-]+)').firstMatch(envUrl);
      if (handleMatch != null) {
        try {
          final handle = handleMatch.group(0)!;
          final channel = await _yt.channels.getByHandle(handle);
          return channel.id.value;
        } catch (e2) {
          print('Failed to resolve handle: $e2');
        }
      }
      return null;
    }
  }

  Future<List<YoutubeVideoData>> fetchLatestVideos({int count = 50}) async {
    final channelId = await resolveChannelId();
    if (channelId == null) {
      throw Exception('Could not resolve YouTube Channel ID from environment variables.');
    }

    // Get channel to get author name
    final channel = await _yt.channels.get(ChannelId(channelId));
    final authorName = channel.title;

    // Get latest videos from channel
    final uploads = await _yt.channels.getUploads(ChannelId(channelId)).take(count).toList();
    
    return uploads.map((video) {
      return YoutubeVideoData(
        id: video.id.value,
        title: video.title,
        description: video.description,
        thumbnailUrl: video.thumbnails.highResUrl,
        duration: video.duration,
        publishedAt: video.uploadDate,
        author: video.author.isNotEmpty ? video.author : authorName,
        isLive: video.isLive,
      );
    }).toList();
  }

  Future<YoutubeVideoData?> fetchVideoDetails(String videoId) async {
    try {
      final video = await _yt.videos.get(VideoId(videoId));
      return YoutubeVideoData(
        id: video.id.value,
        title: video.title,
        description: video.description,
        thumbnailUrl: video.thumbnails.highResUrl,
        duration: video.duration,
        publishedAt: video.uploadDate,
        author: video.author,
        isLive: video.isLive,
      );
    } catch (e) {
      print('Failed to fetch video details: $e');
      return null;
    }
  }

  void dispose() {
    _yt.close();
  }
}
