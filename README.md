# Q9 Finder

App tổng hợp quán ăn & địa điểm vui chơi quanh Vinhomes Q9, parse từ post
Facebook bằng AI, dùng UI Cupertino (iOS-style) trên Flutter.

## Tính năng

- 🔐 Đăng nhập / Đăng ký / Quên mật khẩu (OTP demo — xem ghi chú bên dưới)
- 🏠 Trang chủ chọn "Ăn uống" hoặc "Đi chơi"
- 🔍 Feed có search + filter (danh mục, freeship, sắp xếp)
- 📋 Chi tiết quán: ảnh, menu theo nhóm, đánh giá, gọi điện/Zalo
- ➕ Thêm/sửa quán: dán post Facebook → AI tự trích xuất, hoặc nhập tay
- 👥 Quản lý người dùng + phân quyền (Admin/Editor/Viewer/Guest)
- 💾 100% local, dùng SQLite (drift) — không tốn phí cloud

## Yêu cầu trước khi chạy

1. **Flutter SDK** đã cài và `flutter doctor` chạy sạch (ít nhất phần
   Android hoặc Web/Desktop nếu muốn build cho nền tảng đó).
2. (Tuỳ chọn) **Anthropic API key** nếu muốn dùng tính năng "Trích xuất bằng
   AI". Không có key vẫn dùng được app bình thường qua chế độ "Nhập tay".

## Cài đặt

```bash
# Giải nén xong, vào thư mục project
cd food_finder

# Vì phần platform (android/ios/web...) không có sẵn trong gói này,
# cần generate lại bằng lệnh sau (chỉ chạy 1 lần):
flutter create . --platforms=android,ios,web,windows,macos,linux

# Cài dependencies
flutter pub get

# Generate code cho drift (BẮT BUỘC trước khi chạy app lần đầu)
dart run build_runner build --delete-conflicting-outputs
```

### Thiết lập thêm cho Web (bắt buộc nếu muốn chạy `flutter run -d chrome`)

Web không có SQLite native, nên drift dùng SQLite compiled sang WASM.
Cần tải 2 file và đặt vào thư mục `web/`:

```bash
# Cách dễ nhất: dùng script có sẵn của drift
dart run drift_dev make-web-assets web/
```

Lệnh trên tự động tải `sqlite3.wasm` và tạo `drift_worker.js` vào đúng
thư mục `web/`. Nếu lệnh trên báo lỗi/không có, tải thủ công:
- `sqlite3.wasm` từ https://github.com/simolus3/sqlite3.dart/releases
  (chọn bản phù hợp version `sqlite3` trong `pubspec.yaml`)
- Đặt cả 2 file `sqlite3.wasm` và `drift_worker.js` vào thư mục `web/`
  cùng cấp với `index.html`

> ⚠️ Lưu ý: trên web, `image_picker` không lưu file path thật mà trả về
> blob URL tạm thời (mất khi tải lại trang). Ảnh đã thêm trên web sẽ
> không tồn tại bền vững như trên mobile — đây là giới hạn của trình
> duyệt, không phải lỗi app. Nếu cần ảnh bền vững trên web, nên chuyển
> sang lưu ảnh qua cloud storage (Supabase/Cloudinary) thay vì local.

### Thêm ảnh không hoạt động trên macOS/iOS — cần cấp quyền Photo Library

`image_picker` cần khai báo quyền truy cập Ảnh trong file cấu hình
native. Nếu bấm "Thêm ảnh" mà không có gì xảy ra (hoặc app bị treo),
thêm đoạn sau:

**macOS** — file `macos/Runner/DebugProfile.entitlements` VÀ
`macos/Runner/Release.entitlements`, thêm vào trước thẻ đóng `</dict>`:

```xml
<key>com.apple.security.assets.pictures.read-write</key>
<true/>
```

Đồng thời, file `macos/Runner/Info.plist`, thêm trước thẻ đóng
`</dict>`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Q9 Finder cần quyền truy cập ảnh để thêm hình ảnh cho quán</string>
```

**iOS** — file `ios/Runner/Info.plist`, thêm trước thẻ đóng `</dict>`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Q9 Finder cần quyền truy cập ảnh để thêm hình ảnh cho quán</string>
<key>NSCameraUsageDescription</key>
<string>Q9 Finder cần quyền dùng camera để chụp ảnh cho quán</string>
```

Sau khi thêm, chạy lại `flutter clean && flutter run` (bắt buộc clean
vì thay đổi entitlements/Info.plist không tự áp dụng khi hot reload).

Nếu vẫn không xin được quyền, vào **System Settings → Privacy &
Security → Photos** trên macOS (hoặc **Settings → [Tên app] →
Photos** trên iOS) và cấp quyền thủ công cho app.

### Mở rộng: ảnh hiện hỗ trợ xem full-screen và xoá

Tap vào ảnh bất kỳ trong gallery sẽ mở màn xem full-screen, vuốt
ngang để chuyển ảnh, pinch-to-zoom, và có nút xoá ảnh ở góc phải trên.

> ⚠️ Lưu ý: gọi điện (`tel:`) và mở Zalo qua `url_launcher` hoạt động
> tốt trên mobile, nhưng trên web/desktop sẽ tuỳ thuộc trình duyệt/OS
> có hỗ trợ scheme đó hay không (web thường mở app gọi điện mặc định
> của máy nếu có, desktop thường không có ứng dụng xử lý `tel:`).


## Chạy app

```bash
# Mobile/Desktop — không có AI parsing (chỉ dùng chế độ Nhập tay)
flutter run

# Mobile/Desktop — có AI parsing
flutter run --dart-define=ANTHROPIC_API_KEY=YOUR_KEY

# Web (Chrome) — nhớ làm bước "Thiết lập thêm cho Web" ở trên trước
flutter run -d chrome --dart-define=ANTHROPIC_API_KEY=YOUR_KEY

# Xem danh sách thiết bị/nền tảng khả dụng
flutter devices
```

> 💡 Để khỏi gõ lại key mỗi lần, tạo file `run_with_ai.sh`:
> ```bash
> #!/bin/bash
> flutter run --dart-define=ANTHROPIC_API_KEY=sk-ant-xxxxx
> ```
> rồi `chmod +x run_with_ai.sh` và chạy `./run_with_ai.sh`.
> File này nên thêm vào `.gitignore` để không lộ key.

## Mỗi khi sửa schema database (lib/db/database.dart)

Sau khi thêm/sửa bảng hoặc cột, luôn chạy lại:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Đổi icon app + tên hiển thị

Icon nguồn (1024x1024) nằm tại `assets/icon/app_icon.png` — chủ đề
mái che chợ + tô đồ ăn + 2 căn nhà (cư dân). Để áp dụng icon này cho
mọi platform (Android, iOS, macOS, Windows):

```bash
flutter pub get
dart run flutter_launcher_icons
```

Lệnh này tự sinh icon đúng kích thước cho từng platform, không cần
làm thủ công qua Xcode/Android Studio.

**Đổi tên hiển thị trên Dock/Home Screen** (khác với package name nội
bộ `food_finder` dùng trong code — đổi cái đó không cần thiết và rủi
ro vì phải sửa toàn bộ import):

> ⚠️ **Quan trọng:** KHÔNG đổi `PRODUCT_NAME` thành tên có dấu/khoảng
> trắng — sẽ làm code signing thất bại với lỗi `code object is not
> signed at all` khi build macOS. Giữ `PRODUCT_NAME` không dấu, chỉ
> đổi tên hiển thị qua `CFBundleDisplayName` (macOS/iOS) hoặc
> `android:label` (Android) — các key này an toàn với dấu/khoảng trắng.

- **macOS**: sửa `macos/Runner/Info.plist`, thêm/sửa (giữ nguyên
  `PRODUCT_NAME` trong `AppInfo.xcconfig` không đổi):
  ```xml
  <key>CFBundleDisplayName</key>
  <string>Chợ Cư Dân</string>
  <key>CFBundleName</key>
  <string>ChoCuDan</string>
  ```
  (`CFBundleName` nên giữ không dấu vì 1 số chỗ hệ thống dùng key này)
- **iOS**: sửa `ios/Runner/Info.plist`, giá trị `CFBundleDisplayName`
  → `Chợ Cư Dân`
- **Android**: sửa `android/app/src/main/AndroidManifest.xml`, thuộc
  tính `android:label` trong thẻ `<application>` → `Chợ Cư Dân`

Sau khi đổi, chạy lại `flutter clean && flutter run` để áp dụng.

## Cấu trúc thư mục

```
lib/
  main.dart                     # CupertinoApp entry point
  db/
    database.dart               # Schema drift: Users, Places, MenuItems, Ratings, PlaceImages
    database.g.dart             # Tự sinh ra bởi build_runner — đừng sửa tay
    id_helper.dart               # UUID + hash mật khẩu
  providers/
    app_providers.dart          # Riverpod: database instance, current user, permissions
  services/
    ai_parse_service.dart       # Gọi Claude API để parse post FB
  screens/                      # 13 màn hình theo đúng flow đã thiết kế
  widgets/                      # Component tái dùng (place_card, filter_sheet, form_row)
```

## Ghi chú quan trọng

### OTP hiện đang là demo
App cá nhân local không có backend gửi SMS thật. Mã OTP cố định là
`000000` để bạn test flow. Khi nào muốn dùng OTP thật, cần tích hợp
dịch vụ SMS (Firebase Auth Phone, hoặc nhà cung cấp SMS Việt Nam như
eSMS, SpeedSMS).

### Tài khoản đầu tiên = Admin tự động
Người đầu tiên đăng ký trong app sẽ tự động có role `admin` và toàn
quyền — kể cả `Quản lý người dùng`. Các tài khoản sau mặc định là
`viewer`.

### Database lưu ở đâu
SQLite file `q9_finder.sqlite` nằm trong thư mục Documents riêng của
app trên thiết bị (`getApplicationDocumentsDirectory()`), không yêu cầu
quyền lưu trữ đặc biệt, không bị xoá khi restart app.

### Mở rộng lên Supabase sau này
Schema đã thiết kế sẵn với UUID + timestamps để dễ migrate. Khi cần
sync nhiều thiết bị, tạo thêm 1 implementation Repository pattern gọi
Supabase, giữ nguyên interface, không cần sửa lại UI.

## Build APK / IPA (khi sẵn sàng phát hành)

```bash
# Android
flutter build apk --release --dart-define=ANTHROPIC_API_KEY=YOUR_KEY

# iOS (cần macOS + Xcode)
flutter build ios --release --dart-define=ANTHROPIC_API_KEY=YOUR_KEY
```

## Build & phân phối bản macOS (.app / .dmg)

### Chỉ chạy trên máy bạn (không cần DMG)

```bash
flutter build macos --release
cp -R build/macos/Build/Products/Release/food_finder.app /Applications/
xattr -cr /Applications/food_finder.app
```

Dòng `xattr -cr` bắt buộc — vì app chưa được Apple ký (code sign +
notarize), macOS Gatekeeper sẽ chặn với thông báo *"không thể mở vì
không xác định được nhà phát triển"* nếu bỏ qua bước này. Lệnh này xoá
metadata quarantine mà macOS tự gắn vào app mới build/tải về.

Nếu lỡ quên chạy `xattr` và đã bị chặn, vẫn mở được bằng cách:
**right-click vào app → Open → bấm Open lần nữa** ở hộp thoại cảnh báo
(chỉ cần làm 1 lần, lần sau mở bình thường).

### Đóng gói DMG để chia sẻ cho máy khác

Dùng khi cần gửi app cho người khác cài (vd: dùng chung giữa nhiều máy).

```bash
# Cài công cụ tạo DMG (chỉ cần làm 1 lần)
brew install create-dmg

# Build release trước
flutter build macos --release

# Tạo DMG bằng script có sẵn trong project
chmod +x build_dmg.sh
./build_dmg.sh
```

Script tạo ra file `Q9Finder.dmg` trong thư mục gốc project. Gửi file
này cho người khác — họ chỉ cần:

1. Mở file `.dmg`
2. Kéo icon app vào thư mục **Applications** (có sẵn link tắt trong
   cửa sổ DMG)
3. Eject DMG
4. Chạy `xattr -cr /Applications/food_finder.app` trên máy họ (vì
   quarantine attribute là theo từng máy, không "đi theo" trong DMG)
5. Mở app từ Applications như bình thường

> ⚠️ **Lưu ý quan trọng về dữ liệu:** mỗi máy có database SQLite +
> ảnh **hoàn toàn riêng biệt**, không tự đồng bộ. Cài DMG lên máy thứ
> 2 sẽ bắt đầu với database trống — đây không phải lỗi, mà là tính
> chất local-first của app (xem thêm phần "Database lưu ở đâu" bên
> trên). Nếu cần 2 máy thấy chung 1 bộ dữ liệu, cần chuyển sang backend
> (Supabase) thay vì SQLite local.
