import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/database.dart';
import '../providers/app_providers.dart';
import '../widgets/place_card.dart';
import '../widgets/filter_sheet.dart';
import 'detail_screen.dart';
import 'add_edit_place_screen.dart';

class FeedScreen extends ConsumerStatefulWidget {
  final String type; // "food" | "destination"
  final String title;

  const FeedScreen({super.key, required this.type, required this.title});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  FeedFilters _filters = const FeedFilters();

  List<Place> _places = [];
  Map<String, List<MenuItem>> _menuByPlace = {};
  Map<String, double?> _ratingByPlace = {};
  Map<String, PlaceImage?> _primaryImageByPlace = {};
  List<String> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final db = ref.read(databaseProvider);
    final places = await db.getPlacesByType(widget.type);
    final categories = await db.getDistinctCategories(widget.type);

    final menuMap = <String, List<MenuItem>>{};
    final ratingMap = <String, double?>{};
    final imageMap = <String, PlaceImage?>{};
    for (final place in places) {
      menuMap[place.id] = await db.getMenuItemsForPlace(place.id);
      ratingMap[place.id] = await db.getAverageRating(place.id);
      final images = await db.getImagesForPlace(place.id);
      imageMap[place.id] = images.isEmpty
          ? null
          : images.firstWhere(
              (img) => img.isPrimary,
              orElse: () => images.first,
            );
    }

    if (!mounted) return;
    setState(() {
      _places = places;
      _menuByPlace = menuMap;
      _ratingByPlace = ratingMap;
      _primaryImageByPlace = imageMap;
      _categories = categories;
      _loading = false;
    });
  }

  /// Lấy danh sách tag của 1 quán từ chuỗi "Ăn uống,Bánh" -> ["Ăn uống","Bánh"]
  List<String> _tagsOf(Place p) {
    return (p.category ?? '')
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
  }

  List<Place> get _filteredPlaces {
    var result = _places;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((p) {
        final nameMatch = p.name.toLowerCase().contains(q);
        final menuMatch = (_menuByPlace[p.id] ?? [])
            .any((m) => m.name.toLowerCase().contains(q));
        return nameMatch || menuMatch;
      }).toList();
    }

    if (_filters.categories.isNotEmpty) {
      // Quán khớp filter nếu có ÍT NHẤT 1 tag trùng với tag đã chọn
      // (không phải so khớp toàn bộ chuỗi category).
      result = result.where((p) {
        final placeTags = _tagsOf(p);
        return placeTags.any((tag) => _filters.categories.contains(tag));
      }).toList();
    }

    if (_filters.freeshipOnly) {
      result = result.where((p) => p.freeship).toList();
    }

    final sorted = [...result];
    switch (_filters.sort) {
      case SortOption.ratingDesc:
        sorted.sort((a, b) {
          final ra = _ratingByPlace[a.id] ?? -1;
          final rb = _ratingByPlace[b.id] ?? -1;
          return rb.compareTo(ra);
        });
        break;
      case SortOption.newest:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.priceAsc:
        // Giữ nguyên thứ tự — việc tính giá thấp nhất chính xác để sort
        // cần parse phức tạp hơn, ưu tiên đơn giản cho MVP.
        break;
      case SortOption.viewsDesc:
        sorted.sort((a, b) => b.viewCount.compareTo(a.viewCount));
        break;
    }

    return sorted;
  }

  Future<void> _openFilterSheet() async {
    final result = await showFilterSheet(
      context,
      availableCategories: _categories,
      current: _filters,
    );
    if (result != null) {
      setState(() => _filters = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissions = ref.watch(permissionsProvider);
    final filtered = _filteredPlaces;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Trang chủ',
        middle: Text(widget.title),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoSearchTextField(
                          controller: _searchController,
                          placeholder: 'Tìm shop, món...',
                          onChanged: (v) =>
                              setState(() => _searchQuery = v.trim()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(10),
                        onPressed: _openFilterSheet,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              CupertinoIcons.slider_horizontal_3,
                              size: 16,
                              color: CupertinoColors.label,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _filters.categories.isEmpty
                                  ? 'Lọc'
                                  : 'Lọc (${_filters.categories.length})',
                              style: const TextStyle(
                                color: CupertinoColors.label,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _loading
                      ? const Center(child: CupertinoActivityIndicator())
                      : filtered.isEmpty
                          ? _EmptyState(type: widget.type)
                          : CustomScrollView(
                              slivers: [
                                CupertinoSliverRefreshControl(
                                  onRefresh: _loadData,
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    80,
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final place = filtered[index];
                                        return PlaceCard(
                                          place: place,
                                          menuItems:
                                              _menuByPlace[place.id] ?? [],
                                          primaryImage:
                                              _primaryImageByPlace[place.id],
                                          avgRating: _ratingByPlace[place.id],
                                          onTap: () async {
                                            await Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                builder: (_) => DetailScreen(
                                                  placeId: place.id,
                                                  backTitle: widget.title,
                                                ),
                                              ),
                                            );
                                            _loadData();
                                          },
                                        );
                                      },
                                      childCount: filtered.length,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                ),
              ],
            ),
            if (permissions.canAddPlace)
              Positioned(
                bottom: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => AddEditPlaceScreen(type: widget.type),
                      ),
                    );
                    _loadData();
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: CupertinoColors.activeBlue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x40007AFF),
                          blurRadius: 14,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.add,
                      color: CupertinoColors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String type;

  const _EmptyState({required this.type});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type == 'food'
                  ? CupertinoIcons.flame
                  : CupertinoIcons.map_pin_ellipse,
              size: 40,
              color: CupertinoColors.tertiaryLabel,
            ),
            const SizedBox(height: 12),
            Text(
              type == 'food'
                  ? 'Chưa có quán nào. Bấm "+" để thêm quán đầu tiên!'
                  : 'Chưa có địa điểm nào. Bấm "+" để thêm địa điểm đầu tiên!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
