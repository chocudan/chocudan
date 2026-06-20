import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../db/database.dart';
import '../db/id_helper.dart';
import '../providers/app_providers.dart';
import '../widgets/cupertino_form_row.dart';
import 'otp_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty || phone.isEmpty || password.isEmpty) {
      setState(() => _error = 'Vui lòng nhập đầy đủ thông tin');
      return;
    }
    if (password != confirm) {
      setState(() => _error = 'Mật khẩu xác nhận không khớp');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Mật khẩu cần tối thiểu 6 ký tự');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final db = ref.read(databaseProvider);
    final existing = await db.getUserByPhone(phone);
    if (existing != null) {
      setState(() {
        _loading = false;
        _error = 'Số điện thoại này đã được đăng ký';
      });
      return;
    }

    // Tài khoản đầu tiên trong hệ thống tự động là Admin
    final allUsers = await db.getAllUsers();
    final isFirstUser = allUsers.isEmpty;

    final newUser = UsersCompanion.insert(
      id: newId(),
      name: name,
      phone: phone,
      passwordHash: hashPassword(password),
      role: Value(isFirstUser ? 'admin' : 'viewer'),
      canAddPlace: Value(isFirstUser ? true : true),
      canEditPlace: Value(isFirstUser ? true : false),
      canDeletePlace: Value(isFirstUser),
      canRate: const Value(true),
    );

    await db.insertUser(newUser);

    if (!mounted) return;
    setState(() => _loading = false);

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => OtpScreen(phone: phone, isRegister: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Tạo tài khoản'),
        previousPageTitle: 'Đăng nhập',
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              CupertinoLabeledField(
                icon: CupertinoIcons.person,
                placeholder: 'Họ và tên',
                controller: _nameController,
              ),
              const SizedBox(height: 10),
              CupertinoLabeledField(
                icon: CupertinoIcons.phone,
                placeholder: 'Số điện thoại',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              CupertinoLabeledField(
                icon: CupertinoIcons.lock,
                placeholder: 'Mật khẩu',
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
              const SizedBox(height: 12),
              const Text(
                'Bằng cách tạo tài khoản, bạn đồng ý với các điều khoản sử dụng của chúng tôi.',
                style: TextStyle(
                  fontSize: 11,
                  color: CupertinoColors.secondaryLabel,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CupertinoActivityIndicator(
                        color: CupertinoColors.white,
                      )
                    : const Text('Tạo tài khoản'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
