import 'dart:io';
import 'package:flutter/cupertino.dart';

/// Native (Android/iOS/Windows/macOS/Linux): đọc ảnh từ file path thật
/// trên thiết bị bằng dart:io.
Widget buildPlatformImage({
  required String path,
  required double width,
  required double height,
  required BoxFit fit,
}) {
  return Image.file(
    File(path),
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (context, error, stackTrace) => Container(
      width: width,
      height: height,
      color: CupertinoColors.systemGrey5,
      child: const Icon(CupertinoIcons.photo, color: CupertinoColors.systemGrey),
    ),
  );
}
