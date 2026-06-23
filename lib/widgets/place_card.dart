import 'package:flutter/cupertino.dart';
import '../db/database.dart';
import 'cross_platform_image.dart';
import 'open_status_badge.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final List<MenuItem> menuItems;
  final PlaceImage? primaryImage;
  final double? avgRating;
  final VoidCallback onTap;

  const PlaceCard({
    super.key,
    required this.place,
    required this.menuItems,
    required this.primaryImage,
    required this.avgRating,
    required this.onTap,
  });

  // FIX #4: Parse giá VND dạng "10.000đ" hoặc "10k" để sort/display đúng.
  // Trả về giá trị số đầu tiên tìm được (đơn vị đồng), dùng cho sort priceAsc.
  static double? parseMinPrice(String text) {
    // Thử parse "10.000đ" hoặc "10.000 đ"
    final vndRegex = RegExp(r'([\d.]+)\s*đ');
    for (final m in vndRegex.allMatches(text)) {
      final v = double.tryParse(m.group(1)!.replaceAll('.', ''));
      if (v != null) return v;
    }
    // Fallback: parse "10k"
    final kRegex = RegExp(r'(\d+(?:\.\d+)?)\s*k');
    for (final m in kRegex.allMatches(text)) {
      final v = double.tryParse(m.group(1)!);
      if (v != null) return v * 1000;
    }
    return null;
  }

  // Tính min price từ toàn bộ menu items (dùng cho sort ở feed_screen)
  static double? minPriceFromMenu(List<MenuItem> items) {
    double? min;
    for (final item in items) {
      final p = parseMinPrice(item.priceText);
      if (p != null && (min == null || p < min)) min = p;
    }
    return min;
  }

  // FIX #4: Format hiển thị giá từ avgPriceRange theo chuẩn VND
  String _displayPriceRange() {
    final raw = place.avgPriceRange;
    if (raw != null && raw.isNotEmpty) return raw;
    // fallback tính từ menu
    if (menuItems.isEmpty) return '';
    final prices = <double>[];
    for (final item in menuItems) {
      // thử VND trước
      final vndRegex = RegExp(r'([\d.]+)\s*đ');
      bool foundVnd = false;
      for (final m in vndRegex.allMatches(item.priceText)) {
        final v = double.tryParse(m.group(1)!.replaceAll('.', ''));
        if (v != null) { prices.add(v); foundVnd = true; }
      }
      if (!foundVnd) {
        final kRegex = RegExp(r'(\d+(?:\.\d+)?)\s*k');
        for (final m in kRegex.allMatches(item.priceText)) {
          final v = double.tryParse(m.group(1)!);
          if (v != null) prices.add(v * 1000);
        }
      }
    }
    if (prices.isEmpty) return '';
    prices.sort();
    String fmt(double v) {
      final i = v.toInt();
      // Format kiểu 10.000đ
      final s = i.toString();
      final buf = StringBuffer();
      for (var j = 0; j < s.length; j++) {
        if (j > 0 && (s.length - j) % 3 == 0) buf.write('.');
        buf.write(s[j]);
      }
      return '${buf}đ';
    }
    if (prices.first == prices.last) return fmt(prices.first);
    return '${fmt(prices.first)} - ${fmt(prices.last)}';
  }

  // FIX #3: Format thời gian cập nhật ngắn gọn
  String _formatUpdatedAt(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'vừa xong';
    if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
    if (diff.inDays < 1) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bestSellers =
        menuItems.where((m) => m.isBestSeller).map((m) => m.name).toList();

    // FIX #5: Hiển thị bestsellers trước, sau đó món thường — tối đa 4 món
    final previewItems = (bestSellers.isNotEmpty
            ? [
                ...bestSellers,
                ...menuItems
                    .where((m) => !m.isBestSeller)
                    .map((m) => m.name),
              ]
            : menuItems.map((m) => m.name).toList())
        .take(4)
        .toList();

    final priceRange = _displayPriceRange();

    // FIX #2: Layout responsive — desktop dùng Row (avatar trái, info phải)
    // Mobile vẫn dùng layout dọc với ảnh full-width trên cùng
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: isWide
                ? _WideLayout(
                    place: place,
                    menuItems: menuItems,
                    primaryImage: primaryImage,
                    avgRating: avgRating,
                    priceRange: priceRange,
                    previewItems: previewItems,
                    bestSellers: bestSellers,
                    formatUpdatedAt: _formatUpdatedAt,
                  )
                : _NarrowLayout(
                    place: place,
                    menuItems: menuItems,
                    primaryImage: primaryImage,
                    avgRating: avgRating,
                    priceRange: priceRange,
                    previewItems: previewItems,
                    bestSellers: bestSellers,
                    formatUpdatedAt: _formatUpdatedAt,
                  ),
          ),
        );
      },
    );
  }
}

// ── Layout mobile (cũ, giữ nguyên cảm giác) ──────────────────────────────────
class _NarrowLayout extends StatelessWidget {
  final Place place;
  final List<MenuItem> menuItems;
  final PlaceImage? primaryImage;
  final double? avgRating;
  final String priceRange;
  final List<String> previewItems;
  final List<String> bestSellers;
  final String Function(DateTime) formatUpdatedAt;

  const _NarrowLayout({
    required this.place,
    required this.menuItems,
    required this.primaryImage,
    required this.avgRating,
    required this.priceRange,
    required this.previewItems,
    required this.bestSellers,
    required this.formatUpdatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (primaryImage != null)
          SizedBox(
            height: 140,
            width: double.infinity,
            child: CrossPlatformImage(
              path: primaryImage!.localPath,
              width: double.infinity,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: _CardBody(
            place: place,
            menuItems: menuItems,
            avgRating: avgRating,
            priceRange: priceRange,
            previewItems: previewItems,
            bestSellers: bestSellers,
            formatUpdatedAt: formatUpdatedAt,
          ),
        ),
      ],
    );
  }
}

// FIX #2: Layout desktop — avatar nhỏ bên trái, thông tin bên phải
class _WideLayout extends StatelessWidget {
  final Place place;
  final List<MenuItem> menuItems;
  final PlaceImage? primaryImage;
  final double? avgRating;
  final String priceRange;
  final List<String> previewItems;
  final List<String> bestSellers;
  final String Function(DateTime) formatUpdatedAt;

  const _WideLayout({
    required this.place,
    required this.menuItems,
    required this.primaryImage,
    required this.avgRating,
    required this.priceRange,
    required this.previewItems,
    required this.bestSellers,
    required this.formatUpdatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar nhỏ bên trái — chiều cao cố định 120
        if (primaryImage != null)
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
            child: SizedBox(
              width: 110,
              height: 120,
              child: CrossPlatformImage(
                path: primaryImage!.localPath,
                width: 110,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          Container(
            width: 110,
            height: 120,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
            child: const Center(
              child: Icon(
                CupertinoIcons.photo,
                size: 32,
                color: CupertinoColors.tertiaryLabel,
              ),
            ),
          ),
        // Thông tin bên phải
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: _CardBody(
              place: place,
              menuItems: menuItems,
              avgRating: avgRating,
              priceRange: priceRange,
              previewItems: previewItems,
              bestSellers: bestSellers,
              formatUpdatedAt: formatUpdatedAt,
            ),
          ),
        ),
      ],
    );
  }
}

// Body dùng chung cho cả 2 layout
class _CardBody extends StatelessWidget {
  final Place place;
  final List<MenuItem> menuItems;
  final double? avgRating;
  final String priceRange;
  final List<String> previewItems;
  final List<String> bestSellers;
  final String Function(DateTime) formatUpdatedAt;

  const _CardBody({
    required this.place,
    required this.menuItems,
    required this.avgRating,
    required this.priceRange,
    required this.previewItems,
    required this.bestSellers,
    required this.formatUpdatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tên + badge freeship
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (place.address != null)
                    Text(
                      place.address!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  else if (place.phone != null)
                    Text(
                      place.phone!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                ],
              ),
            ),
            if (place.freeship)
              _Badge(
                text: 'Freeship',
                bg: CupertinoColors.systemGreen.withOpacity(0.15),
                fg: CupertinoColors.activeGreen,
              ),
          ],
        ),

        // FIX #4+#3: Giá VND + số món + view count + thời gian cập nhật
        const SizedBox(height: 8),
        Row(
          children: [
            if (priceRange.isNotEmpty) ...[
              Text(
                priceRange,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: CupertinoColors.label,
                ),
              ),
              const SizedBox(width: 6),
            ],
            if (menuItems.isNotEmpty)
              Text(
                '· ${menuItems.length} món',
                style: const TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            const Spacer(),
            // FIX #3: lượt xem
            const Icon(
              CupertinoIcons.eye,
              size: 12,
              color: CupertinoColors.tertiaryLabel,
            ),
            const SizedBox(width: 3),
            Text(
              '${place.viewCount}',
              style: const TextStyle(
                fontSize: 11,
                color: CupertinoColors.tertiaryLabel,
              ),
            ),
            const SizedBox(width: 8),
            // FIX #3: thời gian cập nhật
            Text(
              formatUpdatedAt(place.updatedAt),
              style: const TextStyle(
                fontSize: 11,
                color: CupertinoColors.tertiaryLabel,
              ),
            ),
          ],
        ),

        // FIX #5: Hiển thị món + giá rõ ràng — bestseller nổi bật với 🔥 + màu cam
        if (previewItems.isNotEmpty) ...[
          const SizedBox(height: 8),
          _MenuPreview(
            previewItems: previewItems,
            bestSellers: bestSellers,
            menuItems: menuItems,
          ),
        ],

        // Footer: giờ mở + rating
        const SizedBox(height: 8),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: CupertinoColors.systemGrey5,
                width: 0.5,
              ),
            ),
          ),
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (place.openHours != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🕐 ${place.openHours}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                    OpenStatusBadge(openHours: place.openHours),
                  ],
                )
              else
                const SizedBox(),
              if (avgRating != null)
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.star_fill,
                      size: 13,
                      color: CupertinoColors.systemYellow,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      avgRating!.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              else
                const Text(
                  'Chưa rate',
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.tertiaryLabel,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// FIX #5: Widget hiển thị menu preview — bestseller nổi bật, kèm giá
class _MenuPreview extends StatelessWidget {
  final List<String> previewItems;
  final List<String> bestSellers;
  final List<MenuItem> menuItems;

  const _MenuPreview({
    required this.previewItems,
    required this.bestSellers,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    // Map tên món -> giá để hiển thị kèm
    final priceMap = {for (final m in menuItems) m.name: m.priceText};

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: previewItems.map((name) {
        final isBest = bestSellers.contains(name);
        final price = priceMap[name] ?? '';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isBest
                ? CupertinoColors.systemOrange.withOpacity(0.12)
                : CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(8),
            border: isBest
                ? Border.all(
                    color: CupertinoColors.systemOrange.withOpacity(0.4),
                    width: 0.8,
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isBest) ...[
                const Text('🔥', style: TextStyle(fontSize: 11)),
                const SizedBox(width: 3),
              ],
              Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  color: isBest
                      ? const Color(0xFFD4500A)
                      : CupertinoColors.label,
                  fontWeight:
                      isBest ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (price.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 11,
                    color: isBest
                        ? const Color(0xFFD4500A).withOpacity(0.8)
                        : CupertinoColors.secondaryLabel,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _Badge({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
