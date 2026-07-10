class BookReadingRange {
  final String bookId;
  final String bookName;
  final int startChapter;
  final int endChapter;

  BookReadingRange({
    required this.bookId,
    required this.bookName,
    required this.startChapter,
    required this.endChapter,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookName': bookName,
      'startChapter': startChapter,
      'endChapter': endChapter,
    };
  }

  factory BookReadingRange.fromJson(Map<String, dynamic> json) {
    return BookReadingRange(
      bookId: json['bookId'] as String? ?? '',
      bookName: json['bookName'] as String? ?? '',
      startChapter: json['startChapter'] as int? ?? 1,
      endChapter: json['endChapter'] as int? ?? 1,
    );
  }
}

class DayReadingPlan {
  final int dayNumber;
  final String title;
  final List<BookReadingRange> ranges;
  final int estimatedReadingTimeMinutes;

  DayReadingPlan({
    required this.dayNumber,
    required this.title,
    required this.ranges,
    required this.estimatedReadingTimeMinutes,
  });
}

class BibleReadingPlanEngine {
  static final List<String> bookOrder = [
    'GEN', 'EXO', 'LEV', 'NUM', 'DEU', 'JOS', 'JDG', 'RUT', '1SA', '2SA',
    '1KI', '2KI', '1CH', '2CH', 'EZR', 'NEH', 'EST', 'JOB', 'PSA', 'PRO',
    'ECC', 'SNG', 'ISA', 'JER', 'LAM', 'EZK', 'DAN', 'HOS', 'JOL', 'AMO',
    'OBA', 'JON', 'MIC', 'NAM', 'HAB', 'ZEP', 'HAG', 'ZEC', 'MAL',
    'MAT', 'MRK', 'LUK', 'JHN', 'ACT', 'ROM', '1CO', '2CO', 'GAL', 'EPH',
    'PHP', 'COL', '1TH', '2TH', '1TI', '2TI', 'TIT', 'PHM', 'HEB', 'JAS',
    '1PE', '2PE', '1JN', '2JN', '3JN', 'JUD', 'REV'
  ];

  static final Map<String, String> bookNames = {
    'GEN': 'Genesis', 'EXO': 'Exodus', 'LEV': 'Leviticus', 'NUM': 'Numbers', 'DEU': 'Deuteronomy',
    'JOS': 'Joshua', 'JDG': 'Judges', 'RUT': 'Ruth', '1SA': '1 Samuel', '2SA': '2 Samuel',
    '1KI': '1 Kings', '2KI': '2 Kings', '1CH': '1 Chronicles', '2CH': '2 Chronicles',
    'EZR': 'Ezra', 'NEH': 'Nehemiah', 'EST': 'Esther', 'JOB': 'Job', 'PSA': 'Psalms',
    'PRO': 'Proverbs', 'ECC': 'Ecclesiastes', 'SNG': 'Song of Solomon', 'ISA': 'Isaiah',
    'JER': 'Jeremiah', 'LAM': 'Lamentations', 'EZK': 'Ezekiel', 'DAN': 'Daniel',
    'HOS': 'Hosea', 'JOL': 'Joel', 'AMO': 'Amos', 'OBA': 'Obadiah', 'JON': 'Jonah',
    'MIC': 'Micah', 'NAM': 'Nahum', 'HAB': 'Habakkuk', 'ZEP': 'Zephaniah', 'HAG': 'Haggai',
    'ZEC': 'Zechariah', 'MAL': 'Malachi',
    'MAT': 'Matthew', 'MRK': 'Mark', 'LUK': 'Luke', 'JHN': 'John', 'ACT': 'Acts',
    'ROM': 'Romans', '1CO': '1 Corinthians', '2CO': '2 Corinthians', 'GAL': 'Galatians',
    'EPH': 'Ephesians', 'PHP': 'Philippians', 'COL': 'Colossians', '1TH': '1 Thessalonians',
    '2TH': '2 Thessalonians', '1TI': '1 Timothy', '2TI': '2 Timothy', 'TIT': 'Titus',
    'PHM': 'Philemon', 'HEB': 'Hebrews', 'JAS': 'James', '1PE': '1 Peter', '2PE': '2 Peter',
    '1JN': '1 John', '2JN': '2 John', '3JN': '3 John', 'JUD': 'Jude', 'REV': 'Revelation'
  };

  static final Map<String, int> chapterCounts = {
    'GEN': 50, 'EXO': 40, 'LEV': 27, 'NUM': 36, 'DEU': 34, 'JOS': 24, 'JDG': 21, 'RUT': 4, '1SA': 31, '2SA': 24,
    '1KI': 22, '2KI': 25, '1CH': 29, '2CH': 36, 'EZR': 10, 'NEH': 13, 'EST': 10, 'JOB': 42, 'PSA': 150, 'PRO': 31,
    'ECC': 12, 'SNG': 8, 'ISA': 66, 'JER': 52, 'LAM': 5, 'EZK': 48, 'DAN': 12, 'HOS': 14, 'JOL': 3, 'AMO': 9,
    'OBA': 1, 'JON': 4, 'MIC': 7, 'NAM': 3, 'HAB': 3, 'ZEP': 3, 'HAG': 2, 'ZEC': 14, 'MAL': 4,
    'MAT': 28, 'MRK': 16, 'LUK': 24, 'JHN': 21, 'ACT': 28, 'ROM': 16, '1CO': 16, '2CO': 13, 'GAL': 6, 'EPH': 6,
    'PHP': 4, 'COL': 4, '1TH': 5, '2TH': 3, '1TI': 6, '2TI': 4, 'TIT': 3, 'PHM': 1, 'HEB': 13, 'JAS': 5,
    '1PE': 5, '2PE': 3, '1JN': 5, '2JN': 1, '3JN': 1, 'JUD': 1, 'REV': 22
  };

  static List<DayReadingPlan>? _cachedPlan;

  static List<DayReadingPlan> getPlan() {
    if (_cachedPlan != null) return _cachedPlan!;

    final List<Map<String, dynamic>> allChapters = [];
    for (var bookId in bookOrder) {
      final chapters = chapterCounts[bookId] ?? 1;
      for (int i = 1; i <= chapters; i++) {
        allChapters.add({
          'bookId': bookId,
          'chapter': i,
        });
      }
    }

    final List<DayReadingPlan> plan = [];
    final int totalChapters = allChapters.length; // 1189
    const int totalDays = 365;

    final int baseChaptersPerDay = totalChapters ~/ totalDays; // 3
    final int extraDays = totalChapters % totalDays; // 94

    int currentIdx = 0;
    for (int day = 1; day <= totalDays; day++) {
      final int chaptersForThisDay = day <= extraDays ? (baseChaptersPerDay + 1) : baseChaptersPerDay;
      final List<Map<String, dynamic>> dayChapters = allChapters.sublist(currentIdx, currentIdx + chaptersForThisDay);
      currentIdx += chaptersForThisDay;

      final List<BookReadingRange> ranges = [];
      for (var ch in dayChapters) {
        final bookId = ch['bookId'] as String;
        final chapter = ch['chapter'] as int;

        if (ranges.isNotEmpty && ranges.last.bookId == bookId) {
          final last = ranges.last;
          ranges[ranges.length - 1] = BookReadingRange(
            bookId: last.bookId,
            bookName: last.bookName,
            startChapter: last.startChapter,
            endChapter: chapter,
          );
        } else {
          ranges.add(BookReadingRange(
            bookId: bookId,
            bookName: bookNames[bookId] ?? bookId,
            startChapter: chapter,
            endChapter: chapter,
          ));
        }
      }

      final titleParts = ranges.map((r) {
        if (r.startChapter == r.endChapter) {
          return '${r.bookName} ${r.startChapter}';
        } else {
          return '${r.bookName} ${r.startChapter}-${r.endChapter}';
        }
      });
      final title = titleParts.join(' & ');
      final estTime = chaptersForThisDay * 3;

      plan.add(DayReadingPlan(
        dayNumber: day,
        title: title,
        ranges: ranges,
        estimatedReadingTimeMinutes: estTime,
      ));
    }

    _cachedPlan = plan;
    return plan;
  }
}
