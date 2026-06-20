import 'package:flutter/cupertino.dart';

/// Stub mặc định — thực tế luôn bị override bởi cross_platform_image_io.dart
/// (native) hoặc cross_platform_image_web.dart (web) qua conditional import.
Widget buildPlatformImage({
  required String path,
  required double width,
  required double height,
  required BoxFit fit,
}) {
  return const SizedBox.shrink();
}
