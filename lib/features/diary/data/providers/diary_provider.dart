import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/diary_entry.dart';
import '../repositories/diary_repository.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepository();
});

final diaryEntriesProvider = StateNotifierProvider<DiaryNotifier, List<DiaryEntry>>((ref) {
  final repo = ref.watch(diaryRepositoryProvider);
  return DiaryNotifier(repo);
});

class DiaryNotifier extends StateNotifier<List<DiaryEntry>> {
  DiaryNotifier(this._repo) : super([]) {
    _loadEntries();
  }

  final DiaryRepository _repo;

  Future<void> _loadEntries() async {
    await _repo.init();
    final entries = await _repo.getEntries();
    state = entries;
  }

  Future<void> addEntry(DiaryEntry entry) async {
    await _repo.saveEntry(entry);
    await _loadEntries();
  }

  Future<void> updateEntry(DiaryEntry entry) async {
    await _repo.saveEntry(entry);
    await _loadEntries();
  }

  Future<void> deleteEntry(String id) async {
    await _repo.deleteEntry(id);
    await _loadEntries();
  }
}
