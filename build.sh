#!/bin/bash
set -e

echo "Starting Flutter installation..."

# Download and extract Flutter
curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz | tar -xJ

# Add Flutter to PATH
export PATH="$PWD/flutter/bin:$PATH"

echo "Flutter installed, checking version..."
flutter --version

echo "Running flutter doctor..."
flutter doctor

echo "Building Flutter web app..."
flutter build web --release

echo "Build completed successfully!" 