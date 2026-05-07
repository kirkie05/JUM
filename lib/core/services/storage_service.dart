import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageService {
  Future<String?> uploadPostMedia(File file) async {
    // Stub implementation
    return 'https://example.com/mock-image.png';
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
