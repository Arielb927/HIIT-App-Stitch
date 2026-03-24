# iOS Scaffold

This workspace does not yet include a generated Flutter `ios/` project (`Runner.xcodeproj` / `Runner.xcworkspace`), so a minimal native scaffold was added manually.

## Included Files

### Runner/
- `AppDelegate.swift` — Standard Flutter app delegate
- `Info.plist` — Bundle config with HealthKit + Live Activities usage descriptions
- `Runner.entitlements` — HealthKit + App Groups capabilities
- `LiveActivityController.swift` — `HIITLiveActivityAttributes` struct (shared with the extension) + start/update/end helpers

### LiveActivityExtension/
- `HIITLiveActivityWidget.swift` — SwiftUI widget with Lock Screen + Dynamic Island layouts
- `Info.plist` — Widget extension bundle config
- `LiveActivityExtension.entitlements` — App Groups capability

### Podfile
- Targets both `Runner` and `LiveActivityExtension`
- Minimum deployment: iOS 16.1 (required for Live Activities)

## How to Generate the Full Xcode Project

Run the bootstrap script from a Mac with Flutter + Xcode:

```bash
chmod +x scripts/bootstrap_ios.sh
./scripts/bootstrap_ios.sh
```

This will:
1. Run `flutter create .` to generate `Runner.xcodeproj` / `Runner.xcworkspace`
2. Run `flutter pub get` + `build_runner`
3. Run `pod install`
4. Print manual Xcode steps (see below)

## Manual Xcode Steps

After the script completes, open `ios/Runner.xcworkspace` in Xcode:

### 1. Add Widget Extension Target
- File > New > Target > **Widget Extension**
- Product Name: `LiveActivityExtension`
- Bundle ID: `com.antigravity.kinetic-hiit.LiveActivityExtension`
- Check **Include Live Activity**
- Minimum Deployment: **iOS 16.1**

### 2. Replace Generated Swift Files
Delete the auto-generated files in the LiveActivityExtension group and add:
- `LiveActivityExtension/HIITLiveActivityWidget.swift`
- `LiveActivityExtension/Info.plist`
- `LiveActivityExtension/LiveActivityExtension.entitlements`

### 3. Share the ActivityAttributes Type
Add `Runner/LiveActivityController.swift` to **both** the Runner and LiveActivityExtension targets, so they share the `HIITLiveActivityAttributes` struct.

### 4. Configure Runner Target
Under Runner > Signing & Capabilities:
- Enable **HealthKit**
- Add **App Groups**: `group.com.antigravity.kinetic`
- Set Code Signing Entitlements to `Runner/Runner.entitlements`

### 5. Configure Extension Target
Under LiveActivityExtension > Signing & Capabilities:
- Add **App Groups**: `group.com.antigravity.kinetic`
- Set Code Signing Entitlements to `LiveActivityExtension/LiveActivityExtension.entitlements`

### 6. Verify Build
Product > Build (Cmd+B) — both targets should compile cleanly.

## Important Notes

- The `@main` attribute appears in both `AppDelegate.swift` (Runner target) and `HIITLiveActivityBundle` (Extension target). This is correct — they are separate compilation targets.
- The `live_activities` Flutter plugin communicates with the native Live Activity controller via platform channels. The plugin handles this automatically once the extension target is properly configured.
- If your bundle ID differs from `com.antigravity.kinetic-hiit`, update the app group string in both entitlement files.
