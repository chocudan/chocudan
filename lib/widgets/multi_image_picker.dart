import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_storage_helper.dart';
import 'cross_platform_image.dart';

class DraftImage {
  String localPath;
  bool isPrimary;
  DraftImage({required this.localPath, this.isPrimary = false});
}

/// Picker ảnh hỗ trợ chọn NHIỀU ảnh cùng lúc (pickMultiImage), hiện dạng
/// lưới ngang, cho phép đặt ảnh đại diện (primary) và xoá từng ảnh.
class MultiImagePicker extends StatefulWidget {
  final List<DraftImage> initialImages;
  final ValueChanged<List<DraftImage>> onChanged;

  const MultiImagePicker({
    super.key,
    required this.initialImages,
    required this.onChanged,
  });

  @override
  State<MultiImagePicker> createState() => _MultiImagePickerState();
}

class _MultiImagePickerState extends State<MultiImagePicker> {
  late List<DraftImage> _images;
  bool _picking = false;

  @override
  void initState() {
    super.initState();
    _images = List.of(widget.initialImages);
  }

  Future<void> _pickImages() async {
    setState(() => _picking = true);
    try {
      final picker = ImagePicker();
      // pickMultiImage cho phép chọn nhiều ảnh 1 lúc thay vì gọi
      // pickImage() lặp lại nhiều lần.
      final picked = await picker.pickMultiImage(imageQuality: 80);
      if (picked.isEmpty) return;

      for (final file in picked) {
        final persistedPath = await ImageStorageHelper.persistImage(
          file.path,
        );
        _images.add(
          DraftImage(
            localPath: persistedPath,
            isPrimary: _images.isEmpty, // ảnh đầu tiên tự thành đại diện
          ),
        );
      }
      setState(() {});
      widget.onChanged(_images);
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Không thể thêm ảnh'),
          content: Text('Lỗi: $e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Đã hiểu'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  void _removeImage(int index) {
    final wasPrimary = _images[index].isPrimary;
    setState(() {
      _images.removeAt(index);
      // Nếu xoá đúng ảnh đại diện, tự gán ảnh đầu tiên còn lại làm đại diện
      if (wasPrimary && _images.isNotEmpty) {
        _images[0].isPrimary = true;
      }
    });
    widget.onChanged(_images);
  }

  void _setPrimary(int index) {
    setState(() {
      for (var i = 0; i < _images.length; i++) {
        _images[i].isPrimary = i == index;
      }
    });
    widget.onChanged(_images);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _picking ? null : _pickImages,
            child: Container(
              width: 90,
              height: 90,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _picking
                  ? const Center(child: CupertinoActivityIndicator())
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.add,
                          color: CupertinoColors.activeBlue,
                        ),
                        SizedBox(height: 2),
                        Text('Thêm ảnh', style: TextStyle(fontSize: 10)),
                      ],
                    ),
            ),
          ),
          ..._images.asMap().entries.map((entry) {
            final index = entry.key;
            final img = entry.value;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: img.isPrimary
                          ? Border.all(
                              color: CupertinoColors.activeBlue,
                              width: 2,
                            )
                          : null,
                    ),
                    child: CrossPlatformImage(
                      path: img.localPath,
                      width: 90,
                      height: 90,
                    ),
                  ),
                  Positioned(
                    top: 3,
                    right: 3,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: CupertinoColors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.xmark,
                          size: 12,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),
                  ),
                  if (!img.isPrimary)
                    Positioned(
                      bottom: 3,
                      left: 3,
                      child: GestureDetector(
                        onTap: () => _setPrimary(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Đặt đại diện',
                            style: TextStyle(
                              fontSize: 8,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const Positioned(
                      bottom: 3,
                      left: 3,
                      child: Icon(
                        CupertinoIcons.star_fill,
                        size: 16,
                        color: CupertinoColors.systemYellow,
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
