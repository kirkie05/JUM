import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/clerk_compat.dart' as clerk;
import '../models/user_model.dart';
import '../../../../core/services/auth_service.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<UserModel?> build() {
    try {
      // In clerk_flutter, Clerk or ClerkAuth is typically used.
      // We read the current user if available.
      final clerkUser = clerk.Clerk.instance.currentUser;
      if (clerkUser != null) {
        loadUser(clerkUser.id);
      } else {
        return const AsyncValue.data(null);
      }
    } catch (_) {
      return const AsyncValue.data(null);
    }
    return const AsyncValue.loading();
  }

  Future<void> loadUser(String clerkId) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authServiceProvider).fetchCurrentUser(clerkId);
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
