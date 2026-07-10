import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class GlobalSeedService {
  final SupabaseClient _supabase;
  GlobalSeedService(this._supabase);

  Future<void> seedIfEmpty() async {
    // ONLY run in debug mode. NEVER in production.
    if (!kDebugMode) return;

    try {
      debugPrint('[SEED_SERVICE] Checking database for empty tables...');

      await _seedCommunityPosts();
      await _seedMarketplaceItems();
      await _seedEvents();
      await _seedSermons();
      await _seedGospelArmyCourses();

      debugPrint('[SEED_SERVICE] Seeding checks completed.');
    } catch (e) {
      debugPrint('[SEED_SERVICE] Error during seeding: $e');
    }
  }

  Future<void> _seedCommunityPosts() async {
    final countRes = await _supabase.from('posts').select('id').limit(1);
    if ((countRes as List).isEmpty) {
      debugPrint('[SEED_SERVICE] Seeding Community Posts...');
      final uuid = const Uuid();
      final List<Map<String, dynamic>> posts = List.generate(10, (index) {
        return {
          'id': uuid.v4(),
          'user_id': '00000000-0000-0000-0000-000000000000', // Mock system user
          'body': 'This is community post number $index. Praise God! #blessed #sunday',
          'media_url': index % 3 == 0 ? 'https://picsum.photos/seed/post$index/600/400' : null,
          'created_at': DateTime.now().subtract(Duration(days: index)).toIso8601String(),
        };
      });
      await _supabase.from('posts').insert(posts);
    }
  }

  Future<void> _seedMarketplaceItems() async {
    final countRes = await _supabase.from('products').select('id').limit(1);
    if ((countRes as List).isEmpty) {
      debugPrint('[SEED_SERVICE] Seeding Marketplace Items...');
      final uuid = const Uuid();
      final List<Map<String, dynamic>> products = List.generate(5, (index) {
        return {
          'id': uuid.v4(),
          'name': 'JUM Product $index',
          'description': 'This is a description for product $index. High quality material.',
          'price': (index + 1) * 10.0,
          'image_url': 'https://picsum.photos/seed/product$index/400/400',
          'category': index % 2 == 0 ? 'Apparel' : 'Books',
          'stock_quantity': 100,
          'created_at': DateTime.now().toIso8601String(),
        };
      });
      await _supabase.from('products').insert(products);
    }
  }

  Future<void> _seedEvents() async {
    final countRes = await _supabase.from('events').select('id').limit(1);
    if ((countRes as List).isEmpty) {
      debugPrint('[SEED_SERVICE] Seeding Events...');
      final uuid = const Uuid();
      final List<Map<String, dynamic>> events = List.generate(3, (index) {
        final date = DateTime.now().add(Duration(days: index * 7 + 2));
        return {
          'id': uuid.v4(),
          'title': 'Church Service $index',
          'description': 'Join us for a wonderful time of worship and the word.',
          'date': date.toIso8601String(),
          'location': 'Main Sanctuary',
          'image_url': 'https://picsum.photos/seed/event$index/600/300',
          'created_at': DateTime.now().toIso8601String(),
        };
      });
      await _supabase.from('events').insert(events);
    }
  }

  Future<void> _seedSermons() async {
    final countRes = await _supabase.from('sermons').select('id').limit(1);
    if ((countRes as List).isEmpty) {
      debugPrint('[SEED_SERVICE] Seeding Sermons...');
      final uuid = const Uuid();
      final List<Map<String, dynamic>> sermons = List.generate(10, (index) {
        return {
          'id': uuid.v4(),
          'title': 'Sermon Message $index',
          'speaker': index % 2 == 0 ? 'Pastor Kingsley' : 'Guest Minister',
          'date': DateTime.now().subtract(Duration(days: index * 7)).toIso8601String(),
          'video_url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
          'thumbnail_url': 'https://picsum.photos/seed/sermon$index/600/400',
          'description': 'An uplifting message about faith and perseverance.',
          'created_at': DateTime.now().toIso8601String(),
        };
      });
      await _supabase.from('sermons').insert(sermons);
    }
  }

  Future<void> _seedGospelArmyCourses() async {
    final countRes = await _supabase.from('courses').select('id').limit(1);
    if ((countRes as List).isEmpty) {
      debugPrint('[SEED_SERVICE] Seeding Gospel Army Courses...');
      final uuid = const Uuid();
      final List<Map<String, dynamic>> courses = List.generate(5, (index) {
        return {
          'id': uuid.v4(),
          'title': 'Gospel Army Course $index',
          'description': 'Learn the fundamentals of faith in this comprehensive course.',
          'thumbnail_url': 'https://picsum.photos/seed/course$index/600/400',
          'is_published': true,
          'created_at': DateTime.now().toIso8601String(),
        };
      });
      await _supabase.from('courses').insert(courses);
    }
  }
}
