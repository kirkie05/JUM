import 'package:file_picker/file_picker.dart';

void main() {
  try {
    print('FilePicker instance: ${FilePicker.platform}');
  } catch (e) {
    print('Error accessing platform: $e');
  }
}
