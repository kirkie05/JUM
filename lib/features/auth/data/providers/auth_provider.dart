import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../messaging/data/repositories/messaging_repository.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<UserModel?> build() {
    // Listen to Supabase auth state changes
    ref.listen(supabaseClientProvider, (previous, current) {
      current.auth.onAuthStateChange.listen((data) {
        if (data.session?.user != null) {
          loadUser();
        } else {
          state = const AsyncValue.data(null);
        }
      });
    });

    final user = ref.watch(supabaseClientProvider).auth.currentUser;
    if (user != null) {
      loadUser();
      return const AsyncValue.loading();
    }
    return const AsyncValue.data(null);
  }

  Future<void> loadUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authServiceProvider).fetchCurrentUser();
      if (user != null) {
        ref.read(messagingRepositoryProvider).processPendingInvitations(user.email, user.id).catchError((e) {
          print('[AUTH_PROVIDER] Error processing pending invites: $e');
        });
      }
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
Future<UserModel?> currentUser(CurrentUserRef ref) async {
  final authState = ref.watch(authNotifierProvider);
  return authState.valueOrNull;
}
