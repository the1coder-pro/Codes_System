---
name: Dart printer companion
description: Project decision for silent printing from the browser app
---

The desktop app offers two modes: standalone Flutter accounting with device-local records and the loopback Dart print service, or a local web companion that launches the existing web/API stack plus the same Dart print service. The web companion expects the full repository, installed Node.js/pnpm/Flutter, and a configured PostgreSQL database. `PRINTER_SERVICE_ONLY=true` remains available for a print-only helper.

**Why:** The user wants both a local Flutter desktop system and a companion for running the locally hosted web UI/API with printing. The standalone mode remains Node-free and keeps records on that device; the web companion uses the user's installed Node.js and pnpm, while printing remains Dart. Browser security prevents silent printer access directly from the web app. On macOS, sandboxed builds need Keychain, print, network, and selected-folder entitlements.

**How to apply:** Keep both modes available from the desktop startup chooser and preserve the direct `PRINTER_COMPANION` and `PRINTER_WEB_COMPANION` build flags. The standalone mode uses OS secure storage for role passwords and local records. The web companion selects a full repository, reads its `.env` without displaying secrets, builds/starts the local API and UI, launches the Dart printer service, then stops child services on exit. Preserve printer defaults and barcode overrides and keep output as PDFs. On macOS, retain Keychain, print, network client/server, and user-selected folder entitlements; verify real printers before claiming hardware validation.
