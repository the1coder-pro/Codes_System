# Legacy `CodesSystem` feature map

This map records the legacy structure as found in the `CodesSystem` repository
and the current Flutter implementation. Legacy names below are source
identifiers; keep their spelling, capitalization, Arabic labels, and existing
misspellings unchanged during the port.

## Repository shape

- `WindowsApp1` contains the WinForms shell and forms.
- `DAL` contains 355 `*Model.vb` data model files and Access/OLE DB data access.
- `Report` and `Reporting` contain invoice, receipt, account, and label reports
  and print templates.
- `ZATCA` contains Saudi e-invoicing integration and invoice XML handling.
- `DBExportImport` contains database export/import UI.
- The supplied schema export contains 357 tables and 982 indexes, but does not
  define foreign keys or include business records.

## Program families

These names come from the legacy `ProgramUseTypeEnum` and must remain intact:

| Arabic name | English name | Existing code |
| --- | --- | --- |
| المحاسبة العامة | Shop | Codes101 |
| إدارة الأملاك | Estate Menagment | Codes102 |
| الوحدات السكنية المفروشة | Furnished Housing Units | Codes103 |
| الخدمات العامة | General Services | Codes104 |
| المطابخ والمطاعم | Kitchen and Restaurant | Codes105 |
| المقاولات | Contracting | Codes106 |
| شؤون الموظفين | Employees | Codes107 |
| تأجير العمال | Worker Rent | Codes108 |
| المعارض والمستودعات | Showroom and Store | Codes109 |
| النظام الإداري الشامل | General Menagment System | Codes110 |
| الجمعيات واللجان الخيرية | Charitable associations | Codes111 |
| النظافة الشاملة | The Total Cleaning | Codes112 |
| قطع الغيار | Spare Part | Codes113 |
| المصانع | Factories | Codes114 |
| الجمعيات الاستثمارية | association | Codes115 |
| الصالات والاستراحات | Rest House | Codes116 |
| مغاسل الملابس | Laundries | Codes117 |
| المشاغل النسائية | Women's Concerns | Codes118 |
| الخياطة والزي الموحد | Sewing and Uniforms | No folder code in the enum entry |

## Legacy navigation and forms

The main desktop shell is `MainForm`. The primary business flow opens
`InvoiceTypeSelectForm`, then `InvoiceForm`; `InvoiceSearchForm` opens an
existing invoice for editing. Other exact form names include:

- `StartupForm`, `LoginForm`, `frmLoginNew`
- `accountsForm`, `ItemsForm`, `ItemFormcopy`, `PrintBarcodesForm`
- `frmBasicData`, `frmBasicDataInOneTable`, `frmGetReport`
- `BalanceChackingForm`
- `BackupForm`, `BackupsForm`, `BackupFolderPathsForm`, `DatabaseFixerForm`
- `ProgramSettingForm`, `ChangeLogForm`, `UpdateDetailsForm`, `WaitForm`
- `ZATCAIntegerationLoginForm`, `ZATCAIntegrationLink_Form`
- `DBExportImport.Form1`

The shell also exposes receipt/payment documents, unified lists, reports,
settings, backup management, and invoice repair/compliance actions. Capture
each actual menu label and permission rule from the source before porting it;
do not replace a legacy form or menu name with a more modern synonym.

## Data and business domains found in the legacy model layer

The `tbl` tables and model files cover financial accounts, item groups and
units, invoices and invoice lines, receipts and money transactions, inventory
balances/movements, branches and users, documents and contacts, contracts and
installments, employees/payroll/attendance/absence, education and student
records, real-estate units and rentals, restaurant/laundry-specific records,
SMS history, backups, reporting configuration, and ZATCA invoice data.

`migration/legacy_schema_manifest.json` is the generated exact-name inventory
of the supplied table, column, key, and index declarations. Its column names
are parsed candidates from the export. The core item, account, invoice, and
transaction fields listed below have additionally been reconciled against
their matching VB.NET DAL models. The remaining schema still needs equivalent
model/Access metadata reconciliation before its fields are used for conversion.

The matching DAL models in the private `CodesSystem` source confirm these
core relationships:

| Legacy model | Exact database table | Confirmed fields |
| --- | --- | --- |
| `ItemGroupModel` | `tblItemGroup` | `ID`, `NameAr`, `NameEn`, `ShortName`, `VAT`, `NotUsed`, `UseTypeID`, `ItemTypeID`, `FilePath`, `ItemNote`, `VaTCategoriesID` |
| `ItemModel` | `tblItem` | `ID`, `Price`, `MinimumPrice`, `WholesalePrice`, `quickitem`, `ItemGroupID`, `WithVatPrice` |
| `ItemOtherDataModel` | `tblItemOtherData` | `ItemID`, `ColorID`, `BarcodeNo`, `ItemPlaceID`, `ItemSizeID`, `UnitCount` |
| `ItemBalanceModel` | `tblItemBalance` | `ItemID` plus the legacy balance, movement, and price fields |
| `accountModel` | `tblAccount` | Account identifiers, names, balances, branch/type, notes, and address fields |
| `tblInvoiceModel` | `tblInvoice` | Invoice identifiers, type, account references, dates, totals, payment transaction, and status fields |
| `tblInvoiceItemModel` | `tblInvoiceItem` | `InvoiceID`, `ID`, `ItemID`, `Price`, `Qty`, discounts, cost, tax, and expiry |
| `tblMoneyTransactionModel` | `tblMoneyTransaction` | `ID`, `CodeID`, `PCID`, `TransactionDate` |

The selected field-level mappings are kept in
`artifacts/accounting/flutter_app/migration/legacy_model_field_map.json`.
Some VB.NET property spellings/capitalization differ from Access column
spellings (for example, `accountModel.acountNote` versus `tblAccount.AcountNote`).
SQL must use the exact database identifier from the schema manifest; do not
rename either legacy identifier to make the two source spellings look alike.

This confirms the item hierarchy: `tblItemGroup.ID` identifies the displayed
group, each `tblItem.ID` identifies a billable item/unit and references that
group through `ItemGroupID`, and `tblItemOtherData.ItemID` stores its barcode,
size, color, place, and unit count. Before connecting the Flutter inventory
screen to these tables, load the existing `tblItemType`, `tblItemSize`,
`tblColor`, and `tblVaTCategories` lookup records and map by their stored IDs.
The current screen's Arabic labels are not a safe substitute for those IDs.
The current Flutter `Item` also keeps separate `id` and `group` values, while
the legacy group record has a single `ID`; its `imageBase64` value is not the
same representation as legacy `FilePath`. These differences need an explicit
model/UI mapping before CRUD can be switched to the legacy tables.

The supplied CSV archive contains matching headers for all 357 tables and
1,544,263 rows. A temporary SQLite import succeeds when every empty field is
interpreted as `NULL`, but four unique indexes reject duplicate empty strings
under strict import. The archive does not encode whether those blanks were
`NULL` or genuine zero-length strings, so a lossless import still requires the
original Access database or an export with an explicit null marker.

It also contains 53,400 nonempty `tblMoneyTransaction.TransactionDate` values
with an invalid day-of-month value of `00`. Do not normalize these dates.
Confirm the original values from Access before mapping this column to a typed
SQL Server date.

## Current Flutter coverage

The existing Flutter foundation contains the main accounting shell, login and
role permissions, inventory and unit rows, account records, the eight invoice
types, invoice history/drafts, barcode printing, printer and invoice layout
settings, local printer companion, and local backup/restore. Its local storage
is now SQLite-backed, but existing business screens still store app-shaped JSON
snapshots in the separate `app_local_settings` table. The verified legacy
relational tables have not yet been connected to those screens, and online
synchronization is not implemented.

The Flutter DAL now has shared legacy model definitions and repository
operations for the core item, account, invoice, and money-transaction tables,
with SQLite and Supabase data-source adapters. SQL Server was selected for the
complete online legacy schema to preserve long index names; its API adapter and
server connection remain future work.

The screens now expose their original form identifiers as compatibility names:
`MainForm`, `ItemsForm`, `accountsForm`, `InvoiceTypeSelectForm`, `InvoiceForm`,
`InvoiceSearchForm`, and `PrintBarcodesForm`. The Flutter implementation may
retain its internal screen-class names, but navigation and public form names
must continue to support these legacy identifiers.

The rewrite must extend this app rather than replace its functioning screens.
The legacy domains above that are not yet represented in Flutter remain
migration work; listing a domain here does not claim it has already been
ported.

## Data compatibility rules

1. Keep every legacy UI/form/menu name, table/column/index name, and stored
   code exact.
2. Preserve source identifiers and values. Type conversion may change only the
   storage representation required by the destination SQL engine; verify the
   value is identical after round-trip.
3. Store new sync metadata separately. Never overwrite a legacy field to encode
   online/offline state.
4. Treat missing Access relationships, values, or semantics as unresolved
   until confirmed from the original database/source. Report ambiguity instead
   of silently renaming or transforming data.
5. Validate import counts, primary keys, unique indexes, and representative
   value comparisons before importing any real business data.

PostgreSQL cannot preserve six legacy index names because they exceed its
63-byte identifier limit. The exact-name requirement is confirmed, so the
online candidate is SQL Server, whose 128-character limit accommodates every
identifier. SQLite remains the validated offline schema. The SQL Server DDL
still needs verification against a real target and representative data before
it is used by the app.
