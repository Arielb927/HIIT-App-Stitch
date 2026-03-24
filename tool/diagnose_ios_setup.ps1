$ErrorActionPreference = "Stop"

Write-Host "Flutter on PATH:" -ForegroundColor Cyan
try {
  flutter --version
} catch {
  Write-Warning "Flutter is not installed or not on PATH."
}

Write-Host ""
Write-Host "Expected iOS scaffold:" -ForegroundColor Cyan
$paths = @(
  "ios\\Runner\\Info.plist",
  "ios\\Runner\\Runner.entitlements",
  "ios\\LiveActivityExtension\\Info.plist",
  "ios\\LiveActivityExtension\\HIITLiveActivityWidget.swift",
  "ios\\Podfile",
  "ios\\Runner.xcodeproj",
  "ios\\Runner.xcworkspace"
)

foreach ($path in $paths) {
  if (Test-Path $path) {
    Write-Host "  OK  $path" -ForegroundColor Green
  } else {
    Write-Host "  MISS $path" -ForegroundColor Yellow
  }
}

Write-Host ""
Write-Host "Recommended commands to run on macOS with Xcode installed:" -ForegroundColor Cyan
Write-Host "  flutter doctor -v"
Write-Host "  flutter clean"
Write-Host "  flutter pub get"
Write-Host "  cd ios; pod repo update; pod install; cd .."
Write-Host "  flutter build ios --debug --no-codesign"
Write-Host "  xcodebuild -workspace Runner.xcworkspace -scheme Runner -sdk iphonesimulator -configuration Debug build"

Write-Host ""
if (-not (Test-Path "ios\\Runner.xcodeproj") -or -not (Test-Path "ios\\Runner.xcworkspace")) {
  Write-Warning "Runner.xcodeproj / Runner.xcworkspace are missing. Generate the iOS project on a Mac first:"
  Write-Host "  flutter create . --org com.antigravity --project-name kinetic_hiit --platforms ios" -ForegroundColor Yellow
}
