import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/database.dart';
import '../providers/app_providers.dart';

class CommentManagementScreen extends ConsumerStatefulWidget {
  const CommentManagementScreen({super.key});

  @override
  ConsumerState<CommentManagementScreen> createState() =>
      _CommentManagementScreenState();
}

class _CommentManagementScreenState
    extends ConsumerState<CommentManagementScreen> {
  List<Comment> _comments = [];
  Map<String, String> _placeNames = {};
  bool _loading = true;
  bool _showOnlyPending = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final db = ref.read(databaseProvider);
    final comments = await db.getAllComments();

    final placeNames = <String, String>{};
    for (final c in comments) {
      if (!placeNames.containsKey(c.placeId)) {
        final place = await db.getPlaceById(c.placeId);
        placeNames[c.placeId] = place?.name ?? '(quán đã xoá)';
      }
    }

    if (!mounted) return;
    setState(() {
      _comments = comments;
      _placeNames = placeNames;
      _loading = false;
    });
  }

  Future<void> _setApproval(Comment comment, bool approved) async {
    final db = ref.read(databaseProvider);
    await db.setCommentApproval(comment.id, approved);
    _load();
  }

  Future<void> _delete(Comment comment) async {
    final db = ref.read(databaseProvider);
    await db.deleteComment(comment.id);
    _load();
  }

  List<Comment> get _filtered {
    if (!_showOnlyPending) return _comments;
    return _comments.where((c) => !c.isApproved).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final pendingCount = _comments.where((c) => !c.isApproved).length;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Cài đặt',
        middle: Text('Quản lý bình luận'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _showOnlyPending = true),
                    child: _FilterChip(
                      label: 'Chờ duyệt ($pendingCount)',
                      selected: _showOnlyPending,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _showOnlyPending = false),
                    child: _FilterChip(
                      label: 'Tất cả (${_comments.length})',
                      selected: !_showOnlyPending,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CupertinoActivityIndicator())
                  : filtered.isEmpty
                      ? Center(
                          child: Text(
                            _showOnlyPending
                                ? 'Không có bình luận chờ duyệt'
                                : 'Chưa có bình luận nào',
                            style: const TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.secondaryLabel,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final comment = filtered[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _placeNames[comment.placeId] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: CupertinoColors.activeBlue,
                                          ),
                                        ),
                                      ),
                                      if (comment.isApproved)
                                        const _StatusBadge(
                                          text: 'Đã duyệt',
                                          color: CupertinoColors.activeGreen,
                                        )
                                      else
                                        const _StatusBadge(
                                          text: 'Chờ duyệt',
                                          color: CupertinoColors.activeOrange,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    comment.content,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      if (!comment.isApproved)
                                        Expanded(
                                          child: CupertinoButton(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            color: CupertinoColors.activeGreen
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            onPressed: () =>
                                                _setApproval(comment, true),
                                            child: const Text(
                                              'Duyệt',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: CupertinoColors
                                                    .activeGreen,
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        Expanded(
                                          child: CupertinoButton(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            color: CupertinoColors.systemGrey6,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            onPressed: () =>
                                                _setApproval(comment, false),
                                            child: const Text(
                                              'Bỏ duyệt',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: CupertinoButton(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          color: CupertinoColors
                                              .destructiveRed
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onPressed: () => _delete(comment),
                                          child: const Text(
                                            'Xoá',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: CupertinoColors
                                                  .destructiveRed,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? CupertinoColors.label : CupertinoColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? CupertinoColors.white : CupertinoColors.label,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
