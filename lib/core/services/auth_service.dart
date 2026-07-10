import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/models/user_model.dart';
import '../services/supabase_service.dart';

part 'auth_service.g.dart';

class AuthService {
  final SupabaseClient _supabase;
  AuthService(this._supabase);

  // Fetch user record from Supabase
  Future<UserModel?> fetchCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final res = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    if (res == null) return null;
    return UserModel.fromJson(res);
  }
}

@riverpod
AuthService authService(AuthServiceRef ref) =>
    AuthService(ref.watch(supabaseClientProvider));
