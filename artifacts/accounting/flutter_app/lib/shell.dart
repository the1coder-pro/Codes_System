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
    await fluent.showDialog(
      context: context,
      builder: (_) => const _CalcDialog(),
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
        glyph: '🧾',
        label: 'الفواتير\nوأوامر الصرف',
        color: AppColors.navy,
        active: view == ShellView.invoiceMenu || view == ShellView.invoice,
        onTap: () => go(ShellView.invoiceMenu),
      ),
      _RibbonButton(
        glyph: '🏷️',
        label: 'طباعة\nالباركود',
        color: AppColors.muted,
        active: view == ShellView.barcode,
        onTap: () => go(ShellView.barcode),
      ),
      _RibbonButton(
        glyph: '📒',
        label: 'الحسابات',
        color: AppColors.navy,
        active: view == ShellView.accounts,
        onTap: () => go(ShellView.accounts),
      ),
      _RibbonButton(
        glyph: '📦',
        label: 'الأصناف',
        color: const Color(0xFF2B7BC4),
        active: view == ShellView.inventory,
        onTap: () => go(ShellView.inventory),
      ),
      _RibbonButton(
        glyph: '📨',
        label: 'ارسال واعتماد\nالفواتير',
        color: AppColors.red,
        onTap: () => soon('ارسال واعتماد الفواتير'),
      ),
    ];
    final left = [
      _RibbonButton(
        glyph: '🧮',
        label: 'آلة حاسبة',
        color: AppColors.muted,
        onTap: calculator,
      ),
      _RibbonButton(
        glyph: '🔄',
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
        glyph: '🌐',
        label: 'موقعنا',
        color: const Color(0xFF2B7BC4),
        onTap: () => soon('الموقع'),
      ),
      _RibbonButton(
        glyph: '🗣️',
        label: 'Arabic',
        color: AppColors.ink,
        onTap: () {},
      ),
      _RibbonButton(
        glyph: '🚪',
        label: 'خروج',
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
          if (width >= 1400) {
            return SizedBox(
              width: width,
              height: 72,
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [const SizedBox(width: 6), ...right],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    key: const ValueKey('ribbon-divider'),
                    width: 1,
                    height: 38,
                    color: AppColors.line,
                  ),
                  const SizedBox(width: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [...left, const SizedBox(width: 6)],
                  ),
                ],
              ),
            );
          }

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

          if (width < 700) {
            return SizedBox(
              height: 108,
              child: Column(
                children: [
                  Expanded(child: compactGroup(right, dense: true)),
                  Expanded(child: compactGroup(left, dense: true)),
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
                    child: compactGroup(right),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  key: const ValueKey('ribbon-divider'),
                  width: 1,
                  height: 38,
                  color: AppColors.line,
                ),
                const SizedBox(width: 4),
                SizedBox(width: 340, child: compactGroup(left)),
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
  final String label;
  final Color color;
  final bool active;
  final bool stacked;
  final bool dense;
  final VoidCallback onTap;
  const _RibbonButton({
    required this.glyph,
    required this.label,
    required this.color,
    required this.onTap,
    this.active = false,
    this.stacked = false,
    this.dense = false,
  });

  _RibbonButton asStacked({bool dense = false}) => _RibbonButton(
    glyph: glyph,
    label: label,
    color: color,
    active: active,
    onTap: onTap,
    stacked: true,
    dense: dense,
  );

  @override
  Widget build(BuildContext context) {
    final buttonHeight = stacked ? (dense ? 50.0 : 74.0) : 60.0;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: stacked ? 1 : 2,
        vertical: stacked ? (dense ? 0 : 1) : 4,
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
                  horizontal: stacked ? 1 : 10,
                  vertical: stacked ? (dense ? 2 : 1) : 8,
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
                        Text(
                          glyph,
                          style: TextStyle(
                            fontSize: dense ? 17 : 27,
                            height: 1.05,
                            color: color,
                          ),
                        ),
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
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        glyph,
                        style: TextStyle(
                          fontSize: 22,
                          color: color,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: const TextStyle(fontSize: 12.5, height: 1.2),
                      ),
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
      child: Text(
        '🔒',
        key: const ValueKey('login-lock'),
        style: TextStyle(fontSize: compact ? 72 : 176, height: 1),
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
  final ctl = TextEditingController();
  String result = '';

  void eval() {
    // Left-to-right with * / precedence over + -.
    final src = ctl.text.replaceAll(' ', '').replaceAll('×', '*');
    final tokens = RegExp(
      r'(\d+\.?\d*|[+\-*/])',
    ).allMatches(src).map((m) => m[0]!).toList();
    try {
      final terms = <double>[];
      final ops = <String>[];
      double? cur;
      String pending = '';
      for (final t in tokens) {
        if ('+-*/'.contains(t)) {
          pending = t;
          if (t == '+' || t == '-') {
            terms.add(cur!);
            ops.add(t);
            cur = null;
          }
        } else {
          final n = double.parse(t);
          if (cur != null && pending == '*') {
            cur = cur * n;
          } else if (cur != null && pending == '/') {
            cur = cur / n;
          } else {
            cur = n;
          }
        }
      }
      terms.add(cur!);
      var total = terms.first;
      for (var i = 0; i < ops.length; i++) {
        total = ops[i] == '+' ? total + terms[i + 1] : total - terms[i + 1];
      }
      setState(() => result = money(total));
    } catch (_) {
      setState(() => result = 'تعبير غير صالح');
    }
  }

  @override
  Widget build(BuildContext context) {
    return fluent.ContentDialog(
      title: const Text('آلة حاسبة'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: fluent.TextBox(
                controller: ctl,
                autofocus: true,
                onSubmitted: (_) => eval(),
                placeholder: '125.40 * 3 + 18',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              result.isEmpty ? '=' : '= $result',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
      actions: [
        fluent.Button(
          onPressed: () => Navigator.pop(context),
          child: const Text('إغلاق'),
        ),
        fluent.FilledButton(onPressed: eval, child: const Text('احسب')),
      ],
    );
  }
}
