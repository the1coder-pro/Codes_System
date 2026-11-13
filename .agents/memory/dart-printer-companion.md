---
name: Dart printer companion
description: Project decision for silent printing from the browser app
---

With `PRINTER_COMPANION=true`, the Flutter desktop app is the standalone accounting system: launch the accounting UI, local authentication, device-local records, and the loopback Dart printing service together. Keep the browser app and its API authentication as a separate path. `PRINTER_SERVICE_ONLY=true` remains available for a print-only helper.

**Why:** The user chose a standalone Flutter desktop app, device-local data without web sync, and admin-managed passwords for all four roles. They explicitly chose Dart so workstations do not need Node.js. Browser security prevents silent printer access directly from the web app. On macOS, sandboxed builds need Keychain, print, and network client/server entitlements.

**How to apply:** In standalone desktop mode, use OS secure storage for role passwords and auto-start the Dart print service; keep accounting records on that device and do not imply web synchronization. Preserve local printer defaults and barcode overrides. Keep invoice and barcode output as PDFs. For macOS, retain Keychain, print, and network client/server entitlements in debug and release builds, then verify behavior on real printers before claiming hardware validation.
