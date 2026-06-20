import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import 'feed_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(permissionsProvider);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Vinhomes Q9'),
            trailing: permissions.isAdmin
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                    child: const Icon(CupertinoIcons.settings),
                  )
                : null,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bạn muốn tìm gì hôm nay?',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ModeCard(
                    icon: CupertinoIcons.flame_fill,
                    iconColor: CupertinoColors.activeGreen,
                    iconBg: CupertinoColors.systemGreen.withOpacity(0.15),
                    title: 'Ăn uống',
                    subtitle: 'Quán ăn, vendor, đồ ăn vặt quanh khu vực',
                    onTap: () {
                      ref.read(currentPlaceTypeProvider.notifier).state =
                          'food';
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) =>
                              const FeedScreen(type: 'food', title: 'Ăn uống'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _ModeCard(
                    icon: CupertinoIcons.map_pin_ellipse,
                    iconColor: CupertinoColors.activeBlue,
                    iconBg: CupertinoColors.systemBlue.withOpacity(0.15),
                    title: 'Đi chơi',
                    subtitle: 'Địa điểm vui chơi, cafe, giải trí',
                    onTap: () {
                      ref.read(currentPlaceTypeProvider.notifier).state =
                          'destination';
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => const FeedScreen(
                            type: 'destination',
                            title: 'Đi chơi',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: CupertinoColors.tertiaryLabel,
            ),
          ],
        ),
      ),
    );
  }
}
