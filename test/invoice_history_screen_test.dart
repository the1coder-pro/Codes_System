import 'dart:convert';

import 'package:accounting_ui/auth_service.dart';
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
        child: Scaffold(
          body: InvoiceHistoryScreen(
            onExit: () {},
            session: const UserSession(
              username: 'test',
              role: AccountingRole.admin,
              token: 'test-token',
            ),
            authService: _AllowAuthService(),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _AllowAuthService implements AccountingAuthService {
  @override
  Future<bool> authorize(UserSession session, String permission) async => true;

  @override
  Future<UserSession> login(String username, String password) async =>
      throw UnimplementedError();
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
    expect(find.byKey(const ValueKey('invoice-history-print')), findsOneWidget);

    final draft = await SharedPreferences.getInstance();
    expect(draft.getString('draft_0'), jsonEncode({'number': 'ACTIVE-DRAFT'}));
  });

  testWidgets('printing a saved invoice does not change invoices or draft', (
    tester,
  ) async {
    final saved = _savedInvoice(
      type: 2,
      number: '000301',
      date: '2026-11-02',
      account: 'Saved account',
    );
    final savedJson = jsonEncode([saved]);
    final draftJson = jsonEncode({
      'number': 'ACTIVE-DRAFT',
      'notes': 'Keep me',
    });
    SharedPreferences.setMockInitialValues({
      'invoices_v1': savedJson,
      'draft_2': draftJson,
    });
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpHistory(tester);
    await tester.tap(
      find.byKey(const ValueKey('invoice-history-record-000301')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('invoice-history-print')));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('invoices_v1'), savedJson);
    expect(prefs.getString('draft_2'), draftJson);
    expect(tester.takeException(), isNull);
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

  testWidgets('history search dialog filters by invoice number', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'invoices_v1': jsonEncode([
        _savedInvoice(
          type: 0,
          number: '000401',
          date: '2026-10-10',
          account: 'First account',
        ),
        _savedInvoice(
          type: 2,
          number: '000402',
          date: '2026-10-11',
          account: 'Second account',
        ),
      ]),
    });
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showInvoiceHistoryDialog(
                  context: context,
                  session: const UserSession(
                    username: 'test',
                    role: AccountingRole.admin,
                    token: 'test-token',
                  ),
                  authService: _AllowAuthService(),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('invoice-history-search-dialog')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('invoice-history-id-filter')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('invoice-history-date-from')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('invoice-history-date-to')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('invoice-history-download')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('invoice-history-print-selected')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey('invoice-history-id-filter')),
      '000402',
    );
    await tester.tap(
      find.byKey(const ValueKey('invoice-history-search-submit')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('invoice-history-result-000402')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('invoice-history-result-000401')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });
}
