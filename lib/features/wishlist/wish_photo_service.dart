import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Welle-8 Round 16: lädt User-Foto für Wish-Item, kopiert es in den
/// app-support dir und liefert absoluten Pfad zurück. Null bei Abbruch.
class WishPhotoService {
  WishPhotoService._();
  static final instance = WishPhotoService._();

  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndStore(String wishItemId) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return null;
    final dir = await getApplicationSupportDirectory();
    final wishDir = Directory(p.join(dir.path, 'wish_photos'));
    if (!wishDir.existsSync()) {
      wishDir.createSync(recursive: true);
    }
    final ext = p.extension(picked.path).isEmpty
        ? '.jpg'
        : p.extension(picked.path);
    final dest = File(p.join(wishDir.path, '$wishItemId$ext'));
    await File(picked.path).copy(dest.path);
    return dest.path;
  }

  Future<void> delete(String photoPath) async {
    final f = File(photoPath);
    if (await f.exists()) await f.delete();
  }
}
