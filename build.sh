#!/bin/bash

# Install Flutter manually
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PWD/flutter/bin:$PATH"

# Enable web support
flutter config --enable-web

# Check version
flutter --version

# Get dependencies
flutter pub get

# Build web
flutter build web
