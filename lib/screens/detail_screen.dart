import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../db/database.dart';
import '../db/id_helper.dart';
import '../providers/app_providers.dart';
import '../widgets/cross_platform_image.dart';
import 'add_edit_place_screen.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String placeId;
  final String backTitle;

  const DetailScreen({
    super.key,
    required this.placeId,
    required this.backTitle,
  });

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  Place? _place;
  List<MenuItem> _menuItems = [];
  List<PlaceImage> _images = [];
  List<Rating> _ratings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final db = ref.read(databaseProvider);
    final place = await db.getPlaceById(widget.placeId);
    final menuItems = await db.getMenuItemsForPlace(widget.placeId);
    final images = await db.getImagesForPlace(widget.placeId);
    final ratings = await db.getRatingsForPlace(widget.placeId);

    if (!mounted) return;
    setState(() {
      _place = place;
      _menuItems = menuItems;
      _images = images;
      _ratings = ratings;
      _loading = false;
    });
  }

  Future<void> _addImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final db = ref.read(databaseProvider);
    await db.insertPlaceImage(
      PlaceImagesCompanion.insert(
        id: newId(),
        placeId: widget.placeId,
        localPath: picked.path,
        isPrimary: Value(_images.isEmpty),
      ),
    );
    _loadData();
  }

  Future<void> _callPhone() async {
    if (_place?.phone == null) return;
    final uri = Uri.parse('tel:${_place!.phone}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openZalo() async {
    if (_place?.phone == null) return;
    final cleanPhone = _place!.phone!.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://zalo.me/$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _showRatingSheet() async {
    int selectedStars = 5;
    final noteController = TextEditingController();

    await showCupertinoModalPopup(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          decoration: const BoxDecoration(
            color: CupertinoColors.systemGroupedBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Đánh giá quán',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () =>
                          setSheetState(() => selectedStars = i + 1),
                      child: Icon(
                        i < selectedStars
                            ? CupertinoIcons.star_fill
                            : CupertinoIcons.star,
                        color: CupertinoColors.systemYellow,
                        size: 32,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 14),
                CupertinoTextField(
                  controller: noteController,
                  placeholder: 'Ghi chú (không bắt buộc)',
                  maxLines: 3,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: () async {
                      final db = ref.read(databaseProvider);
                      final user = ref.read(currentUserProvider);
                      await db.insertRating(
                        RatingsCompanion.insert(
                          id: newId(),
                          placeId: widget.placeId,
                          userId: Value(user?.id),
                          stars: selectedStars,
                          note: Value(
                            noteController.text.trim().isEmpty
                                ? null
                                : noteController.text.trim(),
                          ),
                        ),
                      );
                      if (context.mounted) Navigator.of(context).pop();
                      _loadData();
                    },
                    child: const Text('Lưu đánh giá'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, List<MenuItem>> get _groupedMenu {
    final map = <String, List<MenuItem>>{};
    for (final item in _menuItems) {
      final group = item.categoryGroup ?? 'Khác';
      map.putIfAbsent(group, () => []).add(item);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final permissions = ref.watch(permissionsProvider);

    if (_loading || _place == null) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    final place = _place!;
    final avgRating = _ratings.isEmpty
        ? null
        : _ratings.map((r) => r.stars).reduce((a, b) => a + b) /
            _ratings.length;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: widget.backTitle,
        middle: const Text('Chi tiết'),
        trailing: permissions.canEditPlace
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => AddEditPlaceScreen(
                        type: place.type,
                        existingPlace: place,
                      ),
                    ),
                  );
                  _loadData();
                },
                child: const Text('Sửa'),
              )
            : null,
      ),
      child: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
              children: [
                Text(
                  place.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 10,
                  children: [
                    if (place.address != null)
                      Text(
                        '📍 ${place.address}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                    if (place.openHours != null)
                      Text(
                        '🕐 ${place.openHours}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                  ],
                ),
                if (place.freeshipNote != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '🚚 ${place.freeshipNote}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.activeGreen,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: _addImage,
                        child: Container(
                          width: 90,
                          height: 90,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CupertinoColors.systemGrey3,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.add,
                                color: CupertinoColors.activeBlue,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Thêm ảnh',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ..._images.map(
                        (img) => Container(
                          width: 90,
                          height: 90,
                          margin: const EdgeInsets.only(right: 8),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CrossPlatformImage(
                            path: img.localPath,
                            width: 90,
                            height: 90,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ..._groupedMenu.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6, left: 2),
                        child: Text(
                          entry.key.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.secondaryLabel,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          children: entry.value.asMap().entries.map((e) {
                            final isLast = e.key == entry.value.length - 1;
                            final item = e.value;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
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
                              child: Row(
                                children: [
                                  if (item.isBestSeller)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Text('🔥', style: TextStyle(fontSize: 12)),
                                    ),
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Text(
                                    item.priceText,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.secondaryLabel,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }),
                if (place.note != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemYellow.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Ghi chú: ${place.note}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                if (avgRating != null) ...[
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.star_fill,
                        size: 16,
                        color: CupertinoColors.systemYellow,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${avgRating.toStringAsFixed(1)} (${_ratings.length} đánh giá)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ..._ratings.where((r) => r.note != null).map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '"${r.note}"',
                            style: const TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: CupertinoColors.secondaryLabel,
                            ),
                          ),
                        ),
                      ),
                ],
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: CupertinoColors.white,
                  border: Border(
                    top: BorderSide(
                      color: CupertinoColors.systemGrey5,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: CupertinoIcons.phone,
                        label: 'Gọi',
                        enabled: place.phone != null,
                        onTap: _callPhone,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ActionButton(
                        icon: CupertinoIcons.chat_bubble,
                        label: 'Zalo',
                        enabled: place.phone != null,
                        filled: true,
                        onTap: _openZalo,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ActionButton(
                        icon: CupertinoIcons.star,
                        label: 'Đánh giá',
                        enabled: permissions.canRate,
                        onTap: _showRatingSheet,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: filled
          ? CupertinoColors.activeBlue.withOpacity(0.15)
          : CupertinoColors.systemGrey6,
      borderRadius: BorderRadius.circular(10),
      onPressed: enabled ? onTap : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: enabled
                ? (filled
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.label)
                : CupertinoColors.tertiaryLabel,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: enabled
                  ? (filled
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.label)
                  : CupertinoColors.tertiaryLabel,
            ),
          ),
        ],
      ),
    );
  }
}
