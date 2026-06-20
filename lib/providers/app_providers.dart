import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/database.dart';

/// Provider toàn cục cho database — chỉ tạo 1 instance duy nhất
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// User hiện tại đang đăng nhập (null = chưa login / dùng guest mode)
final currentUserProvider = StateProvider<User?>((ref) => null);

/// Đang ở chế độ khách (guest) — dùng app không cần tài khoản
final isGuestModeProvider = StateProvider<bool>((ref) => false);

/// Helper: kiểm tra quyền hiện tại
class Permissions {
  final User? user;
  final bool isGuest;

  Permissions(this.user, this.isGuest);

  bool get isAdmin => user?.role == 'admin';
  bool get canAddPlace => isGuest ? false : (user?.canAddPlace ?? false);
  bool get canEditPlace => isGuest ? false : (user?.canEditPlace ?? false);
  bool get canDeletePlace => isGuest ? false : (user?.canDeletePlace ?? false);
  bool get canRate => isGuest ? false : (user?.canRate ?? false);
}

final permissionsProvider = Provider<Permissions>((ref) {
  final user = ref.watch(currentUserProvider);
  final isGuest = ref.watch(isGuestModeProvider);
  return Permissions(user, isGuest);
});

/// Mode hiện tại đang xem: "food" hoặc "destination"
final currentPlaceTypeProvider = StateProvider<String>((ref) => 'food');
