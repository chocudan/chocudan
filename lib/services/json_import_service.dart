import 'dart:convert';
import 'package:drift/drift.dart';
import '../db/database.dart';
import '../db/id_helper.dart';

class ImportResult {
  final int inserted;
  final int updated;
  final int failed;
  final List<String> errors;

  ImportResult({
    required this.inserted,
    required this.updated,
    required this.failed,
    required this.errors,
  });
}

/// Import danh sách quán từ JSON theo format ở assets/sample_import.json.
///
/// Quy tắc:
/// - "id" có giá trị + đã tồn tại trong DB -> đè (cập nhật toàn bộ field
///   + xoá/ghi lại menuItems theo dữ liệu mới).
/// - "id" null/rỗng, hoặc có giá trị nhưng CHƯA tồn tại -> tạo quán mới
///   (sinh UUID mới nếu "id" null, giữ nguyên "id" nếu đã có sẵn — hữu
///   ích khi import lại đúng file cũ để cập nhật).
class JsonImportService {
  static Future<ImportResult> importFromJson(
    String jsonString,
    AppDatabase db,
    String? currentUserId,
  ) async {
    int inserted = 0;
    int updated = 0;
    int failed = 0;
    final errors = <String>[];

    late Map<String, dynamic> root;
    try {
      root = jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('File JSON không hợp lệ: $e');
    }

    final placesList = root['places'] as List<dynamic>?;
    if (placesList == null) {
      throw Exception('Thiếu field "places" trong JSON (phải là mảng)');
    }

    for (final raw in placesList) {
      try {
        final item = raw as Map<String, dynamic>;
        final name = item['name'] as String?;
        if (name == null || name.trim().isEmpty) {
          failed++;
          errors.add('Bỏ qua 1 quán: thiếu "name"');
          continue;
        }

        final providedId = item['id'] as String?;
        final placeId = (providedId == null || providedId.trim().isEmpty)
            ? newId()
            : providedId;

        final existing = await db.getPlaceById(placeId);
        final isUpdate = existing != null;

        final companion = PlacesCompanion.insert(
          id: placeId,
          type: Value(item['type'] as String? ?? 'food'),
          name: name,
          phone: Value(item['phone'] as String?),
          phone2: Value(item['phone2'] as String?),
          address: Value(item['address'] as String?),
          rawText: Value(item['rawText'] as String? ?? ''),
          freeship: Value(item['freeship'] as bool? ?? false),
          freeshipNote: Value(item['freeshipNote'] as String?),
          openHours: Value(item['openHours'] as String?),
          category: Value(item['category'] as String?),
          avgPriceRange: Value(item['avgPriceRange'] as String?),
          note: Value(item['note'] as String?),
          createdBy: Value(currentUserId),
          updatedAt: Value(DateTime.now()),
        );

        await db.upsertPlace(companion);

        // Đè toàn bộ menu items: xoá cũ, thêm lại theo JSON mới
        await db.deleteMenuItemsForPlace(placeId);
        final menuItems = item['menuItems'] as List<dynamic>? ?? [];
        for (final m in menuItems) {
          final menuMap = m as Map<String, dynamic>;
          final itemName = menuMap['name'] as String?;
          final priceText = menuMap['priceText'] as String?;
          if (itemName == null || priceText == null) continue;

          await db.insertMenuItem(
            MenuItemsCompanion.insert(
              id: newId(),
              placeId: placeId,
              name: itemName,
              priceText: priceText,
              categoryGroup: Value(menuMap['categoryGroup'] as String?),
              isBestSeller: Value(menuMap['isBestSeller'] as bool? ?? false),
            ),
          );
        }

        if (isUpdate) {
          updated++;
        } else {
          inserted++;
        }
      } catch (e) {
        failed++;
        errors.add('Lỗi xử lý 1 quán: $e');
      }
    }

    return ImportResult(
      inserted: inserted,
      updated: updated,
      failed: failed,
      errors: errors,
    );
  }
}
