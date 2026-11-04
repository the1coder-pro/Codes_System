---
name: Flutter preview rendering
description: Interpreting early screenshots of Flutter web in the preview browser
---

Flutter web can require around ten seconds to show its first frame in the CPU-only preview browser.

**Why:** Initial screenshots showed only the HTML background even though the compiled app loaded successfully; a longer static browser capture displayed the desktop shell correctly.

**How to apply:** When a screenshot is blank, inspect console errors and resource responses, then allow engine initialization before concluding the app is broken. Keep Arabic fonts and CanvasKit local. Do not replace the requested Flutter implementation with React to address capture timing.
