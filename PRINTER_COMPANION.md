# Standalone Desktop Accounting App

The Flutter desktop build runs the complete accounting interface without a
browser or Node.js. It starts the loopback-only printing service automatically
and uses Flutter's `printing` plugin to discover printers and print PDFs.

## Build the single companion app

From the Flutter app root, build the platform-specific launcher with one
command:

```sh
bash scripts/build_accounting_companion.sh
```

The same app opens a simple choice: the standalone desktop UI or the local web
UI in a browser. Do not add a mode-specific `--dart-define`; the launcher starts
the selected UI and the Dart printer service.

On Windows, run `.\scripts\build_accounting_companion.ps1` from PowerShell.

For web mode, choose a full `Codes_System` checkout on first launch. The
companion saves its location, runs `pnpm install --frozen-lockfile`, builds the
API and web UI, starts both plus the Dart printer service, and opens the browser.
Later launches start automatically from the saved checkout. Web mode requires
Node.js, pnpm, Flutter, and a running local PostgreSQL database configured in
`.env`.

The standalone option keeps records on this device and does not need Node.js,
pnpm, Flutter SDK, or a browser after the launcher has been built.

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

## Configure invoice print layouts

Open **إدارة → إدارة الطابعات والفواتير**, then choose the **الفواتير** tab.
Each invoice type has its own paper, design, and language settings. Available
formats are thermal 58/80 mm, A4 portrait, and A4 landscape. Choose Arabic,
English, or bilingual output, review the live sample preview, and save. Settings
are stored locally on the current device.

## Advanced: use a print-only helper with a separately started web app

For a web app that runs separately, build the old print-only window with
`--dart-define=PRINTER_SERVICE_ONLY=true`. Leave it open, copy its pairing token,
and enter it under **الإدارة → إدارة الطابعات** in the browser.

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