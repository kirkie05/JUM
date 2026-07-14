import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jum/features/media/data/models/media_item.dart';
import 'package:jum/features/media/data/repositories/media_repository.dart';
import 'package:jum/features/media/data/services/youtube_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockYoutubeService extends Mock implements YoutubeService {}
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

class FakePostgrestTransformBuilder extends Fake implements PostgrestTransformBuilder<List<Map<String, dynamic>>> {
  final List<Map<String, dynamic>> data;
  FakePostgrestTransformBuilder(this.data);

  @override
  Future<U> then<U>(
    FutureOr<U> Function(List<Map<String, dynamic>>) onValue, {
    Function? onError,
  }) {
    return Future.value(onValue(data));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockYoutubeService mockYoutubeService;
  late MockSupabaseClient mockSupabaseClient;
  late MediaRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockYoutubeService = MockYoutubeService();
    mockSupabaseClient = MockSupabaseClient();
    repository = MediaRepository(mockYoutubeService, mockSupabaseClient);
  });

  group('MediaRepository tests', () {
    test('fetchMedia parses items correctly from Supabase client', () async {
      final mockQueryBuilder = MockSupabaseQueryBuilder();
      final mockFilterBuilder = MockPostgrestFilterBuilder();
      final fakeTransform = FakePostgrestTransformBuilder([
        {
          'id': 'youtube-123',
          'title': 'Test Video',
          'description': 'Test Description',
          'thumbnail_url': 'https://example.com/thumb.jpg',
          'duration': '10:00',
          'published_at': '2026-07-14T12:00:00Z',
          'view_count': 100,
          'source_name': 'JUM',
          'source_url': 'https://youtube.com/watch?v=123',
          'is_live': false,
        }
      ]);
      
      when(() => mockSupabaseClient.from('youtube_videos')).thenAnswer((_) => mockQueryBuilder);
      when(() => mockQueryBuilder.select(any())).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.order(any(), ascending: any(named: 'ascending'))).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.range(any(), any())).thenAnswer((_) => fakeTransform);

      final items = await repository.fetchMedia(limit: 1, offset: 0);

      expect(items.length, 1);
      expect(items.first.id, 'youtube-123');
      expect(items.first.title, 'Test Video');
      expect(items.first.thumbnailUrl, 'https://example.com/thumb.jpg');
      expect(items.first.duration, '10:00');
    });
  });
}
