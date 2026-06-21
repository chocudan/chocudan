import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart';

/// Màn xác thực OTP — dùng chung cho đăng ký và quên mật khẩu.
///
/// LƯU Ý: app cá nhân local không có backend gửi SMS thật.
/// Để đơn giản, mã OTP cố định là 000000 cho mục đích demo/cá nhân.
/// Khi mở rộng cho nhiều người dùng thật, cần tích hợp dịch vụ SMS
/// (vd: Firebase Auth Phone, Twilio, hoặc ESMS/Speedsms cho VN).
class OtpScreen extends StatefulWidget {
  final String phone;
  final bool isRegister; // true: sau đăng ký | false: sau quên mật khẩu

  const OtpScreen({super.key, required this.phone, required this.isRegister});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _secondsLeft = 60;
  Timer? _timer;
  String? _error;

  static const _mockOtp = '000000';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _verify() {
    final entered = _controllers.map((c) => c.text).join();
    if (entered.length < 6) {
      setState(() => _error = 'Vui lòng nhập đủ 6 số');
      return;
    }
    if (entered != _mockOtp) {
      setState(() => _error = 'Mã OTP không đúng (gợi ý: 000000)');
      return;
    }

    if (widget.isRegister) {
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (_) => const LoginScreen(
            successMessage: 'Tạo tài khoản thành công! Đăng nhập để tiếp tục.',
          ),
        ),
        (route) => false,
      );
    } else {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (_) => ResetPasswordScreen(phone: widget.phone),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Xác thực OTP'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                CupertinoIcons.device_phone_portrait,
                size: 36,
                color: CupertinoColors.secondaryLabel,
              ),
              const SizedBox(height: 12),
              const Text(
                'Nhập mã xác thực',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  text: 'Mã 6 số đã được gửi đến ',
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.secondaryLabel,
                  ),
                  children: [
                    TextSpan(
                      text: widget.phone,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SizedBox(
                      width: 42,
                      height: 52,
                      child: CupertinoTextField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: CupertinoColors.systemGrey4,
                          ),
                        ),
                        onChanged: (v) {
                          if (v.isNotEmpty && i < 5) {
                            _focusNodes[i + 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  );
                }),
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
              const SizedBox(height: 14),
              if (_secondsLeft > 0)
                Text(
                  'Gửi lại mã sau $_secondsLeft giây',
                  style: const TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.secondaryLabel,
                  ),
                )
              else
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _startTimer,
                  child: const Text('Gửi lại mã', style: TextStyle(fontSize: 13)),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: _verify,
                  child: const Text('Xác nhận'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
