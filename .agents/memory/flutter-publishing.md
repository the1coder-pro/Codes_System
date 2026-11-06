---
name: Flutter publishing dependencies
description: Why release builds must not depend on the preview environment's Dart cache
---

Flutter publishing must explicitly restore locked Dart dependencies before compilation; do not rely on Flutter's implicit up-to-date detection.

**Why:** The publishing environment had the Flutter SDK but lacked the preview's home-directory Pub cache. Implicit restoration was skipped, leading to missing package files and cascading framework compilation errors. A build using an entirely empty cache confirmed that explicit restoration removes that dependency on local state.

**How to apply:** Keep dependency restoration in the release build command, preserve the committed lockfile, and verify publishing changes against an empty package cache rather than only the already-working preview.
