import 'package:flutter_test/flutter_test.dart';
import 'package:jum/features/bible/data/models/bible_reading_plan_engine.dart';

void main() {
  group('BibleReadingPlanEngine tests', () {
    test('covers exactly 365 days and matches total canonical chapter count (1189)', () {
      final plan = BibleReadingPlanEngine.getPlan();

      expect(plan.length, 365);

      int totalChaptersChecked = 0;
      final Map<String, Set<int>> covered = {};

      for (var day in plan) {
        expect(day.dayNumber, greaterThanOrEqualTo(1));
        expect(day.dayNumber, lessThanOrEqualTo(365));
        expect(day.ranges.isNotEmpty, true);
        expect(day.estimatedReadingTimeMinutes, greaterThan(0));
        expect(day.title.isNotEmpty, true);

        for (var range in day.ranges) {
          expect(range.startChapter, lessThanOrEqualTo(range.endChapter));
          for (int ch = range.startChapter; ch <= range.endChapter; ch++) {
            totalChaptersChecked++;
            covered.putIfAbsent(range.bookId, () => {}).add(ch);
          }
        }
      }

      // Verify total chapter count is 1189
      expect(totalChaptersChecked, 1189);

      // Verify book chapters match canonical limits exactly
      BibleReadingPlanEngine.chapterCounts.forEach((bookId, expectedChapters) {
        final bookCovered = covered[bookId];
        expect(bookCovered, isNotNull, reason: 'Book $bookId is not covered at all');
        expect(bookCovered!.length, expectedChapters, reason: 'Book $bookId should have $expectedChapters chapters but has ${bookCovered.length}');
        for (int ch = 1; ch <= expectedChapters; ch++) {
          expect(bookCovered.contains(ch), true, reason: 'Book $bookId is missing chapter $ch');
        }
      });
    });
  });
}
