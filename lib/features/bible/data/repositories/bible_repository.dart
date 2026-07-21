import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import '../models/bible_models.dart';

class BibleRepository {
  // CDN Base for free open-source scripture hosting
  static const String baseUrl = 'https://cdn.jsdelivr.net/gh/wldeh/bible-api/bibles';
  static const String defaultTranslation = 'BSB';
  static const String _boxName = 'bolls_bible_cache';

  late final Dio _dio;
  Box<String>? _cacheBox;

  BibleRepository({Dio? dio}) {
    _dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl));
    _initCache();
  }

  Future<void> _initCache() async {
    _cacheBox = await Hive.openBox<String>(_boxName);
  }

  // Memory Cache to avoid redundant parsing
  final Map<String, List<BibleBook>> _booksCache = {};
  final Map<String, BibleChapter> _chapterMemoryCache = {};

  // Normalizer maps user friendly selectors to precise repository dataset identifiers
  String _normalizeTranslation(String input) {
    return input.toUpperCase();
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
    
    // 1. Check in-memory cache
    if (_chapterMemoryCache.containsKey(cacheKey)) {
      return _chapterMemoryCache[cacheKey]!;
    }

    // Wait for Hive to be ready
    if (_cacheBox == null) {
      await _initCache();
    }

    // 2. Check local persistence (Offline First capability)
    final cachedJsonStr = _cacheBox!.get(cacheKey);
    if (cachedJsonStr != null) {
      try {
        final dynamic decoded = jsonDecode(cachedJsonStr);
        BibleChapter chapter;
        if (decoded is List) {
          chapter = BibleChapter.fromJsonBolls(chapterNumber, decoded);
        } else {
          chapter = BibleChapter.fromJsonWldeh(chapterNumber, decoded as Map<String, dynamic>);
        }
        _chapterMemoryCache[cacheKey] = chapter;
        return chapter;
      } catch (_) {
        // Fallback to fetch if local cache is corrupted
      }
    }

    // 3. Fetch from Network
    try {
      final int bookIndex = _canonicalBooks.indexWhere((b) => b['id'] == bookId.toUpperCase()) + 1;
      final actualBookIndex = bookIndex > 0 ? bookIndex : 1;
      
      final url = 'https://bolls.life/get-chapter/$vId/$actualBookIndex/$chapterNumber/';
      
      // Use a new Dio without the base config since we are calling an external API
      final fetchDio = Dio();
      final response = await fetchDio.get(url);
      
      final List<dynamic> jsonList = response.data is String 
          ? jsonDecode(response.data) 
          : (response.data as List<dynamic>);
      
      // Save raw JSON to local cache for offline reading later
      _cacheBox!.put(cacheKey, jsonEncode(jsonList));

      print('DEBUG: jsonList length = ${jsonList.length}');
      final chapter = BibleChapter.fromJsonBolls(chapterNumber, jsonList);
      print('DEBUG: chapter content length = ${chapter.content.length}');
      _chapterMemoryCache[cacheKey] = chapter;
      return chapter;
    } catch (e) {
      debugPrint('BibleRepository getChapter Error fetching $vId -> $bookSlug -> $chapterNumber: $e');

      // PREVENT CRASHES BY RETURNING AN EXPLANATORY OFFLINE PREVIEW
      return BibleChapter(
        number: chapterNumber,
        content: [
          ChapterNode(type: ChapterNodeType.heading, content: ['Offline Mode']),
          ChapterNode(
            type: ChapterNodeType.verse,
            verseNumber: 1,
            content: [
              'This module is currently running in Offline Mode or the content for "${bookId} ${chapterNumber}" (${translation}) is not available in the local cache. Please connect to the internet to download it.'
            ],
          ),
        ],
      );
    }
  }

  Future<List<Map<String, dynamic>>> searchVerses(String query, {String translation = defaultTranslation}) async {
    if (query.trim().isEmpty) return [];
    
    final langSlug = translation.toUpperCase() == 'BSB' ? 'KJV' : translation.toUpperCase(); // Bolls has KJV, use it as standard fallback for others
    final url = 'https://bolls.life/v2/find/$langSlug?search=${Uri.encodeComponent(query)}';
    
    try {
      // Use isolated Dio instance for external host
      final searchDio = Dio(); 
      final response = await searchDio.get(url);
      final data = response.data;
      
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        final results = data['results'] as List<dynamic>;
        
        return results.map((item) {
          final rawText = item['text'].toString();
          // Clean up HTML/XML tags like <S>xxxx</S> and <mark>
          final cleanText = rawText
              .replaceAll(RegExp(r'<S>\d+</S>'), '')
              .replaceAll('<mark>', '')
              .replaceAll('</mark>', '')
              .replaceAll(RegExp(r'<[^>]*>'), '') // generic cleanup
              .trim();
              
          final bookNum = item['book'] as int;
          final canonicalBook = (bookNum > 0 && bookNum <= _canonicalBooks.length) 
              ? _canonicalBooks[bookNum - 1]['name'] 
              : 'Book $bookNum';
              
          return {
            'bookName': canonicalBook,
            'chapter': item['chapter'],
            'verse': item['verse'],
            'text': cleanText,
          };
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('BibleRepository Search Error: $e');
      return []; // Fallback gracefully to empty list
    }
  }
}
