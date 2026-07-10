import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/media_note_model.dart';
import '../repositories/media_notes_repository.dart';

part 'media_notes_provider.g.dart';

@riverpod
class MediaNotes extends _$MediaNotes {
  @override
  FutureOr<List<MediaNoteModel>> build(String videoId) async {
    return ref.watch(mediaNotesRepositoryProvider).fetchNotes(videoId);
  }

  Future<void> addNote({
    required String userId,
    required String videoId,
    required int timestampSeconds,
    required String text,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(mediaNotesRepositoryProvider).createNote(
        userId: userId,
        videoId: videoId,
        timestampSeconds: timestampSeconds,
        text: text,
      );
      return ref.read(mediaNotesRepositoryProvider).fetchNotes(videoId);
    });
  }

  Future<void> deleteNote(String noteId) async {
    final videoId = this.videoId;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(mediaNotesRepositoryProvider).deleteNote(noteId);
      return ref.read(mediaNotesRepositoryProvider).fetchNotes(videoId);
    });
  }

  Future<void> editNote(String noteId, String text) async {
    final videoId = this.videoId;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(mediaNotesRepositoryProvider).updateNote(noteId, text);
      return ref.read(mediaNotesRepositoryProvider).fetchNotes(videoId);
    });
  }
}
