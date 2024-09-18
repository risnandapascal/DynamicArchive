#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Access denied. Gunakan root atau sudo untuk menginstal dependensi yang dibutuhkan."
    exit 1
fi

echo "Memperbarui daftar paket..."
sudo apt update

echo "Menginstal dependensi..."
sudo apt install -y tar gpg zip unzip p7zip-full

echo "Semua dependensi telah terinstal."
echo "DynamicArchive siap digunakan."
