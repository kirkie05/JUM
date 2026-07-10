import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/reading_plan_models.dart';

class BibleUserActionsRepository {
  static const String _notesBoxName = 'bible_user_notes';
  static const String _bookmarksBoxName = 'bible_user_bookmarks';

  final SupabaseClient _supabase;
  Box<LocalNote>? _notesBox;
  Box<LocalBookmark>? _bookmarksBox;

  BibleUserActionsRepository(this._supabase) {
    _initHive();
  }

  Future<void> _initHive() async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(LocalNoteAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(LocalBookmarkAdapter());
    }
    _notesBox = await Hive.openBox<LocalNote>(_notesBoxName);
    _bookmarksBox = await Hive.openBox<LocalBookmark>(_bookmarksBoxName);
  }

  Future<Box<LocalNote>> _getNotesBox() async {
    if (_notesBox == null) await _initHive();
    return _notesBox!;
  }

  Future<Box<LocalBookmark>> _getBookmarksBox() async {
    if (_bookmarksBox == null) await _initHive();
    return _bookmarksBox!;
  }

  // --- Notes Actions ---
  Future<List<LocalNote>> getNotesForChapter(String bookId, int chapter) async {
    final box = await _getNotesBox();
    return box.values
        .where((n) => n.bookId == bookId && n.chapter == chapter)
        .toList();
  }

  Future<List<LocalNote>> getAllNotes() async {
    final box = await _getNotesBox();
    return box.values.toList();
  }

  Future<void> addNote({
    required String bookId,
    required int chapter,
    required int verse,
    required String? title,
    required String body,
  }) async {
    final box = await _getNotesBox();
    final String noteId = const Uuid().v4();
    final note = LocalNote(
      id: noteId,
      bookId: bookId,
      chapter: chapter,
      verse: verse,
      title: title,
      body: body,
      updatedAt: DateTime.now(),
    );

    // Save locally
    await box.put(noteId, note);

    // Sync in background
    final user = _supabase.auth.currentUser;
    if (user != null) {
      _syncNoteToCloud(user.id, note);
    }
  }

  Future<void> updateNote(String noteId, String? title, String body) async {
    final box = await _getNotesBox();
    final existing = box.get(noteId);
    if (existing == null) return;

    final updated = LocalNote(
      id: noteId,
      bookId: existing.bookId,
      chapter: existing.chapter,
      verse: existing.verse,
      title: title,
      body: body,
      updatedAt: DateTime.now(),
    );

    await box.put(noteId, updated);

    final user = _supabase.auth.currentUser;
    if (user != null) {
      _syncNoteToCloud(user.id, updated);
    }
  }

  Future<void> deleteNote(String noteId) async {
    final box = await _getNotesBox();
    await box.delete(noteId);

    try {
      await _supabase.from('bible_notes').delete().eq('id', noteId);
    } catch (e) {
      debugPrint('Delete note offline-deferred: $e');
    }
  }

  Future<void> _syncNoteToCloud(String userId, LocalNote note) async {
    try {
      await _supabase.from('bible_notes').upsert({
        'id': note.id,
        'user_id': userId,
        'book_id': note.bookId,
        'chapter': note.chapter,
        'verse': note.verse,
        'title': note.title,
        'body': note.body,
        'updated_at': note.updatedAt.toIso8601String(),
      });
    } catch (e) {
      debugPrint('Sync note offline-deferred: $e');
    }
  }

  // --- Bookmarks / Favorites / Highlights Actions ---
  Future<List<LocalBookmark>> getBookmarksForChapter(String bookId, int chapter) async {
    final box = await _getBookmarksBox();
    return box.values
        .where((b) => b.bookId == bookId && b.chapter == chapter)
        .toList();
  }

  Future<void> addBookmark({
    required String bookId,
    required int chapter,
    required int verse,
    required String type,
    String? color,
  }) async {
    final box = await _getBookmarksBox();
    final id = const Uuid().v4();
    final bookmark = LocalBookmark(
      id: id,
      bookId: bookId,
      chapter: chapter,
      verse: verse,
      type: type,
      color: color,
    );

    await box.put(id, bookmark);

    final user = _supabase.auth.currentUser;
    if (user != null) {
      _syncBookmarkToCloud(user.id, bookmark);
    }
  }

  Future<void> removeBookmark(String bookId, int chapter, int verse, String type) async {
    final box = await _getBookmarksBox();
    final match = box.values.firstWhere(
      (b) => b.bookId == bookId && b.chapter == chapter && b.verse == verse && b.type == type,
      orElse: () => LocalBookmark(id: '', bookId: '', chapter: 0, verse: 0, type: ''),
    );

    if (match.id.isEmpty) return;

    await box.delete(match.id);

    try {
      await _supabase.from('bible_bookmarks').delete().eq('id', match.id);
    } catch (e) {
      debugPrint('Remove bookmark offline-deferred: $e');
    }
  }

  Future<void> _syncBookmarkToCloud(String userId, LocalBookmark bm) async {
    try {
      await _supabase.from('bible_bookmarks').upsert({
        'id': bm.id,
        'user_id': userId,
        'book_id': bm.bookId,
        'chapter': bm.chapter,
        'verse': bm.verse,
        'type': bm.type,
        'color': bm.color,
      });
    } catch (e) {
      debugPrint('Sync bookmark offline-deferred: $e');
    }
  }

  // --- Cloud Sync For All User Actions ---
  Future<void> syncWithCloud() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // 1. Sync Notes
      final dbNotesRes = await _supabase.from('bible_notes').select().eq('user_id', user.id);
      final notesBox = await _getNotesBox();
      if (dbNotesRes != null) {
        final List<dynamic> dbList = dbNotesRes as List;
        final Set<String> dbNoteIds = {};

        for (var item in dbList) {
          final String id = item['id'] as String;
          dbNoteIds.add(id);

          final note = LocalNote(
            id: id,
            bookId: item['book_id'] as String,
            chapter: item['chapter'] as int,
            verse: item['verse'] as int,
            title: item['title'] as String?,
            body: item['body'] as String,
            updatedAt: DateTime.parse(item['updated_at'] as String),
          );
          await notesBox.put(id, note);
        }

        // Push local notes not in cloud
        for (var localNote in notesBox.values.toList()) {
          if (!dbNoteIds.contains(localNote.id)) {
            await _syncNoteToCloud(user.id, localNote);
          }
        }
      }

      // 2. Sync Bookmarks
      final dbBookmarksRes = await _supabase.from('bible_bookmarks').select().eq('user_id', user.id);
      final bookmarksBox = await _getBookmarksBox();
      if (dbBookmarksRes != null) {
        final List<dynamic> dbList = dbBookmarksRes as List;
        final Set<String> dbBookmarkIds = {};

        for (var item in dbList) {
          final String id = item['id'] as String;
          dbBookmarkIds.add(id);

          final bm = LocalBookmark(
            id: id,
            bookId: item['book_id'] as String,
            chapter: item['chapter'] as int,
            verse: item['verse'] as int,
            type: item['type'] as String,
            color: item['color'] as String?,
          );
          await bookmarksBox.put(id, bm);
        }

        // Push local bookmarks not in cloud
        for (var localBm in bookmarksBox.values.toList()) {
          if (!dbBookmarkIds.contains(localBm.id)) {
            await _syncBookmarkToCloud(user.id, localBm);
          }
        }
      }
    } catch (e) {
      debugPrint('Error syncing bible user actions with cloud: $e');
    }
  }
}
