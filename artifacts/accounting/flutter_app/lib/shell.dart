import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'accounts_screen.dart';
import 'barcode_screen.dart';
import 'inventory_screen.dart';
import 'invoice_menu.dart';
import 'invoice_screen.dart';
import 'theme.dart';
import 'widgets.dart';

enum ShellView { home, inventory, invoiceMenu, invoice, accounts, barcode }

/// Window chrome: title strip, menu bar, ribbon, content canvas, status bar.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  ShellView view = ShellView.home;
  int invoiceType = 0;
  int invoiceSession = 0;
  String? currentUser;
  bool _loginDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showLoginDialog());
  }

  Future<void> _showLoginDialog() async {
    if (!mounted || _loginDialogOpen || currentUser != null) return;
    _loginDialogOpen = true;
    final username = await fluent.showDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.canvasBlue,
      dismissWithEsc: false,
      builder: (_) => const _LoginDialog(),
    );
    _loginDialogOpen = false;
    if (!mounted) return;
    if (username == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showLoginDialog());
      return;
    }
    setState(() => currentUser = username);
  }

  void go(ShellView v) => setState(() => view = v);

  void openInvoice(int t) => setState(() {
    invoiceType = t;
    invoiceSession++;
    view = ShellView.invoice;
  });

  void soon(String name) => toast(
    context,
    '$name — غير متاحة في هذه النسخة',
    severity: fluent.InfoBarSeverity.warning,
  );

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
    final versionAndUser = currentUser == null
        ? version
        : '$version - ($currentUser)';
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
    final mainMenu = _menu('القائمة الرئيسية', [
      ('الشاشة الرئيسية', () => go(ShellView.home)),
      ('الفواتير وأوامر الصرف', () => go(ShellView.invoiceMenu)),
      ('الأصناف / المخزون', () => go(ShellView.inventory)),
      ('الحسابات', () => go(ShellView.accounts)),
      ('طباعة الباركود', () => go(ShellView.barcode)),
    ]);
    final adminMenu = _menu('إدارة', [
      ('المستخدمون والصلاحيات', () => soon('المستخدمون')),
      ('بيانات المنشأة', () => soon('بيانات المنشأة')),
    ]);
    final toolsMenu = _menu('أدوات', [
      ('آلة حاسبة', calculator),
      ('نسخة احتياطية', () => soon('النسخ الاحتياطي')),
    ]);
    final itemsMenu = _menu('الأصناف', [
      ('بطاقة صنف', () => go(ShellView.inventory)),
      ('طباعة الباركود', () => go(ShellView.barcode)),
    ]);
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
                  children: [mainMenu, adminMenu],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [toolsMenu, itemsMenu],
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [mainMenu, adminMenu, toolsMenu, itemsMenu],
            ),
    );
  }

  Widget _ribbon() {
    final right = [
      _RibbonButton(
        assetPath: AppIcons.receipt,
        label: 'الفواتير\nوأوامر الصرف',
        color: AppColors.navy,
        active: view == ShellView.invoiceMenu || view == ShellView.invoice,
        onTap: () => go(ShellView.invoiceMenu),
      ),
      _RibbonButton(
        assetPath: AppIcons.printer,
        label: 'طباعة\nالباركود',
        color: AppColors.muted,
        active: view == ShellView.barcode,
        onTap: () => go(ShellView.barcode),
      ),
      _RibbonButton(
        assetPath: AppIcons.users,
        label: 'الحسابات',
        color: AppColors.navy,
        active: view == ShellView.accounts,
        onTap: () => go(ShellView.accounts),
      ),
      _RibbonButton(
        assetPath: AppIcons.shop,
        label: 'الأصناف',
        color: const Color(0xFF2B7BC4),
        active: view == ShellView.inventory,
        onTap: () => go(ShellView.inventory),
      ),
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
        onTap: () {
          setState(() => invoiceSession++);
          toast(
            context,
            'تم تحديث البيانات',
            severity: fluent.InfoBarSeverity.success,
          );
        },
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
        onTap: () => go(ShellView.home),
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
          }) {
            return Row(
              children: [
                for (final button in buttons)
                  Expanded(child: button.asStacked(dense: dense)),
              ],
            );
          }

          Widget sectionGroup(
            List<_RibbonButton> buttons, {
            bool dense = false,
          }) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < buttons.length; index++) ...[
                  if (index > 0) const SizedBox(width: 6),
                  buttons[index].asHorizontalCompact(dense: dense),
                ],
              ],
            );
          }

          if (width >= 1400) {
            return SizedBox(
              width: width,
              height: 72,
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
                          child: sectionGroup(right, dense: true),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 68,
                    height: 72,
                    child: calculatorButton.asStacked(dense: true),
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
                    width: 208,
                    height: 72,
                    child: compactGroup(left, dense: true),
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
            height: 80,
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

  Widget _content() {
    final content = switch (view) {
      ShellView.home => const ColoredBox(
        color: AppColors.canvasBlue,
        child: SizedBox.expand(),
      ),
      ShellView.inventory => InventoryScreen(onExit: () => go(ShellView.home)),
      ShellView.invoiceMenu => InvoiceMenu(
        onPick: openInvoice,
        onClose: () => go(ShellView.home),
      ),
      ShellView.invoice => InvoiceScreen(
        typeIndex: invoiceType,
        onExit: () => go(ShellView.invoiceMenu),
      ),
      ShellView.accounts => AccountsScreen(onExit: () => go(ShellView.home)),
      ShellView.barcode => BarcodeScreen(onExit: () => go(ShellView.home)),
    };
    final contentKey = ValueKey(
      '${view.name}-${view == ShellView.invoice ? '$invoiceType-$invoiceSession' : ''}',
    );
    final theme = fluent.FluentTheme.of(context);
    return ClipRect(
      child: AnimatedSwitcher(
        key: const ValueKey('app-content-transition'),
        duration: theme.mediumAnimationDuration,
        reverseDuration: theme.fastAnimationDuration,
        switchInCurve: theme.animationCurve,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final eased = CurvedAnimation(
            parent: animation,
            curve: theme.animationCurve,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: eased,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.035, 0),
                end: Offset.zero,
              ).animate(eased),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(key: contentKey, child: content),
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
  });

  _RibbonButton asStacked({bool dense = false}) => _RibbonButton(
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
  );

  _RibbonButton asHorizontalCompact({bool dense = false}) => _RibbonButton(
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
  );

  @override
  Widget build(BuildContext context) {
    final buttonHeight = stacked
        ? (dense ? 50.0 : 74.0)
        : horizontalCompact
        ? (dense ? 50.0 : 74.0)
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
                        iconWidget(dense ? 17 : 27),
                        if (!hideLabel) ...[
                          SizedBox(height: dense ? 1 : 2),
                          Text(
                            label.replaceAll('\n', ' '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: dense ? 8.5 : 12,
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
                      iconWidget(dense ? 17 : 27),
                      if (!hideLabel) ...[
                        SizedBox(
                          width: horizontalCompact ? (dense ? 1 : 2) : 6,
                        ),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: horizontalCompact
                                ? (dense ? 8.5 : 12)
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
  const _LoginDialog();

  @override
  State<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<_LoginDialog> {
  static const _users = ['admin', 'cashier1', 'cashier2', 'auditor'];
  static const _demoPassword = '1233';

  final password = TextEditingController();
  String selectedUser = _users.first;
  String? error;

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  void _login() {
    if (password.text != _demoPassword) {
      setState(() => error = 'كلمة المرور غير صحيحة');
      return;
    }
    Navigator.of(context).pop(selectedUser);
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
                onPressed: _login,
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
