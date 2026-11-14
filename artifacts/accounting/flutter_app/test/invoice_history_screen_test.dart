import 'dart:convert';

import 'package:accounting_ui/invoice_history_screen.dart';
import 'package:accounting_ui/theme.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> _savedInvoice({
  required int type,
  required String number,
  required String date,
  required String account,
}) => {
  'typeIndex': type,
  'savedAt': '${date}T12:00:00.000',
  'invoice': {
    'number': number,
    'invDate': '${date}T00:00:00.000',
    'delivDate': '${date}T00:00:00.000',
    'account': account,
    'taxNo': '123456789',
    'taxable': 'خاضع للضريبة',
    'taxRate': '0.15',
    'discount': '2',
    'notes': 'Saved note',
    'lines': [
      {
        'id': 'line-$number',
        'name': 'Saved item',
        'unit': 'piece',
        'qty': 2,
        'price': 10,
      },
    ],
  },
};

Future<void> _pumpHistory(WidgetTester tester) async {
  await tester.pumpWidget(
    fluent.FluentApp(
      theme: buildFluentTheme(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(body: InvoiceHistoryScreen(onExit: () {})),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('searches saved invoices and opens read-only details', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'invoices_v1': jsonEncode([
        _savedInvoice(
          type: 0,
          number: '000101',
          date: '2026-10-18',
          account: 'Supplier One',
        ),
        _savedInvoice(
          type: 1,
          number: '000102',
          date: '2026-10-19',
          account: 'Supplier Two',
        ),
      ]),
      'draft_0': jsonEncode({'number': 'ACTIVE-DRAFT'}),
    });
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpHistory(tester);
    expect(find.text('فاتورة رقم 000101'), findsOneWidget);
    expect(find.textContaining('18/10/2026'), findsOneWidget);
    expect(find.textContaining('فاتورة شراء'), findsOneWidget);
    expect(find.text('فاتورة رقم 000102'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('invoice-history-search')),
      '000101',
    );
    await tester.pumpAndSettle();
    expect(find.text('فاتورة رقم 000101'), findsOneWidget);
    expect(find.text('فاتورة رقم 000102'), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('invoice-history-record-000101')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('invoice-history-details')),
      findsOneWidget,
    );
    expect(find.text('Supplier One'), findsNWidgets(2));
    expect(find.textContaining('Saved item'), findsOneWidget);
    expect(find.text('Saved note'), findsOneWidget);
    expect(find.text('20.70'), findsOneWidget);

    final draft = await SharedPreferences.getInstance();
    expect(draft.getString('draft_0'), jsonEncode({'number': 'ACTIVE-DRAFT'}));
  });

  testWidgets('type filter narrows the saved invoice list', (tester) async {
    SharedPreferences.setMockInitialValues({
      'invoices_v1': jsonEncode([
        _savedInvoice(
          type: 0,
          number: '000201',
          date: '2026-09-01',
          account: 'Supplier One',
        ),
        _savedInvoice(
          type: 1,
          number: '000202',
          date: '2026-09-02',
          account: 'Supplier Two',
        ),
      ]),
    });
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpHistory(tester);
    await tester.tap(find.byKey(const ValueKey('invoice-history-type-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('فاتورة شراء').last);
    await tester.pumpAndSettle();

    expect(find.text('فاتورة رقم 000201'), findsOneWidget);
    expect(find.text('فاتورة رقم 000202'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
