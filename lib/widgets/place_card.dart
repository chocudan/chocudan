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

  String _priceRangeText() {
    if (menuItems.isEmpty) return '';
    final prices = <double>[];
    final regex = RegExp(r'(\d+(?:\.\d+)?)\s*k');
    for (final item in menuItems) {
      for (final m in regex.allMatches(item.priceText)) {
        final v = double.tryParse(m.group(1)!);
        if (v != null) prices.add(v);
      }
    }
    if (prices.isEmpty) return '';
    prices.sort();
    final min = prices.first.toStringAsFixed(
      prices.first.truncateToDouble() == prices.first ? 0 : 1,
    );
    final max = prices.last.toStringAsFixed(
      prices.last.truncateToDouble() == prices.last ? 0 : 1,
    );
    if (min == max) return '${min}k';
    return '${min}k - ${max}k';
  }

  @override
  Widget build(BuildContext context) {
    final bestSellers =
        menuItems.where((m) => m.isBestSeller).map((m) => m.name).toList();
    final previewItems = (bestSellers.isNotEmpty
            ? bestSellers
            : menuItems.map((m) => m.name).toList())
        .take(3)
        .toList();
    final priceRange = place.avgPriceRange ?? _priceRangeText();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  if (priceRange.isNotEmpty || menuItems.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (priceRange.isNotEmpty)
                          Text(
                            priceRange,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        if (menuItems.isNotEmpty)
                          Text(
                            ' · ${menuItems.length} món',
                            style: const TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.secondaryLabel,
                            ),
                          ),
                      ],
                    ),
                  ],
                  if (previewItems.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: previewItems
                          .map(
                            (name) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey6,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                bestSellers.contains(name)
                                    ? '🔥 $name'
                                    : name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.label,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
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
              ),
            ),
          ],
        ),
      ),
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
