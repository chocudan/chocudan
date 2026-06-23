import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show kReleaseMode, kProfileMode;

part 'database.g.dart';

// ----- Tables -----

// Người dùng app (login local đơn giản, có thể nâng cấp sau)
class Users extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();
  TextColumn get phone => text().unique()();
  TextColumn get passwordHash => text()();
  TextColumn get role => text().withDefault(const Constant('viewer'))();
  // role: admin | editor | viewer | guest
  BoolColumn get canAddPlace => boolean().withDefault(const Constant(true))();
  BoolColumn get canEditPlace => boolean().withDefault(const Constant(true))();
  BoolColumn get canDeletePlace =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get canRate => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Quán ăn / địa điểm đi chơi (bảng chung, mở rộng bằng `type`)
class Places extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get type =>
      text().withDefault(const Constant('food'))(); // food | destination
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get phone2 => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get rawText => text().withDefault(const Constant(''))();
  BoolColumn get freeship => boolean().withDefault(const Constant(false))();
  TextColumn get freeshipNote => text().nullable()();
  TextColumn get openHours => text().nullable()();
  // Nhiều danh mục, lưu dạng "Ăn uống,Bánh,Đồ uống" — tách bằng dấu phẩy.
  // Dùng kiểu lưu trữ đơn giản này để dễ sync với filter (so khớp chuỗi
  // con), không cần bảng phụ Categories riêng cho MVP.
  TextColumn get category => text().nullable()();
  // Khoảng giá trung bình do người thêm quán tự nhập tay, vd "20k-50k"
  // (không tự tính từ menu vì giá món thường viết tự do, khó parse chính
  // xác — xem ghi chú ở MenuItems.priceText).
  TextColumn get avgPriceRange => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get createdBy => text().nullable()(); // FK -> Users.id
  IntColumn get viewCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Món ăn / dịch vụ trong 1 quán
class MenuItems extends Table {
  TextColumn get id => text()();
  TextColumn get placeId => text()(); // FK -> Places.id
  TextColumn get categoryGroup => text().nullable()(); // "Đồ uống", "Ăn no"
  TextColumn get name => text()();
  TextColumn get priceText => text()(); // giữ nguyên "45k/h", "12k-15k"
  BoolColumn get isBestSeller =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Đánh giá cá nhân
class Ratings extends Table {
  TextColumn get id => text()();
  TextColumn get placeId => text()(); // FK -> Places.id
  TextColumn get userId => text().nullable()(); // FK -> Users.id
  IntColumn get stars => integer()(); // 1-5
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Bình luận của user đã login (cần Admin duyệt trước khi hiển thị công khai)
class Comments extends Table {
  TextColumn get id => text()();
  TextColumn get placeId => text()(); // FK -> Places.id
  TextColumn get userId => text()(); // FK -> Users.id — bắt buộc, không ẩn danh
  TextColumn get content => text()();
  BoolColumn get isApproved => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Ảnh của quán (lưu local path trên thiết bị)
class PlaceImages extends Table {
  TextColumn get id => text()();
  TextColumn get placeId => text()(); // FK -> Places.id
  TextColumn get localPath => text()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ----- Database -----

@DriftDatabase(
  tables: [Users, Places, MenuItems, Ratings, PlaceImages, Comments],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Cho phép truyền connection khác khi cần (vd: test)
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 -> v2: thêm avgPriceRange, viewCount vào Places;
            // thêm bảng Comments mới.
            await m.addColumn(places, places.avgPriceRange);
            await m.addColumn(places, places.viewCount);
            await m.createTable(comments);
          }
        },
      );

  // ----- Place queries -----

  Future<List<Place>> getPlacesByType(String type) {
    return (select(places)..where((p) => p.type.equals(type))).get();
  }

  Stream<List<Place>> watchPlacesByType(String type) {
    return (select(places)..where((p) => p.type.equals(type))).watch();
  }

  Future<Place?> getPlaceById(String id) {
    return (select(places)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertPlace(PlacesCompanion place) {
    return into(places).insert(place);
  }

  Future<bool> updatePlace(PlacesCompanion place) {
    return update(places).replace(place);
  }

  Future<int> deletePlace(String id) {
    return (delete(places)..where((p) => p.id.equals(id))).go();
  }

  Future<List<String>> getDistinctCategories(String type) async {
    final query = selectOnly(places, distinct: true)
      ..addColumns([places.category])
      ..where(places.type.equals(type) & places.category.isNotNull());
    final rows = await query.get();

    // category lưu dạng "Ăn uống,Bánh" — tách ra thành từng tag riêng,
    // loại trùng, để hiện đúng danh sách tag cho filter sheet.
    final allTags = <String>{};
    for (final row in rows) {
      final raw = row.read(places.category);
      if (raw == null || raw.trim().isEmpty) continue;
      for (final tag in raw.split(',')) {
        final trimmed = tag.trim();
        if (trimmed.isNotEmpty) allTags.add(trimmed);
      }
    }
    return allTags.toList()..sort();
  }

  /// Tăng lượt xem +1 mỗi khi người dùng mở màn chi tiết quán.
  Future<void> incrementViewCount(String placeId) async {
    final place = await getPlaceById(placeId);
    if (place == null) return;
    await (update(places)..where((p) => p.id.equals(placeId))).write(
      PlacesCompanion(viewCount: Value(place.viewCount + 1)),
    );
  }

  /// Lưu nhiều quán cùng lúc từ JSON import — nếu trùng id thì đè (upsert).
  Future<void> upsertPlace(PlacesCompanion place) async {
    await into(places).insertOnConflictUpdate(place);
  }

  // ----- MenuItem queries -----

  Future<List<MenuItem>> getMenuItemsForPlace(String placeId) {
    return (select(menuItems)..where((m) => m.placeId.equals(placeId))).get();
  }

  Future<int> insertMenuItem(MenuItemsCompanion item) {
    return into(menuItems).insert(item);
  }

  Future<int> deleteMenuItem(String id) {
    return (delete(menuItems)..where((m) => m.id.equals(id))).go();
  }

  Future<void> deleteMenuItemsForPlace(String placeId) {
    return (delete(menuItems)..where((m) => m.placeId.equals(placeId))).go();
  }

  // ----- Rating queries -----

  Future<List<Rating>> getRatingsForPlace(String placeId) {
    return (select(ratings)..where((r) => r.placeId.equals(placeId))).get();
  }

  Future<double?> getAverageRating(String placeId) async {
    final query = selectOnly(ratings)
      ..addColumns([ratings.stars.avg()])
      ..where(ratings.placeId.equals(placeId));
    final row = await query.getSingleOrNull();
    return row?.read(ratings.stars.avg());
  }

  Future<int> insertRating(RatingsCompanion rating) {
    return into(ratings).insert(rating);
  }

  // ----- PlaceImage queries -----

  Future<List<PlaceImage>> getImagesForPlace(String placeId) {
    return (select(placeImages)..where((i) => i.placeId.equals(placeId)))
        .get();
  }

  Future<int> insertPlaceImage(PlaceImagesCompanion image) {
    return into(placeImages).insert(image);
  }

  Future<int> deletePlaceImage(String id) {
    return (delete(placeImages)..where((i) => i.id.equals(id))).go();
  }

  // ----- Comment queries -----

  /// Chỉ lấy comment đã được Admin duyệt — dùng cho màn chi tiết công khai.
  Future<List<Comment>> getApprovedCommentsForPlace(String placeId) {
    return (select(comments)
          ..where(
            (c) => c.placeId.equals(placeId) & c.isApproved.equals(true),
          )
          ..orderBy([(c) => OrderingTerm.desc(c.createdAt)]))
        .get();
  }

  /// Lấy toàn bộ comment (kể cả chưa duyệt) — dùng cho màn quản lý của Admin.
  Future<List<Comment>> getAllComments() {
    return (select(comments)
          ..orderBy([(c) => OrderingTerm.desc(c.createdAt)]))
        .get();
  }

  Future<int> getPendingCommentCount() async {
    final query = selectOnly(comments)
      ..addColumns([comments.id.count()])
      ..where(comments.isApproved.equals(false));
    final row = await query.getSingle();
    return row.read(comments.id.count()) ?? 0;
  }

  Future<int> insertComment(CommentsCompanion comment) {
    return into(comments).insert(comment);
  }

  Future<void> setCommentApproval(String id, bool approved) async {
    await (update(comments)..where((c) => c.id.equals(id))).write(
      CommentsCompanion(isApproved: Value(approved)),
    );
  }

  Future<int> deleteComment(String id) {
    return (delete(comments)..where((c) => c.id.equals(id))).go();
  }

  // ----- User queries -----

  Future<User?> getUserByPhone(String phone) {
    return (select(users)..where((u) => u.phone.equals(phone)))
        .getSingleOrNull();
  }

  Future<User?> getUserById(String id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  Future<List<User>> getAllUsers() {
    return select(users).get();
  }

  Future<int> insertUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  Future<bool> updateUser(UsersCompanion user) {
    return update(users).replace(user);
  }
}

/// driftDatabase() (từ package drift_flutter) tự động chọn đúng backend:
/// - Mobile (Android/iOS) & Desktop (Windows/macOS/Linux): native SQLite
/// - Web: SQLite compiled sang WASM, lưu qua IndexedDB của trình duyệt
///
/// Đặt tên file khác nhau giữa debug/profile/release để 2 bản build
/// không vô tình dùng chung 1 database trên cùng máy (vd: khi Bundle ID
/// giống nhau trên macOS, "q9_finder" chung tên sẽ trỏ vào cùng 1 file).
QueryExecutor _openConnection() {
  final dbName = kReleaseMode
      ? 'q9_finder'
      : (kProfileMode ? 'q9_finder_profile' : 'q9_finder_debug');

  return driftDatabase(
    name: dbName,
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
