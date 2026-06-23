import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../db/database.dart';
import '../db/id_helper.dart';
import '../providers/app_providers.dart';

/// Hiển thị danh sách bình luận đã được Admin duyệt, kèm form gửi bình
/// luận mới cho user có quyền canRate. Bình luận mới gửi sẽ ở trạng
/// thái "chờ duyệt", không hiện công khai ngay.
class CommentSection extends ConsumerStatefulWidget {
  final String placeId;

  const CommentSection({super.key, required this.placeId});

  @override
  ConsumerState<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends ConsumerState<CommentSection> {
  List<Comment> _approvedComments = [];
  bool _loading = true;
  bool _submitting = false;
  bool _justSubmitted = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final comments = await db.getApprovedCommentsForPlace(widget.placeId);
    if (!mounted) return;
    setState(() {
      _approvedComments = comments;
      _loading = false;
    });
  }

  Future<void> _submit() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _submitting = true);
    final db = ref.read(databaseProvider);
    await db.insertComment(
      CommentsCompanion.insert(
        id: newId(),
        placeId: widget.placeId,
        userId: user.id,
        content: content,
        isApproved: const Value(false),
      ),
    );

    if (!mounted) return;
    setState(() {
      _controller.clear();
      _submitting = false;
      _justSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final permissions = ref.watch(permissionsProvider);

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BÌNH LUẬN (${_approvedComments.length})',
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.secondaryLabel,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        if (_approvedComments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Chưa có bình luận nào.',
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.tertiaryLabel,
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: _approvedComments.asMap().entries.map((entry) {
                final isLast = entry.key == _approvedComments.length - 1;
                final comment = entry.value;
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(
                              color: CupertinoColors.systemGrey5,
                              width: 0.5,
                            ),
                          ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.content,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatRelativeTime(comment.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: CupertinoColors.tertiaryLabel,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 12),
        if (permissions.canRate) ...[
          if (_justSubmitted)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Bình luận đã gửi, đang chờ Admin duyệt.',
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.activeGreen,
                ),
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CupertinoTextField(
                    controller: _controller,
                    placeholder: 'Viết bình luận...',
                    maxLines: 3,
                    minLines: 1,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                CupertinoButton(
                  padding: const EdgeInsets.all(10),
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(8),
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const CupertinoActivityIndicator(
                          color: CupertinoColors.white,
                        )
                      : const Icon(
                          CupertinoIcons.paperplane_fill,
                          size: 16,
                          color: CupertinoColors.white,
                        ),
                ),
              ],
            ),
        ],
      ],
    );
  }

  String _formatRelativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 30) return '${diff.inDays} ngày trước';
    return '${time.day}/${time.month}/${time.year}';
  }
}
