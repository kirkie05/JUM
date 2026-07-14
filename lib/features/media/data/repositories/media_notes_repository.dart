import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:jum/core/services/supabase_service.dart';
import '../models/media_note_model.dart';

part 'media_notes_repository.g.dart';

class MediaNotesRepository {
  final SupabaseClient _supabase;
  MediaNotesRepository(this._supabase);

  /// Fetch user personal notes for a specific video.
  Future<List<MediaNoteModel>> fetchNotes(String videoId) async {
    final res = await _supabase
        .from('media_notes')
        .select()
        .eq('video_id', videoId)
        .order('timestamp_seconds', ascending: true);

    return (res as List).map((row) => MediaNoteModel.fromJson(row as Map<String, dynamic>)).toList();
  }

  /// Create a personal note.
  Future<MediaNoteModel> createNote({
    required String userId,
    required String videoId,
    required int timestampSeconds,
    required String text,
  }) async {
    final res = await _supabase.from('media_notes').insert({
      'user_id': userId,
      'video_id': videoId,
      'timestamp_seconds': timestampSeconds,
      'text': text,
    }).select().single();

    return MediaNoteModel.fromJson(res);
  }

  /// Update an existing personal note.
  Future<MediaNoteModel> updateNote(String noteId, String text) async {
    final res = await _supabase
        .from('media_notes')
        .update({
          'text': text,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', noteId)
        .select()
        .single();

    return MediaNoteModel.fromJson(res);
  }

  /// Delete a personal note.
  Future<void> deleteNote(String noteId) async {
    await _supabase
        .from('media_notes')
        .delete()
        .eq('id', noteId);
  }
}

@riverpod
MediaNotesRepository mediaNotesRepository(MediaNotesRepositoryRef ref) {
  return MediaNotesRepository(ref.watch(supabaseClientProvider));
}
