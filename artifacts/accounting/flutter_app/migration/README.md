# Legacy-compatible SQL migration

This folder contains the source schema export, audited SQLite DDL, a
provisional SQL Server DDL candidate, and a JSON manifest for the legacy
`CodesSystem` database.
The export is schema-only: it does not contain customer, invoice, or other
business records.

## Exact-name rule

Do not rename legacy forms, menu entries, entities, tables, columns, indexes,
codes, or stored values for style or convenience. SQL quoting and type spelling
may differ between database engines, but the logical identifiers and record
values must remain unchanged. Keep new synchronization and bookkeeping data in
separate tables rather than adding or repurposing legacy business fields.

## Schema export

`source_access_schema.sql` is the provided MDB Tools export. It has 357 table
definitions and 982 index definitions. Some declarations join the column name
and type without a separator. `scripts/migration/audit_legacy_schema.py`
reconstructs SQLite and SQL Server DDL, then validates every SQLite table,
column, primary key, and index in memory. The SQL Server candidate uses
Unicode-capable text types, wide numeric types, and timezone-free date/time
storage. The legacy identifiers fit SQL Server's 128-character limit, including
the six index names that would be truncated by PostgreSQL's 63-byte limit.
Short text maps to `NVARCHAR(255)`. Long text maps to `NVARCHAR(MAX)`, except
the five legacy indexed long-text columns, which use `NVARCHAR(450)` so SQL
Server can build their named indexes. The source export has no text lengths, so
verify those five fields against actual Access data before import; values over
450 characters must be reported, never truncated. SQLite is the validated
offline schema; the SQL Server file is a candidate only and must be checked
against a real target before use.

The export has no foreign-key declarations. Do not invent relationships from
names alone; reconcile them with the legacy Access metadata and VB.NET queries.
The generated SQLite schema is a local/offline foundation, not an online sync
implementation and not a replacement for the original Access database.

Regenerate and validate after changing the source export:

```sh
python3 scripts/migration/audit_legacy_schema.py
```

The original Access database or a representative data export is still needed
to test record conversion, source-to-target value parity, and online/offline
reconciliation. Do not import live business data until those checks and a
recovery plan are reviewed.

## Offline and online direction

The initial direction is SQLite on each offline-capable device and SQL Server
for shared online data, with a single logical legacy schema and exact
identifiers in both stores. The server can run on Linux; desktop and web clients
should reach it through the application API rather than depend on Windows SQL
drivers. Synchronization, conflict handling, and dialect-specific storage
rules must be designed and tested before connecting screens to the new stores.
No synchronization engine is implemented by the schema generator.
