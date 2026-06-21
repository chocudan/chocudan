import 'package:flutter/cupertino.dart';
import 'cross_platform_image.dart';

/// Màn xem ảnh full-screen, vuốt ngang để chuyển ảnh, có nút xoá ảnh.
class ImageViewerScreen extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;
  final void Function(int index)? onDelete;

  const ImageViewerScreen({
    super.key,
    required this.imagePaths,
    this.initialIndex = 0,
    this.onDelete,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        brightness: Brightness.dark,
        middle: Text(
          '${_currentIndex + 1} / ${widget.imagePaths.length}',
          style: const TextStyle(color: CupertinoColors.white),
        ),
        trailing: widget.onDelete != null
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  final confirm = await showCupertinoDialog<bool>(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Xoá ảnh này?'),
                      actions: [
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Xoá'),
                        ),
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Huỷ'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    widget.onDelete!(_currentIndex);
                    if (context.mounted) Navigator.of(context).pop();
                  }
                },
                child: const Icon(
                  CupertinoIcons.delete,
                  color: CupertinoColors.destructiveRed,
                ),
              )
            : null,
      ),
      child: SafeArea(
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.imagePaths.length,
          onPageChanged: (i) => setState(() => _currentIndex = i),
          itemBuilder: (context, index) {
            return Center(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: CrossPlatformImage(
                  path: widget.imagePaths[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
