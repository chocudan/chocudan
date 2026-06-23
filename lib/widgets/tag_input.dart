import 'package:flutter/cupertino.dart';

/// Widget nhập nhiều tag (danh mục), hiện dạng chip có thể xoá, gõ Enter
/// hoặc dấu phẩy để thêm tag mới. Lưu nội bộ dạng List<String>, khi cần
/// lưu DB thì join bằng dấu phẩy: tags.join(',') — dễ sync với filter
/// sheet (chỉ cần split(',') ngược lại).
class TagInput extends StatefulWidget {
  final List<String> initialTags;
  final ValueChanged<List<String>> onChanged;
  final String placeholder;

  const TagInput({
    super.key,
    required this.initialTags,
    required this.onChanged,
    this.placeholder = 'Thêm danh mục...',
  });

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  late List<String> _tags;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tags = List.of(widget.initialTags);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _commitInput() {
    final raw = _controller.text.trim();
    if (raw.isEmpty) return;
    // Cho phép gõ "a, b, c" rồi enter 1 lần để thêm nhiều tag cùng lúc
    final newTags = raw
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty && !_tags.contains(t));
    setState(() {
      _tags.addAll(newTags);
      _controller.clear();
    });
    widget.onChanged(_tags);
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
    widget.onChanged(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 6,
                        top: 5,
                        bottom: 5,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _removeTag(tag),
                            child: const Icon(
                              CupertinoIcons.xmark_circle_fill,
                              size: 15,
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        CupertinoTextField(
          controller: _controller,
          focusNode: _focusNode,
          placeholder: widget.placeholder,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(8),
          ),
          style: const TextStyle(fontSize: 14),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            _commitInput();
            _focusNode.requestFocus();
          },
          suffix: CupertinoButton(
            padding: const EdgeInsets.only(right: 4),
            minSize: 0,
            onPressed: _commitInput,
            child: const Icon(CupertinoIcons.add_circled, size: 20),
          ),
        ),
      ],
    );
  }
}
