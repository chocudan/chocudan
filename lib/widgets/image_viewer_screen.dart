import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'cross_platform_image.dart';

/// Màn xem ảnh full-screen, vuốt ngang để chuyển ảnh, có nút xoá ảnh.
/// Hỗ trợ phím mũi tên trái/phải để chuyển ảnh (hữu ích trên desktop/web).
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
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.imagePaths.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _goToPrevious();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _goToNext();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: CupertinoPageScaffold(
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
          child: Stack(
            children: [
              PageView.builder(
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
              if (widget.imagePaths.length > 1) ...[
                if (_currentIndex > 0)
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _NavArrowButton(
                        icon: CupertinoIcons.chevron_back,
                        onTap: _goToPrevious,
                      ),
                    ),
                  ),
                if (_currentIndex < widget.imagePaths.length - 1)
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _NavArrowButton(
                        icon: CupertinoIcons.chevron_forward,
                        onTap: _goToNext,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: CupertinoColors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: CupertinoColors.white, size: 20),
      ),
    );
  }
}
