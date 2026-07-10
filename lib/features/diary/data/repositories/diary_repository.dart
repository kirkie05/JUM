import 'package:hive/hive.dart';
import '../models/diary_entry.dart';

class DiaryRepository {
  static const String _boxName = 'diary_entries';
  Box<DiaryEntry>? _box;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DiaryEntryAdapter());
    }
    _box = await Hive.openBox<DiaryEntry>(_boxName);
  }

  Future<List<DiaryEntry>> getEntries() async {
    if (_box == null) await init();
    return _box!.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> saveEntry(DiaryEntry entry) async {
    if (_box == null) await init();
    await _box!.put(entry.id, entry);
  }

  Future<void> deleteEntry(String id) async {
    if (_box == null) await init();
    await _box!.delete(id);
  }
}
