# Flutter legacy DAL

The Flutter DAL keeps one legacy model and repository contract while swapping
the database adapter. Each table model has its own source file:

- `lib/dal/legacy_model.dart` defines the shared model base and table metadata.
- `lib/dal/models/` contains one file per model: `item_group_model.dart`,
  `item_model.dart`, `item_other_data_model.dart`, `item_balance_model.dart`,
  `account_model.dart`, `invoice_model.dart`, `invoice_item_model.dart`, and
  `money_transaction_model.dart`.
- `lib/dal/legacy_models.dart` is a small export barrel, so existing callers
  can continue to import all models from one stable path.
- The table mappings cover `tblItemGroup`, `tblItem`, `tblItemOtherData`,
  `tblItemBalance`, `tblAccount`, `tblInvoice`, `tblInvoiceItem`, and
  `tblMoneyTransaction`.
- `LegacyRepository<T>` in `lib/dal/legacy_data_source.dart` offers the same
  list, primary-key lookup, upsert, and delete operations for either backend.
- `SqliteLegacyDataSource` uses a Drift connection.
- `SupabaseLegacyDataSource` uses Supabase's PostgREST API through the existing
  `http` dependency. It does not require or embed a service-role key, but it is
  not the selected online target for the complete legacy schema.

The models keep exact table and column spelling and use `Object?` values rather
than automatically converting legacy values to Dart dates or enums. This is
intentional: historic Access exports include invalid date strings and stored
integer lookup IDs that must not be normalized or guessed.

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

This layer unifies CRUD and serialization; it does not yet implement offline
queueing, conflict resolution, or synchronization between the local database
and the future online SQL Server service.
