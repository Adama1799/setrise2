// lib/core/file/file_picker_adapter.dart
import 'package:image_picker/image_picker.dart';
import '../utils/universal_platform.dart';

class FilePickerAdapter {
  static final _imagePicker = ImagePicker();

  static Future<String?> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      return pickedFile?.path;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  static Future<String?> pickVideo() async {
    try {
      final pickedFile = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );
      return pickedFile?.path;
    } catch (e) {
      print('Error picking video: $e');
      return null;
    }
  }

  static bool canPickImage() {
    // For web, we might need different handling
    if (UniversalPlatform.isWeb) {
      return true; // Web supports file picker
    }
    return true; // Mobile supports image picker
  }
}
