import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'core/services/global_seed_service.dart';
import 'app.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
  } catch (e) {
    debugPrint("Hive initialization failed: $e");
  }

  try {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.jum.app.channel.audio',
      androidNotificationChannelName: 'JUM Audio Playback',
      androidNotificationOngoing: true,
    );
  } catch (e) {
    debugPrint("JustAudioBackground initialization failed: $e");
  }

  // Load environment variables gracefully
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file could not be loaded: $e");
  }

  // Initialize OneSignal safely
  try {
    final onesignalId = dotenv.env['ONESIGNAL_APP_ID'];
    if (onesignalId != null && onesignalId.isNotEmpty) {
      OneSignal.Debug.setLogLevel(OSLogLevel.none);
      OneSignal.initialize(onesignalId);
    }
  } catch (e) {
    debugPrint("OneSignal initialization failed: $e");
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

  // Attempt to seed data if in debug mode and tables are empty
  try {
    if (Supabase.instance.client != null) {
      final seedService = GlobalSeedService(Supabase.instance.client);
      await seedService.seedIfEmpty();
    }
  } catch (e) {
    debugPrint("Seeding skipped or failed: $e");
  }

  // Run the application within ProviderScope
  runApp(
    const ProviderScope(
      child: JumApp(),
    ),
  );
}
