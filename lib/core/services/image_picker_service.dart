import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Contract for picking baby photos from the device.
abstract class ImagePickerService {
  /// Opens the system picker and returns the stored photo path, if any.
  Future<String?> pickImage();
}

/// Default implementation backed by the platform image picker.
class DeviceImagePickerService implements ImagePickerService {
  /// Creates the service using the provided [ImagePicker] or a default instance.
  DeviceImagePickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<String?> pickImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1080,
    );

    if (file == null) {
      return null;
    }

    final documentsDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(documentsDir.path, 'baby_photos'));
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    final targetPath = p.join(
      photosDir.path,
      '${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}',
    );

    final savedFile = await File(file.path).copy(targetPath);
    return savedFile.path;
  }
}
