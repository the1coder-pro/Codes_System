import 'package:accounting_ui/main.dart';
import 'package:accounting_ui/barcode_screen.dart';
import 'package:accounting_ui/invoice_screen.dart';
import 'package:accounting_ui/inventory_screen.dart';
import 'package:accounting_ui/resizable_split.dart';
import 'package:accounting_ui/theme.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _launchAndLogin(
  WidgetTester tester, {
  String username = 'admin',
  bool tryInvalidPassword = false,
}) async {
  await tester.pumpWidget(const AccountingApp());
  await tester.pumpAndSettle();
  expect(find.byKey(const ValueKey('login-dialog')), findsOneWidget);

  if (tryInvalidPassword) {
    await tester.enterText(
      find.byKey(const ValueKey('login-password')),
      'wrong',
    );
    await tester.tap(find.byKey(const ValueKey('login-submit')));
    await tester.pumpAndSettle();
    expect(find.text('كلمة المرور غير صحيحة'), findsOneWidget);
  }

  if (username != 'admin') {
    await tester.tap(find.byKey(const ValueKey('login-user')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(username).last);
    await tester.pumpAndSettle();
  }
  await tester.enterText(find.byKey(const ValueKey('login-password')), '1233');
  await tester.tap(find.byKey(const ValueKey('login-submit')));
  await tester.pumpAndSettle();
  expect(find.byKey(const ValueKey('login-dialog')), findsNothing);
}

void main() {
  testWidgets('shell renders ribbon and status bar', (tester) async {
    await _launchAndLogin(
      tester,
      username: 'cashier1',
      tryInvalidPassword: true,
    );
    expect(find.text('القائمة الرئيسية'), findsOneWidget);
    expect(find.textContaining('مؤسسة العيدان'), findsOneWidget);
    expect(find.text('25.08.18 - (cashier1)'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('bottom-status-bar'))).width,
      tester.getSize(find.byKey(const ValueKey('top-menu-bar'))).width,
    );
    final textContext = tester.element(find.text('القائمة الرئيسية'));
    expect(
      Theme.of(textContext).textTheme.bodyMedium?.fontFamily,
      appFontFamily,
    );
    expect(DefaultTextStyle.of(textContext).style.fontFamily, appFontFamily);
  });

  testWidgets('screen navigation uses Fluent fade and slide transitions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _launchAndLogin(tester);

    await tester.tap(find.byKey(const ValueKey('ribbon-الأصناف')));
    await tester.pump(const Duration(milliseconds: 40));
    final transition = find.byKey(const ValueKey('app-content-transition'));
    expect(
      find.descendant(of: transition, matching: find.byType(SlideTransition)),
      findsWidgets,
    );
    await tester.pumpAndSettle();
    expect(find.byType(InventoryScreen), findsOneWidget);
    expect(find.text('➕'), findsNothing);
    expect(find.text('↩️'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('menus align right and ribbon buttons stay compact on desktop', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _launchAndLogin(tester);
    final menu = tester.getRect(find.text('القائمة الرئيسية'));
    expect(menu.right, greaterThan(960));
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
      expect(tester.getSize(find.byKey(ValueKey('ribbon-$label'))).height, 92);
      final rect = tester.getRect(find.byKey(ValueKey('ribbon-$label')));
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(1024));
    }
    final ribbon = find.byKey(const ValueKey('ribbon-container'));
    expect(
      find.descendant(of: ribbon, matching: find.byType(SingleChildScrollView)),
      findsNothing,
    );
    final iconRect = tester.getRect(find.text('🧾'));
    final labelRect = tester.getRect(find.text('الفواتير وأوامر الصرف'));
    expect(iconRect.center.dx, closeTo(labelRect.center.dx, 1));
    expect(iconRect.bottom, lessThan(labelRect.top));
    expect(
      tester.widget<Text>(find.text('🧾')).style!.fontSize,
      greaterThan(22),
    );
    expect(
      tester.widget<Text>(find.text('الفواتير وأوامر الصرف')).style!.fontSize,
      greaterThan(9.5),
    );
    final mainAction = tester.getRect(
      find.byKey(const ValueKey('ribbon-الفواتير\nوأوامر الصرف')),
    );
    final utilityAction = tester.getRect(
      find.byKey(const ValueKey('ribbon-خروج')),
    );
    expect(mainAction.center.dx, greaterThan(utilityAction.center.dx));
    final hoveredButton = find.byKey(
      const ValueKey('ribbon-الفواتير\nوأوامر الصرف'),
    );
    final initialRect = tester.getRect(hoveredButton);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: initialRect.center);
    await mouse.moveTo(initialRect.center);
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getRect(hoveredButton), initialRect);
    final actionButton = tester.widget<fluent.Button>(
      find.descendant(of: hoveredButton, matching: find.byType(fluent.Button)),
    );
    expect(
      actionButton.style!.backgroundColor!.resolve({WidgetState.hovered}),
      Colors.transparent,
    );
    await mouse.removePointer();
    expect(buildFluentTheme().typography.body!.fontFamily, 'IBMPlexSansArabic');
    expect(tester.takeException(), isNull);
  });

  testWidgets('small screens show the full toolbar without horizontal scroll', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 850);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _launchAndLogin(tester);

    final ribbon = find.byKey(const ValueKey('ribbon-container'));
    for (final label in [
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
    ]) {
      final button = find.byKey(ValueKey('ribbon-$label'));
      expect(button, findsOneWidget);
      final rect = tester.getRect(button);
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(400));
    }
    expect(
      find.descendant(of: ribbon, matching: find.byType(SingleChildScrollView)),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'payment defaults to cash and transfers the sole amount on selection',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        fluent.FluentApp(
          theme: buildFluentTheme(),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(body: InvoiceScreen(typeIndex: 0, onExit: () {})),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (final icon in [
        fluent.FluentIcons.up,
        fluent.FluentIcons.down,
        fluent.FluentIcons.add,
        fluent.FluentIcons.remove,
      ]) {
        expect(find.byIcon(icon), findsOneWidget);
      }
      expect(find.text('⬆️'), findsNothing);
      expect(find.text('⬇️'), findsNothing);
      expect(find.text('➕'), findsNothing);
      expect(find.text('➖'), findsNothing);

      String amount(String key) => tester
          .widget<fluent.TextBox>(find.byKey(ValueKey('payment-field-$key')))
          .controller!
          .text;

      await tester.tap(find.text('اختيار الأصناف'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('إضافة').first);
      await tester.pumpAndSettle();
      expect(amount('cash'), isNot('0'));
      expect(
        (tester
                    .widget<Container>(
                      find.byKey(const ValueKey('payment-cash')),
                    )
                    .decoration!
                as BoxDecoration)
            .color,
        AppColors.mint,
      );

      final cashAmount = amount('cash');
      await tester.tap(find.byKey(const ValueKey('payment-option-network')));
      await tester.pumpAndSettle();
      expect(amount('cash'), '0');
      expect(amount('network'), cashAmount);

      await tester.enterText(
        find.byKey(const ValueKey('payment-field-cash')),
        '10.00',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('payment-option-credit')));
      await tester.pumpAndSettle();
      expect(amount('cash'), '10.00');
      expect(amount('network'), cashAmount);
      expect(amount('credit'), '0');
      expect(
        (tester
                    .widget<Container>(
                      find.byKey(const ValueKey('payment-credit')),
                    )
                    .decoration!
                as BoxDecoration)
            .color,
        AppColors.mint,
      );
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('resizable panel divider changes the first panel width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox.expand(
            child: ResizableSplit(
              first: Container(key: const ValueKey('first-panel')),
              second: Container(key: const ValueKey('second-panel')),
              initialFirstFraction: .4,
              minFirstWidth: 180,
              minSecondWidth: 200,
              dividerKey: const ValueKey('test-panel-divider'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final before = tester
        .getSize(find.byKey(const ValueKey('first-panel')))
        .width;
    await tester.drag(
      find.byKey(const ValueKey('test-panel-divider')),
      const Offset(-50, 0),
    );
    await tester.pumpAndSettle();
    final after = tester
        .getSize(find.byKey(const ValueKey('first-panel')))
        .width;
    expect(after, greaterThan(before));
    expect(tester.takeException(), isNull);
  });

  testWidgets('accounts can be added and searched', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _launchAndLogin(tester);
    await tester.tap(find.byKey(const ValueKey('ribbon-الحسابات')));
    await tester.pumpAndSettle();

    expect(find.text('➕'), findsNothing);
    expect(find.text('↶'), findsNothing);
    expect(find.text('الشيكات المستلمة'), findsOneWidget);
    await tester.tap(find.text('جديد'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('account-field-nameAr')),
      'حساب اختبار',
    );
    await tester.enterText(
      find.byKey(const ValueKey('account-field-nameEn')),
      'Test account',
    );
    await tester.tap(find.text('حفظ'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    const newAccountRow = ValueKey('account-row-1000006');
    expect(find.byKey(newAccountRow), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('accounts-search')),
      'الشيكات',
    );
    await tester.pumpAndSettle();
    expect(find.text('الشيكات المستلمة'), findsOneWidget);
    expect(find.byKey(newAccountRow), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('barcode selection works on a narrow screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(400, 850);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: BarcodeScreen(onExit: () {})),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('طباعة الباركود'), findsOneWidget);
    expect(find.text('ورق تصوير A4'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('barcode-row-2004')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('barcode-date-تاريخ الإنتاج')));
    await tester.pumpAndSettle();
    expect(find.byType(fluent.DatePicker), findsOneWidget);
    await tester.tap(find.text('إلغاء'));
    await tester.pumpAndSettle();
    final barcodeField = tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(const ValueKey('barcode-value')),
        matching: find.byType(EditableText),
      ),
    );
    expect(barcodeField.controller.text, '4006381333931');
    expect(tester.takeException(), isNull);
  });
}
