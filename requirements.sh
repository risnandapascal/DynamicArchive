#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Access denied. Please use root or sudo to install the required dependencies."
    exit 1
fi

echo "Updating package list..."
sudo apt update

echo "Installing dependencies..."
sudo apt install -y tar gpg zip unzip p7zip-full

echo "All dependencies have been installed."
echo "DynamicArchive is ready to use."
