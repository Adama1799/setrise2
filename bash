#!/bin/bash
# build.sh - Build for all platforms

# Android
echo "Building Android..."
flutter build apk --split-per-abi
flutter build appbundle

# iOS
echo "Building iOS..."
flutter build ios --release

# Web
echo "Building Web..."
flutter build web --release

# Desktop (Windows)
echo "Building Windows..."
flutter build windows --release

# Desktop (macOS)
echo "Building macOS..."
flutter build macos --release

# Desktop (Linux)
echo "Building Linux..."
flutter build linux --release
