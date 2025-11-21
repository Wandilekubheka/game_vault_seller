import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final _storage = FirebaseStorage.instance;
  Future<String> uploadXFile(XFile file, String bucketPath) async {
    try {
      final ref = _storage.ref().child(bucketPath).child(file.name);
      await ref.putData(await file.readAsBytes());
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw FormatException('Failed to upload image: $e');
    }
  }

  Future<void> deleteImages(List<String> imageUrls) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrls.first);
      final path = ref.fullPath; // users/photos/pic.jpg
      final folder = ref.parent?.fullPath; // users/photos
      if (folder != null) {
        final folderRef = _storage.ref().child(folder);
        await folderRef.delete();
      } else {
        throw FormatException('Failed to determine folder path for deletion');
      }
    } catch (e) {
      throw FormatException('Failed to delete images: $e');
    }
  }
}
