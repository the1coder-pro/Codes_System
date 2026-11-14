import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'auth_service.dart';
import 'item_image.dart';
import 'invoice_print_settings.dart';
import 'models.dart';
import 'printer_bridge.dart';
import 'print_documents.dart';
import 'resizable_split.dart';
import 'storage.dart';
import 'theme.dart';
import 'widgets.dart';

/// Invoice form: right main form with tabs, left payments/items sidebar,
/// bottom green totals strip. Drafts persist per invoice type.
class InvoiceScreen extends StatefulWidget {
  final int typeIndex;
  final VoidCallback onExit;
  final UserSession session;
  final AccountingAuthService authService;
  const InvoiceScreen({
    super.key,
    required this.typeIndex,
    required this.onExit,
    required this.session,
    required this.authService,
  });

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  static const _paymentKeys = ['cash', 'network', 'credit', 'returnBal'];

  int tab = 0;
  final lines = <InvoiceLine>[];
  final lineCtl = <String, List<TextEditingController>>{};
  final selectedLineIds = <String>{};
  final _printerBridge = PrinterBridgeClient();
  int? selected;
  List<Item> catalog = [];
  String? selectedPayment = 'cash';
  bool paymentAuto = true;

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
  bool get _canEdit => widget.session.can('invoice.save');
  bool get _canDiscount => widget.session.can('invoice.discount');
  bool _can(String permission) => widget.session.can(permission);

  @override
  void initState() {
    super.initState();
    h['number']!.text = '000001';
    h['taxRate']!.text = '0.15';
    h['discount']!.text = '0';
    for (final k in _paymentKeys) {
      h[k]!.text = '0';
    }
    _initializeInvoice();
  }

  Future<void> _initializeInvoice() async {
    final draftCleared = await Store.clearDraft(widget.typeIndex);
    final loadedCatalog = await Store.loadItems();
    final number = await Store.nextInvoiceNumber();
    if (!mounted) return;
    setState(() {
      catalog = loadedCatalog;
      h['number']!.text = number;
    });
    if (!draftCleared) {
      toast(
        context,
        'تعذر مسح بيانات الفاتورة السابقة',
        severity: fluent.InfoBarSeverity.warning,
      );
    }
  }

  @override
  void dispose() {
    _printerBridge.dispose();
    for (final controller in h.values) {
      controller.dispose();
    }
    for (final controllers in lineCtl.values) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
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

  void _syncAutomaticPayment() {
    if (!paymentAuto) return;
    final destination = selectedPayment ?? 'cash';
    final amount = money(net < 0 ? 0 : net);
    for (final key in _paymentKeys) {
      final expected = key == destination ? amount : '0';
      if (h[key]!.text != expected) h[key]!.text = expected;
    }
  }

  void _addLine({
    String code = '',
    String name = '',
    String unitNo = '',
    String unit = '',
    double price = 0,
  }) {
    if (!_canEdit) return;
    selectedLineIds.clear();
    final existingIndex = code.isEmpty
        ? -1
        : lines.indexWhere(
            (line) =>
                line.code == code &&
                ((line.unitNo.isNotEmpty || unitNo.isNotEmpty)
                    ? line.unitNo == unitNo
                    : line.unit == unit && line.price == price),
          );
    if (existingIndex >= 0) {
      final existing = lines[existingIndex];
      existing.qty += 1;
      _syncQty(existing);
      selected = existingIndex;
      return;
    }

    final l = InvoiceLine(
      id: '${DateTime.now().microsecondsSinceEpoch}',
      code: code,
      name: name,
      unitNo: unitNo,
      unit: unit,
      price: price,
    );
    lines.add(l);
    lineCtl[l.id] = [
      TextEditingController(text: name),
      TextEditingController(text: '1'),
      TextEditingController(text: money(price)),
    ];
    selected = lines.length - 1;
  }

  void _syncQty(InvoiceLine l) {
    lineCtl[l.id]![1].text = l.qty % 1 == 0
        ? l.qty.toInt().toString()
        : '${l.qty}';
  }

  void _changeQty(double d) {
    if (!_canEdit || selected == null) return;
    setState(() {
      final l = lines[selected!];
      l.qty = (l.qty + d).clamp(1, 99999).toDouble();
      _syncQty(l);
    });
  }

  void _move(int d) {
    if (!_canEdit || lines.isEmpty) return;
    setState(() {
      selected = ((selected ?? 0) + d).clamp(0, lines.length - 1);
    });
  }

  void _toggleLineSelection(String id) {
    if (!selectedLineIds.add(id)) selectedLineIds.remove(id);
  }

  Future<void> _deleteLine() async {
    if (!await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'invoice.save',
    )) {
      return;
    }
    if (!mounted) return;
    final targets = lines
        .where((line) => selectedLineIds.contains(line.id))
        .map((line) => line.id)
        .toSet();
    if (targets.isEmpty) {
      toast(
        context,
        'حدد صنفاً أو أكثر أولاً',
        severity: fluent.InfoBarSeverity.warning,
      );
      return;
    }

    final count = targets.length;
    final firstTarget = lines.firstWhere((line) => targets.contains(line.id));
    final message = count == 1
        ? 'حذف "${firstTarget.name.isEmpty ? 'الصنف المحدد' : firstTarget.name}" من الفاتورة؟'
        : 'حذف $count أصناف محددة من الفاتورة؟';
    final ok = await confirmDialog(
      context,
      count == 1 ? 'حذف صنف' : 'حذف أصناف',
      message,
    );
    if (!ok || !mounted) return;
    setState(() {
      final activeIndex = selected ?? 0;
      for (final line in lines.where((line) => targets.contains(line.id))) {
        for (final controller in lineCtl.remove(line.id) ?? const []) {
          controller.dispose();
        }
      }
      lines.removeWhere((line) => targets.contains(line.id));
      selectedLineIds.removeAll(targets);
      selected = lines.isEmpty
          ? null
          : activeIndex >= lines.length
          ? lines.length - 1
          : activeIndex;
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
    'paymentAuto': paymentAuto,
    'lines': lines.map((l) => l.toJson()).toList(),
  };

  Future<bool> _saveInvoiceAndReset() async {
    if (!await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'invoice.save',
    )) {
      return false;
    }
    if (!mounted) return false;
    if (discount > 0 &&
        !await requirePermission(
          context: context,
          session: widget.session,
          authService: widget.authService,
          permission: 'invoice.discount',
        )) {
      return false;
    }
    if (!mounted) return false;
    if (lines.isEmpty) {
      toast(
        context,
        'أضف صنفاً قبل حفظ الفاتورة',
        severity: fluent.InfoBarSeverity.warning,
      );
      return false;
    }
    final ok = await Store.saveInvoice(widget.typeIndex, _toJson());
    if (!mounted) return false;
    if (!ok) {
      toast(
        context,
        'تعذر حفظ الفاتورة محلياً',
        severity: fluent.InfoBarSeverity.error,
      );
      return false;
    }
    final draftCleared = await Store.clearDraft(widget.typeIndex);
    final nextNumber = await Store.nextInvoiceNumber();
    if (!mounted) return false;
    setState(() {
      _resetInvoiceForm();
      h['number']!.text = nextNumber;
    });
    if (!draftCleared) {
      toast(
        context,
        'حُفظت الفاتورة، لكن تعذر مسح المسودة السابقة',
        severity: fluent.InfoBarSeverity.warning,
      );
    }
    return true;
  }

  void _resetInvoiceForm() {
    for (final controllers in lineCtl.values) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
    lineCtl.clear();
    lines.clear();
    selectedLineIds.clear();
    selected = null;
    selectedPayment = 'cash';
    paymentAuto = true;
    invDate = DateTime.now();
    delivDate = invDate;
    for (final controller in h.values) {
      controller.clear();
    }
    h['taxRate']!.text = '0.15';
    h['discount']!.text = '0';
    for (final key in _paymentKeys) {
      h[key]!.text = '0';
    }
    creditor = 'مورد بدون حساب';
    debtor = 'مشتريات بضاعة بعرض البيع';
    storeCredit = 'مشتريات بضاعة بعرض البيع';
    storeDebit = '-';
    taxable = 'خاضع للضريبة';
  }

  Future<void> _save() async {
    if (await _saveInvoiceAndReset() && mounted) {
      toast(
        context,
        'تم حفظ الفاتورة ${type.ar}',
        severity: fluent.InfoBarSeverity.success,
      );
    }
  }

  Future<void> _saveAndPrint() async {
    final canSave = await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'invoice.save',
    );
    if (!mounted || !canSave) return;
    final canPrint = await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'invoice.print',
    );
    if (!mounted || !canPrint) return;
    if (lines.isEmpty) {
      toast(
        context,
        'أضف صنفاً قبل حفظ الفاتورة',
        severity: fluent.InfoBarSeverity.warning,
      );
      return;
    }
    final preferences = await _invoicePrinterPreferences();
    if (!mounted || preferences == null) return;
    final printSettings = await Store.loadInvoicePrintSettings(
      widget.typeIndex,
    );
    final document = await _invoicePdf(printSettings);
    if (!mounted) return;
    if (!await _saveInvoiceAndReset()) return;
    try {
      await _printerBridge.printPdf(
        preferences: preferences,
        printerName: preferences.invoicePrinter ?? '',
        jobType: 'invoice',
        pdfBytes: document,
        paperWidthMm: printSettings.paperWidthMm,
        paperHeightMm: printSettings.paperHeightMmFor(
          lines.length,
          notesLength: h['notes']!.text.trim().length,
        ),
      );
      if (mounted) {
        toast(
          context,
          'تم حفظ الفاتورة وإرسالها للطابعة المحددة',
          severity: fluent.InfoBarSeverity.success,
        );
      }
    } catch (error) {
      if (mounted) {
        toast(
          context,
          'حُفظت الفاتورة لكن تعذرت الطباعة: $error',
          severity: fluent.InfoBarSeverity.error,
        );
      }
    }
  }

  Future<void> _printCurrent() async {
    if (!await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'invoice.print',
    )) {
      return;
    }
    if (!mounted) return;
    if (lines.isEmpty) {
      toast(
        context,
        'لا توجد أصناف لطباعة الفاتورة',
        severity: fluent.InfoBarSeverity.warning,
      );
      return;
    }
    final preferences = await _invoicePrinterPreferences();
    if (!mounted || preferences == null) return;
    final printSettings = await Store.loadInvoicePrintSettings(
      widget.typeIndex,
    );
    final document = await _invoicePdf(printSettings);
    try {
      await _printerBridge.printPdf(
        preferences: preferences,
        printerName: preferences.invoicePrinter ?? '',
        jobType: 'invoice',
        pdfBytes: document,
        paperWidthMm: printSettings.paperWidthMm,
        paperHeightMm: printSettings.paperHeightMmFor(
          lines.length,
          notesLength: h['notes']!.text.trim().length,
        ),
      );
    } catch (error) {
      if (mounted) {
        toast(
          context,
          'تعذرت الطباعة: $error',
          severity: fluent.InfoBarSeverity.error,
        );
      }
    }
  }

  Future<PrinterPreferences?> _invoicePrinterPreferences() async {
    final saved = await Store.loadPrinterPreferences();
    if (!mounted) return null;
    final preferences = PrinterPreferences.fromJson(saved);
    final printerName = preferences.invoicePrinter;
    if (preferences.token.isEmpty ||
        printerName == null ||
        printerName.isEmpty) {
      toast(
        context,
        'عيّن طابعة الفواتير من الإدارة ثم أعد المحاولة',
        severity: fluent.InfoBarSeverity.warning,
      );
      return null;
    }
    try {
      final printers = await _printerBridge.loadPrinters(preferences);
      if (!printers.any((printer) => printer.name == printerName)) {
        throw const PrinterBridgeException(
          'الطابعة المحددة للفواتير غير مثبتة على هذا الجهاز',
        );
      }
      return preferences;
    } catch (error) {
      if (mounted) {
        toast(
          context,
          error.toString(),
          severity: fluent.InfoBarSeverity.error,
        );
      }
      return null;
    }
  }

  Future<Uint8List> _invoicePdf([
    InvoicePrintSettings? requestedSettings,
  ]) async {
    final settings =
        requestedSettings ??
        await Store.loadInvoicePrintSettings(widget.typeIndex);
    return buildInvoicePdf(
      titleAr: type.ar,
      titleEn: type.en,
      invoiceNumber: h['number']!.text.trim(),
      invoiceDateTime: '${_fmt(invDate)} ${_time(invDate)}',
      deliveryDate: _fmt(delivDate),
      account: h['account']!.text.trim(),
      taxNumber: h['taxNo']!.text.trim(),
      taxStatus: taxable,
      taxStatusEn: taxable == 'خاضع للضريبة' ? 'Taxable' : 'Not taxable',
      lines: lines.map((line) {
        final matchingItems = catalog.where(
          (item) => item.id == line.code || item.nameAr == line.name,
        );
        return InvoicePrintLine(
          name: line.name,
          nameEn: matchingItems.isEmpty ? '' : matchingItems.first.nameEn,
          unit: line.unit,
          quantity: line.qty == line.qty.roundToDouble()
              ? line.qty.toStringAsFixed(0)
              : line.qty.toString(),
          unitPrice: money(line.price),
          total: money(line.total),
        );
      }).toList(),
      totals: [
        InvoicePrintTotal(
          'الإجمالي قبل الخصم',
          money(subtotal),
          labelEn: 'Gross before discount',
        ),
        InvoicePrintTotal('الخصم', money(discount), labelEn: 'Discount'),
        InvoicePrintTotal('الضريبة', money(tax), labelEn: 'Tax'),
        InvoicePrintTotal(
          'الصافي',
          money(net),
          labelEn: 'Net',
          emphasized: true,
        ),
        InvoicePrintTotal('نقداً', money(_n('cash')), labelEn: 'Cash'),
        InvoicePrintTotal('شبكة', money(_n('network')), labelEn: 'Card'),
        InvoicePrintTotal('آجل', money(_n('credit')), labelEn: 'Credit'),
        InvoicePrintTotal(
          'رصيد رجيع',
          money(_n('returnBal')),
          labelEn: 'Return balance',
        ),
        InvoicePrintTotal('المتبقي', money(remaining), labelEn: 'Remaining'),
      ],
      notes: h['notes']!.text.trim(),
      settings: settings,
    );
  }

  String _fmt(DateTime d) => '${d.month}/${d.day}/${d.year}';
  String _time(DateTime d) {
    final hr = d.hour % 12 == 0 ? 12 : d.hour % 12;
    return '$hr:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')} ${d.hour < 12 ? 'AM' : 'PM'}';
  }

  Future<void> _pickDate(bool invoice) async {
    if (!_canEdit) return;
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
    _syncAutomaticPayment();
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
                  child: ResizableSplit(
                    dividerKey: const ValueKey('splitter-invoice'),
                    first: main,
                    second: SingleChildScrollView(child: side),
                    initialFirstFraction: .76,
                    minFirstWidth: 480,
                    minSecondWidth: 260,
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
      key: const ValueKey('invoice-tabs-strip'),
      width: double.infinity,
      color: const Color(0xFFEFF1F3),
      padding: const EdgeInsets.only(top: 6, left: 6),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < names.length; i++)
                GestureDetector(
                  key: ValueKey('invoice-tab-$i'),
                  onTap: () => setState(() => tab = i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
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
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: tab == i
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainArea(bool wide) {
    Widget body;
    if (tab == 0) {
      body = _headerTab();
    } else if (tab == 1) {
      body = _itemsTab(quickOnly: true);
    } else {
      body = _itemsTab(quickOnly: false);
    }
    return Column(
      mainAxisSize: wide ? MainAxisSize.max : MainAxisSize.min,
      children: [
        _tabs(),
        if (wide || tab != 0) Expanded(child: body) else body,
      ],
    );
  }

  Widget _headerTab() {
    final canEdit = _canEdit;
    final right = Column(
      children: [
        FieldRow(
          label: 'تاريخ الفاتورة',
          labelWidth: 92,
          compact: true,
          child: _dateBox(
            _fmt(invDate),
            () => _pickDate(true),
            enabled: canEdit,
          ),
        ),
        FieldRow(
          label: 'وقت الفاتورة',
          labelWidth: 92,
          compact: true,
          child: _readonly(_time(invDate)),
        ),
        FieldRow(
          label: 'رقم الفاتورة',
          labelWidth: 92,
          compact: true,
          child: _readonly(h['number']!.text),
        ),
        FieldRow(
          label: 'الدائن',
          labelWidth: 92,
          compact: true,
          child: DropBox(
            value: creditor,
            options: const [
              'مورد بدون حساب',
              'مؤسسة الرواد للتموين',
              'شركة النخبة',
            ],
            compact: true,
            onChanged: canEdit ? (v) => setState(() => creditor = v) : null,
          ),
        ),
        FieldRow(
          label: 'المدين',
          labelWidth: 92,
          compact: true,
          child: DropBox(
            value: debtor,
            options: const [
              'مشتريات بضاعة بعرض البيع',
              'مصروفات عمومية',
              'الصندوق',
            ],
            compact: true,
            onChanged: canEdit ? (v) => setState(() => debtor = v) : null,
          ),
        ),
        FieldRow(
          label: 'اسم الحساب',
          labelWidth: 92,
          compact: true,
          child: TextBox(
            key: const ValueKey('invoice-account-field'),
            controller: h['account']!,
            compact: true,
            enabled: canEdit,
          ),
        ),
        FieldRow(
          label: 'الرقم الضريبي',
          labelWidth: 92,
          compact: true,
          child: TextBox(
            controller: h['taxNo']!,
            compact: true,
            enabled: canEdit,
          ),
        ),
        FieldRow(
          label: 'المخزون دائن',
          labelWidth: 92,
          compact: true,
          child: DropBox(
            value: storeCredit,
            options: const [
              'مشتريات بضاعة بعرض البيع',
              'المستودع الرئيسي',
              '-',
            ],
            compact: true,
            onChanged: canEdit ? (v) => setState(() => storeCredit = v) : null,
          ),
        ),
        FieldRow(
          label: 'المخزون مدين',
          labelWidth: 92,
          compact: true,
          child: DropBox(
            value: storeDebit,
            options: const ['-', 'المستودع الرئيسي', 'مستودع الفرع'],
            compact: true,
            onChanged: canEdit ? (v) => setState(() => storeDebit = v) : null,
          ),
        ),
      ],
    );
    final left = Column(
      children: [
        FieldRow(
          label: 'خاضع للضريبة',
          labelWidth: 82,
          compact: true,
          child: DropBox(
            value: taxable,
            options: const ['خاضع للضريبة', 'غير خاضع'],
            compact: true,
            onChanged: canEdit ? (v) => setState(() => taxable = v) : null,
          ),
        ),
        FieldRow(
          label: 'نسبة الضريبة',
          labelWidth: 82,
          compact: true,
          child: TextBox(
            controller: h['taxRate']!,
            compact: true,
            enabled: canEdit,
            onChanged: canEdit ? (_) => setState(() {}) : null,
          ),
        ),
        FieldRow(
          label: 'تاريخ التسليم',
          labelWidth: 82,
          compact: true,
          child: _dateBox(
            _fmt(delivDate),
            () => _pickDate(false),
            enabled: canEdit,
          ),
        ),
        FieldRow(
          label: 'وقت التسليم',
          labelWidth: 82,
          compact: true,
          child: _readonly(_time(delivDate)),
        ),
        FieldRow(
          label: 'ملاحظات',
          labelWidth: 82,
          compact: true,
          child: TextBox(
            controller: h['notes']!,
            maxLines: 4,
            compact: true,
            enabled: canEdit,
          ),
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final panelWidth = constraints.maxWidth.clamp(0.0, 540.0).toDouble();
          final twoColumns = panelWidth >= 440;
          return Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              key: const ValueKey('invoice-details-panel'),
              width: panelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    type.ar,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (twoColumns)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: right),
                        const SizedBox(width: 10),
                        Expanded(child: left),
                      ],
                    )
                  else ...[
                    right,
                    const SizedBox(height: 6),
                    left,
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _dateBox(String text, VoidCallback onTap, {bool enabled = true}) =>
      fluent.Button(
        onPressed: enabled ? onTap : null,
        style: fluent.ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        child: SizedBox(
          height: 30,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(text, style: const TextStyle(fontSize: 12)),
                ),
                const Icon(
                  fluent.FluentIcons.chevron_down,
                  size: 12,
                  color: AppColors.muted,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _readonly(String text) => Container(
    height: 30,
    alignment: AlignmentDirectional.centerStart,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFEDEFF1),
      border: Border.all(color: const Color(0xFFD3D8DD)),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 12, color: AppColors.muted),
    ),
  );

  Widget _itemsTab({required bool quickOnly}) {
    final q = h['pick']!.text.trim();
    final query = q.toLowerCase();
    final list = <({Item item, UnitRow unit})>[];
    for (final item in catalog) {
      final units = item.units.isEmpty ? [UnitRow()] : item.units;
      final itemFields =
          '${item.id} ${item.group} ${item.nameAr} ${item.nameEn} ${item.shortName}';
      for (final unit in units) {
        if (quickOnly) {
          if (unit.quick) list.add((item: item, unit: unit));
          continue;
        }
        if (query.isEmpty) continue;
        final searchable =
            '$itemFields ${unit.unitNo} ${unit.size} ${unit.barcode} ${unit.color}';
        if (searchable.toLowerCase().contains(query)) {
          list.add((item: item, unit: unit));
        }
      }
    }
    return Column(
      children: [
        if (!quickOnly)
          Padding(
            padding: const EdgeInsets.all(6),
            child: FieldRow(
              label: 'بحث عن صنف',
              labelWidth: 78,
              compact: true,
              child: TextBox(
                key: const ValueKey('invoice-item-search'),
                controller: h['pick']!,
                compact: true,
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Text(
                    quickOnly
                        ? 'لا توجد أصناف سريعة'
                        : query.isEmpty
                        ? 'ابحث عن صنف بالاسم أو الرمز'
                        : 'لا توجد أصناف مطابقة للبحث',
                    style: const TextStyle(color: AppColors.muted),
                  ),
                )
              : GridView.builder(
                  key: const ValueKey('invoice-item-grid'),
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 190,
                    mainAxisExtent: 220,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final it = list[i].item;
                    final unit = list[i].unit;
                    final variantKey = it.units.length <= 1
                        ? it.id
                        : '${it.id}-${unit.unitNo}';
                    final unitPrice = double.tryParse(unit.priceBefore) ?? 0;
                    void addItem() {
                      if (!_canEdit) return;
                      setState(
                        () => _addLine(
                          code: it.id,
                          name: it.nameAr,
                          unitNo: unit.unitNo,
                          unit: unit.size,
                          price: unitPrice,
                        ),
                      );
                    }

                    return Card(
                      key: ValueKey('invoice-item-card-$variantKey'),
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _canEdit ? addItem : null,
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: ItemImage(
                                  base64Data: it.imageBase64,
                                  fit: BoxFit.contain,
                                  iconSize: 28,
                                  emptyLabel: '',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    it.nameAr,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${it.id} • ${unit.size}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.muted,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        money(unitPrice),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 30,
                                    child: fluent.Button(
                                      key: ValueKey(
                                        'invoice-item-add-$variantKey',
                                      ),
                                      onPressed: _canEdit ? addItem : null,
                                      child: const Text('إضافة'),
                                    ),
                                  ),
                                ],
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
              if (_canEdit)
                ActionTile(
                  assetPath: AppIcons.delete,
                  label: 'حذف صنف',
                  glyphColor: AppColors.red,
                  width: 54,
                  height: 58,
                  onTap: _deleteLine,
                ),
              if (_canEdit)
                ActionTile(
                  assetPath: AppIcons.save,
                  label: 'حفظ F8',
                  width: 54,
                  height: 58,
                  onTap: _save,
                ),
              if (_canEdit && _can('invoice.print'))
                ActionTile(
                  key: const ValueKey('invoice-save-and-print'),
                  assetPath: AppIcons.saveAndPrintPrinter,
                  label: 'حفظ\nوطباعة',
                  width: 54,
                  height: 58,
                  onTap: _saveAndPrint,
                ),
              if (!_canEdit && _can('invoice.print'))
                ActionTile(
                  key: const ValueKey('invoice-print'),
                  assetPath: AppIcons.printer,
                  label: 'طباعة',
                  width: 54,
                  height: 58,
                  onTap: _printCurrent,
                ),
              ActionTile(
                assetPath: AppIcons.search,
                label: 'بحث F2',
                width: 54,
                height: 58,
                onTap: () => setState(() => tab = 2),
              ),
              ActionTile(
                assetPath: AppIcons.exit,
                label: 'خروج F1',
                hideLabel: true,
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
                        onTap: () => setState(() {
                          selected = i;
                          _toggleLineSelection(l.id);
                        }),
                        child: Container(
                          key: ValueKey('invoice-side-row-$i'),
                          color: selectedLineIds.contains(l.id)
                              ? const Color(0xFFDDEBFA)
                              : i == selected
                              ? const Color(0xFFEAF3F9)
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l.name.isEmpty
                                      ? l.unit.isEmpty
                                            ? '—'
                                            : l.unit
                                      : l.unit.isEmpty
                                      ? l.name
                                      : '${l.name} • ${l.unit}',
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
              _greenBtn(fluent.FluentIcons.up, 'تحريك لأعلى', () => _move(-1)),
              _greenBtn(
                fluent.FluentIcons.add,
                'زيادة الكمية',
                () => _changeQty(1),
              ),
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
                        : lineCtl[lines[selected!].id]![1].text,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              _greenBtn(
                fluent.FluentIcons.remove,
                'تقليل الكمية',
                () => _changeQty(-1),
              ),
              _greenBtn(fluent.FluentIcons.down, 'تحريك لأسفل', () => _move(1)),
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
                        key: const ValueKey('invoice-discount-field'),
                        controller: h['discount']!,
                        align: TextAlign.center,
                        enabled: _canDiscount,
                        onChanged: _canDiscount ? (_) => setState(() {}) : null,
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
              _pay('نقداً', AppIcons.cash, 'cash'),
              _pay('شبكة', AppIcons.network, 'network'),
              _pay('آجل', AppIcons.receipt, 'credit'),
              _pay('رصيد رجيع', AppIcons.profit, 'returnBal'),
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
        ],
      ),
    );
  }

  Widget _greenBtn(IconData icon, String label, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 1.5),
    child: fluent.Button(
      onPressed: _canEdit ? onTap : null,
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
          child: Tooltip(
            message: label,
            child: Icon(icon, color: Colors.white, size: 19),
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

  void _selectPayment(String key) {
    if (!_canEdit) return;
    setState(() {
      final active = [
        'cash',
        'network',
        'credit',
        'returnBal',
      ].where((paymentKey) => _n(paymentKey).abs() >= .005).toList();
      if (active.length == 1 && active.single != key) {
        final previous = active.single;
        h[key]!.text = h[previous]!.text;
        h[previous]!.text = '0';
      } else if (active.length > 1) {
        paymentAuto = false;
      }
      selectedPayment = key;
    });
  }

  Widget _pay(String label, String iconAsset, String key) => Expanded(
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
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                fluent.Button(
                  key: ValueKey('payment-option-$key'),
                  onPressed: _canEdit ? () => _selectPayment(key) : null,
                  style: fluent.ButtonStyle(
                    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                    backgroundColor: WidgetStatePropertyAll(
                      selectedPayment == key ? AppColors.mint : Colors.white,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 5,
                      ),
                      child: Column(
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          AppImageIcon(iconAsset, size: 26),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 34,
                  child: fluent.TextBox(
                    key: ValueKey('payment-field-$key'),
                    controller: h[key],
                    enabled: _canEdit,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    placeholder: '0.00',
                    onChanged: _canEdit
                        ? (_) {
                            paymentAuto = false;
                            setState(() => selectedPayment = key);
                          }
                        : null,
                  ),
                ),
              ],
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
