import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jum/features/media/data/models/media_item.dart';
import 'package:jum/features/media/data/repositories/media_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late MediaRepository repository;

  setUp(() async {
    await dotenv.load(fileName: '.env');
    dotenv.env['YOUTUBE_API_KEY'] = 'mock-key-123';
    mockDio = MockDio();
    repository = MediaRepository(mockDio);
  });

  group('MediaRepository YouTube tests', () {
    test('fetchYoutubeVideos makes correct API calls and returns parsed MediaItems', () async {
      when(() => mockDio.get(
            'https://www.googleapis.com/youtube/v3/channels',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: {
              'items': [
                {
                  'contentDetails': {
                    'relatedPlaylists': {
                      'uploads': 'UUuploads123',
                    }
                  }
                }
              ]
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      when(() => mockDio.get(
            'https://www.googleapis.com/youtube/v3/playlistItems',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: {
              'items': [
                {
                  'snippet': {
                    'resourceId': {
                      'videoId': 'vId_123',
                    }
                  }
                }
              ]
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      when(() => mockDio.get(
            'https://www.googleapis.com/youtube/v3/videos',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: {
              'items': [
                {
                  'id': 'vId_123',
                  'snippet': {
                    'title': 'Test Video Title',
                    'channelTitle': 'Test Channel Name',
                    'description': 'Test Video Description',
                    'publishedAt': '2026-07-09T12:00:00Z',
                    'liveBroadcastContent': 'none',
                    'thumbnails': {
                      'high': {
                        'url': 'https://example.com/thumb.jpg',
                      }
                    }
                  }
                }
              ]
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final items = await repository.fetchYoutubeVideos('mock-channel-id');

      expect(items.length, 1);
      expect(items.first.id, 'youtube-vId_123');
      expect(items.first.title, 'Test Video Title');
      expect(items.first.sourceName, 'Test Channel Name');
      expect(items.first.thumbnailUrl, 'https://example.com/thumb.jpg');
      expect(items.first.isLive, false);
    });

    test('checkYoutubeLive returns media item when a live video is found', () async {
      when(() => mockDio.get(
            'https://www.googleapis.com/youtube/v3/search',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: {
              'items': [
                {
                  'id': {
                    'videoId': 'live_123',
                  },
                  'snippet': {
                    'title': 'Live Stream Service',
                    'channelTitle': 'JUM Live',
                    'description': 'Join our fellowship live',
                    'publishedAt': '2026-07-09T10:00:00Z',
                    'thumbnails': {
                      'high': {
                        'url': 'https://example.com/live_thumb.jpg',
                      }
                    }
                  }
                }
              ]
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final item = await repository.checkYoutubeLive('mock-channel-id');

      expect(item, isNotNull);
      expect(item!.id, 'youtube-live_123');
      expect(item.title, 'Live Stream Service');
      expect(item.isLive, true);
    });
  });
}
