import 'package:accounting_ui/main.dart';
import 'package:accounting_ui/accounts_screen.dart';
import 'package:accounting_ui/auth_service.dart';
import 'package:accounting_ui/barcode_screen.dart';
import 'package:accounting_ui/invoice_screen.dart';
import 'package:accounting_ui/invoice_menu.dart';
import 'package:accounting_ui/inventory_screen.dart';
import 'package:accounting_ui/item_image.dart';
import 'package:accounting_ui/models.dart';
import 'package:accounting_ui/resizable_split.dart';
import 'package:accounting_ui/storage.dart';
import 'package:accounting_ui/theme.dart';
import 'package:accounting_ui/widgets.dart';
import 'package:accounting_ui/widgets.dart' as app_widgets;
import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

const _adminSession = UserSession(
  username: 'admin',
  role: AccountingRole.admin,
  token: 'test-session',
);
const _testAuthService = _TestAuthService();

class _TestAuthService implements AccountingAuthService {
  const _TestAuthService();

  @override
  Future<bool> authorize(UserSession session, String permission) async =>
      session.can(permission);

  @override
  Future<UserSession> login(String username, String password) async {
    if (password != '1233') {
      throw const FormatException('Invalid credentials');
    }
    final role = UserSession.parseRole(username);
    if (role == null) throw const FormatException('Invalid role');
    return UserSession(username: username, role: role, token: 'test-session');
  }
}

InvoiceScreen _invoiceScreen({
  required VoidCallback onExit,
  UserSession session = _adminSession,
  int typeIndex = 0,
  String? draftId,
  InvoiceDraft? initialDraft,
}) => InvoiceScreen(
  typeIndex: typeIndex,
  onExit: onExit,
  session: session,
  authService: _testAuthService,
  draftId: draftId,
  initialDraft: initialDraft,
);

InventoryScreen _inventoryScreen({
  required VoidCallback onExit,
  UserSession session = _adminSession,
  Future<Uint8List?> Function()? pickImageBytes,
}) => InventoryScreen(
  onExit: onExit,
  session: session,
  authService: _testAuthService,
  pickImageBytes: pickImageBytes,
);

BarcodeScreen _barcodeScreen({required VoidCallback onExit}) => BarcodeScreen(
  onExit: onExit,
  session: _adminSession,
  authService: _testAuthService,
);

AccountsScreen _accountsScreen({
  required VoidCallback onExit,
  UserSession session = _adminSession,
}) => AccountsScreen(
  onExit: onExit,
  session: session,
  authService: _testAuthService,
);

Future<void> _launchAndLogin(
  WidgetTester tester, {
  String username = 'admin',
  bool tryInvalidPassword = false,
}) async {
  await tester.pumpWidget(const AccountingApp(authService: _testAuthService));
  await tester.pumpAndSettle();
  expect(find.byKey(const ValueKey('login-dialog')), findsOneWidget);

  if (tryInvalidPassword) {
    await tester.enterText(
      find.byKey(const ValueKey('login-password')),
      'wrong',
    );
    await tester.tap(find.byKey(const ValueKey('login-submit')));
    await tester.pumpAndSettle();
    expect(
      find.text('بيانات الدخول غير صحيحة أو تعذر تسجيل الدخول'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('login-clear')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<fluent.TextBox>(find.byKey(const ValueKey('login-password')))
          .controller!
          .text,
      isEmpty,
    );
    expect(
      find.text('بيانات الدخول غير صحيحة أو تعذر تسجيل الدخول'),
      findsNothing,
    );
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
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'role matrix separates viewing, editing, discounting, and administration',
    () {
      const admin = UserSession(
        username: 'admin',
        role: AccountingRole.admin,
        token: 'test',
      );
      const cashier1 = UserSession(
        username: 'cashier1',
        role: AccountingRole.cashier1,
        token: 'test',
      );
      const cashier2 = UserSession(
        username: 'cashier2',
        role: AccountingRole.cashier2,
        token: 'test',
      );
      const auditor = UserSession(
        username: 'auditor',
        role: AccountingRole.auditor,
        token: 'test',
      );

      expect(admin.can('inventory.manage'), isTrue);
      expect(cashier1.can('inventory.manage'), isFalse);
      expect(cashier2.can('accounts.manage'), isFalse);
      expect(cashier1.can('invoice.discount'), isTrue);
      expect(cashier2.can('invoice.discount'), isFalse);
      expect(auditor.can('invoice.save'), isFalse);
      expect(auditor.can('invoice.print'), isTrue);
      expect(auditor.can('admin.users'), isFalse);
    },
  );

  testWidgets('only administrators can open the backup and restore controls', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _launchAndLogin(tester);
    await tester.tap(find.text('أدوات'));
    await tester.pumpAndSettle();
    expect(find.text('نسخة احتياطية'), findsOneWidget);
    await tester.tap(find.text('نسخة احتياطية'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('backup-restore-dialog')), findsOneWidget);

    await tester.tap(find.text('إغلاق').last);
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await _launchAndLogin(tester, username: 'cashier1');
    await tester.tap(find.text('أدوات'));
    await tester.pumpAndSettle();
    expect(find.text('نسخة احتياطية'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'auditors get read-only accounting controls and invoice printing',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const auditor = UserSession(
        username: 'auditor',
        role: AccountingRole.auditor,
        token: 'test',
      );

      await tester.pumpWidget(
        fluent.FluentApp(
          theme: buildFluentTheme(),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: _inventoryScreen(onExit: () {}, session: auditor),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('inventory-new-item')), findsNothing);
      expect(find.text('تعديل'), findsNothing);
      expect(find.text('حذف'), findsNothing);

      await tester.pumpWidget(
        fluent.FluentApp(
          theme: buildFluentTheme(),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: _accountsScreen(onExit: () {}, session: auditor),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('جديد'), findsNothing);
      expect(find.text('حفظ'), findsNothing);
      expect(find.text('حذف'), findsNothing);

      await tester.pumpWidget(
        fluent.FluentApp(
          theme: buildFluentTheme(),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: _invoiceScreen(onExit: () {}, session: auditor),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('invoice-save-and-print')),
        findsNothing,
      );
      expect(find.byKey(const ValueKey('invoice-print')), findsOneWidget);
      expect(
        tester
            .widget<app_widgets.TextBox>(
              find.byKey(const ValueKey('invoice-discount-field')),
            )
            .enabled,
        isFalse,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('important messages use a top-right Fluent InfoBar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: fluent.Button(
                onPressed: () => toast(context, 'تم الحفظ'),
                child: const Text('عرض رسالة'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('عرض رسالة'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    final infoBar = find.byType(fluent.InfoBar);
    expect(infoBar, findsOneWidget);
    final infoBarRect = tester.getRect(infoBar);
    expect(infoBarRect.right, greaterThan(1200));
    expect(infoBarRect.top, lessThan(200));

    await tester.tap(find.text('عرض رسالة'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    expect(infoBar, findsOneWidget);
    expect(tester.getRect(infoBar).left, isNot(infoBarRect.left));

    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('invoice type menu uses the requested light-gray background', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: InvoiceMenu(onPick: (_) {}, onClose: () {}),
      ),
    );

    final background = tester.widget<Container>(
      find.byKey(const ValueKey('invoice-type-menu-background')),
    );
    expect(background.color, const Color(0xFFF0F0F0));
  });

  testWidgets('barcode form aligns its search and action controls', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1024, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: _barcodeScreen(onExit: () {})),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final barcodePanel = tester.widget<Container>(
      find.byKey(const ValueKey('barcode-settings-panel')),
    );
    final barcodeHeader = tester.widget<Container>(
      find.byKey(const ValueKey('barcode-field-header')),
    );
    expect(barcodePanel.color, AppColors.cyan);
    expect(barcodeHeader.color, const Color(0xFF4F8DB8));

    final searchButton = tester.getRect(
      find.byKey(const ValueKey('barcode-search-button')),
    );
    final searchField = tester.getRect(
      find.byKey(const ValueKey('barcode-search-field')),
    );
    final searchTitle = tester.getRect(
      find.byKey(const ValueKey('barcode-search-title')),
    );
    expect(searchButton.right, lessThan(searchField.left));
    expect(searchTitle.right, closeTo(searchField.right, 1));

    final nameField = tester.getRect(
      find.byKey(const ValueKey('barcode-item-name')),
    );
    final codeField = tester.getRect(
      find.byKey(const ValueKey('barcode-item-code')),
    );
    expect(nameField.left, greaterThan(codeField.left));

    final exitButton = tester.getRect(
      find.byKey(const ValueKey('barcode-exit-button')),
    );
    final printButton = tester.getRect(
      find.byKey(const ValueKey('barcode-print-button')),
    );
    final title = tester.getRect(
      find.byKey(const ValueKey('barcode-screen-title')),
    );
    expect(exitButton.left, lessThan(printButton.left));
    expect(printButton.right, closeTo(title.right, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('login dialog places the fields left of the lock', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const AccountingApp(authService: _testAuthService));
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
          .widget<AppImageIcon>(find.byKey(const ValueKey('login-lock')))
          .size,
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

  testWidgets('calculator can move and perform basic arithmetic', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _launchAndLogin(tester);

    final calculatorButton = find.byKey(const ValueKey('ribbon-آلة حاسبة'));
    final icon = tester.widget<AppImageIcon>(
      find.descendant(
        of: calculatorButton,
        matching: find.byType(AppImageIcon),
      ),
    );
    expect(icon.assetPath, AppIcons.calculator);
    await tester.tap(calculatorButton);
    await tester.pumpAndSettle();

    final window = find.byKey(const ValueKey('calculator-window'));
    final before = tester.getRect(window);
    await tester.drag(
      find.byKey(const ValueKey('calculator-drag-handle')),
      const Offset(70, 45),
    );
    await tester.pumpAndSettle();
    final after = tester.getRect(window);
    expect(after.left, greaterThan(before.left));
    expect(after.top, greaterThan(before.top));

    for (final key in ['7', '+', '3', '=']) {
      await tester.tap(find.byKey(ValueKey('calculator-key-$key')));
      await tester.pump();
    }
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('calculator-display-value')))
          .data,
      '10',
    );
    await tester.tap(find.byKey(const ValueKey('calculator-close')));
    await tester.pumpAndSettle();
    expect(window, findsNothing);
  });

  testWidgets('invoice tabs and compact fields align on the left', (
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
          child: Scaffold(body: _invoiceScreen(onExit: () {})),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final saveAndPrint = find.byKey(const ValueKey('invoice-save-and-print'));
    expect(saveAndPrint, findsOneWidget);
    expect(
      tester
          .widget<AppImageIcon>(
            find.descendant(
              of: saveAndPrint,
              matching: find.byType(AppImageIcon),
            ),
          )
          .assetPath,
      AppIcons.saveAndPrintPrinter,
    );

    final tabStrip = tester.getRect(
      find.byKey(const ValueKey('invoice-tabs-strip')),
    );
    final firstTab = tester.getRect(
      find.byKey(const ValueKey('invoice-tab-0')),
    );
    final secondTab = tester.getRect(
      find.byKey(const ValueKey('invoice-tab-1')),
    );
    final details = tester.getRect(
      find.byKey(const ValueKey('invoice-details-panel')),
    );
    final accountField = tester.getRect(
      find.byKey(const ValueKey('invoice-account-field')),
    );
    expect(firstTab.left, lessThan(secondTab.left));
    expect(firstTab.left, closeTo(tabStrip.left + 6, 2));
    expect(details.left, closeTo(tabStrip.left + 8, 2));
    expect(details.width, lessThanOrEqualTo(540));
    expect(details.right, lessThan(tabStrip.right - 100));
    expect(accountField.width, lessThan(180));
    expect(tester.takeException(), isNull);
  });

  testWidgets('invoice close only confirms when there are unsaved changes', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var exitCount = 0;

    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: _invoiceScreen(onExit: () => exitCount++)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('invoice-exit')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('invoice-unsaved-close-dialog')),
      findsNothing,
    );
    expect(exitCount, 1);

    final accountField = find.byKey(const ValueKey('invoice-account-field'));
    await tester.enterText(accountField, 'مورد تجريبي');
    await tester.tap(find.byKey(const ValueKey('invoice-exit')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('invoice-unsaved-close-dialog')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('invoice-close-continue')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('invoice-unsaved-close-dialog')),
      findsNothing,
    );
    expect(exitCount, 1);
    expect(
      tester.widget<app_widgets.TextBox>(accountField).controller.text,
      'مورد تجريبي',
    );

    await tester.tap(find.byKey(const ValueKey('invoice-exit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('invoice-close-discard')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('invoice-unsaved-close-dialog')),
      findsNothing,
    );
    expect(exitCount, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('forms stack and closing restores the previous form', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _launchAndLogin(tester);

    await tester.tap(find.byKey(const ValueKey('ribbon-الأصناف')));
    await tester.pumpAndSettle();
    expect(find.byType(InventoryScreen), findsOneWidget);
    final searchField = find.descendant(
      of: find.byKey(const ValueKey('inventory-search-panel')),
      matching: find.byType(app_widgets.TextBox),
    );
    await tester.enterText(searchField, 'milk');

    await tester.tap(find.byKey(const ValueKey('ribbon-الحسابات')));
    await tester.pumpAndSettle();
    expect(find.byType(InventoryScreen), findsOneWidget);
    expect(find.byType(AccountsScreen), findsOneWidget);
    expect(
      tester
          .widget<IgnorePointer>(
            find.byKey(const ValueKey('shell-route-layer-1')),
          )
          .ignoring,
      isTrue,
    );
    expect(
      tester
          .widget<IgnorePointer>(
            find.byKey(const ValueKey('shell-route-layer-2')),
          )
          .ignoring,
      isFalse,
    );

    final accountsExit = find.descendant(
      of: find.byType(AccountsScreen),
      matching: find.byWidgetPredicate(
        (widget) => widget is AppImageIcon && widget.assetPath == AppIcons.exit,
      ),
    );
    await tester.tap(accountsExit);
    await tester.pumpAndSettle();
    expect(find.byType(AccountsScreen), findsNothing);
    expect(
      tester
          .widget<IgnorePointer>(
            find.byKey(const ValueKey('shell-route-layer-1')),
          )
          .ignoring,
      isFalse,
    );
    expect(
      tester.widget<app_widgets.TextBox>(searchField).controller.text,
      'milk',
    );

    final inventoryExit = find.descendant(
      of: find.byType(InventoryScreen),
      matching: find.byWidgetPredicate(
        (widget) => widget is AppImageIcon && widget.assetPath == AppIcons.exit,
      ),
    );
    await tester.tap(inventoryExit);
    await tester.pumpAndSettle();
    expect(find.byType(InventoryScreen), findsNothing);
    expect(find.byKey(const ValueKey('shell-home-background')), findsOneWidget);
    expect(
      tester
          .widget<IgnorePointer>(
            find.byKey(const ValueKey('shell-route-layer-0')),
          )
          .ignoring,
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('multiple invoices keep separate drafts and can switch tabs', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _launchAndLogin(tester);

    final invoicesButton = find.byKey(
      const ValueKey('ribbon-الفواتير\nوأوامر الصرف'),
    );
    await tester.tap(invoicesButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('فاتورة شراء').first);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('invoice-form-1')), findsOneWidget);

    final firstAccountField = find.descendant(
      of: find.byKey(const ValueKey('invoice-form-1')),
      matching: find.byKey(const ValueKey('invoice-account-field')),
    );
    await tester.enterText(firstAccountField, 'Supplier One');

    await tester.tap(invoicesButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('فاتورة إرجاع مشتريات').first);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('invoice-form-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('invoice-form-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('open-invoice-tabs')), findsOneWidget);
    expect(find.byKey(const ValueKey('open-invoice-tab-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('open-invoice-tab-2')), findsOneWidget);

    final secondAccountField = find.descendant(
      of: find.byKey(const ValueKey('invoice-form-2')),
      matching: find.byKey(const ValueKey('invoice-account-field')),
    );
    await tester.enterText(secondAccountField, 'Supplier Two');
    await tester.tap(find.byKey(const ValueKey('open-invoice-tab-1')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<IgnorePointer>(
            find.byKey(const ValueKey('shell-route-layer-2')),
          )
          .ignoring,
      isFalse,
    );
    expect(
      tester.widget<app_widgets.TextBox>(firstAccountField).controller.text,
      'Supplier One',
    );
    expect(
      tester.widget<app_widgets.TextBox>(secondAccountField).controller.text,
      'Supplier Two',
    );

    await tester.tap(find.byKey(const ValueKey('open-invoice-tab-2')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<IgnorePointer>(
            find.byKey(const ValueKey('shell-route-layer-4')),
          )
          .ignoring,
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('returning home confirms every changed open invoice', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _launchAndLogin(tester);

    final invoicesButton = find.byKey(
      const ValueKey('ribbon-الفواتير\nوأوامر الصرف'),
    );
    await tester.tap(invoicesButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('فاتورة شراء').first);
    await tester.pumpAndSettle();
    final firstAccountField = find.descendant(
      of: find.byKey(const ValueKey('invoice-form-1')),
      matching: find.byKey(const ValueKey('invoice-account-field')),
    );
    await tester.enterText(firstAccountField, 'مورد أول');

    await tester.tap(invoicesButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('فاتورة إرجاع مشتريات').first);
    await tester.pumpAndSettle();
    final secondAccountField = find.descendant(
      of: find.byKey(const ValueKey('invoice-form-2')),
      matching: find.byKey(const ValueKey('invoice-account-field')),
    );
    await tester.enterText(secondAccountField, 'مورد ثانٍ');

    Future<void> chooseHome() async {
      await tester.tap(find.byKey(const ValueKey('top-menu-القائمة الرئيسية')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('الشاشة الرئيسية'));
      await tester.pumpAndSettle();
    }

    await chooseHome();
    expect(
      find.byKey(const ValueKey('invoice-home-unsaved-close-dialog')),
      findsOneWidget,
    );
    expect(find.textContaining('تحتوي 2 فواتير مفتوحة'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('invoice-home-keep-editing')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('invoice-home-unsaved-close-dialog')),
      findsNothing,
    );

    expect(find.byType(InvoiceScreen), findsNWidgets(2));
    expect(
      tester.widget<app_widgets.TextBox>(firstAccountField).controller.text,
      'مورد أول',
    );
    expect(
      tester.widget<app_widgets.TextBox>(secondAccountField).controller.text,
      'مورد ثانٍ',
    );

    await chooseHome();
    await tester.tap(find.byKey(const ValueKey('invoice-home-discard')));
    await tester.pumpAndSettle();
    expect(find.byType(InvoiceScreen), findsNothing);
    expect(find.byKey(const ValueKey('shell-home-background')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('menus align right and ribbon buttons stay compact on desktop', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
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
      expect(tester.getSize(find.byKey(ValueKey('ribbon-$label'))).height, 64);
      final rect = tester.getRect(find.byKey(ValueKey('ribbon-$label')));
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(1024));
    }
    final ribbon = find.byKey(const ValueKey('ribbon-container'));
    expect(tester.getSize(ribbon).height, 68);
    expect(
      find.descendant(of: ribbon, matching: find.byType(SingleChildScrollView)),
      findsNothing,
    );
    final invoiceButton = find.byKey(
      const ValueKey('ribbon-الفواتير\nوأوامر الصرف'),
    );
    final iconFinder = find.descendant(
      of: invoiceButton,
      matching: find.byType(AppImageIcon),
    );
    final iconRect = tester.getRect(iconFinder);
    final labelRect = tester.getRect(find.text('الفواتير\nوأوامر الصرف'));
    expect(labelRect.right, lessThan(iconRect.left));
    final updateButton = find.byKey(const ValueKey('ribbon-تحديث'));
    final updateIcon = find.descendant(
      of: updateButton,
      matching: find.byType(AppImageIcon),
    );
    final calculatorButton = find.byKey(const ValueKey('ribbon-آلة حاسبة'));
    final calculatorIcon = find.descendant(
      of: calculatorButton,
      matching: find.byType(AppImageIcon),
    );
    expect(
      tester.widget<AppImageIcon>(iconFinder).size,
      tester.widget<AppImageIcon>(updateIcon).size,
    );
    expect(tester.widget<AppImageIcon>(iconFinder).size, 32);
    expect(
      tester.widget<Text>(find.text('الفواتير\nوأوامر الصرف')).style!.fontSize,
      tester.widget<Text>(find.text('تحديث')).style!.fontSize,
    );
    expect(
      tester.widget<Text>(find.text('الفواتير\nوأوامر الصرف')).style!.fontSize,
      12,
    );
    expect(
      tester.widget<AppImageIcon>(iconFinder).size,
      tester.widget<AppImageIcon>(calculatorIcon).size,
    );
    expect(
      tester.widget<Text>(find.text('الفواتير\nوأوامر الصرف')).style!.fontSize,
      tester.widget<Text>(find.text('آلة حاسبة')).style!.fontSize,
    );
    for (final label in [
      'طباعة\nالباركود',
      'الحسابات',
      'الأصناف',
      'ارسال واعتماد\nالفواتير',
    ]) {
      final button = find.byKey(ValueKey('ribbon-$label'));
      final icon = find.descendant(
        of: button,
        matching: find.byType(AppImageIcon),
      );
      final title = find.descendant(of: button, matching: find.text(label));
      expect(tester.getRect(title).right, lessThan(tester.getRect(icon).left));
    }
    final mainAction = tester.getRect(
      find.byKey(const ValueKey('ribbon-الفواتير\nوأوامر الصرف')),
    );
    final barcodeAction = tester.getRect(
      find.byKey(const ValueKey('ribbon-طباعة\nالباركود')),
    );
    final lastMainAction = tester.getRect(
      find.byKey(const ValueKey('ribbon-ارسال واعتماد\nالفواتير')),
    );
    expect(mainAction.right - lastMainAction.left, lessThan(740));
    expect(mainAction.left - barcodeAction.right, greaterThan(8));
    expect(mainAction.left - barcodeAction.right, lessThan(16));
    final utilityAction = tester.getRect(
      find.byKey(const ValueKey('ribbon-خروج')),
    );
    final calculatorAction = tester.getRect(calculatorButton);
    final updateAction = tester.getRect(updateButton);
    final divider = tester.getRect(
      find.byKey(const ValueKey('ribbon-divider')),
    );
    expect(mainAction.center.dx, greaterThan(utilityAction.center.dx));
    expect(calculatorAction.right - utilityAction.left, lessThan(380));
    expect(utilityAction.right, lessThan(divider.left));
    expect(divider.right, lessThan(calculatorAction.left));
    expect(calculatorAction.right, lessThan(lastMainAction.left));
    expect(updateAction.right, lessThan(divider.left));
    expect(lastMainAction.left - calculatorAction.right, lessThan(80));
    expect(calculatorAction.left - divider.right, lessThan(20));
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

  testWidgets('wide ribbon places the divider after the calculator', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1920, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _launchAndLogin(tester);

    final exitAction = tester.getRect(
      find.byKey(const ValueKey('ribbon-خروج')),
    );
    final calculatorAction = tester.getRect(
      find.byKey(const ValueKey('ribbon-آلة حاسبة')),
    );
    final divider = tester.getRect(
      find.byKey(const ValueKey('ribbon-divider')),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('ribbon-container'))).height,
      64,
    );

    expect(calculatorAction.right - exitAction.left, lessThan(700));
    expect(exitAction.right, lessThan(divider.left));
    expect(divider.right, lessThan(calculatorAction.left));
    final lastMainAction = tester.getRect(
      find.byKey(const ValueKey('ribbon-ارسال واعتماد\nالفواتير')),
    );
    expect(calculatorAction.right, lessThan(lastMainAction.left));
    void expectStacked(Finder icon, Finder label) {
      final iconRect = tester.getRect(icon);
      final labelRect = tester.getRect(label);
      expect(iconRect.center.dx, closeTo(labelRect.center.dx, 1));
      expect(iconRect.bottom, lessThan(labelRect.top));
    }

    for (final pair in [
      (find.text('ع'), find.text('Arabic')),
      (
        find.descendant(
          of: find.byKey(const ValueKey('ribbon-موقعنا')),
          matching: find.byType(AppImageIcon),
        ),
        find.text('موقعنا'),
      ),
      (
        find.descendant(
          of: find.byKey(const ValueKey('ribbon-تحديث')),
          matching: find.byType(AppImageIcon),
        ),
        find.text('تحديث'),
      ),
    ]) {
      expectStacked(pair.$1, pair.$2);
    }
    final invoiceButton = find.byKey(
      const ValueKey('ribbon-الفواتير\nوأوامر الصرف'),
    );
    final invoiceIcon = find.descendant(
      of: invoiceButton,
      matching: find.byType(AppImageIcon),
    );
    final updateButton = find.byKey(const ValueKey('ribbon-تحديث'));
    final updateIcon = find.descendant(
      of: updateButton,
      matching: find.byType(AppImageIcon),
    );
    expect(
      tester.widget<AppImageIcon>(invoiceIcon).size,
      tester.widget<AppImageIcon>(updateIcon).size,
    );
    expect(tester.widget<AppImageIcon>(invoiceIcon).size, 32);
    expect(
      tester.widget<Text>(find.text('الفواتير\nوأوامر الصرف')).style!.fontSize,
      tester.widget<Text>(find.text('تحديث')).style!.fontSize,
    );
    expect(
      tester.widget<Text>(find.text('الفواتير\nوأوامر الصرف')).style!.fontSize,
      12,
    );
    final exitButton = find.byKey(const ValueKey('ribbon-خروج'));
    expect(
      find.descendant(of: exitButton, matching: find.text('خروج')),
      findsNothing,
    );
    expect(
      tester
          .widget<AppImageIcon>(
            find.descendant(
              of: exitButton,
              matching: find.byType(AppImageIcon),
            ),
          )
          .assetPath,
      AppIcons.exit,
    );
    final calculator = find.byKey(const ValueKey('ribbon-آلة حاسبة'));
    expectStacked(
      find.descendant(of: calculator, matching: find.byType(AppImageIcon)),
      find.descendant(of: calculator, matching: find.text('آلة حاسبة')),
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('ribbon-container')),
        matching: find.byType(SingleChildScrollView),
      ),
      findsNothing,
    );
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
    expect(tester.getSize(ribbon).height, 108);
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
    final mobileMainIcon = find.descendant(
      of: find.byKey(const ValueKey('ribbon-الفواتير\nوأوامر الصرف')),
      matching: find.byType(AppImageIcon),
    );
    expect(tester.widget<AppImageIcon>(mobileMainIcon).size, 22);
    expect(
      tester.widget<Text>(find.text('الفواتير وأوامر الصرف')).style!.fontSize,
      8.5,
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
    final resultsPanel = find.byKey(
      const ValueKey('inventory-search-results-panel'),
    );
    expect(
      tester.getTopLeft(searchPanel).dx,
      lessThan(tester.getTopLeft(resultsPanel).dx),
    );
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
      const Offset(40, 0),
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

    final headerSection = find.byKey(
      const ValueKey('inventory-header-section'),
    );
    final headerGridDivider = find.byKey(
      const ValueKey('splitter-inventory-header-grid'),
    );
    final headerBeforeResize = tester.getSize(headerSection).height;
    final gridBeforeResize = tester.getSize(gridArea).height;
    await tester.drag(headerGridDivider, const Offset(0, 72));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(headerSection).height,
      greaterThan(headerBeforeResize),
    );
    expect(tester.getSize(gridArea).height, lessThan(gridBeforeResize));
    await tester.drag(headerGridDivider, const Offset(0, 2000));
    await tester.pumpAndSettle();
    expect(tester.getSize(gridArea).height, greaterThanOrEqualTo(180));

    tester.view.physicalSize = const Size(1280, 640);
    await tester.pumpAndSettle();
    expect(tester.getSize(headerSection).height, greaterThanOrEqualTo(210));
    expect(tester.getSize(gridArea).height, greaterThanOrEqualTo(180));
    tester.view.physicalSize = const Size(1280, 1200);
    await tester.pumpAndSettle();
    expect(tester.getSize(headerSection).height, greaterThanOrEqualTo(210));
    expect(tester.getSize(gridArea).height, greaterThanOrEqualTo(180));

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

  testWidgets('mobile inventory filters can be hidden and reopened', (
    tester,
  ) async {
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
          child: Scaffold(body: _inventoryScreen(onExit: () {})),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final filters = find.byKey(const ValueKey('inventory-search-panel'));
    final toggle = find.byKey(
      const ValueKey('inventory-mobile-filters-toggle'),
    );
    final results = find.byKey(
      const ValueKey('inventory-search-results-panel'),
    );
    final mobileLayout = find.byKey(const ValueKey('inventory-mobile-layout'));
    await tester.scrollUntilVisible(
      toggle,
      400,
      scrollable: find
          .descendant(of: mobileLayout, matching: find.byType(Scrollable))
          .first,
    );
    await tester.pumpAndSettle();
    expect(filters, findsOneWidget);
    final searchField = find
        .descendant(of: filters, matching: find.byType(app_widgets.TextBox))
        .last;
    await tester.ensureVisible(searchField);
    await tester.enterText(searchField, 'milk');

    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(filters, findsNothing);
    expect(results, findsOneWidget);
    expect(find.text('إظهار عوامل التصفية'), findsOneWidget);

    await tester.ensureVisible(results);
    await tester.pumpAndSettle();
    final resultsRect = tester.getRect(results);
    expect(resultsRect.top, greaterThanOrEqualTo(0));
    expect(resultsRect.bottom, lessThanOrEqualTo(850));

    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(filters, findsOneWidget);
    expect(
      tester.widget<app_widgets.TextBox>(searchField).controller.text,
      'milk',
    );
    expect(find.text('إخفاء عوامل التصفية'), findsOneWidget);
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
            body: _inventoryScreen(
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
    expect(
      find.descendant(of: find.byType(ItemImage), matching: find.byType(Image)),
      findsOneWidget,
    );

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
          child: Scaffold(body: _inventoryScreen(onExit: () {})),
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
          child: Scaffold(body: _invoiceScreen(onExit: () {})),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('إضافة الأصناف'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('invoice-item-grid')), findsOneWidget);
    expect(find.byKey(const ValueKey('invoice-item-card-P-1')), findsOneWidget);
    expect(find.byType(ItemImage), findsOneWidget);
    expect(
      find.descendant(of: find.byType(ItemImage), matching: find.byType(Image)),
      findsOneWidget,
    );
    expect(find.text('صنف مصور'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('invoice-item-add-P-1')));
    await tester.pumpAndSettle();
    expect(find.text('صنف مصور • حبة'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('saving an invoice stores it and starts a blank invoice', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await Store.saveItems([
      Item(
        id: 'SAVE-1',
        nameAr: 'صنف للحفظ',
        units: [
          UnitRow(unitNo: '1', size: 'حبة', priceBefore: '8.5', quick: true),
        ],
      ),
    ]);
    final savedDraft = InvoiceDraft(
      id: 'draft-being-saved',
      typeIndex: 0,
      updatedAt: DateTime(2026, 11, 13),
      invoice: {'number': '000001', 'lines': []},
    );
    final otherDraft = InvoiceDraft(
      id: 'other-open-draft',
      typeIndex: 1,
      updatedAt: DateTime(2026, 11, 13),
      invoice: {'number': '000099', 'lines': []},
    );
    await Store.saveInvoiceDraft(savedDraft);
    await Store.saveInvoiceDraft(otherDraft);
    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: _invoiceScreen(onExit: () {}, draftId: savedDraft.id),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('000001'), findsOneWidget);
    expect(find.byKey(const ValueKey('invoice-side-row-0')), findsNothing);
    await tester.tap(find.text('إضافة الأصناف'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('invoice-item-add-SAVE-1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('invoice-side-row-0')), findsOneWidget);
    await tester.tap(find.text('حفظ F8'));
    await tester.pumpAndSettle();

    final savedInvoices = await Store.loadInvoices();
    expect(savedInvoices, hasLength(1));
    expect(savedInvoices.single['typeIndex'], 0);
    final invoice = Map<String, dynamic>.from(
      savedInvoices.single['invoice'] as Map,
    );
    final savedLines = List<Map<String, dynamic>>.from(
      (invoice['lines'] as List).map(
        (line) => Map<String, dynamic>.from(line as Map),
      ),
    );
    expect(savedLines.single['name'], 'صنف للحفظ');
    expect(invoice['number'], '000001');
    expect(DateTime.tryParse(invoice['invDate'] as String), isNotNull);
    expect((await Store.loadInvoiceDrafts()).map((draft) => draft.id), [
      otherDraft.id,
    ]);
    expect(find.byKey(const ValueKey('invoice-side-row-0')), findsNothing);
    expect(find.text('مسح المسودة وبدء فاتورة جديدة'), findsNothing);
    expect(find.text('حفظ\nوطباعة'), findsOneWidget);
    expect(find.textContaining('طباعة F7'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('invoice-exit')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('invoice-unsaved-close-dialog')),
      findsNothing,
    );
    await tester.tap(find.text('بيانات الفاتورة'));
    await tester.pumpAndSettle();
    expect(find.text('000002'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('restored invoice draft keeps its fields and can be discarded', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final draft = InvoiceDraft(
      id: 'restored-invoice',
      typeIndex: 4,
      updatedAt: DateTime(2026, 11, 14),
      invoice: {
        'number': '000042',
        'invDate': DateTime(2026, 11, 10).toIso8601String(),
        'delivDate': DateTime(2026, 11, 11).toIso8601String(),
        'account': 'عميل محفوظ',
        'taxNo': '300123456700003',
        'notes': 'ملاحظات المسودة',
        'discount': '4',
        'taxRate': '0.15',
        'cash': '5',
        'network': '12',
        'credit': '0',
        'returnBal': '1',
        'pick': '',
        'creditor': 'شركة النخبة',
        'debtor': 'الصندوق',
        'storeCredit': '-',
        'storeDebit': 'المستودع الرئيسي',
        'taxable': 'غير خاضع',
        'selectedPayment': 'network',
        'paymentAuto': false,
        'lines': [
          {
            'id': 'draft-line-1',
            'code': 'DRAFT-1',
            'name': 'صنف محفوظ',
            'unitNo': '2',
            'unit': 'كرتون',
            'qty': 3,
            'price': 7.5,
          },
        ],
      },
    );
    expect(await Store.saveInvoiceDraft(draft), isTrue);

    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: _invoiceScreen(
              onExit: () {},
              typeIndex: 4,
              draftId: draft.id,
              initialDraft: draft,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('000042'), findsOneWidget);
    expect(find.byKey(const ValueKey('invoice-side-row-0')), findsOneWidget);
    expect(find.text('صنف محفوظ • كرتون'), findsOneWidget);
    expect(
      tester
          .widget<app_widgets.TextBox>(
            find.byKey(const ValueKey('invoice-account-field')),
          )
          .controller
          .text,
      'عميل محفوظ',
    );
    expect(
      tester
          .widget<fluent.TextBox>(
            find.byKey(const ValueKey('payment-field-network')),
          )
          .controller!
          .text,
      '12',
    );

    await tester.tap(find.byKey(const ValueKey('invoice-discard-draft')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('نعم، تأكيد'));
    await tester.pumpAndSettle();
    expect(await Store.loadInvoiceDrafts(), isEmpty);
    expect(find.byKey(const ValueKey('invoice-side-row-0')), findsNothing);
    expect(find.text('000001'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  testWidgets('saved invoice drafts reopen after signing in', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final draft = InvoiceDraft(
      id: 'startup-recovery',
      typeIndex: 2,
      updatedAt: DateTime(2026, 11, 14),
      invoice: {
        'number': '000077',
        'invDate': DateTime(2026, 11, 12).toIso8601String(),
        'delivDate': DateTime(2026, 11, 13).toIso8601String(),
        'account': 'حساب مستعاد',
        'taxNo': '',
        'notes': '',
        'discount': '0',
        'taxRate': '0.15',
        'cash': '0',
        'network': '0',
        'credit': '0',
        'returnBal': '0',
        'pick': '',
        'paymentAuto': false,
        'lines': [
          {
            'id': 'startup-line',
            'code': 'STARTUP-1',
            'name': 'بند مستعاد',
            'unitNo': '1',
            'unit': 'حبة',
            'qty': 2,
            'price': 11,
          },
        ],
      },
    );
    await Store.saveInvoiceDraft(draft);

    await _launchAndLogin(tester);

    expect(find.byType(InvoiceScreen), findsOneWidget);
    expect(find.text('000077'), findsOneWidget);
    expect(find.text('بند مستعاد • حبة'), findsOneWidget);
    expect(
      tester
          .widget<app_widgets.TextBox>(
            find.byKey(const ValueKey('invoice-account-field')),
          )
          .controller
          .text,
      'حساب مستعاد',
    );
  });

  testWidgets('invoice edits are saved automatically as an independent draft', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await Store.saveItems([
      Item(
        id: 'AUTO-1',
        nameAr: 'صنف للمسودة',
        units: [
          UnitRow(unitNo: '1', size: 'حبة', priceBefore: '9', quick: true),
        ],
      ),
    ]);
    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: _invoiceScreen(onExit: () {}, draftId: 'autosave-test'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('إضافة الأصناف'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('invoice-item-add-AUTO-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('بيانات الفاتورة'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('invoice-account-field')),
      'حساب يحفظ تلقائياً',
    );
    await tester.enterText(
      find.byKey(const ValueKey('payment-field-network')),
      '23.5',
    );
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    final savedDrafts = await Store.loadInvoiceDrafts();
    expect(savedDrafts, hasLength(1));
    expect(savedDrafts.single.id, 'autosave-test');
    expect(savedDrafts.single.typeIndex, 0);
    expect(savedDrafts.single.invoice['account'], 'حساب يحفظ تلقائياً');
    expect(savedDrafts.single.invoice['network'], '23.5');
    final savedLines = savedDrafts.single.invoice['lines'] as List;
    expect(savedLines, hasLength(1));
    expect((savedLines.single as Map)['qty'], 1);
    expect((savedLines.single as Map)['name'], 'صنف للمسودة');
  });

  testWidgets('inventory adds a unit row without clearing item fields', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final startingItems = await Store.loadItems();
    final original = startingItems.first;

    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: _inventoryScreen(onExit: () {})),
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
    final newUnitRow = original.units.length;
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
      'اسم محدث',
    );

    final unitType = tester.widget<fluent.ComboBox<String>>(
      find.descendant(
        of: find.byKey(ValueKey('inventory-unit-type-$newUnitRow')),
        matching: find.byType(fluent.ComboBox<String>),
      ),
    );
    unitType.onChanged?.call('كيلوجرام');
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(ValueKey('inventory-unit-cell-$newUnitRow-1')),
      '42',
    );
    await tester.enterText(
      find.byKey(ValueKey('inventory-unit-cell-$newUnitRow-9')),
      'أحمر',
    );
    await tester.tap(find.text('حفظ').first);
    await tester.pumpAndSettle();

    final savedItems = await Store.loadItems();
    expect(savedItems.first.nameAr, 'اسم محدث');
    expect(savedItems.length, startingItems.length);
    expect(savedItems.first.group, original.group);
    expect(savedItems.first.units.length, original.units.length + 1);
    expect(savedItems.first.units.last.size, 'كيلوجرام');
    expect(savedItems.first.units.last.priceBefore, '42');
    expect(savedItems.first.units.last.color, 'أحمر');
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
          child: Scaffold(body: _invoiceScreen(onExit: () {})),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('إضافة الأصناف'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('invoice-item-card-FAST-1')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('invoice-item-card-REGULAR-1')),
      findsNothing,
    );

    await tester.tap(find.text('اختيار الأصناف'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('invoice-item-grid')), findsNothing);
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

  testWidgets(
    'scanning a barcode and pressing Enter adds and increments item',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const barcode = '6291234567890';
      await Store.saveItems([
        Item(
          id: 'SCAN-1',
          nameAr: 'صنف ممسوح',
          units: [
            UnitRow(
              unitNo: '1',
              size: 'علبة',
              priceBefore: '7.50',
              barcode: barcode,
            ),
          ],
        ),
      ]);

      await tester.pumpWidget(
        fluent.FluentApp(
          theme: buildFluentTheme(),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(body: _invoiceScreen(onExit: () {})),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('اختيار الأصناف'));
      await tester.pumpAndSettle();

      final searchField = find.byKey(const ValueKey('invoice-item-search'));
      await tester.enterText(searchField, barcode);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('invoice-side-row-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('invoice-side-row-1')), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('invoice-quantity-readout')),
          matching: find.text('1'),
        ),
        findsOneWidget,
      );
      expect(find.text('صنف ممسوح • علبة'), findsOneWidget);

      await tester.enterText(searchField, barcode);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('invoice-side-row-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('invoice-side-row-1')), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('invoice-quantity-readout')),
          matching: find.text('2'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

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
          child: Scaffold(body: _invoiceScreen(onExit: () {})),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('إضافة الأصناف'));
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
    expect(find.text('بنود الفاتورة'), findsNothing);
    expect(find.byKey(const ValueKey('invoice-tab-3')), findsNothing);
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('adding the same invoice unit increases its quantity', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await Store.saveItems([
      Item(
        id: 'REPEAT-1',
        nameAr: 'صنف متكرر',
        units: [
          UnitRow(unitNo: '1', size: 'علبة', priceBefore: '12', quick: true),
        ],
      ),
    ]);

    await tester.pumpWidget(
      fluent.FluentApp(
        theme: buildFluentTheme(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: _invoiceScreen(onExit: () {})),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('إضافة الأصناف'));
    await tester.pumpAndSettle();
    final addButton = find.byKey(const ValueKey('invoice-item-add-REPEAT-1'));
    await tester.tap(addButton);
    await tester.pumpAndSettle();
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('invoice-side-row-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('invoice-side-row-1')), findsNothing);
    expect(find.text('صنف متكرر • علبة'), findsOneWidget);
    expect(find.byType(fluent.InfoBar), findsNothing);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('invoice-side-row-0')),
        matching: find.text('24.00'),
      ),
      findsOneWidget,
    );
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
          child: Scaffold(body: _invoiceScreen(onExit: () {})),
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
    await tester.enterText(
      find.byKey(const ValueKey('invoice-item-search')),
      '1002',
    );
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
            child: Scaffold(body: _invoiceScreen(onExit: () {})),
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
    final addressTab = tester.widget<Container>(
      find.byKey(const ValueKey('account-tab-0')),
    );
    final addressStyle = addressTab.decoration! as BoxDecoration;
    expect(addressStyle.color, Colors.white);
    expect(addressStyle.border!.top.color, AppColors.green);
    final documentsStyle =
        tester
                .widget<Container>(find.byKey(const ValueKey('account-tab-1')))
                .decoration!
            as BoxDecoration;
    expect(documentsStyle.color, const Color(0xFFE2E5E8));

    await tester.tap(find.byKey(const ValueKey('account-tab-1')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('account-field-commercialNumber')),
      findsOneWidget,
    );
    expect(
      (tester
                  .widget<Container>(
                    find.byKey(const ValueKey('account-tab-1')),
                  )
                  .decoration!
              as BoxDecoration)
          .color,
      Colors.white,
    );
    await tester.tap(find.byKey(const ValueKey('account-tab-0')));
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
          child: Scaffold(body: _barcodeScreen(onExit: () {})),
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
