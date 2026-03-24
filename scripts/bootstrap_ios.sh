#!/usr/bin/env bash
# ============================================================================
# KINETIC iOS Bootstrap Script
# ============================================================================
# Run this on a Mac with Flutter + Xcode installed to generate the full iOS
# project and wire up the Live Activity widget extension target.
#
# Usage:
#   chmod +x scripts/bootstrap_ios.sh
#   ./scripts/bootstrap_ios.sh
# ============================================================================
set -euo pipefail

PROJ_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJ_ROOT"

echo "==> Step 1: Regenerate Flutter iOS project scaffold"
flutter create . --org com.antigravity --project-name kinetic_hiit --platforms ios

echo "==> Step 2: Install Dart dependencies"
flutter pub get

echo "==> Step 3: Run code generation (freezed + riverpod_generator)"
dart run build_runner build --delete-conflicting-outputs

echo "==> Step 4: Copy native source files into generated project"
# The ios/ folder already has our custom files (AppDelegate, Info.plist,
# entitlements, LiveActivityController, widget extension sources).
# flutter create may regenerate some defaults — our files take precedence.

echo "==> Step 5: Install CocoaPods"
cd ios
pod install --repo-update
cd ..

echo ""
echo "============================================================================"
echo " MANUAL XCODE STEPS REQUIRED"
echo "============================================================================"
echo ""
echo " Open ios/Runner.xcworkspace in Xcode and complete these steps:"
echo ""
echo " 1. ADD WIDGET EXTENSION TARGET"
echo "    File > New > Target > Widget Extension"
echo "    Product Name: LiveActivityExtension"
echo "    Bundle ID:    com.antigravity.kinetic-hiit.LiveActivityExtension"
echo "    - Check 'Include Live Activity'"
echo "    - Minimum Deployment: iOS 16.1"
echo ""
echo " 2. REPLACE GENERATED SWIFT FILES"
echo "    Delete the auto-generated Swift files in the LiveActivityExtension"
echo "    group and add these from ios/LiveActivityExtension/:"
echo "      - HIITLiveActivityWidget.swift"
echo "      - Info.plist"
echo "      - LiveActivityExtension.entitlements"
echo ""
echo " 3. SHARE HIITLiveActivityAttributes"
echo "    The struct in ios/Runner/LiveActivityController.swift defines"
echo "    HIITLiveActivityAttributes. Add LiveActivityController.swift to"
echo "    BOTH the Runner AND LiveActivityExtension targets so they share"
echo "    the same ActivityAttributes type."
echo ""
echo " 4. CONFIGURE RUNNER TARGET"
echo "    Runner > Signing & Capabilities:"
echo "      - Enable HealthKit"
echo "      - Add App Groups: group.com.antigravity.kinetic"
echo "      - Set Code Signing Entitlements to Runner/Runner.entitlements"
echo ""
echo " 5. CONFIGURE EXTENSION TARGET"
echo "    LiveActivityExtension > Signing & Capabilities:"
echo "      - Add App Groups: group.com.antigravity.kinetic"
echo "      - Set Code Signing Entitlements to"
echo "        LiveActivityExtension/LiveActivityExtension.entitlements"
echo ""
echo " 6. VERIFY BUILD"
echo "    Product > Build (Cmd+B) — both targets should compile."
echo ""
echo " 7. DOWNLOAD FONTS"
echo "    The pubspec.yaml references local font files in fonts/."
echo "    Download Lexend and Inter from Google Fonts and place the .ttf"
echo "    files in the fonts/ directory, or switch to google_fonts package"
echo "    for runtime fetching (already in pubspec as a dependency)."
echo ""
echo "============================================================================"
echo " Bootstrap complete. Open ios/Runner.xcworkspace to finish Xcode setup."
echo "============================================================================"
