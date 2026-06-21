#!/bin/bash
# Script tạo file DMG để chia sẻ app Q9 Finder
# Chạy từ thư mục gốc của project (food_finder/)

set -e

APP_NAME="food_finder"
DMG_NAME="Q9Finder"
APP_PATH="build/macos/Build/Products/Release/${APP_NAME}.app"

if [ ! -d "$APP_PATH" ]; then
  echo "❌ Không tìm thấy $APP_PATH"
  echo "Chạy 'flutter build macos --release' trước."
  exit 1
fi

# Xoá file DMG cũ nếu có
rm -f "${DMG_NAME}.dmg"

create-dmg \
  --volname "Q9 Finder" \
  --window-pos 200 120 \
  --window-size 600 400 \
  --icon-size 100 \
  --icon "${APP_NAME}.app" 150 150 \
  --hide-extension "${APP_NAME}.app" \
  --app-drop-link 450 150 \
  "${DMG_NAME}.dmg" \
  "$APP_PATH"

echo "✅ Đã tạo ${DMG_NAME}.dmg — gửi file này cho người khác cài."
