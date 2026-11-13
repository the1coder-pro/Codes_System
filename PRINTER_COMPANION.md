# Standalone Desktop Accounting App

The Flutter desktop build runs the complete accounting interface without a
browser or Node.js. It starts the loopback-only printing service automatically
and uses Flutter's `printing` plugin to discover printers and print PDFs.

## Build the standalone system

Install Flutter and the platform's normal desktop build tools. From the
repository root, run:

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

## Use the web app with a separate print-only companion

For a web app that runs separately, build the old print-only window with
`--dart-define=PRINTER_SERVICE_ONLY=true`. Leave it open, copy its pairing token,
and enter it under **الإدارة → إدارة الطابعات** in the browser.

For custom app domains, set `PRINTER_ALLOWED_ORIGINS` to the exact origin (or
comma-separated origins) when launching the companion. Replit preview and
published domains are allowed by default.

## Platform setup

- macOS: both debug and release entitlements include printer access, local
  network client/server access, and Keychain access for secure passwords.
- Linux: install `libsecret-1-dev` to build and `libsecret-1-0` to run the app.
- Windows: install Visual Studio Build Tools with the C++ ATL component.


## Print formats

Invoices and barcode sheets are generated as PDFs using IBM Plex Sans Arabic.
The barcode companion uses the selected printer and the document's A4 page
format; the barcode label dimensions and grid are laid out inside the page.