import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:url_launcher/url_launcher.dart';
import '../db/database.dart';
import '../db/id_helper.dart';
import '../providers/app_providers.dart';
import '../services/image_storage_helper.dart';
import '../widgets/cross_platform_image.dart';
import '../widgets/image_viewer_screen.dart';
import '../widgets/open_status_badge.dart';
import '../widgets/comment_section.dart';
import '../widgets/multi_image_picker.dart';
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
  bool _viewCounted = false;

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

    if (!_viewCounted) {
      _viewCounted = true;
      await db.incrementViewCount(widget.placeId);
    }

    if (!mounted) return;
    setState(() {
      _place = place;
      _menuItems = menuItems;
      _images = images;
      _ratings = ratings;
      _loading = false;
    });
  }

  List<PlaceImage> get _sortedImages {
    final list = List<PlaceImage>.of(_images);
    list.sort((a, b) {
      if (a.isPrimary == b.isPrimary) return 0;
      return a.isPrimary ? -1 : 1;
    });
    return list;
  }

  Future<void> _openImagePicker() async {
    final draftImages = _images
        .map((img) =>
            DraftImage(localPath: img.localPath, isPrimary: img.isPrimary))
        .toList();

    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: CupertinoColors.systemGroupedBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quản lý ảnh',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await _syncImages(draftImages);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: const Text('Xong'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: MultiImagePicker(
                    initialImages: draftImages,
                    onChanged: (imgs) {
                      draftImages
                        ..clear()
                        ..addAll(imgs);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _syncImages(List<DraftImage> draftImages) async {
    final db = ref.read(databaseProvider);
    final oldImages = await db.getImagesForPlace(widget.placeId);
    for (final img in oldImages) {
      await db.deletePlaceImage(img.id);
    }
    for (final draft in draftImages) {
      await db.insertPlaceImage(
        PlaceImagesCompanion.insert(
          id: newId(),
          placeId: widget.placeId,
          localPath: draft.localPath,
          isPrimary: Value(draft.isPrimary),
        ),
      );
    }
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

  void _showActionMenu(
    BuildContext context,
    Place place,
    Permissions permissions,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(place.name),
        actions: [
          if (permissions.canEditPlace)
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.of(this.context).push(
                  CupertinoPageRoute(
                    builder: (_) => AddEditPlaceScreen(
                      type: place.type,
                      existingPlace: place,
                    ),
                  ),
                );
                _loadData();
              },
              child: const Text('Sửa thông tin'),
            ),
          if (permissions.canDeletePlace)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDeletePlace(place);
              },
              child: const Text('Xoá quán'),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Huỷ'),
        ),
      ),
    );
  }

  void _confirmDeletePlace(Place place) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Xoá quán này?'),
        content: Text(
          '"${place.name}" cùng toàn bộ món ăn, ảnh, đánh giá sẽ bị xoá '
          'vĩnh viễn. Hành động này không thể hoàn tác.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Huỷ'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              final db = ref.read(databaseProvider);
              await db.deleteMenuItemsForPlace(place.id);
              for (final img in _images) {
                await db.deletePlaceImage(img.id);
                await ImageStorageHelper.deleteImageFile(img.localPath);
              }
              await db.deletePlace(place.id);
              if (!mounted) return;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
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
    final categoryTags = (place.category ?? '')
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    final sortedImages = _sortedImages;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: widget.backTitle,
        middle: const Text('Chi tiết'),
        trailing: (permissions.canEditPlace || permissions.canDeletePlace)
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showActionMenu(context, place, permissions),
                child: const Icon(CupertinoIcons.ellipsis_circle),
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
                  crossAxisAlignment: WrapCrossAlignment.center,
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '🕐 ${place.openHours}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.secondaryLabel,
                            ),
                          ),
                          OpenStatusBadge(openHours: place.openHours),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (place.avgPriceRange != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '💰 ${place.avgPriceRange}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.eye,
                          size: 13,
                          color: CupertinoColors.tertiaryLabel,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${place.viewCount} lượt xem',
                          style: const TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.tertiaryLabel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (categoryTags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: categoryTags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: CupertinoColors.activeBlue
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 11,
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                if (place.freeshipNote != null) ...[
                  const SizedBox(height: 6),
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
                      if (permissions.canEditPlace)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _openImagePicker,
                          child: Container(
                            width: 90,
                            height: 90,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: CupertinoColors.systemGrey3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.photo_on_rectangle,
                                  color: CupertinoColors.activeBlue,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Quản lý ảnh',
                                  style: TextStyle(fontSize: 9),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ...sortedImages.asMap().entries.map(
                        (entry) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (_) => ImageViewerScreen(
                                  imagePaths: sortedImages
                                      .map((i) => i.localPath)
                                      .toList(),
                                  initialIndex: entry.key,
                                  onDelete: permissions.canEditPlace
                                      ? (index) async {
                                          final db =
                                              ref.read(databaseProvider);
                                          final imgToDelete =
                                              sortedImages[index];
                                          await db.deletePlaceImage(
                                            imgToDelete.id,
                                          );
                                          await ImageStorageHelper
                                              .deleteImageFile(
                                            imgToDelete.localPath,
                                          );
                                          _loadData();
                                        }
                                      : null,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                margin: const EdgeInsets.only(right: 8),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: entry.value.isPrimary
                                      ? Border.all(
                                          color: CupertinoColors.activeBlue,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: CrossPlatformImage(
                                  path: entry.value.localPath,
                                  width: 90,
                                  height: 90,
                                ),
                              ),
                              if (entry.value.isPrimary)
                                const Positioned(
                                  bottom: 3,
                                  left: 3,
                                  child: Icon(
                                    CupertinoIcons.star_fill,
                                    size: 14,
                                    color: CupertinoColors.systemYellow,
                                  ),
                                ),
                            ],
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
                                      child: Text(
                                        '🔥',
                                        style: TextStyle(fontSize: 12),
                                      ),
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
                  const SizedBox(height: 16),
                ],
                CommentSection(placeId: widget.placeId),
                const SizedBox(height: 16),
                Text(
                  'Cập nhật lần cuối: ${_formatDate(place.updatedAt)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: CupertinoColors.tertiaryLabel,
                  ),
                ),
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
