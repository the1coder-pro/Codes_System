---
name: Browser file selection
description: Why accounting image uploads use a browser-native file input on web.
---

Use a browser-native file input for web image uploads and keep `file_picker` as the non-web fallback.

**Why:** The generated web plugin registrant omitted `FilePickerWeb` even though `file_picker` was a declared dependency, so the web call could fall back to an unavailable method channel.

**How to apply:** When changing image uploads, preserve the conditional web implementation and check the generated web plugin registrant instead of assuming a declared plugin is registered.
