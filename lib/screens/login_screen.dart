import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/database.dart';
import '../db/id_helper.dart';
import '../providers/app_providers.dart';
import '../widgets/cupertino_form_row.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String? successMessage;

  const LoginScreen({super.key, this.successMessage});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _successMessage = widget.successMessage;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (phone.isEmpty || password.isEmpty) {
      setState(() => _error = 'Vui lòng nhập đầy đủ thông tin');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final db = ref.read(databaseProvider);
    final user = await db.getUserByPhone(phone);

    if (user == null || !verifyPassword(password, user.passwordHash)) {
      setState(() {
        _loading = false;
        _error = 'Số điện thoại hoặc mật khẩu không đúng';
      });
      return;
    }

    ref.read(currentUserProvider.notifier).state = user;
    ref.read(isGuestModeProvider.notifier).state = false;

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _continueAsGuest() {
    ref.read(isGuestModeProvider.notifier).state = true;
    ref.read(currentUserProvider.notifier).state = null;
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 48),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  CupertinoIcons.flame_fill,
                  color: CupertinoColors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Chợ Cư Dân',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Khám phá quanh Vinhomes Q9',
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
              const SizedBox(height: 28),
              if (_successMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.checkmark_circle_fill,
                        color: CupertinoColors.activeGreen,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _successMessage!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.activeGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],
              CupertinoLabeledField(
                icon: CupertinoIcons.phone,
                placeholder: 'Số điện thoại',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: (_) {
                  if (_successMessage != null) {
                    setState(() => _successMessage = null);
                  }
                },
              ),
              const SizedBox(height: 10),
              CupertinoLabeledField(
                icon: CupertinoIcons.lock,
                placeholder: 'Mật khẩu',
                controller: _passwordController,
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
                ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const CupertinoActivityIndicator(
                          color: CupertinoColors.white,
                        )
                      : const Text('Đăng nhập'),
                ),
              ),
              Row(
                children: [
                  const Expanded(
                    child: SizedBox(
                      height: 1,
                      child: ColoredBox(color: CupertinoColors.systemGrey4),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'hoặc',
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(
                      height: 1,
                      child: ColoredBox(color: CupertinoColors.systemGrey4),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: CupertinoColors.white,
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Tạo tài khoản mới',
                    style: TextStyle(color: CupertinoColors.label),
                  ),
                ),
              ),
              CupertinoButton(
                onPressed: _continueAsGuest,
                child: const Text(
                  'Dùng không cần tài khoản →',
                  style: TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
