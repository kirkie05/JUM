import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;
}

// Manual Riverpod provider for clean integration without version generation hell
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseService.client;
});
