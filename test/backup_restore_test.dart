import 'dart:convert';

import 'package:accounting_ui/backup_restore_dialog.dart';
import 'package:accounting_ui/storage.dart';
import 'package:accounting_ui/theme.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _pumpBackupDialog(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    fluent.FluentApp(
      theme: buildFluentTheme(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(body: child),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test(
    'exports and restores inventory, accounts, invoices, and sequence',
    () async {
      SharedPreferences.setMockInitialValues({
        'items_v1': jsonEncode([
          {
            'id': 'item-1',
            'nameAr': 'صنف محفوظ',
            'units': [
              {'size': 'حبة', 'priceBefore': '12'},
            ],
          },
        ]),
        'accounts_v1': jsonEncode([
          {'code': 'A-1', 'nameAr': 'حساب محفوظ'},
        ]),
        'invoices_v1': jsonEncode([
          {
            'typeIndex': 0,
            'savedAt': '2026-11-14T10:30:00.000',
            'invoice': {
              'number': '000123',
              'invDate': '2026-11-14T10:00:00.000',
              'delivDate': '2026-11-14T10:00:00.000',
              'lines': [
                {'id': 'line-1', 'name': 'محفوظ', 'qty': 1, 'price': 12},
              ],
            },
          },
        ]),
        'invoice_next_number_v1': 124,
      });

      final encoded = await Store.exportBackup(
        createdAt: DateTime.utc(2026, 11, 14),
      );
      final backup = Store.parseBackup(encoded);
      expect(backup.inventoryCount, 1);
      expect(backup.accountCount, 1);
      expect(backup.invoiceCount, 1);

      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('items_v1', '[]');
      await preferences.setString('accounts_v1', '[]');
      await preferences.setString('invoices_v1', '[]');
      await preferences.setInt('invoice_next_number_v1', 1);

      await Store.restoreBackup(encoded);
      expect((await Store.loadItems()).single.nameAr, 'صنف محفوظ');
      expect((await Store.loadAccounts()).single.nameAr, 'حساب محفوظ');
      expect(
        (await Store.loadInvoices()).single['invoice']['number'],
        '000123',
      );
      expect(preferences.getInt('invoice_next_number_v1'), 124);
    },
  );

  test(
    'rejects invalid and incompatible backups without changing records',
    () async {
      SharedPreferences.setMockInitialValues({
        'items_v1': '[{"id":"existing","units":[]}]',
        'accounts_v1': '[{"code":"keep","nameAr":"keep"}]',
        'invoices_v1': '[]',
        'invoice_next_number_v1': 7,
      });
      final preferences = await SharedPreferences.getInstance();
      final before = Map<String, Object?>.from(
        preferences.getKeys().fold(
          <String, Object?>{},
          (values, key) => values..[key] = preferences.get(key),
        ),
      );

      await expectLater(
        Store.restoreBackup('{"format":"unknown","schemaVersion":1}'),
        throwsFormatException,
      );
      await expectLater(
        Store.restoreBackup(
          '{"format":"accounting-local-backup","schemaVersion":99}',
        ),
        throwsFormatException,
      );
      await expectLater(
        Store.restoreBackup(
          jsonEncode({
            'format': 'accounting-local-backup',
            'schemaVersion': 1,
            'createdAt': '2026-11-14T00:00:00Z',
            'inventory': [
              {'id': 4, 'units': []},
            ],
            'accounts': [],
            'invoices': [],
            'nextInvoiceNumber': 1,
          }),
        ),
        throwsFormatException,
      );

      for (final entry in before.entries) {
        expect(preferences.get(entry.key), entry.value);
      }
    },
  );

  testWidgets('restore requires confirmation before replacing local records', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'items_v1': '[{"id":"existing","nameAr":"قديم","units":[]}]',
      'accounts_v1': '[]',
      'invoices_v1': '[]',
    });
    final backup = await Store.exportBackup();
    await _pumpBackupDialog(
      tester,
      BackupRestoreDialog(openBackup: () async => backup),
    );

    await tester.tap(find.byKey(const ValueKey('backup-restore')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(
      find.byKey(const ValueKey('backup-restore-confirmation')),
      findsOneWidget,
    );
    expect((await Store.loadItems()).single.nameAr, 'قديم');

    await tester.tap(find.byKey(const ValueKey('backup-restore-cancel')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect((await Store.loadItems()).single.nameAr, 'قديم');
    expect(find.byKey(const ValueKey('backup-restore-dialog')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('confirmed restore replaces data and export creates dated JSON', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'items_v1': '[{"id":"existing","nameAr":"قديم","units":[]}]',
      'accounts_v1': '[]',
      'invoices_v1': '[]',
    });
    final preferences = await SharedPreferences.getInstance();
    final replacement = jsonEncode({
      'format': 'accounting-local-backup',
      'schemaVersion': 1,
      'createdAt': '2026-11-14T00:00:00Z',
      'inventory': [
        {'id': 'restored', 'nameAr': 'مستعاد', 'units': []},
      ],
      'accounts': [],
      'invoices': [],
      'nextInvoiceNumber': 12,
    });
    await _pumpBackupDialog(
      tester,
      BackupRestoreDialog(
        openBackup: () async => replacement,
        saveBackup: (contents, fileName) async {
          expect(
            fileName,
            matches(RegExp(r'^accounting-backup-\d{8}-\d{6}\.json$')),
          );
          expect(Store.parseBackup(contents).inventoryCount, 1);
          return 'saved.json';
        },
      ),
    );

    await tester.tap(find.byKey(const ValueKey('backup-restore')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.tap(find.byKey(const ValueKey('backup-restore-confirm')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect((await Store.loadItems()).single.nameAr, 'مستعاد');
    expect(preferences.getInt('invoice_next_number_v1'), 12);
    expect(
      find.text(
        'تمت استعادة النسخة الاحتياطية. أعد تشغيل التطبيق لتحديث الشاشات.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('backup-export')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('تم حفظ النسخة الاحتياطية بنجاح.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
