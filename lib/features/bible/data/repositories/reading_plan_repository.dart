import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/reading_plan_models.dart';

class ReadingPlanRepository {
  static const String _progressBoxName = 'bible_reading_progress';
  static const String _streakBoxName = 'bible_reading_streaks';
  static const String _planStartDatePrefKey = 'bible_plan_start_date';

  final SupabaseClient _supabase;
  Box<LocalProgress>? _progressBox;
  Box<LocalStreak>? _streakBox;

  ReadingPlanRepository(this._supabase) {
    _initHive();
  }

  Future<void> _initHive() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(LocalProgressAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(LocalStreakAdapter());
    }
    _progressBox = await Hive.openBox<LocalProgress>(_progressBoxName);
    _streakBox = await Hive.openBox<LocalStreak>(_streakBoxName);
  }

  Future<Box<LocalProgress>> _getProgressBox() async {
    if (_progressBox == null) await _initHive();
    return _progressBox!;
  }

  Future<Box<LocalStreak>> _getStreakBox() async {
    if (_streakBox == null) await _initHive();
    return _streakBox!;
  }

  // --- Start Date Management ---
  Future<DateTime> getPlanStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final localDateStr = prefs.getString(_planStartDatePrefKey);
    if (localDateStr != null) {
      return DateTime.parse(localDateStr);
    }

    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        final res = await _supabase
            .from('user_reading_plans')
            .select('start_date')
            .eq('user_id', user.id)
            .maybeSingle();

        if (res != null && res['start_date'] != null) {
          final dbDate = DateTime.parse(res['start_date'] as String);
          await prefs.setString(_planStartDatePrefKey, dbDate.toIso8601String());
          return dbDate;
        }
      } catch (e) {
        debugPrint('Error fetching plan start date: $e');
      }
    }

    // Default to today if not set anywhere
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);
    await prefs.setString(_planStartDatePrefKey, dateOnly.toIso8601String());

    if (user != null) {
      try {
        await _supabase.from('user_reading_plans').upsert({
          'user_id': user.id,
          'start_date': dateOnly.toIso8601String(),
        });
      } catch (e) {
        debugPrint('Error saving plan start date: $e');
      }
    }

    return dateOnly;
  }

  // --- Progress Management ---
  Future<List<LocalProgress>> getCompletedDays() async {
    final box = await _getProgressBox();
    return box.values.toList();
  }

  Future<void> markDayCompleted(int dayNumber, int durationSeconds) async {
    final box = await _getProgressBox();
    final today = DateTime.now();
    final progress = LocalProgress(
      dayNumber: dayNumber,
      completedAt: today,
      duration: durationSeconds,
    );

    // Save locally
    await box.put(dayNumber, progress);

    // Update streak locally
    await _updateStreakLocally(today);

    // Sync in background
    final user = _supabase.auth.currentUser;
    if (user != null) {
      _syncProgressItem(user.id, progress);
      _syncStreak(user.id);
    }
  }

  // --- Streaks Management ---
  Future<LocalStreak> getStreak() async {
    final box = await _getStreakBox();
    if (box.isEmpty) {
      return LocalStreak(currentStreak: 0, longestStreak: 0);
    }
    return box.values.first;
  }

  Future<void> _updateStreakLocally(DateTime readDateTime) async {
    final box = await _getStreakBox();
    final currentStreakData = box.isEmpty
        ? LocalStreak(currentStreak: 0, longestStreak: 0)
        : box.values.first;

    int cur = currentStreakData.currentStreak;
    int max = currentStreakData.longestStreak;

    final readDate = DateTime(readDateTime.year, readDateTime.month, readDateTime.day);

    if (currentStreakData.lastCompletedDate != null) {
      final prevDate = DateTime(
        currentStreakData.lastCompletedDate!.year,
        currentStreakData.lastCompletedDate!.month,
        currentStreakData.lastCompletedDate!.day,
      );

      final diff = readDate.difference(prevDate).inDays;
      if (diff == 1) {
        cur += 1;
      } else if (diff > 1) {
        cur = 1; // broken, reset to 1
      }
    } else {
      cur = 1; // first time reading
    }

    if (cur > max) {
      max = cur;
    }

    final newStreak = LocalStreak(
      currentStreak: cur,
      longestStreak: max,
      lastCompletedDate: readDate,
    );

    await box.clear();
    await box.add(newStreak);
  }

  // --- Cloud Sync ---
  Future<void> _syncProgressItem(String userId, LocalProgress progress) async {
    try {
      await _supabase.from('user_reading_progress').upsert({
        'user_id': userId,
        'day_number': progress.dayNumber,
        'completed': true,
        'completed_at': progress.completedAt.toIso8601String(),
        'reading_duration': progress.duration,
        'progress_percentage': 100.0,
      });
    } catch (e) {
      debugPrint('Sync progress item offline-deferred: $e');
    }
  }

  Future<void> _syncStreak(String userId) async {
    try {
      final streak = await getStreak();
      await _supabase.from('reading_streaks').upsert({
        'user_id': userId,
        'current_streak': streak.currentStreak,
        'longest_streak': streak.longestStreak,
        'last_read_date': streak.lastCompletedDate?.toIso8601String().substring(0, 10),
      });
    } catch (e) {
      debugPrint('Sync streak offline-deferred: $e');
    }
  }

  Future<void> syncWithCloud() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // 1. Pull start date
      await getPlanStartDate();

      // 2. Push any unsynced local progress items
      final localProgressItems = await getCompletedDays();
      
      // 3. Pull progress from Supabase
      final dbProgressRes = await _supabase
          .from('user_reading_progress')
          .select()
          .eq('user_id', user.id);

      final box = await _getProgressBox();
      
      if (dbProgressRes != null) {
        final List<dynamic> dbList = dbProgressRes as List;
        final Set<int> dbDayNumbers = {};

        for (var item in dbList) {
          final int dayNum = item['day_number'] as int;
          dbDayNumbers.add(dayNum);

          final progress = LocalProgress(
            dayNumber: dayNum,
            completedAt: DateTime.parse(item['completed_at'] as String),
            duration: item['reading_duration'] as int? ?? 0,
          );
          // Overwrite/insert in Hive
          await box.put(dayNum, progress);
        }

        // Push local ones that aren't in Supabase
        for (var localItem in localProgressItems) {
          if (!dbDayNumbers.contains(localItem.dayNumber)) {
            await _syncProgressItem(user.id, localItem);
          }
        }
      }

      // 4. Pull streaks from Supabase
      final dbStreakRes = await _supabase
          .from('reading_streaks')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (dbStreakRes != null) {
        final streakBox = await _getStreakBox();
        final cloudStreak = LocalStreak(
          currentStreak: dbStreakRes['current_streak'] as int? ?? 0,
          longestStreak: dbStreakRes['longest_streak'] as int? ?? 0,
          lastCompletedDate: dbStreakRes['last_read_date'] != null 
              ? DateTime.tryParse(dbStreakRes['last_read_date'] as String) 
              : null,
        );
        
        await streakBox.clear();
        await streakBox.add(cloudStreak);
      } else {
        // Push local streaks to Supabase if none exists there
        await _syncStreak(user.id);
      }
    } catch (e) {
      debugPrint('Error syncing reading plan with cloud: $e');
    }
  }
}
