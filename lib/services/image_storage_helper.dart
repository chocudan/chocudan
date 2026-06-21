import 'dart:io';
import 'package:flutter/foundation.dart' show kReleaseMode, kProfileMode;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// image_picker trên native (mobile/desktop) trả về đường dẫn file nằm
/// trong thư mục TẠM của hệ thống — không đảm bảo tồn tại lâu dài, có thể
/// bị OS dọn dẹp hoặc đổi container path giữa các lần mở app.
///
/// Hàm này copy ảnh đã chọn vào thư mục Documents riêng của app
/// (`<app_documents>/place_images[_debug|_profile]/`) để đảm bảo ảnh tồn
/// tại bền vững, không phụ thuộc vào vòng đời của thư mục tạm.
///
/// Thư mục được tách theo build mode (debug/profile/release) — giống
/// cách database.dart tách tên file DB — để bản debug và release trên
/// cùng máy không vô tình dùng chung ảnh khi Bundle ID giống nhau.
class ImageStorageHelper {
  static String get _folderName {
    if (kReleaseMode) return 'place_images';
    if (kProfileMode) return 'place_images_profile';
    return 'place_images_debug';
  }

  static Future<String> persistImage(String tempPath) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(docsDir.path, _folderName));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final ext = p.extension(tempPath);
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${p.basenameWithoutExtension(tempPath)}$ext';
    final destPath = p.join(imagesDir.path, fileName);

    final sourceFile = File(tempPath);
    await sourceFile.copy(destPath);

    return destPath;
  }

  /// Xoá file ảnh thật trên đĩa khi xoá record trong database.
  /// Không throw nếu file không tồn tại (đã bị xoá trước đó hoặc lỗi cũ).
  static Future<void> deleteImageFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Bỏ qua lỗi xoá file — không nên chặn việc xoá record DB vì lý do này
    }
  }
}
