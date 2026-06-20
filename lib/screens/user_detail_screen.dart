import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../db/database.dart';
import '../providers/app_providers.dart';

class UserDetailScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  ConsumerState<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends ConsumerState<UserDetailScreen> {
  User? _user;
  bool _loading = true;

  String _role = 'viewer';
  bool _canAdd = false;
  bool _canEdit = false;
  bool _canDelete = false;
  bool _canRate = false;

  static const _roleDefaults = {
    'admin': (true, true, true, true),
    'editor': (true, true, false, true),
    'viewer': (false, false, false, true),
    'guest': (false, false, false, false),
  };

  static const _roleLabels = {
    'admin': ('Admin', 'Toàn quyền, quản lý người dùng'),
    'editor': ('Editor', 'Thêm, sửa quán — không xoá'),
    'viewer': ('Viewer', 'Xem và đánh giá, không sửa'),
    'guest': ('Guest', 'Chỉ xem, không đánh giá'),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final user = await db.getUserById(widget.userId);
    if (!mounted || user == null) return;
    setState(() {
      _user = user;
      _role = user.role;
      _canAdd = user.canAddPlace;
      _canEdit = user.canEditPlace;
      _canDelete = user.canDeletePlace;
      _canRate = user.canRate;
      _loading = false;
    });
  }

  void _selectRole(String role) {
    final defaults = _roleDefaults[role]!;
    setState(() {
      _role = role;
      _canAdd = defaults.$1;
      _canEdit = defaults.$2;
      _canDelete = defaults.$3;
      _canRate = defaults.$4;
    });
  }

  Future<void> _save() async {
    if (_user == null) return;
    final db = ref.read(databaseProvider);
    await db.updateUser(
      _user!.toCompanion(true).copyWith(
            role: Value(_role),
            canAddPlace: Value(_canAdd),
            canEditPlace: Value(_canEdit),
            canDeletePlace: Value(_canDelete),
            canRate: Value(_canRate),
          ),
    );

    // Nếu đang sửa chính mình, cập nhật luôn provider hiện tại
    final current = ref.read(currentUserProvider);
    if (current?.id == _user!.id) {
      final updated = await db.getUserById(_user!.id);
      ref.read(currentUserProvider.notifier).state = updated;
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _user == null) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Danh sách',
        middle: const Text('Phân quyền'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _save,
          child: const Text('Lưu'),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: CupertinoColors.systemGrey3,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.person_fill,
                      color: CupertinoColors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _user!.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _user!.phone,
                    style: const TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _SectionHeader('Vai trò'),
            CupertinoListSection.insetGrouped(
              margin: EdgeInsets.zero,
              children: _roleLabels.entries.map((entry) {
                final selected = _role == entry.key;
                return CupertinoListTile(
                  leading: Icon(
                    selected
                        ? CupertinoIcons.circle_fill
                        : CupertinoIcons.circle,
                    size: 20,
                    color: selected
                        ? CupertinoColors.activeBlue
                        : CupertinoColors.systemGrey3,
                  ),
                  title: Text(entry.value.$1),
                  subtitle: Text(
                    entry.value.$2,
                    style: const TextStyle(fontSize: 11),
                  ),
                  onTap: () => _selectRole(entry.key),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            const _SectionHeader('Quyền chi tiết'),
            CupertinoListSection.insetGrouped(
              margin: EdgeInsets.zero,
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.add_circled),
                  title: const Text('Thêm quán'),
                  trailing: CupertinoSwitch(
                    value: _canAdd,
                    onChanged: (v) => setState(() => _canAdd = v),
                  ),
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.pencil),
                  title: const Text('Sửa quán'),
                  trailing: CupertinoSwitch(
                    value: _canEdit,
                    onChanged: (v) => setState(() => _canEdit = v),
                  ),
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.delete),
                  title: const Text('Xoá quán'),
                  trailing: CupertinoSwitch(
                    value: _canDelete,
                    onChanged: (v) => setState(() => _canDelete = v),
                  ),
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.star),
                  title: const Text('Đánh giá'),
                  trailing: CupertinoSwitch(
                    value: _canRate,
                    onChanged: (v) => setState(() => _canRate = v),
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
