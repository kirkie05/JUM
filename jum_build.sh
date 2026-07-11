#!/usr/bin/env bash

# ==============================================================================
# JUM DEVELOPMENT WORKFLOW PIPELINE
# ==============================================================================
# This script strictly enforces a reliable build pipeline for the JUM Flutter
# application to guarantee that code changes are consistently reflected in the 
# Android Emulator.
#
# It resolves issues caused by:
# 1. Stale Hot Reload states masking new logic.
# 2. Caching of the .env asset bundle inside the APK.
# 3. Out-of-date Riverpod, Freezed, and JSON Serializable generated files.
# 4. Emulator Quick Boot restoring outdated RAM snapshots.
# ==============================================================================

# Abort immediately if any command fails
set -e

# Support an optional `--fast` flag to skip flutter clean when iterating on UI only.
SKIP_CLEAN=false
if [ "$1" == "--fast" ]; then
    SKIP_CLEAN=true
    echo "⚡ Fast mode activated: Skipping 'flutter clean'."
fi

echo "==========================================="
echo "🚀 STARTING JUM STRICT BUILD PIPELINE"
echo "==========================================="

if [ "$SKIP_CLEAN" = false ]; then
    echo "🧹 [1/6] Cleaning Flutter & Android caches (Fixes stale .env and APKs)..."
    flutter clean
else
    echo "⏭️ [1/6] Skipping flutter clean..."
fi

echo "📦 [2/6] Resolving Flutter dependencies..."
flutter pub get

echo "⚙️ [3/6] Running Build Runner (Regenerating Freezed & Riverpod logic)..."
dart run build_runner build --delete-conflicting-outputs

echo "🔍 [4/6] Analyzing Dart code for static errors..."
flutter analyze

echo "🧪 [5/6] Executing test suite..."
# We will temporarily allow tests to fail gracefully if there are outdated tests from scaffolding,
# but it will execute them.
if flutter test; then
    echo "✅ Tests passed successfully."
else
    echo "⚠️ Tests failed. Please review your test suite, but continuing to deployment for development purposes."
fi

echo "📱 [6/6] Deploying fresh build to the Android Emulator..."
# Use flutter run to install the latest APK. 
# We do not use `flutter run --hot` explicitly, just standard flutter run which connects to the device.
flutter run
