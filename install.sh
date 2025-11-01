#!/bin/bash
set -e

REPO_URL="https://github.com/Nizwarax/tracking.git"
TEMP_DIR="/tmp/track_install_$$"
BIN_NAME="track"
DEST_PATH="/usr/local/bin/$BIN_NAME"

echo "🚀 Mengunduh TrackingDevz..."
mkdir -p "$TEMP_DIR"
git clone --depth=1 "$REPO_URL" "$TEMP_DIR"
cd "$TEMP_DIR"

# Pastikan file utama ada
if [ ! -f tracking.py ]; then
    echo "❌ File tracking.py tidak ditemukan di repositori!"
    exit 1
fi

echo "📦 Menginstal dependensi..."
pip3 install -r requirements.txt

echo "🔧 Memasang perintah 'track' ke sistem..."
sudo cp tracking.py "$DEST_PATH"
sudo chmod +x "$DEST_PATH"

# Tambahkan shebang jika belum ada
if ! head -n1 "$DEST_PATH" | grep -q "^#!"; then
    sudo sed -i '1i#!/usr/bin/env python3' "$DEST_PATH"
fi

echo "✅ Instalasi selesai! Jalankan dengan:"
echo "   track"
