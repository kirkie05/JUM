import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../models/event_model.dart';
import '../models/rsvp_model.dart';
import '../repositories/events_repository.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return EventsRepository(client);
});

final upcomingEventsProvider = FutureProvider.family<List<EventModel>, String>((ref, churchId) async {
  final repo = ref.watch(eventsRepositoryProvider);
  return repo.fetchUpcoming(churchId);
});

// A StateNotifier to manage RSVPs dynamically so that newly created RSVPs are updated immediately in the UI.
class RsvpNotifier extends StateNotifier<AsyncValue<Map<String, RsvpModel>>> {
  final EventsRepository _repo;

  RsvpNotifier(this._repo) : super(const AsyncValue.data({}));

  Future<void> loadRsvp(String userId, String eventId) async {
    final key = '$userId-$eventId';
    state = const AsyncValue.loading();
    try {
      final rsvp = await _repo.fetchRsvp(userId, eventId);
      final currentMap = state.value ?? {};
      if (rsvp != null) {
        state = AsyncValue.data({...currentMap, key: rsvp});
      } else {
        state = AsyncValue.data({...currentMap}..remove(key));
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<RsvpModel> createRsvp(String userId, String eventId) async {
    final key = '$userId-$eventId';
    try {
      final rsvp = await _repo.createRsvp(userId, eventId);
      final currentMap = state.value ?? {};
      state = AsyncValue.data({...currentMap, key: rsvp});
      return rsvp;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

final rsvpNotifierProvider = StateNotifierProvider<RsvpNotifier, AsyncValue<Map<String, RsvpModel>>>((ref) {
  final repo = ref.watch(eventsRepositoryProvider);
  return RsvpNotifier(repo);
});
