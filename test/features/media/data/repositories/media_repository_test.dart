import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jum/features/media/data/models/media_item.dart';
import 'package:jum/features/media/data/repositories/media_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late MediaRepository repository;

  setUp(() {
    mockDio = MockDio();
    repository = MediaRepository(mockDio);
    SharedPreferences.setMockInitialValues({});
  });

  group('MediaRepository', () {
    test('loadChannelConfig returns default config when no values saved', () async {
      final config = await repository.loadChannelConfig();
      expect(config.youtubeUrl, MediaChannelConfig.defaults.youtubeUrl);
      expect(config.mixlrUrl, MediaChannelConfig.defaults.mixlrUrl);
    });

    test('saveChannelConfig stores values and loadChannelConfig retrieves them', () async {
      const testConfig = MediaChannelConfig(
        youtubeUrl: 'https://youtube.com/c/custom',
        mixlrUrl: 'https://mixlr.com/custom',
      );

      await repository.saveChannelConfig(testConfig);
      final config = await repository.loadChannelConfig();

      expect(config.youtubeUrl, testConfig.youtubeUrl);
      expect(config.mixlrUrl, testConfig.mixlrUrl);
    });

    test('fetchYoutubeVideos parses XML correctly', () async {
      const channelUrl = 'https://www.youtube.com/channel/UCtest12345678901234567890';
      const channelId = 'UCtest12345678901234567890';

      // Mock response for resolveYoutubeChannelId if needed.
      // Actually, since channelUrl has UC[...], it skips HTTP request.
      
      const xmlContent = '''
<feed>
  <title>Jesus Unhindered Ministry</title>
  <entry>
    <yt:videoId>ABC123456</yt:videoId>
    <title>Sample Video</title>
    <published>2024-01-01T12:00:00+00:00</published>
    <media:thumbnail url="https://thumb.jpg"/>
    <media:description>A test description</media:description>
    <media:statistics views="1500"/>
  </entry>
</feed>
''';

      when(() => mockDio.get<String>('https://www.youtube.com/feeds/videos.xml?channel_id=$channelId'))
          .thenAnswer((_) async => Response(
                data: xmlContent,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final videos = await repository.fetchYoutubeVideos(channelUrl);

      expect(videos.length, 1);
      expect(videos.first.id, 'youtube-ABC123456');
      expect(videos.first.title, 'Sample Video');
      expect(videos.first.sourceName, 'Jesus Unhindered Ministry');
      expect(videos.first.thumbnailUrl, 'https://thumb.jpg');
      expect(videos.first.viewCount, 1500);
    });

    test('fetchMixlrAudio parses JSON data correctly', () async {
      const mixlrUrl = 'https://test.mixlr.com/';
      const viewJson = {
        'live': true,
        'channel_id': 12345,
        'channel_name': 'Test Channel Live',
        'profile_image_url': 'https://mixlr.com/logo.jpg',
        'about_me': 'About this channel'
      };

      const recordingsJson = {
        'data': [
          {
            'id': '999',
            'type': 'recording',
            'attributes': {
              'title': 'Old Broadcast',
              'starts_at': '2024-02-01T10:00:00Z',
              'media': {
                'artwork': {
                  'image': {'medium': 'https://mixlr.com/thumb.jpg'}
                }
              }
            },
            'relationships': {
              'audio': {
                'data': {'id': 'a1', 'type': 'audio'}
              }
            }
          }
        ],
        'included': [
          {
            'id': 'a1',
            'type': 'audio',
            'attributes': {
              'url': 'https://mixlr-cdn.com/stream.mp3'
            }
          }
        ]
      };

      when(() => mockDio.get<Map<String, dynamic>>(
              'https://apicdn.mixlr.com/v3/channel_view/test'))
          .thenAnswer((_) async => Response(
                data: viewJson,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      when(() => mockDio.get<Map<String, dynamic>>(
              'https://apicdn.mixlr.com/v3/channels/test/recordings?page[size]=20'))
          .thenAnswer((_) async => Response(
                data: recordingsJson,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final audioItems = await repository.fetchMixlrAudio(mixlrUrl);

      // Expect live item + 1 recording item = 2 total
      expect(audioItems.length, 2);

      final liveItem =
          audioItems.firstWhere((element) => element.id == 'mixlr-test-live');
      expect(liveItem.isLive, true);
      expect(liveItem.sourceUrl, 'https://edge.mixlr.com/channel/12345');

      final recordingItem =
          audioItems.firstWhere((element) => element.id == 'mixlr-rec-999');
      expect(recordingItem.title, 'Old Broadcast');
      expect(recordingItem.sourceUrl, 'https://mixlr-cdn.com/stream.mp3');
    });
  });
}
