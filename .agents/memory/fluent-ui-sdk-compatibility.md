---
name: Fluent UI SDK compatibility
description: Validate fluent_ui versions against this app's actual Flutter toolchain.
---

Do not rely only on fluent_ui's declared minimum Flutter version. Some releases may reference framework APIs newer than that minimum and fail compilation.

**Why:** During integration, releases declared compatible with Flutter 3.32 but used APIs absent from the installed SDK.

**How to apply:** Before upgrading fluent_ui, run the widget tests and a Flutter web release build with the app's pinned SDK.
