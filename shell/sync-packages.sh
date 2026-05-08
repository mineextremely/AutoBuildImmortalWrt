#!/bin/sh
# shell/sync-packages.sh
# Collect .ipk or .apk files from extra-packages/ into packages/
# Usage: sh shell/sync-packages.sh [ipk|apk]

PKG_FMT="${1:-ipk}"

BASE_DIR="extra-packages"
TEMP_DIR="$BASE_DIR/temp-unpack"
TARGET_DIR="packages"

# 清理旧的目录
rm -rf "$TEMP_DIR" "$TARGET_DIR"
mkdir -p "$TEMP_DIR" "$TARGET_DIR"

# 解压 .run 文件
for run_file in "$BASE_DIR"/*.run; do
    [ -e "$run_file" ] || continue
    echo "🧩 解压 $run_file -> $TEMP_DIR"
    sh "$run_file" --target "$TEMP_DIR" --noexec
done

# 1. 收集 run 解压出的包文件
find "$TEMP_DIR" -type f -name "*.${PKG_FMT}" -exec cp -v {} "$TARGET_DIR"/ \;

# 2. 收集 extra-packages/*/ 下的包文件（只查一级子目录）
find "$BASE_DIR" -mindepth 2 -maxdepth 2 -type f -name "*.${PKG_FMT}" ! -path "$TEMP_DIR/*" \
  -exec echo "👉 Found:" {} \; \
  -exec cp -v {} "$TARGET_DIR"/ \;

echo "✅ 所有 .${PKG_FMT} 文件已整理至 $TARGET_DIR/"
