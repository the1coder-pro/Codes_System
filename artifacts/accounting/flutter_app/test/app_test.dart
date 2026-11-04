import 'package:accounting_ui/main.dart';
import 'package:accounting_ui/invoice_screen.dart';
import 'package:accounting_ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shell renders ribbon and status bar', (tester) async {
    await tester.pumpWidget(const AccountingApp());
    await tester.pump();
    expect(find.text('القائمة الرئيسية'), findsOneWidget);
    expect(find.textContaining('مؤسسة العيدان'), findsOneWidget);
  });

  testWidgets(
    'menus align right and ribbon buttons have equal padded heights',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const AccountingApp());
      await tester.pumpAndSettle();
      final menu = tester.getRect(find.text('القائمة الرئيسية'));
      expect(menu.right, greaterThan(1200));
      final buttons = [
        'الفواتير\nوأوامر الصرف',
        'طباعة\nالباركود',
        'الحسابات',
        'الأصناف',
        'ارسال واعتماد\nالفواتير',
        'آلة حاسبة',
        'تحديث',
        'موقعنا',
        'Arabic',
        'خروج',
      ];
      for (final label in buttons) {
        expect(
          tester.getSize(find.byKey(ValueKey('ribbon-$label'))).height,
          74,
        );
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'payment buttons open validated amounts and support split payments',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(body: InvoiceScreen(typeIndex: 0, onExit: () {})),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final entry in {'cash': '125.50', 'network': '25.00'}.entries) {
        await tester.tap(find.byKey(ValueKey('payment-${entry.key}')));
        await tester.pumpAndSettle();
        if (entry.key == 'cash') {
          await tester.enterText(
            find.byKey(const ValueKey('payment-amount')),
            '-1',
          );
          await tester.tap(find.text('تأكيد المبلغ'));
          await tester.pumpAndSettle();
          expect(find.text('أدخل مبلغاً صحيحاً لا يقل عن صفر'), findsOneWidget);
        }
        await tester.enterText(
          find.byKey(const ValueKey('payment-amount')),
          entry.value,
        );
        await tester.tap(find.text('تأكيد المبلغ'));
        await tester.pumpAndSettle();
        expect(
          find.descendant(
            of: find.byKey(ValueKey('payment-${entry.key}')),
            matching: find.text(entry.value),
          ),
          findsOneWidget,
        );
      }
      expect(find.text('-150.50'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('payment-credit')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('payment-amount')),
        '99',
      );
      await tester.tap(find.text('إلغاء'));
      await tester.pumpAndSettle();
      expect(find.text('-150.50'), findsOneWidget);
      expect(
        tester
            .widget<Material>(find.byKey(const ValueKey('payment-network')))
            .color,
        AppColors.mint,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
