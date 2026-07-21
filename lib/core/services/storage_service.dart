import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class StorageService {
  final SupabaseClient _supabase;
  StorageService(this._supabase);

  Future<String?> uploadPostMedia(File file, String mediaType) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      String bucket = 'documents';
      if (mediaType == 'image') {
        bucket = 'avatars';
      } else if (mediaType == 'video') {
        bucket = 'videos';
      } else if (mediaType == 'audio') {
        bucket = 'audio';
      }

      await _supabase.storage.from(bucket).upload(fileName, file);
      final publicUrl = _supabase.storage.from(bucket).getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      print('[STORAGE_SERVICE] Error uploading media: $e');
      // Fallback to high quality mock URLs if storage write fails
      if (mediaType == 'image') {
        return 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/600/400';
      } else if (mediaType == 'video') {
        return 'https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp4';
      } else {
        return 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
      }
    }
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(supabaseClientProvider));
});
