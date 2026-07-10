import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../repositories/admin_repository.dart';

final adminOverviewStatsProvider = FutureProvider<AdminOverviewStats>((ref) {
  return ref.watch(adminRepositoryProvider).fetchOverviewStats();
});

final adminRecentActivitiesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final list = await ref.watch(adminRepositoryProvider).fetchRecentActivities();
  return list.map((e) {
    final dt = DateTime.tryParse(e['time'] ?? '');
    return {
      'text': e['text'],
      'time': dt != null ? timeago.format(dt) : 'Just now',
    };
  }).toList();
});

final adminUsersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(adminRepositoryProvider).fetchAllUsers();
});

class AdminUsersNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  AdminUsersNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> updateUserRole(String userId, String newRole) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).updateUserRole(userId, newRole);
      ref.invalidate(adminUsersProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminUsersNotifierProvider = StateNotifierProvider<AdminUsersNotifier, AsyncValue<void>>((ref) {
  return AdminUsersNotifier(ref);
});

final adminDepartmentsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(adminRepositoryProvider).fetchDepartments();
});

final adminEventsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(adminRepositoryProvider).fetchEvents();
});

final adminDonationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(adminRepositoryProvider).fetchDonations();
});
