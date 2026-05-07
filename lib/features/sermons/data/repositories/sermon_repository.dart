import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/sermon_model.dart';

part 'sermon_repository.g.dart';

class SermonRepository {
  final SupabaseClient _supabase;
  SermonRepository(this._supabase);

  Future<List<SermonModel>> fetchAll(String churchId) async {
    final res = await _supabase
        .from('sermons')
        .select()
        .eq('church_id', churchId)
        .order('published_at', ascending: false);

    return (res as List).map((row) => SermonModel.fromJson(row)).toList();
  }

  Future<List<SermonModel>> search(String churchId, String query) async {
    final res = await _supabase
        .from('sermons')
        .select()
        .eq('church_id', churchId)
        .ilike('title', '%$query%')
        .order('published_at', ascending: false);

    return (res as List).map((row) => SermonModel.fromJson(row)).toList();
  }

  Stream<SermonModel> watchSermon(String id) {
    return _supabase
        .from('sermons')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((rows) => SermonModel.fromJson(rows.first));
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
  return SermonRepository(ref.watch(supabaseClientProvider));
}
