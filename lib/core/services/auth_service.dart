import 'clerk_compat.dart' as clerk;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/models/user_model.dart';
import '../services/supabase_service.dart';

part 'auth_service.g.dart';

typedef ClerkUser = clerk.User;

class AuthService {
  final SupabaseClient _supabase;
  AuthService(this._supabase);

  // Get role from Clerk metadata
  String getRoleFromClerk(ClerkUser user) {
    return user.publicMetadata['role'] as String? ?? 'member';
  }

  // Sync clerk user to Supabase users table
  Future<void> syncUser(ClerkUser clerkUser, String churchId) async {
    final role = getRoleFromClerk(clerkUser);
    
    // Fallback if full name is not set
    String fullName = '';
    if (clerkUser.firstName != null) fullName += clerkUser.firstName!;
    if (clerkUser.lastName != null) fullName += ' ${clerkUser.lastName!}';
    fullName = fullName.trim();
    
    // email addresses
    String email = '';
    if (clerkUser.emailAddresses.isNotEmpty) {
      email = clerkUser.emailAddresses.first.emailAddress;
    }

    await _supabase.from('users').upsert({
      'id': clerkUser.id,        // use clerk ID as Supabase UUID
      'clerk_id': clerkUser.id,
      'name': fullName,
      'email': email,
      'role': role,
      'church_id': churchId,
      'created_at': DateTime.now().toIso8601String(),
    }, onConflict: 'clerk_id');
  }

  // Fetch user record from Supabase
  Future<UserModel?> fetchCurrentUser(String clerkId) async {
    final res = await _supabase
        .from('users')
        .select()
        .eq('clerk_id', clerkId)
        .maybeSingle();
    if (res == null) return null;
    return UserModel.fromJson(res);
  }
}

@riverpod
AuthService authService(AuthServiceRef ref) =>
    AuthService(ref.watch(supabaseClientProvider));
