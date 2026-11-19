import 'dart:convert';

import 'package:accounting_ui/dal/legacy_data_source.dart';
import 'package:accounting_ui/dal/legacy_models.dart';
import 'package:accounting_ui/dal/sqlite_legacy_data_source.dart';
import 'package:accounting_ui/dal/supabase_legacy_data_source.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('legacy models preserve exact column names and raw values', () {
    const invalidHistoricalDate = '2025-05-00 00:00:00';
    final transaction = tblMoneyTransactionModel({
      'ID': 'tx-1',
      'CodeID': 7,
      'PCID': 2,
      'TransactionDate': invalidHistoricalDate,
    });

    expect(transaction.TransactionDate, invalidHistoricalDate);
    expect(transaction.toMap().keys, [
      'ID',
      'CodeID',
      'PCID',
      'TransactionDate',
    ]);
    expect(() => ItemModel({'ID': 1, 'QuickItem': 1}), throwsArgumentError);
    expect(
      ItemBalanceModel.definition.metadata.columns,
      contains('PackingAndUnPackingCount'),
    );
    expect(
      ItemBalanceModel.definition.metadata.columns,
      isNot(contains('PackingandUnPackingCount')),
    );
  });

  test('SQLite repository saves, reads, and deletes the same model', () async {
    final database = _TestDatabase();
    addTearDown(database.close);
    await database.customStatement('''
      CREATE TABLE "tblItem" (
        "ID" INTEGER PRIMARY KEY,
        "Price" REAL NOT NULL,
        "MinimumPrice" REAL NOT NULL,
        "WholesalePrice" REAL NOT NULL,
        "quickitem" INTEGER NOT NULL,
        "ItemGroupID" INTEGER,
        "WithVatPrice" REAL
      )
    ''');

    final repository = LegacyRepository<ItemModel>(
      dataSource: SqliteLegacyDataSource(database),
      definition: ItemModel.definition,
    );
    final row = ItemModel({
      'ID': 594,
      'Price': 25.0,
      'MinimumPrice': 20.0,
      'WholesalePrice': 22.0,
      'quickitem': 1,
      'ItemGroupID': 31,
      'WithVatPrice': 28.75,
    });

    final saved = await repository.save(row);
    expect(saved.ID, 594);
    expect(saved['quickitem'], 1);
    expect((await repository.byKey({'ID': 594}))?.ItemGroupID, 31);

    await repository.deleteByKey({'ID': 594});
    expect(await repository.byKey({'ID': 594}), isNull);
  });

  test(
    'Supabase REST adapter uses exact model names and the shared repository',
    () async {
      final captured = <http.Request>[];
      final client = MockClient((request) async {
        captured.add(request);
        if (request.method == 'POST') {
          final submitted = Map<String, Object?>.from(
            jsonDecode(request.body) as Map,
          );
          return http.Response(jsonEncode([submitted]), 201);
        }
        if (request.method == 'GET') {
          return http.Response(
            jsonEncode([
              {
                'ID': 594,
                'Price': 25,
                'MinimumPrice': 20,
                'WholesalePrice': 22,
                'quickitem': 1,
                'ItemGroupID': 31,
                'WithVatPrice': 28.75,
              },
            ]),
            200,
          );
        }
        return http.Response('', 204);
      });
      final source = SupabaseLegacyDataSource(
        projectUrl: 'https://example.supabase.co',
        anonKey: 'public-test-key',
        client: client,
        accessTokenProvider: () async => 'signed-in-test-token',
      );
      final repository = LegacyRepository<ItemModel>(
        dataSource: source,
        definition: ItemModel.definition,
      );
      final saved = await repository.save(
        ItemModel({
          'ID': 594,
          'Price': 25,
          'MinimumPrice': 20,
          'WholesalePrice': 22,
          'quickitem': 1,
          'ItemGroupID': 31,
          'WithVatPrice': 28.75,
        }),
      );
      final loaded = await repository.byKey({'ID': 594});
      await repository.deleteByKey({'ID': 594});

      expect(saved['quickitem'], 1);
      expect(loaded?.ItemGroupID, 31);
      expect(captured.map((request) => request.method), [
        'POST',
        'GET',
        'DELETE',
      ]);
      expect(captured.first.url.path, '/rest/v1/tblItem');
      expect(captured.first.url.queryParameters['on_conflict'], 'ID');
      expect(captured.first.headers['apikey'], 'public-test-key');
      expect(
        captured.first.headers['Authorization'],
        'Bearer signed-in-test-token',
      );
      expect(captured[1].url.queryParameters['ID'], 'eq.594');
      expect(captured[2].url.queryParameters['ID'], 'eq.594');
      expect(jsonDecode(captured.first.body), containsPair('quickitem', 1));
      expect(jsonDecode(captured.first.body), isNot(contains('QuickItem')));
    },
  );

  test('repository rejects incomplete and extra primary-key fields', () async {
    final repository = LegacyRepository<tblInvoiceItemModel>(
      dataSource: _NoopDataSource(),
      definition: tblInvoiceItemModel.definition,
    );

    await expectLater(
      repository.byKey({'InvoiceID': 'inv-1'}),
      throwsArgumentError,
    );
    expect(
      () =>
          repository.deleteByKey({'InvoiceID': 'inv-1', 'ID': 1, 'ItemID': 2}),
      throwsArgumentError,
    );
  });
}

class _TestDatabase extends GeneratedDatabase {
  _TestDatabase() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  Iterable<TableInfo> get allTables => const [];
}

class _NoopDataSource implements LegacyDataSource {
  @override
  Future<void> delete(
    LegacyTableMetadata table,
    Map<String, Object?> primaryKey,
  ) async {}

  @override
  Future<List<Map<String, Object?>>> select(
    LegacyTableMetadata table, {
    Map<String, Object?> equals = const {},
  }) async => [];

  @override
  Future<Map<String, Object?>> upsert(
    LegacyTableMetadata table,
    Map<String, Object?> values,
  ) async => values;
}
