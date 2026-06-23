import 'package:flutter/cupertino.dart';

/// Phân tích chuỗi giờ hoạt động dạng tự do (vd "8:30 - 22:30",
/// "15h-2h sáng") và so với giờ hiện tại để biết quán đang mở hay đóng.
///
/// LƯU Ý: vì openHours là text tự do (không có cấu trúc cố định khi
/// nhập tay hoặc AI parse), hàm này chỉ xử lý được các định dạng phổ
/// biến nhất (HH:MM - HH:MM, HH:MM-HH:MM, có thể có "h" thay ":").
/// Nếu không parse được, trả về null — UI sẽ không hiện badge thay vì
/// hiện sai.
class OpenStatusHelper {
  static bool? isOpenNow(String? openHours) {
    if (openHours == null || openHours.trim().isEmpty) return null;

    final range = _parseRange(openHours);
    if (range == null) return null;

    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final openMinutes = range.$1;
    final closeMinutes = range.$2;

    if (openMinutes <= closeMinutes) {
      // Trường hợp thường: mở và đóng trong cùng ngày, vd 8:30 - 22:30
      return nowMinutes >= openMinutes && nowMinutes < closeMinutes;
    } else {
      // Trường hợp qua đêm: vd 15:00 - 2:00 (đóng cửa sau nửa đêm)
      return nowMinutes >= openMinutes || nowMinutes < closeMinutes;
    }
  }

  /// Trả về (openMinutes, closeMinutes) tính từ 00:00, hoặc null nếu
  /// không parse được.
  static (int, int)? _parseRange(String text) {
    // Khớp các pattern: "8:30 - 22:30", "8h30 - 22h30", "15h-2h",
    // "8:30-22:30", "8 - 22"
    final pattern = RegExp(
      r'(\d{1,2})[h:]?(\d{0,2})\s*-\s*(\d{1,2})[h:]?(\d{0,2})',
    );
    final match = pattern.firstMatch(text);
    if (match == null) return null;

    final openHour = int.tryParse(match.group(1) ?? '');
    final openMin = int.tryParse(match.group(2) ?? '') ?? 0;
    final closeHour = int.tryParse(match.group(3) ?? '');
    final closeMin = int.tryParse(match.group(4) ?? '') ?? 0;

    if (openHour == null || closeHour == null) return null;
    if (openHour > 23 || closeHour > 23) return null;

    return (openHour * 60 + openMin, closeHour * 60 + closeMin);
  }
}

/// Badge nhỏ hiện "Đang mở" (xanh) hoặc "Đã đóng cửa" (xám/đỏ) bên cạnh
/// giờ hoạt động. Không hiện gì nếu không parse được giờ.
class OpenStatusBadge extends StatelessWidget {
  final String? openHours;

  const OpenStatusBadge({super.key, required this.openHours});

  @override
  Widget build(BuildContext context) {
    final isOpen = OpenStatusHelper.isOpenNow(openHours);
    if (isOpen == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isOpen
            ? CupertinoColors.systemGreen.withOpacity(0.15)
            : CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isOpen ? 'Đang mở' : 'Đã đóng cửa',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isOpen
              ? CupertinoColors.activeGreen
              : CupertinoColors.secondaryLabel,
        ),
      ),
    );
  }
}
