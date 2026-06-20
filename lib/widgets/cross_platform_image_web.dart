import 'package:flutter/cupertino.dart';

/// Web: image_picker trên web trả về blob URL (vd "blob:http://...") thay
/// vì file path thật, vì trình duyệt không cho truy cập filesystem trực
/// tiếp. Dùng Image.network để load blob URL này.
Widget buildPlatformImage({
  required String path,
  required double width,
  required double height,
  required BoxFit fit,
}) {
  return Image.network(
    path,
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
