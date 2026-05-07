import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables gracefully
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file could not be loaded: $e");
  }

  // Initialize Supabase safely
  try {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? 'https://placeholder-project-url.supabase.co',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? 'placeholder-anon-key',
    );
  } catch (e) {
    debugPrint("Supabase initialization failed/skipped: $e");
  }

  // Run the application within ProviderScope
  runApp(
    const ProviderScope(
      child: JumApp(),
    ),
  );
}
