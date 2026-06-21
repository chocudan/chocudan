import 'package:flutter/cupertino.dart';

/// Một dòng trong CupertinoListSection.insetGrouped — label trái, value/input phải
/// (Đặt tên AppFormRow để tránh trùng với CupertinoFormRow có sẵn trong
/// package:flutter/cupertino.dart)
class AppFormRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;

  const AppFormRow({
    super.key,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
    this.controller,
    this.placeholder,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(label, style: const TextStyle(fontSize: 17)),
      trailing: trailing ??
          (controller != null
              ? SizedBox(
                  width: 180,
                  child: CupertinoTextField(
                    controller: controller,
                    placeholder: placeholder,
                    keyboardType: keyboardType,
                    obscureText: obscureText,
                    textAlign: TextAlign.right,
                    decoration: const BoxDecoration(),
                    style: const TextStyle(fontSize: 17),
                    padding: EdgeInsets.zero,
                  ),
                )
              : Text(
                  value ?? '',
                  style: const TextStyle(
                    fontSize: 17,
                    color: CupertinoColors.secondaryLabel,
                  ),
                )),
      onTap: onTap,
    );
  }
}

/// Input field đứng riêng (không phải trong list) — dùng cho login/register
class CupertinoLabeledField extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  const CupertinoLabeledField({
    super.key,
    required this.icon,
    required this.placeholder,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      prefix: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Icon(icon, size: 20, color: CupertinoColors.secondaryLabel),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      style: const TextStyle(fontSize: 17),
    );
  }
}
