---
name: Legacy schema compatibility
description: Exact naming and value-preservation constraints for migrating the CodesSystem legacy database.
---

Preserve every legacy-facing name and database identifier exactly, and preserve stored business values through Access-to-SQL conversion. Keep offline and online stores logically identical; isolate sync metadata and operational changes from the legacy tables and values.

**Why:** The user requires existing Access data and names to carry into the replacement unchanged so older-device records continue working smoothly.

**How to apply:** During schema reconstruction, SQL dialect conversion, data import, UI porting, and offline/online sync, verify against the legacy source and flag ambiguity instead of silently renaming or transforming data. Resolve `ItemTypeID`, `UseTypeID`, `VaTCategoriesID`, `ItemSizeID`, and `ColorID` through imported legacy lookup rows; UI labels are not safe substitutes for their stored IDs. Keep one Flutter DAL model/repository contract across SQL adapters. The user selected SQL Server for the full online legacy schema because PostgreSQL/Supabase cannot preserve six long index names; Flutter should reach SQL Server through the app API.
