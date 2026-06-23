import 'package:flutter/cupertino.dart';

enum SortOption { ratingDesc, newest, priceAsc, viewsDesc }

class FeedFilters {
  final Set<String> categories;
  final bool freeshipOnly;
  final SortOption sort;

  const FeedFilters({
    this.categories = const {},
    this.freeshipOnly = false,
    this.sort = SortOption.ratingDesc,
  });

  FeedFilters copyWith({
    Set<String>? categories,
    bool? freeshipOnly,
    SortOption? sort,
  }) {
    return FeedFilters(
      categories: categories ?? this.categories,
      freeshipOnly: freeshipOnly ?? this.freeshipOnly,
      sort: sort ?? this.sort,
    );
  }
}

Future<FeedFilters?> showFilterSheet(
  BuildContext context, {
  required List<String> availableCategories,
  required FeedFilters current,
}) {
  return showCupertinoModalPopup<FeedFilters>(
    context: context,
    builder: (context) => _FilterSheetContent(
      availableCategories: availableCategories,
      initial: current,
    ),
  );
}

class _FilterSheetContent extends StatefulWidget {
  final List<String> availableCategories;
  final FeedFilters initial;

  const _FilterSheetContent({
    required this.availableCategories,
    required this.initial,
  });

  @override
  State<_FilterSheetContent> createState() => _FilterSheetContentState();
}

class _FilterSheetContentState extends State<_FilterSheetContent> {
  late Set<String> _selectedCategories;
  late bool _freeshipOnly;
  late SortOption _sort;

  @override
  void initState() {
    super.initState();
    _selectedCategories = Set.of(widget.initial.categories);
    _freeshipOnly = widget.initial.freeshipOnly;
    _sort = widget.initial.sort;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.systemGroupedBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey3,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const Text(
              'Lọc',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            if (widget.availableCategories.isNotEmpty) ...[
              const Text(
                'DANH MỤC',
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.secondaryLabel,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: widget.availableCategories.map((cat) {
                  final selected = _selectedCategories.contains(cat);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _selectedCategories.remove(cat);
                        } else {
                          _selectedCategories.add(cat);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? CupertinoColors.activeBlue
                            : CupertinoColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 13,
                          color: selected
                              ? CupertinoColors.white
                              : CupertinoColors.label,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'GIAO HÀNG',
              style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.secondaryLabel,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _freeshipOnly = !_freeshipOnly),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: _freeshipOnly
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '🚚 Freeship',
                  style: TextStyle(
                    fontSize: 13,
                    color: _freeshipOnly
                        ? CupertinoColors.white
                        : CupertinoColors.label,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'SẮP XẾP',
              style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.secondaryLabel,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            _SortRadioRow(
              label: 'Đánh giá cao nhất',
              selected: _sort == SortOption.ratingDesc,
              onTap: () => setState(() => _sort = SortOption.ratingDesc),
            ),
            _SortRadioRow(
              label: 'Mới thêm gần đây',
              selected: _sort == SortOption.newest,
              onTap: () => setState(() => _sort = SortOption.newest),
            ),
            _SortRadioRow(
              label: 'Giá thấp đến cao',
              selected: _sort == SortOption.priceAsc,
              onTap: () => setState(() => _sort = SortOption.priceAsc),
            ),
            _SortRadioRow(
              label: 'Xem nhiều nhất',
              selected: _sort == SortOption.viewsDesc,
              onTap: () => setState(() => _sort = SortOption.viewsDesc),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    color: CupertinoColors.white,
                    onPressed: () {
                      setState(() {
                        _selectedCategories.clear();
                        _freeshipOnly = false;
                        _sort = SortOption.ratingDesc;
                      });
                    },
                    child: const Text(
                      'Đặt lại',
                      style: TextStyle(color: CupertinoColors.label),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CupertinoButton.filled(
                    onPressed: () {
                      Navigator.of(context).pop(
                        FeedFilters(
                          categories: _selectedCategories,
                          freeshipOnly: _freeshipOnly,
                          sort: _sort,
                        ),
                      );
                    },
                    child: const Text('Áp dụng'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SortRadioRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SortRadioRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Icon(
              selected
                  ? CupertinoIcons.circle_fill
                  : CupertinoIcons.circle,
              size: 18,
              color: selected
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.systemGrey3,
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
