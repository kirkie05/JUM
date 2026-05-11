import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bible_models.dart';
import '../repositories/bible_repository.dart';

final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  return BibleRepository();
});

final bibleTranslationProvider = StateProvider<String>((ref) => 'BSB');

final bibleBooksProvider = FutureProvider<List<BibleBook>>((ref) async {
  final repo = ref.watch(bibleRepositoryProvider);
  final trans = ref.watch(bibleTranslationProvider);
  return repo.getBooks(translation: trans);
});

// Holds currently selected state
final currentBookProvider = StateProvider<String>((ref) => 'GEN');
final currentChapterNumberProvider = StateProvider<int>((ref) => 1);

final bibleChapterProvider = FutureProvider<BibleChapter>((ref) async {
  final repo = ref.watch(bibleRepositoryProvider);
  final bookId = ref.watch(currentBookProvider);
  final chapterNumber = ref.watch(currentChapterNumberProvider);
  final trans = ref.watch(bibleTranslationProvider);

  return repo.getChapter(bookId, chapterNumber, translation: trans);
});

// Highlighting & Selections Local State
final selectedVerseProvider = StateProvider<int?>((ref) => null);

// --- New Expanded State For Typography, Themes & Persistent Highlights ---

final bibleFontSizeProvider = StateProvider<double>((ref) => 18.0);
final bibleFontFamilyProvider = StateProvider<String>((ref) => 'Serif');
enum ReadingTheme { light, sepia, dark }
final bibleReadingThemeProvider = StateProvider<ReadingTheme>((ref) => ReadingTheme.light);

// Persistent Highlight State Management
class BibleHighlightsNotifier extends StateNotifier<Map<String, int>> {
  static const String _prefKey = 'bible_highlights';
  
  BibleHighlightsNotifier() : super({}) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefKey);
      if (jsonStr != null) {
        final Map<String, dynamic> rawMap = jsonDecode(jsonStr);
        // Cast keys to string and values to color int code
        final Map<String, int> parsed = {};
        rawMap.forEach((key, value) {
          parsed[key] = value as int;
        });
        state = parsed;
      }
    } catch (e) {
      debugPrint('Error loading highlights: $e');
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, jsonEncode(state));
    } catch (e) {
      debugPrint('Error saving highlights: $e');
    }
  }

  void setHighlight(String bookId, int chapter, int verse, Color? color) {
    final key = '${bookId.toUpperCase()}.$chapter.$verse';
    final nextState = Map<String, int>.from(state);
    if (color == null) {
      nextState.remove(key);
    } else {
      nextState[key] = color.value;
    }
    state = nextState;
    _save();
  }

  Color? getHighlightFor(String bookId, int chapter, int verse) {
    final key = '${bookId.toUpperCase()}.$chapter.$verse';
    final val = state[key];
    if (val == null) return null;
    return Color(val);
  }
}

final bibleHighlightsProvider = StateNotifierProvider<BibleHighlightsNotifier, Map<String, int>>((ref) {
  return BibleHighlightsNotifier();
});
