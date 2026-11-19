# Accounting System — Program and Operations Guide

This guide explains the current cross-platform Flutter application, how its
main screens and services work, and how it relates to the legacy
`CodesSystem` application. It distinguishes working features from migration
work that is still pending. Legacy labels, class names, table names, column
names, index names, and stored values are compatibility identifiers: keep their
original spelling and capitalization.

## 1. Product and repository overview

The project is a Flutter rewrite of the legacy financial accounting program.
The old application is a Windows desktop system built with VB.NET/WinForms and
Microsoft Access. This repository keeps the existing Flutter accounting
application and adds a migration foundation intended to preserve the old
program's names and data while making the application usable on desktop and
web.

The legacy repository has several distinct program families. Its source
contains the WinForms shell and screens in `WindowsApp1`, about 355 VB.NET DAL
model files, reporting and print-template projects, ZATCA integration, and
database export/import tools. The supplied schema export describes 357 tables
and 982 indexes. It does not declare foreign keys, so relationships must be
confirmed from source behavior or the original database rather than inferred
from similar names.

The legacy families include general accounting/shop management, property
management, furnished housing, general services, restaurants, contracting,
employee affairs, worker rental, showrooms and stores, administrative
management, charitable organizations, cleaning, spare parts, factories,
investment associations, rest houses, laundries, women's salons, and sewing
and uniforms. The current Flutter app is the accounting foundation; it does
not yet implement all of these legacy program families.

## 2. Main Flutter structure

The Flutter code is under `artifacts/accounting/flutter_app/lib/`.

| Area | Responsibility |
| --- | --- |
| `main.dart` | Chooses browser startup, the desktop mode picker, standalone desktop, or a companion-only mode. |
| `shell.dart` | Main window frame, login dialog, top menus, ribbon buttons, stacked forms, status area, role checks, and navigation. |
| `inventory_screen.dart` | Item form, unit rows, image, prices, fast-item setting, search and filters. |
| `accounts_screen.dart` | Account list, account fields, address/contact/document tabs, and account actions. |
| `invoice_menu.dart` | Bilingual menu of the eight invoice types and access to invoice history. |
| `invoice_screen.dart` | Invoice tabs, item selection, quantities, payment allocation, totals, draft handling, save, and save-and-print. |
| `invoice_history_screen.dart` | Search and review of locally saved invoices, with the available edit/print actions. |
| `barcode_screen.dart` | Item selection and barcode-label settings and printing. |
| `printer_settings_screen.dart` | Printer selection and invoice paper/design settings. |
| `local_printer_service.dart`, `printer_companion.dart` | Local printer discovery and print-job handling for the desktop companion. |
| `local_sqlite_store.dart`, `storage.dart` | Local application persistence, backups, invoice sequence, settings, and drafts. |
| `dal/` | Exact-name legacy model definitions, the common data-source contract, and SQLite/Supabase adapters. |
| `auth_service.dart`, `local_auth_service.dart` | Web/API authentication and device-local authentication paths. |

The app uses Flutter with `fluent_ui` controls and a right-to-left Arabic
layout. Its main UI compatibility names include `MainForm`, `ItemsForm`,
`accountsForm`, `InvoiceTypeSelectForm`, `InvoiceForm`, `InvoiceSearchForm`,
and `PrintBarcodesForm`.

## 3. Starting and running the program

### 3.1 Browser or Replit web preview

The configured accounting workflow builds the Flutter web release and serves
the output. From the repository root, the relevant commands are:

```sh
pnpm install --frozen-lockfile
pnpm --filter @workspace/accounting run build
pnpm --filter @workspace/accounting run serve
```

The Replit workflow runs its configured development command, which builds the
web app and starts the static server. The API server is a separate workflow:

```sh
pnpm --filter @workspace/api-server run dev
```

The API currently provides authentication and permission routes. Business
screens in the browser still use local SQLite-compatible storage (SQLite
WebAssembly with browser persistence); they do not yet read or write the
verified legacy relational tables on a shared server.

### 3.2 Desktop launcher

Run or build the Flutter desktop app from `artifacts/accounting/flutter_app`.
When started normally on a desktop, it first shows a launcher with two choices:

1. **Desktop standalone application** — opens the accounting UI directly,
   initializes local storage, and starts the printer companion. This mode is
   designed for local use and does not require Node.js.
2. **Browser-based local web UI** — asks for the complete project checkout,
   checks for Node.js, pnpm, Flutter, the configured environment, and required
   ports; installs locked dependencies; builds the API and web UI; starts the
   local printer service, API server, and web server; and opens the browser.

The web-companion startup code currently requires a local PostgreSQL
`DATABASE_URL` in the checkout's `.env` file. The current API business-data
routes are not yet connected to the legacy SQL schema, so this startup
requirement must not be interpreted as completed online business-data
synchronization. Keep `.env` and all passwords out of Git.

Common developer commands, run from the repository root:

```sh
cd artifacts/accounting/flutter_app
flutter pub get --enforce-lockfile
flutter run -d macos
flutter build macos
```

Replace `macos` with an installed Flutter desktop target such as `windows` or
`linux`. Use `flutter doctor` if the target SDK or native desktop toolchain is
not installed. A normal desktop launch displays the mode picker; build flags
are only for specialized companion/service startup.

The web companion asks for the full `Codes_System` project folder because it
uses that checkout's lockfile, scripts, API, and Flutter build. It remembers
the selected folder on that computer. Use its Start and Stop controls rather
than closing child server processes manually.

## 4. Login, roles, and authorization

The login dialog selects one of four roles:

- `admin`
- `cashier1`
- `cashier2`
- `auditor`

Web authentication posts to `/api/auth/login`; protected actions also ask the
API to authorize the requested permission. Desktop standalone uses the local
secure-storage authentication implementation. The web companion can manage
role passwords after verifying the administrator password. New/changed
passwords must meet the companion's minimum length requirements.

The role permission matrix currently used by the program is:

| Permission | Admin | Cashier 1 | Cashier 2 | Auditor |
| --- | :---: | :---: | :---: | :---: |
| View inventory and accounts | Yes | Yes | Yes | Yes |
| Manage or delete inventory/accounts | Yes | No | No | No |
| View and save invoices | Yes | Yes | Yes | View only |
| Print invoices | Yes | Yes | No | Yes |
| Apply invoice discounts | Yes | Yes | No | No |
| Approve/send invoices | Admin permission exists; screen action is not implemented |
| View and print barcodes | Yes | Yes | Yes | Yes |
| Manage users, printers, and backups | Yes | No | No | No |

The role list is enforced both in the Flutter UI and by the API authorization
endpoint. Production operation requires a configured session-signing secret
and role passwords. Do not use development fallback credentials in a
production environment. Store deployment values in the environment's secrets
facility or in a private local environment file; never put them in source code.

### Runtime configuration

| Setting | Purpose |
| --- | --- |
| `SESSION_SECRET` | Signs API login sessions; required for API login and authorization. |
| `ACCOUNTING_ROLE_PASSWORDS` | JSON object containing the four role passwords. Configure strong passwords for production. |
| `DATABASE_URL` | Currently required by the local web companion to start its PostgreSQL-backed workspace runtime; legacy business tables are not yet connected to it. |
| `PRINTER_ALLOWED_ORIGINS` | Comma-separated browser origins permitted to use the local printer service. |

The local web companion stores its generated or updated role-password
configuration and session secret in the platform's secure local storage, then
restarts the API after a password change. Do not copy these values into a
public issue, screenshot, or committed `.env` file.

## 5. Main window and navigation

The main window contains:

- A top dropdown menu with the main screen, administration, tools, and item
  actions.
- A ribbon with the main invoice, barcode, accounts, inventory, and
  invoice-approval entries, plus refresh, website, language, exit, and
  calculator controls.
- A content area. The blue home canvas means no form is currently open.
- A bottom status bar.

Forms are stacked. Opening another form leaves the previous form underneath;
closing the top form returns to the previous one. Multiple invoice forms may
remain open at the same time. If an invoice has unsaved changes, the app asks
before discarding them. Saved drafts are restored after login.

Not every legacy-looking menu control is connected yet. For example, the
website and invoice-approval/send controls currently display an unavailable
notice; company data and some user-management entries are also unfinished.
Do not treat a visible ribbon item as proof that the legacy integration is
complete.

## 6. Inventory (`ItemsForm`)

The inventory form supports:

- Creating, editing, saving, undoing, and deleting items, subject to role
  permissions.
- Arabic and English item names, short name, group/type, usage, VAT settings,
  notes, and item image selection.
- Multiple billable unit rows within a group. Each row can have its own unit
  label, barcode, prices, color/size-related values, and quantity.
- Automatic item numbering and price/VAT calculation in the current UI model.
- A `quick item` setting: quick items appear in the invoice's quick-add tab;
  other items are chosen through search.
- Search and filtering in a resizable area alongside the results list.

The current app's `Item` and `UnitRow` are UI-domain models. They are not yet
the same schema as the legacy `tblItemGroup`, `tblItem`, `tblItemOtherData`,
and `tblItemBalance` rows. The lookup IDs and group/unit relationships must be
mapped explicitly before replacing current storage with legacy CRUD.

## 7. Accounts (`accountsForm`)

The account form supports account selection/search and create, edit, save,
undo, and delete actions. Account details include Arabic/English names,
account and payment type, branch, notes, tax/identity details, and contact
information. The lower detail area is organized into tabs for:

- Address
- Documents
- Contact methods

The current screen stores `Account` snapshots locally. It does not yet map all
account data to the exact `tblAccount` column set or to other legacy contact,
document, branch, and account-type tables.

## 8. Invoices (`InvoiceTypeSelectForm` and `InvoiceForm`)

The invoice type menu contains these eight types:

| Arabic | English |
| --- | --- |
| فاتورة شراء | Purchases Invoice |
| فاتورة إرجاع مشتريات | Purchases Return Invoice |
| فاتورة ضريبية مبسطة | Simplified Tax Invoice |
| رجيع فاتورة ضريبية مبسطة (دائن) | Simplified Tax Invoice Return |
| فاتورة تأجير | Rental Invoices |
| فاتورة رجيع تأجير | Rental Return Invoices |
| فاتورة مصاريف | Spent Invoice |
| فاتورة إرجاع مصاريف | Spent Return Invoice |

The invoice form has invoice details, quick-item addition, and item search/
selection tabs. The search tab accepts a barcode; when a scanner types the
barcode and sends Enter, the matching item can be added. Choosing an item
already present increases its quantity rather than creating a duplicate row.
Multiple selected rows can be removed together.

The form records invoice and delivery dates/times, invoice number, account
roles, taxable state and tax rate, notes, discount, item lines, and payment
amounts. The current invoice sequence is six-digit formatted. Payment amounts
can be entered under the payment choices; selecting one payment type assigns
the outstanding amount when there is no split across payment types. The form
calculates line and invoice totals from its current item data.

Unsaved invoices are stored as drafts and restored on login. Each open invoice
has its own form state and draft identity. **Save** stores the invoice locally,
clears its lines and payment values, and prepares the next invoice number.
**Save and print** stores and resets first, then sends the resulting PDF to the
configured invoice printer. If printing fails, the saved invoice remains saved
and the UI reports the print failure; do not save it again simply because the
printer failed.

Invoice history can search saved invoices and exposes the available viewing,
editing, and printing actions. Invoice print settings are configured per
invoice type and include paper format, orientation, language, and thermal
receipt dimensions/design options. The current invoice and history data are
local UI records, not records in the verified legacy `tblInvoice` and
`tblInvoiceItem` tables.

## 9. Barcode printing

`PrintBarcodesForm` lets the user search/select inventory items, configure the
barcode value and label template, and provide item/date/quantity values needed
for labels. Barcode printing uses a separately configurable printer from
invoice printing. The browser can use its standard print path; the desktop
printer companion provides local printer discovery and the native print path
where supported.

## 10. Printer and invoice settings

**Administration → إدارة الطابعات والفواتير** opens a two-tab settings form:

- **Printers**: discover installed printers and select the default printer for
  invoices and the printer for barcodes. A desktop companion can provide the
  local printer list to the web UI.
- **Invoices**: select an invoice type, paper size (including A4 or thermal),
  portrait/landscape orientation, language, and receipt dimensions/design;
  inspect the preview and save settings.

Printer settings and print designs are currently stored with local app
settings. They are not part of the business-data backup described below.

## 11. Local printer companion

The local printer companion is written in Flutter/Dart and uses the operating
system's installed printer list. It can start as part of standalone desktop
mode or as part of the local web companion. For web use, the companion provides
a local authenticated endpoint for printer discovery and print jobs. Allowed
web origins are controlled by `PRINTER_ALLOWED_ORIGINS`; the local service
also uses an access token. Do not expose its local endpoint to a public network
or disable its origin/token checks.

Printer discovery depends on the printer being installed and available to the
current operating-system user. If a printer is missing, first verify it appears
in the operating system's printer settings, then restart the companion and
rediscover printers in the app.

## 12. Local storage and backups

The current screen data is persisted through Drift/SQLite. Existing
SharedPreferences data is copied to the local SQL store during initialization;
the old preference values are retained as a recovery copy. Web builds use
SQLite WebAssembly and browser-managed persistence. Current screens store
serialized app-shaped records in local settings tables, including inventory,
accounts, invoices, drafts, printer preferences, and invoice print settings.
The exact-name legacy relational schema is separate and is not installed in
the app database automatically.

The local backup JSON currently includes:

- Inventory
- Accounts
- Saved invoices
- Next invoice number

It does not include passwords, sessions, printer preferences, or invoice
design settings. The exported file contains readable business data; keep it in
a private, protected location. Restore validates its format and record
structure, shows counts, and asks for confirmation. Confirming restore
**replaces** the current local inventory, accounts, invoices, and sequence.
The restore operation has no in-app undo. Save a separate recovery copy first.
After restoring, restart the app so open screens reload the restored values.

## 13. Data-access layer (DAL)

The shared DAL is in `lib/dal/`:

1. `LegacyModel` keeps values keyed by exact legacy column names and rejects
   unknown fields. Values are intentionally not converted automatically to
   `DateTime`, because some legacy date strings are invalid and must remain
   unchanged until reviewed.
2. `LegacyDataSource` defines common select, upsert, and delete operations.
3. `LegacyRepository<T>` applies model metadata and primary-key validation.
4. `SqliteLegacyDataSource` uses a Drift database connection.
5. `SupabaseLegacyDataSource` uses PostgREST over HTTP.

The model catalog contains all 357 legacy class declarations and their 2,136
public properties in separate Dart files. Exact class names, property names,
capitalization, and original VB.NET types are preserved in each model's source
metadata and in `migration/legacy_dal_model_catalog.json`. Values use raw
`Object?` maps so identifiers, stored codes, and historic invalid dates are not
silently converted.

Eight class-to-table mappings have been confirmed against the supplied schema:

| Model | Table | Primary key |
| --- | --- | --- |
| `ItemGroupModel` | `tblItemGroup` | `ID` |
| `ItemModel` | `tblItem` | `ID` |
| `ItemOtherDataModel` | `tblItemOtherData` | `ItemID` |
| `ItemBalanceModel` | `tblItemBalance` | `ItemID` |
| `accountModel` | `tblAccount` | `ID` |
| `tblInvoiceModel` | `tblInvoice` | `ID` |
| `tblInvoiceItemModel` | `tblInvoiceItem` | `InvoiceID`, `ID` |
| `tblMoneyTransactionModel` | `tblMoneyTransaction` | `ID` |

The other 349 source models have separate files and explicitly unresolved table
mappings. Their table names are not guessed. Both adapters expect their legacy
tables to exist; they do not install the 357-table schema. No business screens
use these repositories yet, and there is no offline queue, conflict resolver,
or synchronization engine.

The user selected SQL Server as the full online legacy database because
PostgreSQL/Supabase cannot preserve six index names longer than PostgreSQL's
63-byte identifier limit. The generic model/repository contract can support a
SQL Server-backed API adapter, but that adapter and server connection are not
implemented. The Supabase adapter is optional and must not be treated as the
full legacy store unless the user approves shortened index names.

## 14. Legacy Access migration

### Known source limitations

The available schema and CSV archive are not yet sufficient to claim a
lossless production import:

- The source schema has 357 tables and 982 indexes, but no foreign-key
  declarations.
- The CSV package contains 1,544,263 rows, but its blank fields do not
  distinguish SQL `NULL` from an intentional empty string. Some unique indexes
  reject duplicate empty strings.
- The export contains 53,400 nonempty `tblMoneyTransaction.TransactionDate`
  values with day `00`. These values must not be normalized or silently
  changed; SQL Server `DATETIME2` cannot represent them as valid dates.
- Five indexed long-text columns need size validation before the SQL Server
  candidate can be used.
- The original `.accdb` file and its metadata are needed to resolve these
  ambiguities.

### Export, validate, and import

On macOS/Linux, the cross-platform exporter uses Java 11+ and Maven with
UCanAccess:

```sh
./scripts/migration/export_access.sh \
  --database "$HOME/path/to/legacy.accdb" \
  --output "$HOME/path/to/legacy-access-export.zip"
```

On Windows, `scripts/migration/export_access.ps1` uses the Microsoft Access
Database Engine matching the PowerShell process architecture. Exporters read
the source and do not modify its records. The output includes a table/column
manifest, preserves SQL `NULL` separately from empty text, and base64-encodes
binary values.

Validate the exported archive:

```sh
python3 scripts/migration/validate_legacy_csv_export.py \
  --archive "$HOME/path/to/legacy-access-export.zip" \
  --null-marker '\N' \
  --escape-prefix '\'
```

Only after strict validation, create a new offline SQLite file:

```sh
python3 scripts/migration/import_legacy_csv.py \
  --archive "$HOME/path/to/legacy-access-export.zip" \
  --output "$HOME/path/to/CodesSystem.sqlite"
```

The importer writes to a new temporary database and publishes it only after
schema, row-count, constraint, and integrity checks pass. It preserves invalid
date text in SQLite and reports it. Do not import into or replace a production
database until the unresolved null/empty and invalid-date semantics are
confirmed and a recovery copy exists.

Useful checks from the repository root:

```sh
python3 scripts/migration/audit_legacy_schema.py
python3 -m unittest discover -s scripts/migration -p 'test_*.py'
cd artifacts/accounting/flutter_app && flutter analyze && flutter test
```

## 15. Current status and next implementation steps

### Implemented in the current Flutter foundation

- Arabic RTL Fluent UI shell and login.
- Role and permission checks.
- Inventory and unit-row UI; accounts UI.
- Eight invoice types, invoice forms, drafts/history, local numbering, and
  save/save-and-print.
- Barcode form and local printer companion.
- Per-type invoice print settings and printer choices.
- Local SQLite persistence, backup and restore.
- Separate DAL model files for all 357 legacy classes; eight table mappings are
  confirmed and the other 349 remain explicitly unresolved.
- Schema audit, CSV validator, importer foundation, and migration tests.

### Not yet implemented or connected

- CRUD in the screens against all exact legacy tables.
- SQL Server server/API adapter and verified SQL Server DDL.
- Offline/online synchronization, conflict handling, and sync metadata.
- Production Access import with resolved blank-value and invalid-date semantics.
- The remaining legacy modules, reports, ZATCA workflows, and their
  permissions.
- Some visible menu actions such as invoice sending/approval and company
  details.
- End-to-end checks against the real Access database and a real SQL Server
  target.

The order for completing the rewrite should be: reconcile remaining models and
relationships; confirm Access value semantics; complete SQL Server schema and
API access; connect one domain at a time through the shared DAL; add
synchronization only after CRUD and round-trip data tests pass; then port the
remaining legacy modules and reports.

## 16. Related references

- [Legacy feature map](legacy-feature-map.md)
- [Flutter DAL details](flutter-dal.md)
- [Schema and data migration instructions](../artifacts/accounting/flutter_app/migration/README.md)
- [Documentation index](README.md)
