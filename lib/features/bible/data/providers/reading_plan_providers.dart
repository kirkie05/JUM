import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/bible_reading_plan_engine.dart';
import '../models/reading_plan_models.dart';
import '../repositories/reading_plan_repository.dart';
import '../repositories/bible_user_actions_repository.dart';

final readingPlanRepositoryProvider = Provider<ReadingPlanRepository>((ref) {
  return ReadingPlanRepository(ref.watch(supabaseClientProvider));
});

final bibleUserActionsRepositoryProvider = Provider<BibleUserActionsRepository>((ref) {
  return BibleUserActionsRepository(ref.watch(supabaseClientProvider));
});

class ReadingPlanState {
  final DateTime startDate;
  final List<LocalProgress> completedDays;
  final LocalStreak streak;
  final DayReadingPlan nextReading;
  final int daysSinceStart;
  final int missedDays;
  final double completionPercentage;
  final int remainingDays;

  ReadingPlanState({
    required this.startDate,
    required this.completedDays,
    required this.streak,
    required this.nextReading,
    required this.daysSinceStart,
    required this.missedDays,
    required this.completionPercentage,
    required this.remainingDays,
  });
}

class ReadingPlanNotifier extends StateNotifier<AsyncValue<ReadingPlanState>> {
  final ReadingPlanRepository _repo;

  ReadingPlanNotifier(this._repo) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final startDate = await _repo.getPlanStartDate();
      final completed = await _repo.getCompletedDays();
      final streak = await _repo.getStreak();

      final stateVal = _buildState(startDate, completed, streak);
      state = AsyncValue.data(stateVal);

      // Trigger background cloud sync
      await _repo.syncWithCloud();
      final syncedCompleted = await _repo.getCompletedDays();
      final syncedStreak = await _repo.getStreak();
      state = AsyncValue.data(_buildState(startDate, syncedCompleted, syncedStreak));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  ReadingPlanState _buildState(DateTime startDate, List<LocalProgress> completed, LocalStreak streak) {
    final completedDayNums = completed.map((p) => p.dayNumber).toSet();

    // Next reading is the first day that is not completed
    int nextDayNum = 1;
    final plan = BibleReadingPlanEngine.getPlan();
    for (int day = 1; day <= 365; day++) {
      if (!completedDayNums.contains(day)) {
        nextDayNum = day;
        break;
      }
    }

    final nextReading = plan.firstWhere(
      (d) => d.dayNumber == nextDayNum,
      orElse: () => plan.first,
    );

    final today = DateTime.now();
    final dateOnlyToday = DateTime(today.year, today.month, today.day);
    final daysSinceStart = dateOnlyToday.difference(startDate).inDays + 1;
    final missedDays = daysSinceStart > completed.length ? (daysSinceStart - completed.length) : 0;
    final double completionPercentage = (completed.length / 365.0) * 100.0;
    final remainingDays = 365 - completed.length;

    return ReadingPlanState(
      startDate: startDate,
      completedDays: completed,
      streak: streak,
      nextReading: nextReading,
      daysSinceStart: daysSinceStart,
      missedDays: missedDays,
      completionPercentage: completionPercentage,
      remainingDays: remainingDays,
    );
  }

  Future<void> markCompleted(int dayNumber, int durationSeconds) async {
    try {
      await _repo.markDayCompleted(dayNumber, durationSeconds);
      // Reload stats
      final startDate = await _repo.getPlanStartDate();
      final completed = await _repo.getCompletedDays();
      final streak = await _repo.getStreak();
      state = AsyncValue.data(_buildState(startDate, completed, streak));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final readingPlanStateProvider = StateNotifierProvider<ReadingPlanNotifier, AsyncValue<ReadingPlanState>>((ref) {
  return ReadingPlanNotifier(ref.watch(readingPlanRepositoryProvider));
});

// --- Bible Notes State Notifier ---
class BibleNotesNotifier extends StateNotifier<AsyncValue<List<LocalNote>>> {
  final BibleUserActionsRepository _repo;

  BibleNotesNotifier(this._repo) : super(const AsyncValue.loading());

  Future<void> load(String bookId, int chapter) async {
    state = const AsyncValue.loading();
    try {
      final notes = await _repo.getNotesForChapter(bookId, chapter);
      state = AsyncValue.data(notes);
      
      // Background cloud sync
      await _repo.syncWithCloud();
      final synced = await _repo.getNotesForChapter(bookId, chapter);
      state = AsyncValue.data(synced);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addNote({
    required String bookId,
    required int chapter,
    required int verse,
    required String? title,
    required String body,
  }) async {
    try {
      await _repo.addNote(
        bookId: bookId,
        chapter: chapter,
        verse: verse,
        title: title,
        body: body,
      );
      final notes = await _repo.getNotesForChapter(bookId, chapter);
      state = AsyncValue.data(notes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteNote(String noteId, String bookId, int chapter) async {
    try {
      await _repo.deleteNote(noteId);
      final notes = await _repo.getNotesForChapter(bookId, chapter);
      state = AsyncValue.data(notes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateNote(String noteId, String? title, String body, String bookId, int chapter) async {
    try {
      await _repo.updateNote(noteId, title, body);
      final notes = await _repo.getNotesForChapter(bookId, chapter);
      state = AsyncValue.data(notes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final bibleNotesProvider = StateNotifierProvider.family<BibleNotesNotifier, AsyncValue<List<LocalNote>>, String>((ref, arg) {
  // arg is in format "bookId_chapter"
  final parts = arg.split('_');
  final bookId = parts[0];
  final chapter = int.parse(parts[1]);
  final notifier = BibleNotesNotifier(ref.watch(bibleUserActionsRepositoryProvider));
  notifier.load(bookId, chapter);
  return notifier;
});

// --- Bible Bookmarks State Notifier ---
class BibleBookmarksNotifier extends StateNotifier<AsyncValue<List<LocalBookmark>>> {
  final BibleUserActionsRepository _repo;

  BibleBookmarksNotifier(this._repo) : super(const AsyncValue.loading());

  Future<void> load(String bookId, int chapter) async {
    state = const AsyncValue.loading();
    try {
      final bms = await _repo.getBookmarksForChapter(bookId, chapter);
      state = AsyncValue.data(bms);

      // Background cloud sync
      await _repo.syncWithCloud();
      final synced = await _repo.getBookmarksForChapter(bookId, chapter);
      state = AsyncValue.data(synced);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addBookmark({
    required String bookId,
    required int chapter,
    required int verse,
    required String type,
    String? color,
  }) async {
    try {
      await _repo.addBookmark(
        bookId: bookId,
        chapter: chapter,
        verse: verse,
        type: type,
        color: color,
      );
      final bms = await _repo.getBookmarksForChapter(bookId, chapter);
      state = AsyncValue.data(bms);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeBookmark({
    required String bookId,
    required int chapter,
    required int verse,
    required String type,
  }) async {
    try {
      await _repo.removeBookmark(bookId, chapter, verse, type);
      final bms = await _repo.getBookmarksForChapter(bookId, chapter);
      state = AsyncValue.data(bms);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final bibleBookmarksProvider = StateNotifierProvider.family<BibleBookmarksNotifier, AsyncValue<List<LocalBookmark>>, String>((ref, arg) {
  // arg is in format "bookId_chapter"
  final parts = arg.split('_');
  final bookId = parts[0];
  final chapter = int.parse(parts[1]);
  final notifier = BibleBookmarksNotifier(ref.watch(bibleUserActionsRepositoryProvider));
  notifier.load(bookId, chapter);
  return notifier;
});

final selectedPlanDayProvider = StateProvider<int?>((ref) => null);
