#!/bin/zsh
# Build "Herdr notifier.app" from an existing terminal-notifier.app.
#
# Usage: build.sh /path/to/terminal-notifier.app [output.app]
# Default output: ~/Applications/Herdr notifier.app
set -euo pipefail

SRC="${1:?usage: build.sh /path/to/terminal-notifier.app [output.app]}"
OUT="${2:-$HOME/Applications/Herdr notifier.app}"
HERE="${0:A:h}"
BUNDLE_ID="${HERDR_NOTIFIER_BUNDLE_ID:-cn.zeehub.herdr-notifier}"
PLIST="$OUT/Contents/Info.plist"

[[ -x "$SRC/Contents/MacOS/terminal-notifier" ]] || { echo "not a terminal-notifier.app: $SRC" >&2; exit 1; }

rm -rf "$OUT"
mkdir -p "${OUT:h}"
ditto "$SRC" "$OUT"

# macOS takes a notification's name and icon from the app bundle.
/usr/libexec/PlistBuddy -c "Set :CFBundleName Herdr notifier" "$PLIST"
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName Herdr notifier" "$PLIST" 2>/dev/null \
  || /usr/libexec/PlistBuddy -c "Add :CFBundleDisplayName string Herdr notifier" "$PLIST"
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $BUNDLE_ID" "$PLIST"
/usr/libexec/PlistBuddy -c "Set :CFBundleIconFile RamDark" "$PLIST" 2>/dev/null \
  || /usr/libexec/PlistBuddy -c "Add :CFBundleIconFile string RamDark" "$PLIST"
# Keep the executable name; Herdr launches Contents/MacOS/terminal-notifier.
/usr/libexec/PlistBuddy -c "Set :LSUIElement true" "$PLIST" 2>/dev/null \
  || /usr/libexec/PlistBuddy -c "Add :LSUIElement bool true" "$PLIST"

cp "$HERE/RamDark.icns" "$OUT/Contents/Resources/RamDark.icns"

# Changing the bundle invalidates the original signature.
codesign --force --deep --sign - "$OUT"

echo "Built: $OUT"
echo "Run it once and allow notifications for 'Herdr notifier' in System Settings."
