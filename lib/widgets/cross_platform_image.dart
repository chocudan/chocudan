import 'package:flutter/cupertino.dart';
import 'cross_platform_image_stub.dart'
    if (dart.library.io) 'cross_platform_image_io.dart'
    if (dart.library.html) 'cross_platform_image_web.dart';

/// Widget hiển thị ảnh từ local path, hoạt động trên cả native (mobile/
/// desktop, dùng File thật) lẫn web (dùng blob URL vì web không có
/// filesystem thật — image_picker trên web trả về blob URL sẵn).
class CrossPlatformImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final BoxFit fit;

  const CrossPlatformImage({
    super.key,
    required this.path,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return buildPlatformImage(path: path, width: width, height: height, fit: fit);
  }
}
