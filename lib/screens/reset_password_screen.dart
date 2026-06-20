import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../db/database.dart';
import '../db/id_helper.dart';
import '../providers/app_providers.dart';
import '../widgets/cupertino_form_row.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String phone;

  const ResetPasswordScreen({super.key, required this.phone});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (password.length < 6) {
      setState(() => _error = 'Mật khẩu cần tối thiểu 6 ký tự');
      return;
    }
    if (password != confirm) {
      setState(() => _error = 'Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final db = ref.read(databaseProvider);
    final user = await db.getUserByPhone(widget.phone);
    if (user == null) {
      setState(() {
        _loading = false;
        _error = 'Có lỗi xảy ra, vui lòng thử lại';
      });
      return;
    }

    await db.updateUser(
      user
          .toCompanion(true)
          .copyWith(passwordHash: Value(hashPassword(password))),
    );

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Đặt lại mật khẩu'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(
                CupertinoIcons.lock_shield,
                size: 36,
                color: CupertinoColors.secondaryLabel,
              ),
              const SizedBox(height: 12),
              const Text(
                'Tạo mật khẩu mới cho tài khoản của bạn',
                style: TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.secondaryLabel,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CupertinoLabeledField(
                icon: CupertinoIcons.lock,
                placeholder: 'Mật khẩu mới',
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              CupertinoLabeledField(
                icon: CupertinoIcons.lock,
                placeholder: 'Xác nhận mật khẩu',
                controller: _confirmController,
                obscureText: true,
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: CupertinoColors.destructiveRed,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CupertinoActivityIndicator(
                        color: CupertinoColors.white,
                      )
                    : const Text('Xác nhận'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
