import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// Utility to resolve direct playable media URLs (like physical MP4 streams)
/// from standard public video web addresses like YouTube.
class MediaStreamResolver {
  static final YoutubeExplode _yt = YoutubeExplode();

  /// Accepts a URL, and if it identifies as a YouTube link, extracts and returns
  /// the direct stream URL (muxed video + audio MP4) with the highest bitrate.
  /// Otherwise, yields the original URL directly.
  static Future<String> resolveNativeStreamUrl(String url) async {
    final cleanUrl = url.trim();
    
    if (cleanUrl.contains('youtube') || cleanUrl.contains('youtu.be')) {
      try {
        final videoIdStr = VideoId.parseVideoId(cleanUrl);
        if (videoIdStr != null) {
          final videoId = VideoId(videoIdStr);
          final manifest = await _yt.videos.streamsClient.getManifest(videoId);
          
          // Fetch highest quality muxed stream (contains both video + audio)
          final muxedStream = manifest.muxed.withHighestBitrate();
          return muxedStream.url.toString();
        }
      } catch (e) {
        // If extraction fails due to geo-restrictions or runtime error, return source URL
      }
    }
    
    return cleanUrl;
  }

  /// Close the internal HTTP client when necessary.
  static void close() {
    _yt.close();
  }
}
