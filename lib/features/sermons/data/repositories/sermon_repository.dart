import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/sermon_model.dart';

part 'sermon_repository.g.dart';

class SermonRepository {
  final SupabaseClient _supabase;
  SermonRepository(this._supabase);

  static Map<String, dynamic> _mapDbToSermon(Map<String, dynamic> row) {
    final map = Map<String, dynamic>.from(row);
    map['speaker'] = map['preacher'] ?? 'Pastor';
    map['media_url'] = map['video_url'] ?? map['audio_url'] ?? '';
    map['duration_seconds'] = map['duration_secs'] ?? 0;
    map['type'] = (map['video_url'] != null && map['video_url'].toString().isNotEmpty) ? 'video' : 'audio';
    map['published_at'] = map['published_at'] ?? map['created_at'] ?? DateTime.now().toIso8601String();
    return map;
  }

  Future<List<SermonModel>> fetchAll() async {
    final res = await _supabase
        .from('sermons')
        .select()
        .order('published_at', ascending: false);

    return (res as List).map((row) {
      final mapped = _mapDbToSermon(Map<String, dynamic>.from(row as Map));
      return SermonModel.fromJson(mapped);
    }).toList();
  }

  Future<SermonModel?> fetchLatestSermon() async {
    try {
      final countCheck = await _supabase.from('sermons').select('id').limit(1);
      if ((countCheck as List).isEmpty) {
        await _seedDefaultSermons();
      }
    } catch (e) {
      print('[SERMON_REPO] Auto-seed check failed or skipped: $e');
    }

    try {
      final res = await _supabase
          .from('sermons')
          .select()
          .order('published_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (res != null) {
        final mapped = _mapDbToSermon(Map<String, dynamic>.from(res as Map));
        return SermonModel.fromJson(mapped);
      }
    } catch (e) {
      print('[SERMON_REPO] Failed to fetch latest sermon: $e');
      return getSeededFallbackSermon();
    }
    return getSeededFallbackSermon();
  }

  Future<void> _seedDefaultSermons() async {
    final now = DateTime.now();
    final sermonsList = [
      {
        'id': 'fac30312-1676-52e3-bfdc-ab60b3f00287',
        'title': 'Reclaiming Your Spiritual Authority',
        'description': 'In this sermon, Pastor Kingsley preaches on the believer\'s authority in Christ, teaching practical steps to overcome doubt and walk in absolute victory in every sphere of life.',
        'preacher': 'Pastor Kingsley Aniche',
        'date_preached': now.subtract(const Duration(days: 10)).toIso8601String(),
        'video_url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        'audio_url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        'thumbnail_url': 'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
        'duration_secs': 2450,
        'created_at': now.subtract(const Duration(days: 10)).toIso8601String(),
        'youtube_video_id': 'dQw4w9WgXcQ',
        'published_at': now.subtract(const Duration(days: 10)).toIso8601String(),
      }
    ];
    await _supabase.from('sermons').insert(sermonsList);
  }

  SermonModel getSeededFallbackSermon() {
    return SermonModel(
      id: 'fac30312-1676-52e3-bfdc-ab60b3f00287',
      title: 'Reclaiming Your Spiritual Authority',
      description: 'In this sermon, Pastor Kingsley preaches on the believer\'s authority in Christ, teaching practical steps to overcome doubt and walk in absolute victory in every sphere of life.',
      speaker: 'Pastor Kingsley Aniche',
      mediaUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnailUrl: 'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
      type: 'video',
      durationSeconds: 2450,
      publishedAt: DateTime.now().subtract(const Duration(days: 10)),
      youtubeVideoId: 'dQw4w9WgXcQ',
    );
  }

  Future<List<SermonModel>> search(String query) async {
    final res = await _supabase
        .from('sermons')
        .select()
        .ilike('title', '%$query%')
        .order('published_at', ascending: false);

    return (res as List).map((row) {
      final mapped = _mapDbToSermon(Map<String, dynamic>.from(row as Map));
      return SermonModel.fromJson(mapped);
    }).toList();
  }

  Stream<SermonModel> watchSermon(String id) {
    return _supabase
        .from('sermons')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((rows) {
          final mapped = _mapDbToSermon(Map<String, dynamic>.from(rows.first));
          return SermonModel.fromJson(mapped);
        });
  }

  Future<void> createSermon(SermonModel sermon) async {
    await _supabase.from('sermons').insert(sermon.toJson());
  }

  Future<void> deleteSermon(String id) async {
    await _supabase.from('sermons').delete().eq('id', id);
  }
}

@riverpod
SermonRepository sermonRepository(SermonRepositoryRef ref) {
  return SermonRepository(
    ref.watch(supabaseClientProvider),
  );
}
