import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/database.dart';
import '../providers/app_providers.dart';
import 'user_detail_screen.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  List<User> _users = [];
  bool _loading = true;
  String _search = '';
  String? _roleFilter;

  static const _roles = ['admin', 'editor', 'viewer', 'guest'];
  static const _roleLabels = {
    'admin': 'Admin',
    'editor': 'Editor',
    'viewer': 'Viewer',
    'guest': 'Guest',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final db = ref.read(databaseProvider);
    final users = await db.getAllUsers();
    if (!mounted) return;
    setState(() {
      _users = users;
      _loading = false;
    });
  }

  List<User> get _filtered {
    var result = _users;
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      result = result
          .where((u) =>
              u.name.toLowerCase().contains(q) || u.phone.contains(q))
          .toList();
    }
    if (_roleFilter != null) {
      result = result.where((u) => u.role == _roleFilter).toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Cài đặt',
        middle: Text('Quản lý người dùng'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: CupertinoSearchTextField(
                placeholder: 'Tìm theo tên, SĐT...',
                onChanged: (v) => setState(() => _search = v.trim()),
              ),
            ),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _RoleChip(
                    label: 'Tất cả',
                    selected: _roleFilter == null,
                    onTap: () => setState(() => _roleFilter = null),
                  ),
                  ..._roles.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: _RoleChip(
                        label: _roleLabels[r]!,
                        selected: _roleFilter == r,
                        onTap: () => setState(() => _roleFilter = r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(child: CupertinoActivityIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final user = _filtered[index];
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (_) =>
                                    UserDetailScreen(userId: user.id),
                              ),
                            );
                            _load();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: user.role == 'admin'
                                        ? CupertinoColors.label
                                        : CupertinoColors.systemGrey3,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.person_fill,
                                    color: CupertinoColors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        user.phone,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color:
                                              CupertinoColors.secondaryLabel,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _RoleBadgeSmall(role: user.role),
                                const SizedBox(width: 6),
                                const Icon(
                                  CupertinoIcons.chevron_right,
                                  size: 14,
                                  color: CupertinoColors.tertiaryLabel,
                                ),
                              ],
                            ),
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

class _RoleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? CupertinoColors.label : CupertinoColors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selected ? CupertinoColors.white : CupertinoColors.label,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleBadgeSmall extends StatelessWidget {
  final String role;
  const _RoleBadgeSmall({required this.role});

  @override
  Widget build(BuildContext context) {
    final styles = {
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
    final (bg, fg) = styles[role] ?? styles['viewer']!;
    final labels = {
      'admin': 'Admin',
      'editor': 'Editor',
      'viewer': 'Viewer',
      'guest': 'Guest',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        labels[role] ?? role,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
