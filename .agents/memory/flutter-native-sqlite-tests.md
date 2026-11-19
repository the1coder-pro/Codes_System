---
name: Native SQLite tests
description: Replit environment requirement for Flutter tests that use Drift's native SQLite executor.
---

Install the Nix `sqlite` system dependency before running Flutter tests that open Drift's native SQLite database; Dart FFI otherwise fails to load `libsqlite3.so`.

**Why:** The Flutter test suite includes native Drift-backed storage and repository tests, while the base Replit environment may not expose SQLite's shared library.

**How to apply:** If `flutter test` fails with `Failed to load dynamic library 'libsqlite3.so'`, install `sqlite` through Replit's system dependency flow, then rerun analysis and tests.
