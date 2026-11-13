# Local Printer Service

The accounting app is hosted in a browser and cannot select an operating-system
printer or print silently by itself. This Electron companion runs on each
workstation, lists that computer's installed printers, and sends invoice or
barcode HTML to the selected printer without opening a browser print dialog.

## Supported computers

Windows, macOS, and Linux desktops with Node.js 22 or later and pnpm 10.
The service binds only to `127.0.0.1:17863`; it is not exposed to the network.

## Start and pair a workstation

From the project root on the workstation:

```sh
pnpm install
pnpm --filter @workspace/local-printer-agent run show-token
```

Keep that terminal running. Copy the pairing token shown there, sign in to the
accounting app on the same computer, open **إدارة → إدارة الطابعات**, paste the
token, and choose the invoice and barcode printers. The two defaults are stored
in that browser profile on this workstation. The barcode screen can still
override its default for an individual print.

On later launches, start the service with:

```sh
pnpm --filter @workspace/local-printer-agent start
```

To display the pairing token again, stop the service and run `show-token`.
Allow the browser's local-network permission prompt if it appears.

## Custom app domains

Replit preview and published app domains are allowed by default. For a custom
domain, set `PRINTER_ALLOWED_ORIGINS` to its exact origin before starting the
service, for example `https://accounting.example.com`. Separate multiple
origins with commas.

## Notes

- Printers must already be installed and available to the operating-system
  account running the service.
- Removing browser storage clears the saved token and printer choices; pair
  that browser profile again.
- This source version runs in a terminal. It does not install itself as a
  background service or launch automatically when the computer starts.
