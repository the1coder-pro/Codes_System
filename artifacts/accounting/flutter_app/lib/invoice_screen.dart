import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'models.dart';
import 'storage.dart';
import 'theme.dart';
import 'widgets.dart';

/// Invoice form: right main form with tabs, left payments/items sidebar,
/// bottom green totals strip. Drafts persist per invoice type.
class InvoiceScreen extends StatefulWidget {
  final int typeIndex;
  final VoidCallback onExit;
  const InvoiceScreen({
    super.key,
    required this.typeIndex,
    required this.onExit,
  });

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  int tab = 0;
  final lines = <InvoiceLine>[];
  final lineCtl = <String, List<TextEditingController>>{};
  int? selected;
  List<Item> catalog = [];
  bool draftLoaded = false;
  String? selectedPayment;

  DateTime invDate = DateTime.now();
  DateTime delivDate = DateTime.now();
  final h = <String, TextEditingController>{
    for (final k in [
      'number',
      'account',
      'taxNo',
      'notes',
      'discount',
      'taxRate',
      'cash',
      'network',
      'credit',
      'returnBal',
      'pick',
    ])
      k: TextEditingController(),
  };
  String creditor = 'مورد بدون حساب';
  String debtor = 'مشتريات بضاعة بعرض البيع';
  String storeCredit = 'مشتريات بضاعة بعرض البيع';
  String storeDebit = '-';
  String taxable = 'خاضع للضريبة';

  InvoiceType get type => invoiceTypes[widget.typeIndex];

  @override
  void initState() {
    super.initState();
    h['taxRate']!.text = '0.15';
    h['discount']!.text = '0';
    for (final k in ['cash', 'network', 'credit', 'returnBal']) {
      h[k]!.text = '0';
    }
    Store.loadItems().then((v) {
      if (mounted) setState(() => catalog = v);
    });
    Store.loadDraft(widget.typeIndex).then((d) {
      if (d == null || !mounted) return;
      setState(() {
        _apply(d);
        draftLoaded = true;
      });
    });
  }

  double _n(String k) => double.tryParse(h[k]!.text) ?? 0;
  double get subtotal => lines.fold(0, (s, l) => s + l.total);
  double get discount => _n('discount');
  double get tax => taxable == 'خاضع للضريبة'
      ? ((subtotal - discount).clamp(0, double.infinity)) * _n('taxRate')
      : 0;
  double get net => subtotal - discount + tax;
  double get paid =>
      _n('cash') + _n('network') + _n('credit') + _n('returnBal');
  double get remaining => net - paid;

  void _addLine({String code = '', String name = '', double price = 0}) {
    final l = InvoiceLine(
      id: '${DateTime.now().microsecondsSinceEpoch}',
      code: code,
      name: name,
      price: price,
    );
    lines.add(l);
    lineCtl[l.id] = [
      TextEditingController(text: code),
      TextEditingController(text: name),
      TextEditingController(text: '1'),
      TextEditingController(text: money(price)),
    ];
    selected = lines.length - 1;
  }

  void _syncQty(InvoiceLine l) {
    lineCtl[l.id]![2].text = l.qty % 1 == 0
        ? l.qty.toInt().toString()
        : '${l.qty}';
  }

  void _changeQty(double d) {
    if (selected == null) return;
    setState(() {
      final l = lines[selected!];
      l.qty = (l.qty + d).clamp(1, 99999).toDouble();
      _syncQty(l);
    });
  }

  void _move(int d) {
    if (lines.isEmpty) return;
    setState(() {
      selected = ((selected ?? 0) + d).clamp(0, lines.length - 1);
    });
  }

  Future<void> _deleteLine() async {
    if (selected == null) {
      toast(context, 'حدد صنفاً أولاً');
      return;
    }
    final l = lines[selected!];
    final ok = await confirmDialog(
      context,
      'حذف صنف',
      'حذف "${l.name.isEmpty ? 'سطر ${selected! + 1}' : l.name}" من الفاتورة؟',
    );
    if (!ok || !mounted) return;
    setState(() {
      lines.removeAt(selected!);
      lineCtl.remove(l.id);
      selected = lines.isEmpty
          ? null
          : (selected! - 1).clamp(0, lines.length - 1);
    });
  }

  Map<String, dynamic> _toJson() => {
    'invDate': invDate.toIso8601String(),
    'delivDate': delivDate.toIso8601String(),
    for (final e in h.entries) e.key: e.value.text,
    'creditor': creditor,
    'debtor': debtor,
    'storeCredit': storeCredit,
    'storeDebit': storeDebit,
    'taxable': taxable,
    'selectedPayment': selectedPayment,
    'lines': lines.map((l) => l.toJson()).toList(),
  };

  void _apply(Map<String, dynamic> d) {
    invDate = DateTime.tryParse(d['invDate'] ?? '') ?? invDate;
    delivDate = DateTime.tryParse(d['delivDate'] ?? '') ?? delivDate;
    for (final e in h.entries) {
      if (d[e.key] is String) e.value.text = d[e.key];
    }
    creditor = d['creditor'] ?? creditor;
    debtor = d['debtor'] ?? debtor;
    storeCredit = d['storeCredit'] ?? storeCredit;
    storeDebit = d['storeDebit'] ?? storeDebit;
    taxable = d['taxable'] ?? taxable;
    selectedPayment = d['selectedPayment'] as String?;
    lines.clear();
    lineCtl.clear();
    for (final raw in (d['lines'] as List? ?? [])) {
      final l = InvoiceLine.fromJson(Map<String, dynamic>.from(raw));
      lines.add(l);
      lineCtl[l.id] = [
        TextEditingController(text: l.code),
        TextEditingController(text: l.name),
        TextEditingController(),
        TextEditingController(text: money(l.price)),
      ];
      _syncQty(l);
    }
  }

  Future<void> _save() async {
    final ok = await Store.saveDraft(widget.typeIndex, _toJson());
    if (mounted) {
      setState(() => draftLoaded = true);
      toast(context, ok ? 'تم حفظ مسودة ${type.ar}' : 'تعذر الحفظ محلياً');
    }
  }

  Future<void> _discard() async {
    final ok = await confirmDialog(
      context,
      'مسودة جديدة',
      'مسح بيانات الفاتورة الحالية والمسودة المحفوظة؟',
    );
    if (!ok || !mounted) return;
    await Store.clearDraft(widget.typeIndex);
    setState(() {
      lines.clear();
      lineCtl.clear();
      selected = null;
      selectedPayment = null;
      for (final k in ['number', 'account', 'taxNo', 'notes']) {
        h[k]!.text = '';
      }
      for (final k in ['discount', 'cash', 'network', 'credit', 'returnBal']) {
        h[k]!.text = '0';
      }
      draftLoaded = false;
    });
  }

  void _print() {
    fluent.showDialog(
      context: context,
      builder: (c) => fluent.ContentDialog(
        title: Text('معاينة طباعة — ${type.ar}'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'رقم: ${h['number']!.text.isEmpty ? '—' : h['number']!.text}   التاريخ: ${_fmt(invDate)}',
              ),
              const Divider(),
              for (final l in lines)
                Row(
                  children: [
                    Expanded(
                      child: Text(l.name.isEmpty ? '(بدون اسم)' : l.name),
                    ),
                    Text('${l.qty} × ${money(l.price)} = ${money(l.total)}'),
                  ],
                ),
              const Divider(),
              Text(
                'الصافي: ${money(net)}',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
        actions: [
          fluent.Button(
            onPressed: () => Navigator.pop(c),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) => '${d.month}/${d.day}/${d.year}';
  String _time(DateTime d) {
    final hr = d.hour % 12 == 0 ? 12 : d.hour % 12;
    return '$hr:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')} ${d.hour < 12 ? 'AM' : 'PM'}';
  }

  Future<void> _pickDate(bool invoice) async {
    final initialDate = invoice ? invDate : delivDate;
    var chosen = initialDate;
    final confirmed = await fluent.showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => fluent.ContentDialog(
          title: Text(invoice ? 'تاريخ الفاتورة' : 'تاريخ التسليم'),
          content: SizedBox(
            width: 340,
            child: fluent.DatePicker(
              selected: chosen,
              startDate: DateTime(2015),
              endDate: DateTime(2035),
              onChanged: (date) => setDialogState(() => chosen = date),
            ),
          ),
          actions: [
            fluent.Button(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            fluent.FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('اختيار'),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true && mounted) {
      setState(() => invoice ? invDate = chosen : delivDate = chosen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final wide = box.maxWidth >= 980;
        final main = _mainArea(wide);
        final side = _sidebar();
        final totals = _totalsStrip();
        if (wide) {
          return Container(
            color: AppColors.paper,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: main),
                      Container(width: 1, color: AppColors.line),
                      SizedBox(
                        width: 300,
                        child: SingleChildScrollView(child: side),
                      ),
                    ],
                  ),
                ),
                totals,
              ],
            ),
          );
        }
        return Container(
          color: AppColors.paper,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: tab == 0 ? null : 460,
                      child: tab == 0 ? main : main,
                    ),
                    const Divider(height: 1),
                    side,
                  ],
                ),
              ),
              totals,
            ],
          ),
        );
      },
    );
  }

  Widget _tabs() {
    const names = ['بيانات الفاتورة', 'إضافة الأصناف', 'اختيار الأصناف'];
    return Container(
      color: const Color(0xFFEFF1F3),
      padding: const EdgeInsets.only(top: 6, right: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < 3; i++)
              GestureDetector(
                onTap: () => setState(() => tab = i),
                child: Container(
                  margin: const EdgeInsets.only(left: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: tab == i ? Colors.white : const Color(0xFFE2E5E8),
                    border: Border(
                      top: BorderSide(
                        color: tab == i ? AppColors.green : AppColors.line,
                        width: tab == i ? 2.5 : 1,
                      ),
                      left: const BorderSide(color: AppColors.line),
                      right: const BorderSide(color: AppColors.line),
                    ),
                  ),
                  child: Text(
                    names[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: tab == i ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _mainArea(bool wide) {
    Widget body;
    if (tab == 0) {
      body = _headerTab(wide);
      body = wide ? SingleChildScrollView(child: body) : body;
    } else if (tab == 1) {
      body = _linesTab();
    } else {
      body = _pickTab();
    }
    return Column(
      mainAxisSize: wide ? MainAxisSize.max : MainAxisSize.min,
      children: [
        _tabs(),
        if (wide || tab != 0) Expanded(child: body) else body,
      ],
    );
  }

  Widget _headerTab(bool wide) {
    final right = Column(
      children: [
        FieldRow(
          label: 'تاريخ الفاتورة',
          labelWidth: 108,
          child: _dateBox(_fmt(invDate), () => _pickDate(true)),
        ),
        FieldRow(
          label: 'وقت الفاتورة',
          labelWidth: 108,
          child: _readonly(_time(invDate)),
        ),
        FieldRow(
          label: 'رقم الفاتورة اليدوي',
          labelWidth: 108,
          child: TextBox(controller: h['number']!),
        ),
        FieldRow(
          label: 'الدائن',
          labelWidth: 108,
          child: DropBox(
            value: creditor,
            options: const [
              'مورد بدون حساب',
              'مؤسسة الرواد للتموين',
              'شركة النخبة',
            ],
            onChanged: (v) => setState(() => creditor = v),
          ),
        ),
        FieldRow(
          label: 'المدين',
          labelWidth: 108,
          child: DropBox(
            value: debtor,
            options: const [
              'مشتريات بضاعة بعرض البيع',
              'مصروفات عمومية',
              'الصندوق',
            ],
            onChanged: (v) => setState(() => debtor = v),
          ),
        ),
        FieldRow(
          label: 'اسم الحساب',
          labelWidth: 108,
          child: TextBox(controller: h['account']!),
        ),
        FieldRow(
          label: 'الرقم الضريبي',
          labelWidth: 108,
          child: TextBox(controller: h['taxNo']!),
        ),
        FieldRow(
          label: 'المخزون دائن',
          labelWidth: 108,
          child: DropBox(
            value: storeCredit,
            options: const [
              'مشتريات بضاعة بعرض البيع',
              'المستودع الرئيسي',
              '-',
            ],
            onChanged: (v) => setState(() => storeCredit = v),
          ),
        ),
        FieldRow(
          label: 'المخزون مدين',
          labelWidth: 108,
          child: DropBox(
            value: storeDebit,
            options: const ['-', 'المستودع الرئيسي', 'مستودع الفرع'],
            onChanged: (v) => setState(() => storeDebit = v),
          ),
        ),
      ],
    );
    final left = Column(
      children: [
        FieldRow(
          label: 'خاضع للضريبة',
          labelWidth: 96,
          child: DropBox(
            value: taxable,
            options: const ['خاضع للضريبة', 'غير خاضع'],
            onChanged: (v) => setState(() => taxable = v),
          ),
        ),
        FieldRow(
          label: 'نسبة الضريبة',
          labelWidth: 96,
          child: TextBox(
            controller: h['taxRate']!,
            onChanged: (_) => setState(() {}),
          ),
        ),
        FieldRow(
          label: 'تاريخ التسليم',
          labelWidth: 96,
          child: _dateBox(_fmt(delivDate), () => _pickDate(false)),
        ),
        FieldRow(
          label: 'وقت التسليم',
          labelWidth: 96,
          child: _readonly(_time(delivDate)),
        ),
        FieldRow(
          label: 'ملاحظات',
          labelWidth: 96,
          child: TextBox(controller: h['notes']!, maxLines: 4),
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              if (wide) const SizedBox(width: 190),
              Expanded(
                child: Text(
                  type.ar,
                  textAlign: wide ? TextAlign.start : TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (draftLoaded)
                const Text(
                  '● مسودة محفوظة',
                  style: TextStyle(color: AppColors.green, fontSize: 12),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: right),
                const SizedBox(width: 28),
                Expanded(child: left),
              ],
            )
          else ...[
            right,
            const SizedBox(height: 8),
            left,
          ],
        ],
      ),
    );
  }

  Widget _dateBox(String text, VoidCallback onTap) => fluent.Button(
    onPressed: onTap,
    style: fluent.ButtonStyle(
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      backgroundColor: const WidgetStatePropertyAll(Colors.white),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    child: SizedBox(
      height: 36,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
            const Text('▾', style: TextStyle(color: AppColors.muted)),
          ],
        ),
      ),
    ),
  );

  Widget _readonly(String text) => Container(
    height: 36,
    alignment: AlignmentDirectional.centerStart,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFEDEFF1),
      border: Border.all(color: const Color(0xFFD3D8DD)),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 14, color: AppColors.muted),
    ),
  );

  Widget _linesTab() {
    const cols = [
      GridColumn('رمز الصنف', 100),
      GridColumn('اسم الصنف', 220),
      GridColumn('الكمية', 80),
      GridColumn('السعر', 100),
      GridColumn('الإجمالي', 110),
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              fluent.FilledButton(
                style: fluent.ButtonStyle(
                  backgroundColor: const WidgetStatePropertyAll(
                    AppColors.green,
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                onPressed: () => setState(() => _addLine()),
                child: const Text('+ سطر جديد'),
              ),
              const SizedBox(width: 8),
              fluent.Button(
                onPressed: _deleteLine,
                child: const Text('حذف السطر'),
              ),
              const Spacer(),
              Text(
                '${lines.length} سطر',
                style: const TextStyle(color: AppColors.muted),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.ink),
            ),
            child: lines.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد أصناف بعد — أضف سطراً أو اختر من تبويب اختيار الأصناف',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted),
                    ),
                  )
                : EditableGrid(
                    columns: cols,
                    rowCount: lines.length,
                    selectedRow: selected,
                    onSelectRow: (r) => setState(() => selected = r),
                    cell: (r, c) {
                      final l = lines[r];
                      if (c == 4) {
                        return Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            money(l.total),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        );
                      }
                      return CellField(
                        controller: lineCtl[l.id]![c],
                        onChanged: (v) => setState(() {
                          switch (c) {
                            case 0:
                              l.code = v;
                            case 1:
                              l.name = v;
                            case 2:
                              l.qty = double.tryParse(v) ?? 0;
                            case 3:
                              l.price = double.tryParse(v) ?? 0;
                          }
                        }),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _pickTab() {
    final q = h['pick']!.text.trim();
    final list = catalog
        .where(
          (e) =>
              q.isEmpty ||
              e.nameAr.contains(q) ||
              e.id.contains(q) ||
              e.units.any((u) => u.barcode.contains(q)),
        )
        .toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: FieldRow(
            label: 'بحث عن صنف',
            labelWidth: 90,
            child: TextBox(
              controller: h['pick']!,
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد أصناف مطابقة في المخزون',
                    style: TextStyle(color: AppColors.muted),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final it = list[i];
                    return ListTile(
                      dense: true,
                      title: Text(
                        it.nameAr,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        '${it.id}  ·  ${it.units.isEmpty ? '' : it.units.first.barcode}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(money(it.price)),
                          const SizedBox(width: 10),
                          fluent.Button(
                            onPressed: () {
                              setState(
                                () => _addLine(
                                  code: it.id,
                                  name: it.nameAr,
                                  price: it.price,
                                ),
                              );
                              toast(context, 'أضيف ${it.nameAr}');
                            },
                            child: const Text('إضافة'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _sidebar() {
    return Container(
      color: const Color(0xFFF7F8F9),
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: [
              ActionTile(
                glyph: '🗑️',
                label: 'حذف صنف',
                glyphColor: AppColors.red,
                width: 54,
                height: 58,
                onTap: _deleteLine,
              ),
              ActionTile(
                glyph: '💾',
                label: 'حفظ F8',
                width: 54,
                height: 58,
                onTap: _save,
              ),
              ActionTile(
                glyph: '🖨️',
                label: 'طباعة F7',
                glyphColor: AppColors.muted,
                width: 54,
                height: 58,
                onTap: _print,
              ),
              ActionTile(
                glyph: '🔎',
                label: 'بحث F2',
                width: 54,
                height: 58,
                onTap: () => setState(() => tab = 2),
              ),
              ActionTile(
                glyph: '🚪',
                label: 'خروج F1',
                width: 54,
                height: 58,
                onTap: widget.onExit,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFFBFC3C7),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text('الاسم', style: TextStyle(fontSize: 11)),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text('السعر', style: TextStyle(fontSize: 11)),
                      ),
                      SizedBox(
                        width: 56,
                        child: Text('الإجمالي', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: lines.length,
                    itemBuilder: (_, i) {
                      final l = lines[i];
                      return GestureDetector(
                        onTap: () => setState(() => selected = i),
                        child: Container(
                          color: i == selected
                              ? const Color(0xFFDDEBFA)
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l.name.isEmpty ? '—' : l.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: Text(
                                  money(l.price),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width: 56,
                                child: Text(
                                  money(l.total),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _greenBtn('⬆️', () => _move(-1)),
              _greenBtn('➕', () => _changeQty(1)),
              Expanded(
                child: Container(
                  height: 34,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Text(
                    selected == null
                        ? '0'
                        : lineCtl[lines[selected!].id]![2].text,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              _greenBtn('➖', () => _changeQty(-1)),
              _greenBtn('⬇️', () => _move(1)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _metric('الصافي', money(net), AppColors.green),
              _metric('الضريبة', money(tax), AppColors.ink),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'الخصم',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: TextBox(
                        controller: h['discount']!,
                        align: TextAlign.center,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
              _metric('المجموع', money(subtotal), AppColors.ink),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _pay('نقداً', '💵', 'cash'),
              _pay('شبكة', '💳', 'network'),
              _pay('آجل', '🧾', 'credit'),
              _pay('رصيد رجيع', '💸', 'returnBal'),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            color: AppColors.navy,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                const Text(
                  'المتبقي',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  money(remaining),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          fluent.Button(
            onPressed: _discard,
            child: const Text('مسح المسودة وبدء فاتورة جديدة'),
          ),
        ],
      ),
    );
  }

  Widget _greenBtn(String t, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 1.5),
    child: fluent.Button(
      onPressed: onTap,
      style: fluent.ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.green),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      child: SizedBox(
        width: 44,
        height: 34,
        child: Center(
          child: Text(
            t,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _metric(String label, String value, Color c) => Expanded(
    child: Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w900, color: c),
        ),
      ],
    ),
  );

  Future<void> _editPayment(String label, String key) async {
    final form = GlobalKey<FormState>();
    var amount = h[key]!.text;
    final result = await fluent.showDialog<String>(
      context: context,
      builder: (dialogContext) {
        void apply() {
          if (form.currentState!.validate()) {
            Navigator.of(dialogContext).pop(amount);
          }
        }

        return fluent.ContentDialog(
          title: Text('مبلغ الدفع — $label'),
          content: SizedBox(
            width: 320,
            child: Form(
              key: form,
              child: fluent.TextFormBox(
                key: const ValueKey('payment-amount'),
                initialValue: amount,
                autofocus: true,
                textDirection: TextDirection.ltr,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.done,
                placeholder: 'المبلغ',
                onChanged: (value) => amount = value.trim(),
                onFieldSubmitted: (_) => apply(),
                validator: (value) {
                  final parsed = double.tryParse(value?.trim() ?? '');
                  if (parsed == null || !parsed.isFinite || parsed < 0) {
                    return 'أدخل مبلغاً صحيحاً لا يقل عن صفر';
                  }
                  return null;
                },
              ),
            ),
          ),
          actions: [
            fluent.Button(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('إلغاء'),
            ),
            fluent.FilledButton(
              onPressed: apply,
              child: const Text('تأكيد المبلغ'),
            ),
          ],
        );
      },
    );
    if (result == null || !mounted) return;
    setState(() {
      selectedPayment = key;
      h[key]!.text = money(double.parse(result));
    });
  }

  Widget _pay(String label, String glyph, String key) => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Semantics(
        button: true,
        selected: selectedPayment == key,
        label: '$label، ${h[key]!.text}',
        child: Container(
          key: ValueKey('payment-$key'),
          decoration: BoxDecoration(
            color: selectedPayment == key ? AppColors.mint : Colors.white,
            border: Border.all(
              color: selectedPayment == key ? AppColors.green : AppColors.line,
              width: selectedPayment == key ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: fluent.Button(
            onPressed: () => _editPayment(label, key),
            style: fluent.ButtonStyle(
              padding: const WidgetStatePropertyAll(EdgeInsets.zero),
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) => selectedPayment == key
                    ? AppColors.mint
                    : states.contains(WidgetState.hovered)
                    ? const Color(0xFFEAF2FB)
                    : Colors.white,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Column(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    glyph,
                    style: const TextStyle(
                      fontSize: 22,
                      color: AppColors.green,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      money(_n(key)),
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _totalsStrip() {
    Widget box(String v, Color bg, int flex) => Expanded(
      flex: flex,
      child: Container(
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        color: bg,
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          v,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
    return Container(
      color: AppColors.paper,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          box('عدد الأصناف ${lines.length}', const Color(0xFF1C4FB8), 2),
          box(
            h['account']!.text.isEmpty ? '-' : h['account']!.text,
            AppColors.green,
            4,
          ),
          box('ضريبة ${money(tax)}', AppColors.green, 2),
          box(money(net), AppColors.green, 2),
        ],
      ),
    );
  }
}
