---
name: Dart printer companion
description: Project decision for silent printing from the browser app
---

Use a Flutter desktop companion with a loopback-only Dart HTTP service and direct PDF printing. Keep the accounting web app as the user interface and send generated PDFs to the companion.

**Why:** The user explicitly chose Dart so workstations do not need Node.js. Browser security prevents silent printer access directly from the web app. On macOS, the sandbox blocks `HttpServer.bind` in a release app unless the server-network entitlement is granted; the debug entitlement does not cover release builds. Printer discovery and printing also require Apple's print entitlement.

**How to apply:** Preserve the local pairing token, printer defaults, and barcode override. Keep invoice and barcode print output as PDFs. For macOS, keep both the server-network and print entitlements enabled in debug and release signing configurations, then verify behavior on actual Windows, macOS, and Linux printers before claiming hardware validation.
