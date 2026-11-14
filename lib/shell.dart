import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'accounts_screen.dart';
import 'auth_service.dart';
import 'backup_restore_dialog.dart';
import 'barcode_screen.dart';
import 'inventory_screen.dart';
import 'invoice_menu.dart';
import 'invoice_history_screen.dart';
import 'invoice_screen.dart';
import 'models.dart';
import 'printer_settings_screen.dart';
import 'storage.dart';
import 'user_passwords_screen.dart';
import 'theme.dart';
import 'widgets.dart';

enum ShellView {
  home,
  inventory,
  invoiceMenu,
  invoice,
  accounts,
  barcode,
  printerSettings,
  userPasswords,
}

class _ShellRoute {
  final int id;
  final ShellView view;
  final int? invoiceType;
  final int? invoiceNumber;
  final String? draftId;
  final InvoiceDraft? invoiceDraft;

  const _ShellRoute({
    required this.id,
    required this.view,
    this.invoiceType,
    this.invoiceNumber,
    this.draftId,
    this.invoiceDraft,
  });
}

/// Window chrome: title strip, menu bar, ribbon, content canvas, status bar.
class AppShell extends StatefulWidget {
  final AccountingAuthService authService;
  final String? embeddedPrinterToken;

  const AppShell({
    super.key,
    this.authService = const ApiAuthService(),
    this.embeddedPrinterToken,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final List<_ShellRoute> _routes = [
    const _ShellRoute(id: 0, view: ShellView.home),
  ];
  final Map<int, InvoiceDirtyCheck> _invoiceDirtyChecks = {};
  int _nextRouteId = 1;
  int _nextInvoiceNumber = 1;
  UserSession? session;
  bool _loginDialogOpen = false;

  ShellView get view => _routes.last.view;
  List<_ShellRoute> get _openInvoices =>
      _routes.where((route) => route.view == ShellView.invoice).toList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showLoginDialog());
  }

  Future<void> _showLoginDialog() async {
    if (!mounted || _loginDialogOpen || session != null) return;
    _loginDialogOpen = true;
    final loggedInSession = await fluent.showDialog<UserSession>(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.canvasBlue,
      dismissWithEsc: false,
      builder: (_) => _LoginDialog(authService: widget.authService),
    );
    _loginDialogOpen = false;
    if (!mounted) return;
    if (loggedInSession == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showLoginDialog());
      return;
    }
    setState(() => session = loggedInSession);
    unawaited(_restoreSavedInvoiceDrafts());
  }

  Future<void> _restoreSavedInvoiceDrafts() async {
    final drafts = await Store.loadInvoiceDrafts();
    if (!mounted || drafts.isEmpty) return;
    setState(() {
      for (final draft in drafts) {
        final invoiceNumber = int.tryParse('${draft.invoice['number'] ?? ''}');
        _routes.add(
          _ShellRoute(
            id: _nextRouteId++,
            view: ShellView.invoice,
            invoiceType: draft.typeIndex,
            invoiceNumber: invoiceNumber,
            draftId: draft.id,
            invoiceDraft: draft,
          ),
        );
      }
    });
  }

  bool _can(String permission) => session?.can(permission) ?? false;

  void go(ShellView v) {
    final permission = switch (v) {
      ShellView.inventory => 'inventory.view',
      ShellView.accounts => 'accounts.view',
      ShellView.invoiceMenu || ShellView.invoice => 'invoice.view',
      ShellView.barcode => 'barcode.view',
      ShellView.printerSettings => 'printer.manage',
      ShellView.userPasswords => 'admin.users',
      ShellView.home => null,
    };
    if (permission != null && !_can(permission)) {
      soon('هذه الشاشة');
      return;
    }
    if (v == ShellView.home) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_returnHomeSafely());
      });
      return;
    }
    setState(() {
      if (_routes.last.view == v) return;
      _routes.add(_ShellRoute(id: _nextRouteId++, view: v));
    });
  }

  Future<bool> _confirmOpenInvoicesCanClose() async {
    final openInvoices = _routes
        .where((route) => route.view == ShellView.invoice)
        .toList();
    final dirtyCount = openInvoices
        .where((route) => _invoiceDirtyChecks[route.id]?.call() ?? false)
        .length;
    if (dirtyCount == 0) return true;

    final discard = await fluent.showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => fluent.ContentDialog(
        key: const ValueKey('invoice-home-unsaved-close-dialog'),
        title: const Text('تغييرات غير محفوظة'),
        content: Text(
          dirtyCount == 1
              ? 'تحتوي الفاتورة المفتوحة على تغييرات لم يتم حفظها. '
                    'هل تريد تجاهلها والعودة للشاشة الرئيسية؟'
              : 'تحتوي $dirtyCount فواتير مفتوحة على تغييرات لم يتم حفظها. '
                    'هل تريد تجاهلها والعودة للشاشة الرئيسية؟',
        ),
        actions: [
          fluent.Button(
            key: const ValueKey('invoice-home-keep-editing'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('متابعة التعديل'),
          ),
          fluent.FilledButton(
            key: const ValueKey('invoice-home-discard'),
            style: fluent.ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(AppColors.red),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('تجاهل التغييرات'),
          ),
        ],
      ),
    );
    return discard == true;
  }

  Future<void> _returnHomeSafely() async {
    if (!await _confirmOpenInvoicesCanClose() || !mounted) return;
    setState(() {
      _routes
        ..clear()
        ..add(const _ShellRoute(id: 0, view: ShellView.home));
    });
  }

  void openInvoice(int t) {
    if (!_can('invoice.view')) return;
    final draftId =
        'invoice-${DateTime.now().microsecondsSinceEpoch}-$_nextRouteId';
    setState(() {
      final newInvoice = _ShellRoute(
        id: _nextRouteId++,
        view: ShellView.invoice,
        invoiceType: t,
        invoiceNumber: _nextInvoiceNumber++,
        draftId: draftId,
      );
      if (view == ShellView.invoiceMenu) {
        _routes[_routes.length - 1] = newInvoice;
      } else {
        _routes.add(newInvoice);
      }
    });
  }

  void _activateInvoice(int routeId) {
    final index = _routes.indexWhere(
      (route) => route.id == routeId && route.view == ShellView.invoice,
    );
    if (index < 0 || index == _routes.length - 1) return;
    setState(() => _routes.add(_routes.removeAt(index)));
  }

  void _closeCurrentView() {
    if (_routes.length <= 1) return;
    setState(() => _routes.removeLast());
  }

  void _logout() => unawaited(_logoutSafely());

  Future<void> _logoutSafely() async {
    if (!await _confirmOpenInvoicesCanClose() || !mounted) return;
    setState(() {
      session = null;
      _routes
        ..clear()
        ..add(const _ShellRoute(id: 0, view: ShellView.home));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _showLoginDialog());
  }

  void _refreshCurrentView() {
    setState(() {
      if (view == ShellView.invoice) {
        final previous = _routes.removeLast();
        _routes.add(
          _ShellRoute(
            id: _nextRouteId++,
            view: ShellView.invoice,
            invoiceType: previous.invoiceType,
            invoiceNumber: previous.invoiceNumber,
            draftId: previous.draftId,
            invoiceDraft: previous.invoiceDraft,
          ),
        );
      }
    });
    toast(
      context,
      'تم تحديث البيانات',
      severity: fluent.InfoBarSeverity.success,
    );
  }

  void soon(String name) => toast(
    context,
    '$name — غير متاحة في هذه النسخة',
    severity: fluent.InfoBarSeverity.warning,
  );

  Future<void> _openBackupDialog() async {
    if (!_can('admin.backup')) return;
    await fluent.showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const BackupRestoreDialog(),
    );
  }

  Future<void> calculator() async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'إغلاق الآلة الحاسبة',
      barrierColor: Colors.black26,
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, _, _) => const _CalcDialog(),
      transitionBuilder: (context, animation, _, child) {
        final eased = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: eased,
          child: ScaleTransition(scale: eased, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _titleStrip(),
            _menuBar(),
            _ribbon(),
            if (_openInvoices.length > 1) _openInvoiceTabs(),
            const Divider(height: 1, color: AppColors.line),
            Expanded(child: _content()),
            const _StatusBar(),
          ],
        ),
      ),
    );
  }

  Widget _titleStrip() {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final version = view == ShellView.invoice ? '25.07.17' : '25.08.18';
    final versionAndUser = session == null
        ? version
        : '$version - (${session!.username})';
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'المحاسبة المالية العامة',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: compact ? 10 : 12,
                color: AppColors.muted,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            versionAndUser,
            key: const ValueKey('top-version-user'),
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              color: AppColors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menu(String title, List<(String, VoidCallback)> entries) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    return fluent.DropDownButton(
      key: ValueKey('top-menu-$title'),
      title: Text(title, style: TextStyle(fontSize: compact ? 11 : 13)),
      style: fluent.ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: compact ? 4 : 10, vertical: 3),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      items: [
        for (final entry in entries)
          fluent.MenuFlyoutItem(text: Text(entry.$1), onPressed: entry.$2),
      ],
    );
  }

  Widget _menuBar() {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final mainEntries = <(String, VoidCallback)>[
      ('الشاشة الرئيسية', () => go(ShellView.home)),
    ];
    if (_can('invoice.view')) {
      mainEntries.add((
        'الفواتير وأوامر الصرف',
        () => go(ShellView.invoiceMenu),
      ));
    }
    if (_can('inventory.view')) {
      mainEntries.add(('الأصناف / المخزون', () => go(ShellView.inventory)));
    }
    if (_can('accounts.view')) {
      mainEntries.add(('الحسابات', () => go(ShellView.accounts)));
    }
    if (_can('barcode.view')) {
      mainEntries.add(('طباعة الباركود', () => go(ShellView.barcode)));
    }
    final mainMenu = _menu('القائمة الرئيسية', mainEntries);
    final adminMenu = _menu('إدارة', [
      if (widget.authService is AdminPasswordManagementService)
        ('إدارة كلمات المرور', () => go(ShellView.userPasswords))
      else
        ('المستخدمون والصلاحيات', () => soon('المستخدمون')),
      ('بيانات المنشأة', () => soon('بيانات المنشأة')),
      if (_can('printer.manage'))
        ('إدارة الطابعات والفواتير', () => go(ShellView.printerSettings)),
    ]);
    final toolsMenu = _menu('أدوات', [
      ('آلة حاسبة', calculator),
      if (_can('admin.backup')) ('نسخة احتياطية', _openBackupDialog),
    ]);
    final itemsEntries = <(String, VoidCallback)>[];
    if (_can('inventory.view')) {
      itemsEntries.add(('بطاقة صنف', () => go(ShellView.inventory)));
    }
    if (_can('barcode.view')) {
      itemsEntries.add(('طباعة الباركود', () => go(ShellView.barcode)));
    }
    final itemsMenu = itemsEntries.isEmpty
        ? null
        : _menu('الأصناف', itemsEntries);
    final menus = <Widget>[
      mainMenu,
      if (_can('admin.users')) adminMenu,
      toolsMenu,
      if (itemsMenu != null) itemsMenu,
    ];
    return Container(
      key: const ValueKey('top-menu-bar'),
      color: Colors.white,
      height: compact ? 56 : 32,
      width: double.infinity,
      alignment: AlignmentDirectional.centerStart,
      child: compact
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: menus.take(2).toList(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: menus.skip(2).toList(),
                ),
              ],
            )
          : Row(mainAxisSize: MainAxisSize.min, children: menus),
    );
  }

  Widget _ribbon() {
    final right = [
      if (_can('invoice.view'))
        _RibbonButton(
          assetPath: AppIcons.receipt,
          label: 'الفواتير\nوأوامر الصرف',
          color: AppColors.navy,
          active: view == ShellView.invoiceMenu || view == ShellView.invoice,
          onTap: () => go(ShellView.invoiceMenu),
        ),
      if (_can('barcode.view'))
        _RibbonButton(
          assetPath: AppIcons.printer,
          label: 'طباعة\nالباركود',
          color: AppColors.muted,
          active: view == ShellView.barcode,
          onTap: () => go(ShellView.barcode),
        ),
      if (_can('accounts.view'))
        _RibbonButton(
          assetPath: AppIcons.users,
          label: 'الحسابات',
          color: AppColors.navy,
          active: view == ShellView.accounts,
          onTap: () => go(ShellView.accounts),
        ),
      if (_can('inventory.view'))
        _RibbonButton(
          assetPath: AppIcons.shop,
          label: 'الأصناف',
          color: const Color(0xFF2B7BC4),
          active: view == ShellView.inventory,
          onTap: () => go(ShellView.inventory),
        ),
      if (_can('invoice.approve'))
        _RibbonButton(
          assetPath: AppIcons.test,
          label: 'ارسال واعتماد\nالفواتير',
          color: AppColors.red,
          onTap: () => soon('ارسال واعتماد الفواتير'),
        ),
    ];
    final calculatorButton = _RibbonButton(
      assetPath: AppIcons.calculator,
      label: 'آلة حاسبة',
      color: AppColors.muted,
      onTap: calculator,
    );
    final left = [
      _RibbonButton(
        assetPath: AppIcons.refresh,
        label: 'تحديث',
        color: AppColors.green,
        onTap: _refreshCurrentView,
      ),
      _RibbonButton(
        assetPath: AppIcons.website,
        label: 'موقعنا',
        color: const Color(0xFF2B7BC4),
        onTap: () => soon('الموقع'),
      ),
      _RibbonButton(
        glyph: 'ع',
        label: 'Arabic',
        color: AppColors.ink,
        onTap: () {},
      ),
      _RibbonButton(
        assetPath: AppIcons.exit,
        label: 'خروج',
        hideLabel: true,
        color: const Color(0xFF2B7BC4),
        onTap: _logout,
      ),
    ];
    return Container(
      key: const ValueKey('ribbon-container'),
      color: AppColors.ribbon,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          Widget compactGroup(
            List<_RibbonButton> buttons, {
            bool dense = false,
            double? iconSize,
          }) {
            return Row(
              children: [
                for (final button in buttons)
                  Expanded(
                    child: button.asStacked(dense: dense, iconSize: iconSize),
                  ),
              ],
            );
          }

          Widget sectionGroup(
            List<_RibbonButton> buttons, {
            bool dense = false,
            double? iconSize,
          }) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < buttons.length; index++) ...[
                  if (index > 0) const SizedBox(width: 12),
                  buttons[index].asHorizontalCompact(
                    dense: dense,
                    iconSize: iconSize,
                  ),
                ],
              ],
            );
          }

          if (width >= 1400) {
            return SizedBox(
              width: width,
              height: 64,
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 6),
                          child: sectionGroup(right, dense: true, iconSize: 32),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 88,
                    height: 64,
                    child: calculatorButton.asStacked(
                      dense: true,
                      iconSize: 32,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    key: const ValueKey('ribbon-divider'),
                    width: 1,
                    height: 38,
                    color: AppColors.line,
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 256,
                    height: 64,
                    child: compactGroup(left, dense: true, iconSize: 32),
                  ),
                  const SizedBox(width: 6),
                ],
              ),
            );
          }

          if (width < 700) {
            return SizedBox(
              height: 108,
              child: Column(
                children: [
                  Expanded(child: compactGroup(right, dense: true)),
                  Expanded(
                    child: compactGroup([
                      calculatorButton,
                      ...left,
                    ], dense: true),
                  ),
                ],
              ),
            );
          }

          return SizedBox(
            height: 68,
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: width < 1000
                        ? compactGroup(right)
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: sectionGroup(right),
                          ),
                  ),
                ),
                const SizedBox(width: 4),
                SizedBox(width: 68, child: calculatorButton.asStacked()),
                const SizedBox(width: 8),
                Container(
                  key: const ValueKey('ribbon-divider'),
                  width: 1,
                  height: 38,
                  color: AppColors.line,
                ),
                const SizedBox(width: 4),
                SizedBox(width: 208, child: compactGroup(left)),
                const SizedBox(width: 6),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _openInvoiceTabs() {
    final invoices = _openInvoices;
    return Container(
      key: const ValueKey('open-invoice-tabs'),
      height: 42,
      color: const Color(0xFFF0F0F0),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: invoices.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          if (index == invoices.length) {
            return fluent.Button(
              key: const ValueKey('open-new-invoice-tab'),
              onPressed: () => go(ShellView.invoiceMenu),
              style: fluent.ButtonStyle(
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                ),
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                foregroundColor: const WidgetStatePropertyAll(AppColors.ink),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    side: const BorderSide(color: AppColors.line),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              child: const Text('＋ فاتورة جديدة'),
            );
          }
          final route = invoices[index];
          final isActive =
              view == ShellView.invoice && _routes.last.id == route.id;
          final typeIndex = (route.invoiceType ?? 0)
              .clamp(0, invoiceTypes.length - 1)
              .toInt();
          return fluent.Button(
            key: ValueKey('open-invoice-tab-${route.invoiceNumber}'),
            onPressed: () => _activateInvoice(route.id),
            style: fluent.ButtonStyle(
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              ),
              backgroundColor: WidgetStatePropertyAll(
                isActive ? AppColors.navy : Colors.white,
              ),
              foregroundColor: WidgetStatePropertyAll(
                isActive ? Colors.white : AppColors.ink,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  side: BorderSide(
                    color: isActive ? AppColors.navy : AppColors.line,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${invoiceTypes[typeIndex].ar} ${route.invoiceNumber ?? index + 1}',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _content() {
    final theme = fluent.FluentTheme.of(context);
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (var index = 0; index < _routes.length; index++)
            _buildRouteLayer(
              _routes[index],
              isTop: index == _routes.length - 1,
              theme: theme,
            ),
        ],
      ),
    );
  }

  Widget _buildRouteLayer(
    _ShellRoute route, {
    required bool isTop,
    required fluent.FluentThemeData theme,
  }) {
    final content = switch (route.view) {
      ShellView.home => const ColoredBox(
        key: ValueKey('shell-home-background'),
        color: AppColors.canvasBlue,
        child: SizedBox.expand(),
      ),
      ShellView.inventory => InventoryScreen(
        session: session!,
        authService: widget.authService,
        onExit: _closeCurrentView,
      ),
      ShellView.invoiceMenu => InvoiceMenu(
        onPick: openInvoice,
        onHistory: () => showInvoiceHistoryDialog(
          context: context,
          session: session!,
          authService: widget.authService,
        ),
        onClose: _closeCurrentView,
      ),
      ShellView.invoice => InvoiceScreen(
        key: ValueKey('invoice-form-${route.invoiceNumber}'),
        typeIndex: route.invoiceType ?? 0,
        session: session!,
        authService: widget.authService,
        onExit: _closeCurrentView,
        onCloseGuardReady: (isDirty) => _invoiceDirtyChecks[route.id] = isDirty,
        onCloseGuardDisposed: () => _invoiceDirtyChecks.remove(route.id),
        draftId: route.draftId,
        initialDraft: route.invoiceDraft,
      ),
      ShellView.accounts => AccountsScreen(
        session: session!,
        authService: widget.authService,
        onExit: _closeCurrentView,
      ),
      ShellView.barcode => BarcodeScreen(
        session: session!,
        authService: widget.authService,
        onExit: _closeCurrentView,
      ),
      ShellView.printerSettings => PrinterSettingsScreen(
        session: session!,
        authService: widget.authService,
        embeddedPrinterToken: widget.embeddedPrinterToken,
        onExit: _closeCurrentView,
      ),
      ShellView.userPasswords => UserPasswordsScreen(
        session: session!,
        authService: widget.authService,
        passwordService: widget.authService as AdminPasswordManagementService,
        onExit: _closeCurrentView,
      ),
    };
    return Positioned.fill(
      key: ValueKey('shell-position-${route.id}'),
      child: IgnorePointer(
        key: ValueKey('shell-route-layer-${route.id}'),
        ignoring: !isTop,
        child: ExcludeSemantics(
          excluding: !isTop,
          child: AnimatedOpacity(
            opacity: isTop ? 1 : 0,
            duration: theme.mediumAnimationDuration,
            curve: theme.animationCurve,
            child: AnimatedSlide(
              offset: isTop ? Offset.zero : const Offset(0.025, 0),
              duration: theme.mediumAnimationDuration,
              curve: theme.animationCurve,
              child: TickerMode(
                enabled: isTop,
                child: KeyedSubtree(
                  key: ValueKey('shell-route-${route.id}-${route.view.name}'),
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RibbonButton extends StatelessWidget {
  final String glyph;
  final String? assetPath;
  final IconData? icon;
  final String label;
  final Color color;
  final bool active;
  final bool stacked;
  final bool dense;
  final bool horizontalCompact;
  final bool hideLabel;
  final double? iconSize;
  final VoidCallback onTap;
  const _RibbonButton({
    this.glyph = '',
    required this.label,
    required this.color,
    required this.onTap,
    this.assetPath,
    this.icon,
    this.active = false,
    this.stacked = false,
    this.dense = false,
    this.horizontalCompact = false,
    this.hideLabel = false,
    this.iconSize,
  });

  _RibbonButton asStacked({bool dense = false, double? iconSize}) =>
      _RibbonButton(
        glyph: glyph,
        assetPath: assetPath,
        icon: icon,
        label: label,
        color: color,
        active: active,
        onTap: onTap,
        stacked: true,
        dense: dense,
        horizontalCompact: false,
        hideLabel: hideLabel,
        iconSize: iconSize,
      );

  _RibbonButton asHorizontalCompact({bool dense = false, double? iconSize}) =>
      _RibbonButton(
        glyph: glyph,
        assetPath: assetPath,
        icon: icon,
        label: label,
        color: color,
        active: active,
        onTap: onTap,
        horizontalCompact: true,
        dense: dense,
        hideLabel: hideLabel,
        iconSize: iconSize,
      );

  @override
  Widget build(BuildContext context) {
    final resolvedIconSize = iconSize ?? (dense ? 22.0 : 32.0);
    final compactFontSize = dense && iconSize == null ? 8.5 : 12.0;
    final compactHeight = dense && iconSize != null ? 64.0 : 50.0;
    final buttonHeight = stacked
        ? (dense ? compactHeight : 64.0)
        : horizontalCompact
        ? (dense ? compactHeight : 64.0)
        : 60.0;
    Widget iconWidget(double size) => assetPath != null
        ? AppImageIcon(assetPath!, size: size)
        : icon != null
        ? Icon(icon, size: size, color: color)
        : Text(
            glyph,
            style: TextStyle(
              fontSize: size,
              height: 1.1,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          );
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: stacked
            ? 1
            : horizontalCompact
            ? 0
            : 2,
        vertical: stacked
            ? (dense ? 0 : 1)
            : horizontalCompact
            ? (dense ? 0 : 1)
            : 4,
      ),
      child: SizedBox(
        key: ValueKey('ribbon-$label'),
        width: stacked ? double.infinity : null,
        height: buttonHeight,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: active ? const Color(0xFF8DB6E2) : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: fluent.Button(
            onPressed: onTap,
            style: fluent.ButtonStyle(
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(
                  horizontal: stacked
                      ? 1
                      : horizontalCompact
                      ? 2
                      : 10,
                  vertical: stacked
                      ? (dense ? 2 : 1)
                      : horizontalCompact
                      ? 2
                      : 8,
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(
                active ? const Color(0xFFDDEBFA) : Colors.transparent,
              ),
              foregroundColor: const WidgetStatePropertyAll(AppColors.ink),
              shadowColor: const WidgetStatePropertyAll(Colors.transparent),
              elevation: const WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            child: stacked
                ? SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        iconWidget(resolvedIconSize),
                        if (!hideLabel) ...[
                          SizedBox(height: dense ? 1 : 2),
                          Text(
                            label.replaceAll('\n', ' '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: compactFontSize,
                              height: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      iconWidget(resolvedIconSize),
                      if (!hideLabel) ...[
                        SizedBox(
                          width: horizontalCompact ? (dense ? 1 : 2) : 6,
                        ),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: horizontalCompact
                                ? compactFontSize
                                : 12.5,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 11.5, color: AppColors.green);
    final backupInfo = Row(
      textDirection: TextDirection.ltr,
      children: [
        const Expanded(
          child: Text(
            'آخر نسخة احتياطية: 2025/08/30',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        const SizedBox(width: 16),
        const Text('------', style: style),
        const SizedBox(width: 16),
        Container(width: 54, height: 10, color: AppColors.red),
        const SizedBox(width: 12),
        Container(width: 54, height: 10, color: AppColors.red),
      ],
    );
    final otherInfo = Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'نسخة خاصة بـ : مؤسسة العيدان التجارية',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'تاريخ نهاية الضمان: 2015/03/01',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ],
      ),
    );
    return Container(
      key: const ValueKey('bottom-status-bar'),
      width: double.infinity,
      height: 26,
      color: const Color(0xFFF6F6F4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final contentWidth = constraints.maxWidth < 900
              ? 900.0
              : constraints.maxWidth;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: contentWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Expanded(child: backupInfo),
                    const SizedBox(width: 16),
                    Expanded(child: otherInfo),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoginDialog extends StatefulWidget {
  final AccountingAuthService authService;
  const _LoginDialog({required this.authService});

  @override
  State<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<_LoginDialog> {
  static const _users = ['admin', 'cashier1', 'cashier2', 'auditor'];

  final password = TextEditingController();
  String selectedUser = _users.first;
  String? error;
  bool signingIn = false;

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (signingIn) return;
    setState(() {
      signingIn = true;
      error = null;
    });
    try {
      final authenticated = await widget.authService.login(
        selectedUser,
        password.text,
      );
      if (mounted) Navigator.of(context).pop(authenticated);
    } catch (_) {
      if (mounted) {
        setState(() {
          error = 'بيانات الدخول غير صحيحة أو تعذر تسجيل الدخول';
          signingIn = false;
        });
      }
    }
  }

  void _clearPassword() {
    password.clear();
    setState(() => error = null);
  }

  Widget _loginFields() => Directionality(
    textDirection: TextDirection.rtl,
    child: Column(
      key: const ValueKey('login-fields'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'تسجيل الدخول',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        const Text('المستخدم', style: TextStyle(color: AppColors.ink)),
        const SizedBox(height: 5),
        DropBox(
          key: const ValueKey('login-user'),
          value: selectedUser,
          options: _users,
          onChanged: (value) => setState(() {
            selectedUser = value;
            error = null;
          }),
        ),
        const SizedBox(height: 12),
        const Text('كلمة المرور', style: TextStyle(color: AppColors.ink)),
        const SizedBox(height: 5),
        fluent.TextBox(
          key: const ValueKey('login-password'),
          controller: password,
          obscureText: true,
          autofocus: true,
          textDirection: TextDirection.ltr,
          placeholder: 'كلمة المرور',
          onSubmitted: (_) => _login(),
        ),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(
            error!,
            key: const ValueKey('login-error'),
            style: const TextStyle(
              color: Color(0xFFB42318),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              fluent.FilledButton(
                key: const ValueKey('login-submit'),
                onPressed: signingIn ? null : _login,
                child: const Text('دخول'),
              ),
              fluent.Button(
                key: const ValueKey('login-clear'),
                onPressed: _clearPassword,
                child: const Text('مسح كلمة المرور'),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 600;
    final maxDialogWidth = (screenWidth - 32).clamp(280.0, 760.0);
    final lock = Center(
      child: AppImageIcon(
        AppIcons.lock,
        key: const ValueKey('login-lock'),
        size: compact ? 72 : 176,
      ),
    );
    return fluent.ContentDialog(
      key: const ValueKey('login-dialog'),
      constraints: BoxConstraints(maxWidth: maxDialogWidth),
      content: Container(
        key: const ValueKey('login-panel'),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: compact
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _loginFields(),
                  const SizedBox(height: 12),
                  SizedBox(height: 82, child: lock),
                ],
              )
            : Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: [
                    Expanded(child: _loginFields()),
                    const SizedBox(width: 28),
                    SizedBox(width: 190, height: 250, child: lock),
                  ],
                ),
              ),
      ),
    );
  }
}

class _CalcDialog extends StatefulWidget {
  const _CalcDialog();
  @override
  State<_CalcDialog> createState() => _CalcDialogState();
}

class _CalcDialogState extends State<_CalcDialog> {
  static const _keys = [
    'C',
    '⌫',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '−',
    '1',
    '2',
    '3',
    '+',
    '±',
    '0',
    '.',
    '=',
  ];

  String display = '0';
  String? operation;
  double? storedValue;
  bool replaceOnDigit = true;
  Offset? position;

  String _format(double value) {
    if (!value.isFinite) return 'خطأ';
    final fixed = value.toStringAsFixed(8);
    return fixed
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  void _calculate() {
    final right = double.tryParse(display);
    final left = storedValue;
    if (left == null || right == null || operation == null) return;
    final result = switch (operation) {
      '+' => left + right,
      '−' => left - right,
      '×' => left * right,
      '÷' => right == 0 ? double.nan : left / right,
      _ => right,
    };
    display = _format(result);
    storedValue = null;
    operation = null;
    replaceOnDigit = true;
  }

  void _press(String key) {
    setState(() {
      if (key.length == 1 && '0123456789'.contains(key)) {
        if (replaceOnDigit || display == '0' || display == 'خطأ') {
          display = key;
        } else if (display.length < 16) {
          display += key;
        }
        replaceOnDigit = false;
        return;
      }
      switch (key) {
        case '.':
          if (replaceOnDigit || display == 'خطأ') {
            display = '0.';
            replaceOnDigit = false;
          } else if (!display.contains('.')) {
            display += '.';
          }
          break;
        case 'C':
          display = '0';
          storedValue = null;
          operation = null;
          replaceOnDigit = true;
          break;
        case '⌫':
          if (!replaceOnDigit && display.length > 1) {
            display = display.substring(0, display.length - 1);
          } else {
            display = '0';
          }
          break;
        case '±':
          final value = double.tryParse(display);
          if (value != null) display = _format(-value);
          break;
        case '%':
          final value = double.tryParse(display);
          if (value != null) display = _format(value / 100);
          break;
        case '+':
        case '−':
        case '×':
        case '÷':
          if (storedValue != null && operation != null && !replaceOnDigit) {
            _calculate();
          }
          storedValue ??= double.tryParse(display);
          operation = key;
          replaceOnDigit = true;
          break;
        case '=':
          _calculate();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math
            .min(360.0, constraints.maxWidth - 24)
            .clamp(0.0, double.infinity)
            .toDouble();
        final height = math
            .min(460.0, constraints.maxHeight - 24)
            .clamp(0.0, double.infinity)
            .toDouble();
        final defaultPosition = Offset(
          (constraints.maxWidth - width) / 2,
          (constraints.maxHeight - height) / 2,
        );
        final current = position ?? defaultPosition;
        final maxLeft = math.max(0.0, constraints.maxWidth - width);
        final maxTop = math.max(0.0, constraints.maxHeight - height);
        final left = current.dx.clamp(0.0, maxLeft).toDouble();
        final top = current.dy.clamp(0.0, maxTop).toDouble();

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: left,
              top: top,
              child: SizedBox(
                key: const ValueKey('calculator-window'),
                width: width,
                height: height,
                child: Material(
                  color: Colors.white,
                  elevation: 18,
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        GestureDetector(
                          key: const ValueKey('calculator-drag-handle'),
                          behavior: HitTestBehavior.opaque,
                          onPanUpdate: (details) {
                            setState(() {
                              position = Offset(
                                (left + details.delta.dx)
                                    .clamp(0.0, maxLeft)
                                    .toDouble(),
                                (top + details.delta.dy)
                                    .clamp(0.0, maxTop)
                                    .toDouble(),
                              );
                            });
                          },
                          child: Container(
                            height: 38,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            color: AppColors.ribbon,
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'آلة حاسبة',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                fluent.Button(
                                  key: const ValueKey('calculator-close'),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Icon(
                                    fluent.FluentIcons.chrome_close,
                                    size: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          key: const ValueKey('calculator-display'),
                          width: double.infinity,
                          height: 54,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F5F7),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: Text(
                            display,
                            key: const ValueKey('calculator-display-value'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.ltr,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            mainAxisSpacing: 6,
                            crossAxisSpacing: 6,
                            childAspectRatio: 1.45,
                            children: [
                              for (final key in _keys) _calculatorKey(key),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _calculatorKey(String key) {
    final isEquals = key == '=';
    final isOperator = const {'÷', '×', '−', '+'}.contains(key);
    final style = fluent.ButtonStyle(
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      backgroundColor: WidgetStatePropertyAll(
        isOperator ? const Color(0xFFE8F1FB) : const Color(0xFFF3F5F7),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
    final child = Text(
      key,
      style: TextStyle(
        fontSize: key.length > 1 ? 14 : 20,
        fontWeight: FontWeight.w600,
      ),
    );
    return SizedBox.expand(
      child: isEquals
          ? fluent.FilledButton(
              key: ValueKey('calculator-key-$key'),
              onPressed: () => _press(key),
              child: child,
            )
          : fluent.Button(
              key: ValueKey('calculator-key-$key'),
              style: style,
              onPressed: () => _press(key),
              child: child,
            ),
    );
  }
}
