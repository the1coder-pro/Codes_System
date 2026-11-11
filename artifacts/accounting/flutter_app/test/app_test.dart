import 'package:accounting_ui/main.dart';
import 'package:accounting_ui/barcode_screen.dart';
import 'package:accounting_ui/invoice_screen.dart';
import 'package:accounting_ui/inventory_screen.dart';
import 'package:accounting_ui/item_image.dart';
import 'package:accounting_ui/models.dart';
import 'package:accounting_ui/resizable_split.dart';
import 'package:accounting_ui/storage.dart';
import 'package:accounting_ui/theme.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
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
    await tester.tap(find.byKey(const ValueKey('login-clear')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<fluent.TextBox>(find.byKey(const ValueKey('login-password')))
          .controller!
          .text,
      isEmpty,
    );
    expect(find.text('كلمة المرور غير صحيحة'), findsNothing);
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
  testWidgets('login dialog places the fields left of the lock', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const AccountingApp());
    await tester.pumpAndSettle();

    expect(
      tester
          .widgetList<ModalBarrier>(find.byType(ModalBarrier))
          .any((barrier) => barrier.color == AppColors.canvasBlue),
      isTrue,
    );
    expect(
      (tester
                  .widget<Container>(find.byKey(const ValueKey('login-panel')))
                  .decoration!
              as BoxDecoration)
          .color,
      Colors.white,
    );
    final fields = tester.getRect(find.byKey(const ValueKey('login-fields')));
    final lock = tester.getRect(find.byKey(const ValueKey('login-lock')));
    expect(fields.center.dx, lessThan(lock.center.dx));
    expect(
      tester.getRect(find.text('تسجيل الدخول')).bottom,
      lessThan(tester.getRect(find.byKey(const ValueKey('login-user'))).top),
    );
    expect(
      tester.getRect(find.byKey(const ValueKey('login-submit'))).top,
      greaterThan(
        tester.getRect(find.byKey(const ValueKey('login-password'))).bottom,
      ),
    );
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('login-lock')))
          .style!
          .fontSize,
      greaterThan(100),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('shell renders ribbon and status bar', (tester) async {
    await _launchAndLogin(
      tester,
      username: 'cashier1',
      tryInvalidPassword: true,
    );
    expect(find.text('القائمة الرئيسية'), findsOneWidget);
    expect(find.textContaining('مؤسسة العيدان'), findsOneWidget);
    expect(find.text('25.08.18 - (cashier1)'), findsOneWidget);
    final backupInfo = tester.getRect(
      find.text('آخر نسخة احتياطية: 2025/08/30'),
    );
    final companyInfo = tester.getRect(
      find.text('نسخة خاصة بـ : مؤسسة العيدان التجارية'),
    );
    expect(backupInfo.center.dx, lessThan(companyInfo.center.dx));
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

  testWidgets('inventory side panels can be collapsed and reopened', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _launchAndLogin(tester);
    await tester.tap(find.byKey(const ValueKey('ribbon-الأصناف')));
    await tester.pumpAndSettle();

    final gridArea = find.byKey(const ValueKey('inventory-items-grid-area'));
    final resizeViewport = find.byKey(
      const ValueKey('inventory-resize-viewport'),
    );
    final searchSection = find.byKey(
      const ValueKey('inventory-search-section-size'),
    );
    final sectionToggle = find.byKey(
      const ValueKey('splitter-inventory-search-section-toggle'),
    );
    final verticalDivider = find.byKey(
      const ValueKey('splitter-inventory-search-section'),
    );
    final searchHeightBeforeResize = tester.getSize(searchSection).height;
    await tester.drag(verticalDivider, const Offset(0, 80));
    await tester.pumpAndSettle();
    final smallerSearchHeight = tester.getSize(searchSection).height;
    expect(smallerSearchHeight, lessThan(searchHeightBeforeResize));
    final searchPanel = find.byKey(const ValueKey('inventory-search-panel'));
    expect(
      find.descendant(
        of: searchPanel,
        matching: find.byType(SingleChildScrollView),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: searchPanel, matching: find.byType(Scrollbar)),
      findsOneWidget,
    );
    final filterScrollView = find.descendant(
      of: searchPanel,
      matching: find.byType(SingleChildScrollView),
    );
    final filterScrollable = find.descendant(
      of: filterScrollView,
      matching: find.byType(Scrollable),
    );
    expect(
      tester
          .state<ScrollableState>(filterScrollable.first)
          .position
          .maxScrollExtent,
      greaterThan(0),
    );

    await tester.drag(verticalDivider, const Offset(0, -1000));
    await tester.pumpAndSettle();
    expect(tester.getSize(verticalDivider).height, 48);
    expect(
      tester.getSize(searchSection).height,
      closeTo(tester.getSize(resizeViewport).height - 48, 1),
    );

    await tester.tap(sectionToggle);
    await tester.pumpAndSettle();
    expect(tester.getSize(searchSection).height, 0);
    expect(gridArea, findsOneWidget);
    await tester.tap(sectionToggle);
    await tester.pumpAndSettle();
    expect(
      tester.getSize(searchSection).height,
      closeTo(tester.getSize(resizeViewport).height - 48, 1),
    );

    final searchToggle = find.byKey(
      const ValueKey('splitter-inventory-search-toggle'),
    );
    expect(searchPanel, findsOneWidget);
    final searchWidthBefore = tester.getSize(searchPanel).width;
    await tester.drag(
      find.byKey(const ValueKey('splitter-inventory-search')),
      const Offset(-40, 0),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(searchPanel).width, greaterThan(searchWidthBefore));
    await tester.tap(searchToggle);
    await tester.pumpAndSettle();
    expect(searchPanel, findsNothing);
    expect(find.text('التصفية'), findsOneWidget);
    await tester.tap(searchToggle);
    await tester.pumpAndSettle();
    expect(searchPanel, findsOneWidget);

    await tester.tap(sectionToggle);
    await tester.pumpAndSettle();
    expect(tester.getSize(searchSection).height, 0);

    final actionsPanel = find.byKey(const ValueKey('inventory-actions-panel'));
    final actionsToggle = find.byKey(
      const ValueKey('splitter-inventory-header-toggle'),
    );
    expect(actionsPanel, findsOneWidget);
    await tester.tap(actionsToggle);
    await tester.pumpAndSettle();
    expect(actionsPanel, findsNothing);
    expect(find.text('الإجراءات'), findsOneWidget);
    await tester.tap(actionsToggle);
    await tester.pumpAndSettle();
    expect(actionsPanel, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('inventory uploads and persists an item image', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final imageBytes = img.encodePng(img.Image(width: 8, height: 8));

    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: InventoryScreen(
              onExit: () {},
              pickImageBytes: () async => imageBytes,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('تعديل').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('inventory-unit-quick-0')));
    await tester.tap(find.byKey(const ValueKey('inventory-image-upload')));
    await tester.pumpAndSettle();
    expect(find.byType(ItemImage), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    await tester.tap(find.text('حفظ').first);
    await tester.pumpAndSettle();
    var savedItems = await Store.loadItems();
    expect(savedItems.first.imageBase64, isNotNull);
    expect(savedItems.first.imageBase64, isNotEmpty);
    expect(savedItems.first.units.first.quick, isTrue);

    await tester.tap(find.text('تعديل').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('inventory-image-remove')));
    await tester.tap(find.text('حفظ').first);
    await tester.pumpAndSettle();
    savedItems = await Store.loadItems();
    expect(savedItems.first.imageBase64, isNull);
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('new inventory items get numbers and paired VAT prices', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: InventoryScreen(onExit: () {})),
        ),
      ),
    );
    await tester.pumpAndSettle();
    fluent.TextBox unitField(int column) => tester.widget<fluent.TextBox>(
      find.descendant(
        of: find.byKey(ValueKey('inventory-unit-cell-0-$column')),
        matching: find.byType(fluent.TextBox),
      ),
    );
    await tester.tap(find.text('جديد').first);
    await tester.pumpAndSettle();
    expect(unitField(0).controller!.text, '2005');

    await tester.enterText(
      find.byKey(const ValueKey('inventory-name-ar')),
      'منتج جديد',
    );
    await tester.enterText(
      find.byKey(const ValueKey('inventory-unit-cell-0-1')),
      '100',
    );
    await tester.pump();
    expect(unitField(4).controller!.text, '115.00');

    await tester.enterText(
      find.byKey(const ValueKey('inventory-unit-cell-0-4')),
      '230',
    );
    await tester.pump();
    expect(unitField(1).controller!.text, '200.00');

    await tester.tap(find.text('حفظ').first);
    await tester.pumpAndSettle();
    final savedItems = await Store.loadItems();
    expect(savedItems.last.id, '2005');
    expect(savedItems.last.units.first.unitNo, '2005');
    expect(savedItems.last.units.first.priceBefore, '200.00');
    expect(savedItems.last.units.first.priceInc, '230');
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('invoice picker shows inventory items as image cards', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final imageBytes = img.encodePng(img.Image(width: 8, height: 8));
    final imageData = optimizeItemImage(imageBytes);
    expect(
      await Store.saveItems([
        Item(
          id: 'P-1',
          nameAr: 'صنف مصور',
          imageBase64: imageData,
          units: [UnitRow(unitNo: '1', priceBefore: '12.50', quick: true)],
        ),
      ]),
      isTrue,
    );

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
    await tester.tap(find.text('اختيار الأصناف'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('invoice-item-grid')), findsOneWidget);
    expect(find.byKey(const ValueKey('invoice-item-card-P-1')), findsOneWidget);
    expect(find.byType(ItemImage), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('صنف مصور'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('invoice-item-add-P-1')));
    await tester.pumpAndSettle();
    expect(find.text('صنف مصور • حبة'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('inventory adds a same-group item with its own unit data', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final original = (await Store.loadItems()).first;

    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: InventoryScreen(onExit: () {})),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('تعديل').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('inventory-name-ar')),
      'اسم محدث',
    );

    await tester.tap(find.byKey(const ValueKey('inventory-new-item')));
    await tester.pumpAndSettle();
    final groupField = tester.widget<fluent.TextBox>(
      find.descendant(
        of: find.byKey(const ValueKey('inventory-group-number')),
        matching: find.byType(fluent.TextBox),
      ),
    );
    expect(groupField.controller!.text, original.group);
    expect(
      tester
          .widget<EditableText>(
            find.descendant(
              of: find.byKey(const ValueKey('inventory-name-ar')),
              matching: find.byType(EditableText),
            ),
          )
          .controller
          .text,
      isEmpty,
    );

    await tester.enterText(
      find.byKey(const ValueKey('inventory-name-ar')),
      'وحدة إضافية',
    );
    final unitType = tester.widget<fluent.ComboBox<String>>(
      find.descendant(
        of: find.byKey(const ValueKey('inventory-unit-type-0')),
        matching: find.byType(fluent.ComboBox<String>),
      ),
    );
    unitType.onChanged?.call('كيلوجرام');
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('inventory-unit-cell-0-1')),
      '42',
    );
    await tester.enterText(
      find.byKey(const ValueKey('inventory-unit-cell-0-9')),
      'أحمر',
    );
    await tester.tap(find.text('حفظ').first);
    await tester.pumpAndSettle();

    final savedItems = await Store.loadItems();
    expect(savedItems.first.nameAr, 'اسم محدث');
    final sibling = savedItems.last;
    expect(sibling.group, original.group);
    expect(sibling.nameAr, 'وحدة إضافية');
    expect(sibling.units.single.size, 'كيلوجرام');
    expect(sibling.units.single.priceBefore, '42');
    expect(sibling.units.single.color, 'أحمر');
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('invoice shows quick items first and searches all items', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await Store.saveItems([
      Item(
        id: 'FAST-1',
        nameAr: 'صنف سريع',
        units: [UnitRow(unitNo: '1', priceBefore: '10', quick: true)],
      ),
      Item(
        id: 'REGULAR-1',
        nameAr: 'صنف عادي',
        units: [UnitRow(unitNo: '1', priceBefore: '20')],
      ),
    ]);

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
    await tester.tap(find.text('اختيار الأصناف'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('invoice-item-card-FAST-1')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('invoice-item-card-REGULAR-1')),
      findsNothing,
    );

    await tester.enterText(
      find.byKey(const ValueKey('invoice-item-search')),
      'REGULAR-1',
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('invoice-item-card-FAST-1')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('invoice-item-card-REGULAR-1')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('invoice shows each unit type with its own price', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await Store.saveItems([
      Item(
        id: 'MULTI-1',
        nameAr: 'صنف متعدد',
        units: [
          UnitRow(unitNo: '1', size: 'حبة', priceBefore: '5', quick: true),
          UnitRow(unitNo: '2', size: 'كرتون', priceBefore: '50', quick: true),
        ],
      ),
    ]);

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
    await tester.tap(find.text('اختيار الأصناف'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('invoice-item-card-MULTI-1-1')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('invoice-item-card-MULTI-1-2')),
      findsOneWidget,
    );
    expect(find.text('MULTI-1 • كرتون'), findsOneWidget);
    expect(find.text('50.00'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('invoice-item-add-MULTI-1-2')));
    await tester.pumpAndSettle();
    expect(find.text('صنف متعدد • كرتون'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('invoice deletes all mouse-selected rows in one action', (
    tester,
  ) async {
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
    await tester.tap(find.text('اختيار الأصناف'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('invoice-item-search')),
      '1001',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('إضافة').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('إضافة').first);
    await tester.pumpAndSettle();

    expect(find.byType(fluent.Checkbox), findsNothing);
    expect(find.byKey(const ValueKey('invoice-side-row-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('invoice-side-row-1')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('invoice-side-row-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('invoice-side-row-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('حذف صنف'));
    await tester.pumpAndSettle();
    expect(find.text('حذف أصناف'), findsOneWidget);
    expect(find.text('حذف 2 أصناف محددة من الفاتورة؟'), findsOneWidget);

    await tester.tap(find.text('نعم، تأكيد'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('invoice-side-row-0')), findsNothing);
    await tester.pump(const Duration(seconds: 3));
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
      await tester.enterText(
        find.byKey(const ValueKey('invoice-item-search')),
        '1001',
      );
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
