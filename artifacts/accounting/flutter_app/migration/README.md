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

The uploaded CSV archive has all 357 expected table files, exact headers, and
1,544,263 rows. Its rows fit the current candidate field-length limits. A
temporary SQLite import passes all schema constraints only when empty CSV
fields are treated as SQL `NULL`; the strict check reports duplicate empty
values in four unique-indexed fields. The archive does not distinguish `NULL`
from a genuine zero-length string, so that conversion is not safe.

The supplied CSV archive contains 53,400 nonempty
`tblMoneyTransaction.TransactionDate` values whose day component is `00`.
These are not valid SQL dates, and the SQL Server `DATETIME2` candidate cannot
store them. Do not normalize them. The archive has been checked against the
original upload and is byte-for-byte identical; verify these values from the
Access database before deciding how to store them.

Run the structural/constraint check with:

```sh
python3 scripts/migration/validate_legacy_csv_export.py \
  --archive attached_assets/0_Archive_1795026221028.zip
```

`--empty-as-null` is available only to test that interpretation; it is not a
data-import setting and can change valid empty strings. The cross-platform
exporter uses Java 11+ and Maven to read the database locally through
UCanAccess. On macOS or Linux, run:

```sh
./scripts/migration/export_access.sh \
  --database "$HOME/path/to/legacy.accdb" \
  --output "$HOME/path/to/legacy-access-export.zip"
```

On Windows, the PowerShell alternative is:

```powershell
powershell -NoProfile -File .\scripts\migration\export_access.ps1 `
  -DatabasePath "C:\path\to\legacy.accdb" `
  -OutputPath "C:\path\to\legacy-access-export.zip"
```

The Java exporter downloads its pinned Java dependencies from Maven Central on
the first run. Both exporters read the Access file without changing its
business records, check table and column names against the exact legacy
manifest, stream the tables into a ZIP, distinguish SQL `NULL` from empty text,
format dates invariantly, and encode binary fields as base64. The Java route
does not require Microsoft Access or its Windows-only database driver. The
PowerShell route requires the Microsoft Access Database Engine matching the
PowerShell process architecture. Each exporter removes a partial output if
schema validation or a table read fails; neither uploads nor prints business
records.

Validate either resulting archive with Python 3:

```sh
python3 ./scripts/migration/validate_legacy_csv_export.py \
  --archive "$HOME/path/to/legacy-access-export.zip" \
  --null-marker '\N' \
  --escape-prefix '\'
```

The temporary validation database is deleted automatically. This exporter
produces a local validation package; a production data importer and online/offline
synchronization are not implemented yet.

## Offline and online direction

The initial direction is SQLite on each offline-capable device and SQL Server
for shared online data, with a single logical legacy schema and exact
identifiers in both stores. The server can run on Linux; desktop and web clients
should reach it through the application API rather than depend on Windows SQL
drivers. Synchronization, conflict handling, and dialect-specific storage
rules must be designed and tested before connecting screens to the new stores.
No synchronization engine is implemented by the schema generator.
