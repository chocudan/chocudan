import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Sinh UUID mới — dùng cho mọi primary key để dễ sync lên server sau này
String newId() => _uuid.v4();

/// Hash mật khẩu đơn giản (SHA-256).
/// Lưu ý: đây là giải pháp tạm cho app local cá nhân.
/// Khi mở rộng lên server thật, nên đổi sang bcrypt/argon2 phía backend.
String hashPassword(String raw) {
  final bytes = utf8.encode(raw);
  return sha256.convert(bytes).toString();
}

bool verifyPassword(String raw, String hash) {
  return hashPassword(raw) == hash;
}
