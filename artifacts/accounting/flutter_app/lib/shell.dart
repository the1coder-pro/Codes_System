import 'package:flutter/material.dart';

import 'inventory_screen.dart';
import 'invoice_menu.dart';
import 'invoice_screen.dart';
import 'theme.dart';
import 'widgets.dart';

enum ShellView { home, inventory, invoiceMenu, invoice }

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

  void go(ShellView v) => setState(() => view = v);

  void openInvoice(int t) => setState(() {
    invoiceType = t;
    invoiceSession++;
    view = ShellView.invoice;
  });

  void soon(String name) => toast(context, '$name — غير متاحة في هذه النسخة');

  Future<void> calculator() async {
    await showDialog(context: context, builder: (_) => const _CalcDialog());
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 1100;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _titleStrip(),
            _menuBar(),
            _ribbon(),
            const Divider(height: 1, color: AppColors.line),
            Expanded(child: _content()),
            _StatusBar(narrow: narrow),
          ],
        ),
      ),
    );
  }

  Widget _titleStrip() => Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    child: Row(
      children: [
        const Text(
          'المحاسبة المالية العامة',
          style: TextStyle(fontSize: 12, color: AppColors.muted),
        ),
        const Spacer(),
        Text(
          view == ShellView.invoice ? '25.07.17' : '25.08.18',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _menu(String title, List<(String, VoidCallback)> entries) {
    return PopupMenuButton<int>(
      tooltip: '',
      position: PopupMenuPosition.under,
      onSelected: (i) => entries[i].$2(),
      itemBuilder: (_) => [
        for (var i = 0; i < entries.length; i++)
          PopupMenuItem(value: i, height: 38, child: Text(entries[i].$1)),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(title, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _menuBar() => Container(
    key: const ValueKey('top-menu-bar'),
    color: Colors.white,
    height: 32,
    width: double.infinity,
    alignment: AlignmentDirectional.centerStart,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _menu('القائمة الرئيسية', [
            ('الشاشة الرئيسية', () => go(ShellView.home)),
            ('الفواتير وأوامر الصرف', () => go(ShellView.invoiceMenu)),
            ('الأصناف / المخزون', () => go(ShellView.inventory)),
          ]),
          _menu('إدارة', [
            ('المستخدمون والصلاحيات', () => soon('المستخدمون')),
            ('بيانات المنشأة', () => soon('بيانات المنشأة')),
          ]),
          _menu('أدوات', [
            ('آلة حاسبة', calculator),
            ('نسخة احتياطية', () => soon('النسخ الاحتياطي')),
          ]),
          _menu('الأصناف', [
            ('بطاقة صنف', () => go(ShellView.inventory)),
            ('طباعة الباركود', () => soon('طباعة الباركود')),
          ]),
        ],
      ),
    ),
  );

  Widget _ribbon() {
    final right = [
      _RibbonButton(
        glyph: '▤',
        label: 'الفواتير\nوأوامر الصرف',
        color: AppColors.navy,
        active: view == ShellView.invoiceMenu || view == ShellView.invoice,
        onTap: () => go(ShellView.invoiceMenu),
      ),
      _RibbonButton(
        glyph: '▥',
        label: 'طباعة\nالباركود',
        color: AppColors.muted,
        onTap: () => soon('طباعة الباركود'),
      ),
      _RibbonButton(
        glyph: '◎',
        label: 'الحسابات',
        color: AppColors.navy,
        onTap: () => soon('الحسابات'),
      ),
      _RibbonButton(
        glyph: '▦',
        label: 'الأصناف',
        color: const Color(0xFF2B7BC4),
        active: view == ShellView.inventory,
        onTap: () => go(ShellView.inventory),
      ),
      _RibbonButton(
        glyph: '☑',
        label: 'ارسال واعتماد\nالفواتير',
        color: AppColors.red,
        onTap: () => soon('ارسال واعتماد الفواتير'),
      ),
    ];
    final left = [
      _RibbonButton(
        glyph: '±',
        label: 'آلة حاسبة',
        color: AppColors.muted,
        onTap: calculator,
      ),
      _RibbonButton(
        glyph: '↻',
        label: 'تحديث',
        color: AppColors.green,
        onTap: () {
          setState(() => invoiceSession++);
          toast(context, 'تم تحديث البيانات');
        },
      ),
      _RibbonButton(
        glyph: 'www',
        label: 'موقعنا',
        color: const Color(0xFF2B7BC4),
        onTap: () => soon('الموقع'),
      ),
      _RibbonButton(
        glyph: 'Ar',
        label: 'Arabic',
        color: AppColors.ink,
        onTap: () => toast(context, 'اللغة الحالية: العربية'),
      ),
      _RibbonButton(
        glyph: '⇥',
        label: 'خروج',
        color: const Color(0xFF2B7BC4),
        onTap: () => go(ShellView.home),
      ),
    ];
    return Container(
      color: AppColors.ribbon,
      height: 86,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SizedBox(
              height: 86,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [const SizedBox(width: 6), ...right],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 1, height: 44, color: AppColors.line),
                      ...left,
                      const SizedBox(width: 6),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    switch (view) {
      case ShellView.home:
        return const ColoredBox(
          color: AppColors.canvasBlue,
          child: SizedBox.expand(),
        );
      case ShellView.inventory:
        return InventoryScreen(onExit: () => go(ShellView.home));
      case ShellView.invoiceMenu:
        return InvoiceMenu(
          onPick: openInvoice,
          onClose: () => go(ShellView.home),
        );
      case ShellView.invoice:
        return InvoiceScreen(
          key: ValueKey('inv-$invoiceType-$invoiceSession'),
          typeIndex: invoiceType,
          onExit: () => go(ShellView.invoiceMenu),
        );
    }
  }
}

class _RibbonButton extends StatelessWidget {
  final String glyph;
  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;
  const _RibbonButton({
    required this.glyph,
    required this.label,
    required this.color,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      child: SizedBox(
        height: 74,
        child: Material(
          key: ValueKey('ribbon-$label'),
          color: active ? const Color(0xFFDDEBFA) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
            side: BorderSide(
              color: active ? const Color(0xFF8DB6E2) : Colors.transparent,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(3),
            hoverColor: const Color(0xFFE8F1FB),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
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
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final bool narrow;
  const _StatusBar({required this.narrow});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 11.5, color: AppColors.green);
    final parts = [
      const Text('نسخة خاصة بـ : مؤسسة العيدان التجارية', style: style),
      const Text('تاريخ نهاية الضمان: 2015/03/01', style: style),
      const Text('آخر نسخة احتياطية: 2025/08/30', style: style),
      const Text('------', style: style),
      Container(width: 54, height: 10, color: AppColors.red),
      Container(width: 54, height: 10, color: AppColors.red),
    ];
    return Container(
      height: 26,
      color: const Color(0xFFF6F6F4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            for (final p in parts) ...[p, const SizedBox(width: 16)],
          ],
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
    return AlertDialog(
      title: const Text('آلة حاسبة'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: TextField(
                controller: ctl,
                autofocus: true,
                onSubmitted: (_) => eval(),
                decoration: const InputDecoration(hintText: '125.40 * 3 + 18'),
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إغلاق'),
        ),
        FilledButton(onPressed: eval, child: const Text('احسب')),
      ],
    );
  }
}
