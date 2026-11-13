# Local Printer Companion

The accounting web app cannot access installed printers silently from the
browser. The Flutter desktop companion runs on the workstation, exposes a
loopback-only HTTP service, and uses Flutter's `printing` plugin to discover
printers and print PDF jobs without a browser dialog.

## Build for a workstation

Install Flutter and the platform's normal desktop build tools on the build
computer. From `artifacts/accounting/flutter_app`, run one of:

```sh
flutter build windows --dart-define=PRINTER_COMPANION=true
flutter build macos --dart-define=PRINTER_COMPANION=true
flutter build linux --dart-define=PRINTER_COMPANION=true
```

The resulting desktop app includes its Flutter runtime and does not require
Node.js or a separate Dart installation on the workstation.

## Pair

1. Launch the companion app and leave its window open.
2. Copy the pairing token shown in the app.
3. In the accounting web app, open **الإدارة → إدارة الطابعات**.
4. Paste the token, connect, and choose separate invoice and barcode printers.
5. Open the barcode form and choose a different printer for an individual job
   if needed.

Printer names and pairing settings are local to that workstation's operating
system and browser profile. The companion binds to `127.0.0.1:17863` only.
Accept the browser's local-network permission prompt if it appears.

For custom app domains, set `PRINTER_ALLOWED_ORIGINS` to the exact origin (or
comma-separated origins) when launching the companion. Replit preview and
published domains are allowed by default.

## Print formats

Invoices and barcode sheets are generated as PDFs using IBM Plex Sans Arabic.
The barcode companion uses the selected printer and the document's A4 page
format; the barcode label dimensions and grid are laid out inside the page.
