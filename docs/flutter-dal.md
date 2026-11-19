# Flutter legacy DAL

## Model catalog

The catalog mirrors the private `CodesSystem/DAL` source: **355 VB.NET model
files, 357 class declarations, and 2,136 public properties**. Each source class
has its own Dart file in `lib/dal/models/`; original class names, property
spellings, capitalization, and VB.NET type names are recorded without
normalizing them.

- `lib/dal/legacy_model.dart` contains the shared table model, raw source-model
  representation, exact table metadata, and explicit mapping status.
- `lib/dal/models/` contains one file per source class.
- `lib/dal/legacy_models.dart` exports all model files.
- `lib/dal/legacy_model_catalog.dart` exposes the full source metadata registry.
- `migration/legacy_dal_model_catalog.json` is the generated completeness
  manifest. It records class/file/property counts, original VB types, table
  mapping status, and source parsing warnings.
- `scripts/migration/generate_flutter_dal_models.py` regenerates the catalog
  from the checked-out DAL source and supports `--check`.

The eight mappings confirmed against the supplied schema remain full
`LegacyModel` table models:

| Model | Exact table |
| --- | --- |
| `ItemGroupModel` | `tblItemGroup` |
| `ItemModel` | `tblItem` |
| `ItemOtherDataModel` | `tblItemOtherData` |
| `ItemBalanceModel` | `tblItemBalance` |
| `accountModel` | `tblAccount` |
| `tblInvoiceModel` | `tblInvoice` |
| `tblInvoiceItemModel` | `tblInvoiceItem` |
| `tblMoneyTransactionModel` | `tblMoneyTransaction` |

The other 349 source classes have separate Dart model files and explicit
`unresolved` table status. Their exact source properties and VB type names are
captured, but no database table name is guessed. `LegacySourceModel` stores
values in an immutable raw map, preserves the original keys and values, and
rejects keys that are not present in that source class's property list. This
keeps stored codes, invalid date text, and other Access values from being
silently converted or normalized.

Four source files reach end-of-file without a closing `End Class`. Their
properties are still cataloged, and the source warnings are retained in the
manifest rather than silently repaired:
`tblInvoiceItemNoteModel.vb`, `tblInvoiceModel.vb`,
`tblMoneyTransactionModel.vb`, and `tblObjectModel.vb`.

## Shared table repository

`LegacyRepository<T>` in `lib/dal/legacy_data_source.dart` provides list,
primary-key lookup, upsert, and delete operations for mapped table models.

- `SqliteLegacyDataSource` uses a Drift connection.
- `SupabaseLegacyDataSource` uses Supabase's PostgREST API through the existing
  `http` dependency. It does not require or embed a service-role key, but it is
  not the selected online target for the complete legacy schema.

Example:

```dart
final repository = LegacyRepository<ItemModel>(
  dataSource: sqliteDataSource, // or SupabaseLegacyDataSource
  definition: ItemModel.definition,
);
final item = await repository.byKey({'ID': 594});
```

`SqliteLegacyDataSource` expects the legacy tables to already be installed in
the supplied Drift database. Schema import/install is deliberately separate;
the current app's local database still contains settings and transitional
JSON snapshots rather than the complete legacy relational schema.

The user selected SQL Server for the full online legacy schema because its
identifier limit accommodates the exact legacy index names. Flutter should
reach that database through the application API, not connect directly with
database credentials. A SQL Server API adapter and server-side connection are
not implemented yet.

The Supabase adapter remains available for a compatible Supabase schema. It
cannot preserve six legacy index names longer than PostgreSQL's 63-byte
identifier limit, so it must not be used as the full legacy-schema store unless
the user later approves that exception. If used for another schema, enable Row
Level Security and use only a public/anon key plus the signed-in user's access
token.

This layer unifies CRUD and serialization for the eight confirmed table
mappings; it does not yet implement offline queueing, conflict resolution, or
synchronization between the local database and the future online SQL Server
service. The other catalog models need confirmed table relationships before
they can be used through `LegacyRepository`.
