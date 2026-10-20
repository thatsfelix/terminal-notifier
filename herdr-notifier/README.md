# Herdr notifier

A renamed copy of `terminal-notifier.app` for [Herdr](https://github.com/herdrdev/herdr)
system notifications on macOS. It only changes how the notification looks in Notification Center
(name and icon, which macOS takes from the app bundle). `terminal-notifier` itself is unchanged.

Herdr prefers `~/Applications/Herdr notifier.app/Contents/MacOS/terminal-notifier` and falls back to
`terminal-notifier` on `PATH`, so the bundle is optional.

## Build

```sh
# Source: a terminal-notifier.app, e.g. from the upstream release zip
./herdr-notifier/build.sh /path/to/terminal-notifier.app
```

What `build.sh` changes in the copy:

| Item | Value |
|---|---|
| `CFBundleName`, `CFBundleDisplayName` | `Herdr notifier` |
| `CFBundleIdentifier` | `cn.zeehub.herdr-notifier` (override with `HERDR_NOTIFIER_BUNDLE_ID`) |
| `CFBundleIconFile` | `RamDark` (`RamDark.icns`) |
| `LSUIElement` | `true` |
| Signature | ad hoc: `codesign --force --deep --sign -` |

Then run the app once and allow notifications for it in System Settings.

## Notes

- Tested against terminal-notifier 3.1.0 (arm64). The build prints its usage and exits 1 when
  `-message` is empty or whitespace, and exits 2 for `-`; the Herdr changes work around this by
  falling back to the notification title.
- `RamDark.icns` is derived from the Herdr logo (`assets/logo.*` in herdrdev/herdr, Apache-2.0).
- Related Herdr changes: https://github.com/thatsfelix/herdr/tree/fix/macos-notification-navigation
  and https://github.com/herdrdev/herdr/discussions/5422
