import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/bible_models.dart';

class BibleRepository {
  // CDN Base for free open-source scripture hosting
  static const String baseUrl = 'https://cdn.jsdelivr.net/gh/wldeh/bible-api/bibles';
  static const String defaultTranslation = 'BSB';

  late final Dio _dio;

  BibleRepository({Dio? dio}) {
    _dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl));
  }

  // Cache to avoid redundant network reads
  final Map<String, List<BibleBook>> _booksCache = {};
  final Map<String, BibleChapter> _chapterCache = {};

  // Normalizer maps user friendly selectors to precise repository dataset identifiers
  String _normalizeTranslation(String input) {
    switch (input.toUpperCase()) {
      case 'BSB':
        return 'en-bsb';
      case 'KJV':
        return 'en-kjv';
      case 'ASV':
        return 'en-asv';
      case 'WEB':
        return 'en-web';
      case 'FBV':
        return 'en-fbv';
      case 'RV':
        return 'en-rv';
      // Standard fallbacks for non-public datasets
      default:
        return 'en-bsb'; 
    }
  }

  // Canonical Book Index: Instantly yields data for ALL translations without ping delays.
  static final List<Map<String, dynamic>> _canonicalBooks = [
    {"id": "GEN", "name": "Genesis", "slug": "genesis"},
    {"id": "EXO", "name": "Exodus", "slug": "exodus"},
    {"id": "LEV", "name": "Leviticus", "slug": "leviticus"},
    {"id": "NUM", "name": "Numbers", "slug": "numbers"},
    {"id": "DEU", "name": "Deuteronomy", "slug": "deuteronomy"},
    {"id": "JOS", "name": "Joshua", "slug": "joshua"},
    {"id": "JDG", "name": "Judges", "slug": "judges"},
    {"id": "RUT", "name": "Ruth", "slug": "ruth"},
    {"id": "1SA", "name": "1 Samuel", "slug": "1samuel"},
    {"id": "2SA", "name": "2 Samuel", "slug": "2samuel"},
    {"id": "1KI", "name": "1 Kings", "slug": "1kings"},
    {"id": "2KI", "name": "2 Kings", "slug": "2kings"},
    {"id": "1CH", "name": "1 Chronicles", "slug": "1chronicles"},
    {"id": "2CH", "name": "2 Chronicles", "slug": "2chronicles"},
    {"id": "EZR", "name": "Ezra", "slug": "ezra"},
    {"id": "NEH", "name": "Nehemiah", "slug": "nehemiah"},
    {"id": "EST", "name": "Esther", "slug": "esther"},
    {"id": "JOB", "name": "Job", "slug": "job"},
    {"id": "PSA", "name": "Psalms", "slug": "psalms"},
    {"id": "PRO", "name": "Proverbs", "slug": "proverbs"},
    {"id": "ECC", "name": "Ecclesiastes", "slug": "ecclesiastes"},
    {"id": "SNG", "name": "Song of Solomon", "slug": "songofsolomon"},
    {"id": "ISA", "name": "Isaiah", "slug": "isaiah"},
    {"id": "JER", "name": "Jeremiah", "slug": "jeremiah"},
    {"id": "LAM", "name": "Lamentations", "slug": "lamentations"},
    {"id": "EZK", "name": "Ezekiel", "slug": "ezekiel"},
    {"id": "DAN", "name": "Daniel", "slug": "daniel"},
    {"id": "HOS", "name": "Hosea", "slug": "hosea"},
    {"id": "JOL", "name": "Joel", "slug": "joel"},
    {"id": "AMO", "name": "Amos", "slug": "amos"},
    {"id": "OBA", "name": "Obadiah", "slug": "obadiah"},
    {"id": "JON", "name": "Jonah", "slug": "jonah"},
    {"id": "MIC", "name": "Micah", "slug": "micah"},
    {"id": "NAM", "name": "Nahum", "slug": "nahum"},
    {"id": "HAB", "name": "Habakkuk", "slug": "habakkuk"},
    {"id": "ZEP", "name": "Zephaniah", "slug": "zephaniah"},
    {"id": "HAG", "name": "Haggai", "slug": "haggai"},
    {"id": "ZEC", "name": "Zechariah", "slug": "zechariah"},
    {"id": "MAL", "name": "Malachi", "slug": "malachi"},
    {"id": "MAT", "name": "Matthew", "slug": "matthew"},
    {"id": "MRK", "name": "Mark", "slug": "mark"},
    {"id": "LUK", "name": "Luke", "slug": "luke"},
    {"id": "JHN", "name": "John", "slug": "john"},
    {"id": "ACT", "name": "Acts", "slug": "acts"},
    {"id": "ROM", "name": "Romans", "slug": "romans"},
    {"id": "1CO", "name": "1 Corinthians", "slug": "1corinthians"},
    {"id": "2CO", "name": "2 Corinthians", "slug": "2corinthians"},
    {"id": "GAL", "name": "Galatians", "slug": "galatians"},
    {"id": "EPH", "name": "Ephesians", "slug": "ephesians"},
    {"id": "PHP", "name": "Philippians", "slug": "philippians"},
    {"id": "COL", "name": "Colossians", "slug": "colossians"},
    {"id": "1TH", "name": "1 Thessalonians", "slug": "1thessalonians"},
    {"id": "2TH", "name": "2 Thessalonians", "slug": "2thessalonians"},
    {"id": "1TI", "name": "1 Timothy", "slug": "1timothy"},
    {"id": "2TI", "name": "2 Timothy", "slug": "2timothy"},
    {"id": "TIT", "name": "Titus", "slug": "titus"},
    {"id": "PHM", "name": "Philemon", "slug": "philemon"},
    {"id": "HEB", "name": "Hebrews", "slug": "hebrews"},
    {"id": "JAS", "name": "James", "slug": "james"},
    {"id": "1PE", "name": "1 Peter", "slug": "1peter"},
    {"id": "2PE", "name": "2 Peter", "slug": "2peter"},
    {"id": "1JN", "name": "1 John", "slug": "1john"},
    {"id": "2JN", "name": "2 John", "slug": "2john"},
    {"id": "3JN", "name": "3 John", "slug": "3john"},
    {"id": "JUD", "name": "Jude", "slug": "jude"},
    {"id": "REV", "name": "Revelation", "slug": "revelation"},
  ];

  Future<List<BibleBook>> getBooks({String translation = defaultTranslation}) async {
    final vId = _normalizeTranslation(translation);
    
    if (_booksCache.containsKey(vId)) {
      return _booksCache[vId]!;
    }

    // We generate it on the fly from static schema to prevent massive boot times
    final List<BibleBook> books = [];
    for (int i = 0; i < _canonicalBooks.length; i++) {
      final map = _canonicalBooks[i];
      books.add(BibleBook(
        id: map['id']!, // Keep Standard Uppercase IDs internally
        name: map['name']!,
        commonName: map['name']!,
        title: map['name']!,
        numberOfChapters: BibleBook.canonicalChapterCounts[map['id']!] ?? 1,
        order: i + 1,
      ));
    }
    
    _booksCache[vId] = books;
    return books;
  }

  Future<BibleChapter> getChapter(
    String bookId,
    int chapterNumber, {
    String translation = defaultTranslation,
  }) async {
    final vId = _normalizeTranslation(translation);
    
    // Fetch proper URL slug from canonical map
    final bookEntry = _canonicalBooks.firstWhere(
      (b) => b['id'] == bookId.toUpperCase(), 
      orElse: () => {"slug": bookId.toLowerCase().replaceAll(' ', '')}
    );
    final String bookSlug = bookEntry['slug']!;
    
    final cacheKey = '${vId}_${bookSlug}_$chapterNumber';
    if (_chapterCache.containsKey(cacheKey)) {
      return _chapterCache[cacheKey]!;
    }

    try {
      final url = '$baseUrl/$vId/books/$bookSlug/chapters/$chapterNumber.json';
      final response = await _dio.get(url);
      
      final jsonMap = response.data is String 
          ? jsonDecode(response.data) 
          : (response.data as Map<String, dynamic>);
      
      final chapter = BibleChapter.fromJsonWldeh(chapterNumber, jsonMap);
      _chapterCache[cacheKey] = chapter;
      return chapter;
    } catch (e) {
      debugPrint('BibleRepository getChapter Error fetching $vId -> $bookSlug -> $chapterNumber: $e');
      rethrow;
    }
  }
}
