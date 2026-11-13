---
name: Dart printer companion
description: Project decision for silent printing from the browser app
---

Use a Flutter desktop companion with a loopback-only Dart HTTP service and direct PDF printing. Keep the accounting web app as the user interface and send generated PDFs to the companion.

**Why:** The user explicitly chose Dart so workstations do not need Node.js. Browser security prevents silent printer access directly from the web app.

**How to apply:** Preserve the local pairing token, printer defaults, and barcode override. Keep invoice and barcode print output as PDFs and verify behavior on actual Windows, macOS, and Linux printers before claiming hardware validation.
