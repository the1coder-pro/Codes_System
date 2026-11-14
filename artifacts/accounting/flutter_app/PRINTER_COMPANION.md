# Standalone Desktop Accounting App

The Flutter desktop build runs the complete accounting interface without a
browser or Node.js. It starts the loopback-only printing service automatically
and uses Flutter's `printing` plugin to discover printers and print PDFs.

## Choose between the two desktop modes

From the full repository's Flutter app folder, build without a mode define to
show the startup chooser:

```sh
flutter build macos
```

Choose either the standalone Flutter system or the local web companion. To
build directly into one mode, use `PRINTER_COMPANION=true` for the standalone
system or `PRINTER_WEB_COMPANION=true` for the local web companion. The web
companion requires Node.js, pnpm, Flutter, PostgreSQL, and a full
`Codes_System` checkout; it starts the local API and web UI and launches the
Dart printer service.

## Build the standalone system

Install Flutter and the platform's normal desktop build tools. From
`artifacts/accounting/flutter_app`, run:

```sh
flutter build windows --dart-define=PRINTER_COMPANION=true
flutter build macos --dart-define=PRINTER_COMPANION=true
flutter build linux --dart-define=PRINTER_COMPANION=true
```

The resulting app opens the accounting system and starts printing on the same
computer. It does not require Node.js or a separate Dart installation. Inventory,
accounts, invoices, printer preferences, and role passwords stay on this
computer and are not synchronized with the browser version.

On first launch, all four roles use password `1233`. Sign in as `admin` and use
**الإدارة → إدارة كلمات المرور** to set new passwords. New passwords must be at
least eight characters and are stored in the operating system's secure storage.

## Manage passwords in local web mode

Start the local web companion and use **إدارة كلمات المرور** in its window.
Verify with the current admin password. The first secure setup requires new
passwords for all four roles; later updates can target one role at a time.
Passwords are stored in the operating system's secure storage, not written to
`.env`. Saving them restarts the local API and invalidates active browser
sessions. The saved passwords are applied when the API is started through this
companion. Web-mode passwords are separate from the standalone Flutter app's
passwords.

## Use the web app with a separate print-only companion

For a web app that runs separately, build the old print-only window with
`--dart-define=PRINTER_SERVICE_ONLY=true`. Leave it open, copy its pairing token,
and enter it under **الإدارة → إدارة الطابعات** in the browser.

Printer names and pairing settings are local to that workstation's operating
system and browser profile. The companion binds to `127.0.0.1:17863` only.
Accept the browser's local-network permission prompt if it appears.

For custom app domains, set `PRINTER_ALLOWED_ORIGINS` to the exact origin (or
comma-separated origins) when launching the companion. Replit preview and
published domains are allowed by default.

## Platform setup

- macOS: both debug and release entitlements include printer access, local
  network client/server access, Keychain access for secure passwords, and
  selected-folder access for the web companion.
- Linux: install `libsecret-1-dev` to build and `libsecret-1-0` to run the app.
- Windows: install Visual Studio Build Tools with the C++ ATL component.

## Print formats

Invoices and barcode sheets are generated as PDFs using IBM Plex Sans Arabic.
The barcode companion uses the selected printer and the document's A4 page
format; the barcode label dimensions and grid are laid out inside the page.
