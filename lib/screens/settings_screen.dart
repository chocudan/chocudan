import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import 'login_screen.dart';
import 'user_management_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final permissions = ref.watch(permissionsProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Trang chủ',
        middle: Text('Cài đặt'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            if (user != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: CupertinoColors.label,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.person_fill,
                        color: CupertinoColors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user.phone,
                            style: const TextStyle(
                              fontSize: 12,
                              color: CupertinoColors.secondaryLabel,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _RoleBadge(role: user.role),
                  ],
                ),
              )
            else
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeBlue.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.person,
                          color: CupertinoColors.activeBlue,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                            Text(
                              'Đang dùng ở chế độ khách — đăng nhập để thêm/sửa quán',
                              style: TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.chevron_right,
                        size: 16,
                        color: CupertinoColors.tertiaryLabel,
                      ),
                    ],
                  ),
                ),
              ),
            if (permissions.isAdmin) ...[
              const SizedBox(height: 18),
              const _SectionHeader('Quản trị'),
              CupertinoListSection.insetGrouped(
                margin: EdgeInsets.zero,
                children: [
                  CupertinoListTile(
                    leading: const Icon(CupertinoIcons.person_2),
                    title: const Text('Quản lý người dùng'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => const UserManagementScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
            const SizedBox(height: 18),
            const _SectionHeader('Thông tin'),
            CupertinoListSection.insetGrouped(
              margin: EdgeInsets.zero,
              children: const [
                CupertinoListTile(
                  leading: Icon(CupertinoIcons.info),
                  title: Text('Phiên bản'),
                  trailing: Text(
                    'v0.1.0',
                    style: TextStyle(color: CupertinoColors.secondaryLabel),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (user != null)
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: CupertinoColors.systemRed.withOpacity(0.1),
                  onPressed: () {
                    ref.read(currentUserProvider.notifier).state = null;
                    ref.read(isGuestModeProvider.notifier).state = false;
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final colors = {
      'admin': (CupertinoColors.label, CupertinoColors.white),
      'editor': (
        CupertinoColors.systemBlue.withOpacity(0.15),
        CupertinoColors.activeBlue,
      ),
      'viewer': (CupertinoColors.systemGrey5, CupertinoColors.label),
      'guest': (
        CupertinoColors.systemOrange.withOpacity(0.15),
        CupertinoColors.activeOrange,
      ),
    };
    final (bg, fg) = colors[role] ?? colors['viewer']!;
    final label = {
      'admin': 'Admin',
      'editor': 'Editor',
      'viewer': 'Viewer',
      'guest': 'Guest',
    }[role] ??
        role;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          color: CupertinoColors.secondaryLabel,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
