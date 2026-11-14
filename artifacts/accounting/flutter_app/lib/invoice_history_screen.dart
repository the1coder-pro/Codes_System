import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'invoice_pdf_download.dart';
import 'models.dart';
import 'printer_bridge.dart';
import 'print_documents.dart';
import 'storage.dart';
import 'theme.dart';

/// Read-only browser for invoices that have already been saved locally.
class InvoiceHistoryScreen extends StatefulWidget {
  final VoidCallback onExit;
  final UserSession session;
  final AccountingAuthService authService;

  const InvoiceHistoryScreen({
    super.key,
    required this.onExit,
    required this.session,
    required this.authService,
  });

  @override
  State<InvoiceHistoryScreen> createState() => _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends State<InvoiceHistoryScreen> {
  final _searchController = TextEditingController();
  final _printerBridge = PrinterBridgeClient();
  List<_SavedInvoice> _invoices = [];
  bool _loading = true;
  int _selectedType = -1;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _printerBridge.dispose();
    super.dispose();
  }

  Future<void> _loadInvoices() async {
    final saved = await Store.loadInvoices();
    if (!mounted) return;
    final invoices = saved.map(_SavedInvoice.fromJson).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      _invoices = invoices;
      _loading = false;
    });
  }

  List<_SavedInvoice> get _visibleInvoices {
    final query = _searchController.text.trim().toLowerCase();
    return _invoices.where((invoice) {
      if (_selectedType >= 0 && invoice.typeIndex != _selectedType) {
        return false;
      }
      final range = _dateRange;
      if (range != null) {
        final date = DateTime(
          invoice.date.year,
          invoice.date.month,
          invoice.date.day,
        );
        final first = DateTime(
          range.start.year,
          range.start.month,
          range.start.day,
        );
        final last = DateTime(
          range.end.year,
          range.end.month,
          range.end.day,
          23,
          59,
          59,
        );
        if (date.isBefore(first) || date.isAfter(last)) return false;
      }
      if (query.isEmpty) return true;
      return [
        invoice.number,
        _formatDate(invoice.date),
        '${invoice.date.year}-${_twoDigits(invoice.date.month)}-${_twoDigits(invoice.date.day)}',
        invoice.type.ar,
        invoice.type.en,
        invoice.account,
        invoice.notes,
      ].any((value) => value.toLowerCase().contains(query));
    }).toList();
  }

  Future<void> _chooseDateRange() async {
    final now = DateTime.now();
    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 10, 12, 31),
      initialDateRange: _dateRange,
      helpText: 'اختر فترة الفواتير',
      cancelText: 'إلغاء',
      confirmText: 'تطبيق',
      saveText: 'تطبيق',
    );
    if (!mounted || selected == null) return;
    setState(() => _dateRange = selected);
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleInvoices;
    return ColoredBox(
      color: AppColors.canvasBlue,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(),
            const SizedBox(height: 8),
            _filters(),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                key: const ValueKey('invoice-history-list'),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : visible.isEmpty
                    ? _emptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: visible.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 6),
                        itemBuilder: (context, index) =>
                            _invoiceTile(visible[index]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() => Container(
    padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 4, 8),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      children: [
        const Expanded(
          child: Text(
            'سجل الفواتير المحفوظة',
            key: ValueKey('invoice-history-title'),
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        fluent.Button(
          key: const ValueKey('invoice-history-exit'),
          onPressed: widget.onExit,
          child: const Text('إغلاق'),
        ),
      ],
    ),
  );

  Widget _filters() => Wrap(
    spacing: 8,
    runSpacing: 8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      SizedBox(
        width: MediaQuery.sizeOf(context).width < 600 ? double.infinity : 310,
        child: TextField(
          key: const ValueKey('invoice-history-search'),
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'ابحث برقم الفاتورة أو التاريخ أو النوع',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'مسح البحث',
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.clear),
                  ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      SizedBox(
        width: MediaQuery.sizeOf(context).width < 600 ? double.infinity : 260,
        child: DropdownButtonFormField<int>(
          key: const ValueKey('invoice-history-type-filter'),
          value: _selectedType,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'نوع الفاتورة',
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem(value: -1, child: Text('كل الأنواع')),
            for (var index = 0; index < invoiceTypes.length; index++)
              DropdownMenuItem(
                value: index,
                child: Text(
                  invoiceTypes[index].ar,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (value) => setState(() => _selectedType = value ?? -1),
        ),
      ),
      OutlinedButton.icon(
        key: const ValueKey('invoice-history-date-filter'),
        onPressed: _chooseDateRange,
        icon: const Icon(Icons.date_range),
        label: Text(
          _dateRange == null
              ? 'كل التواريخ'
              : '${_formatDate(_dateRange!.start)} – ${_formatDate(_dateRange!.end)}',
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(130, 48),
        ),
      ),
      if (_dateRange != null)
        IconButton(
          key: const ValueKey('invoice-history-clear-date'),
          tooltip: 'مسح الفترة',
          onPressed: () => setState(() => _dateRange = null),
          icon: const Icon(Icons.close),
        ),
    ],
  );

  Widget _emptyState() {
    final hasFilters =
        _searchController.text.trim().isNotEmpty ||
        _selectedType >= 0 ||
        _dateRange != null;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          hasFilters
              ? 'لا توجد فواتير تطابق البحث والفلاتر المحددة'
              : 'لا توجد فواتير محفوظة حتى الآن',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted, fontSize: 16),
        ),
      ),
    );
  }

  Widget _invoiceTile(_SavedInvoice invoice) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(4),
    child: InkWell(
      key: ValueKey('invoice-history-record-${invoice.number}'),
      borderRadius: BorderRadius.circular(4),
      onTap: () => _showDetails(invoice),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grid),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.receipt_long, color: AppColors.navy),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'فاتورة رقم ${invoice.number}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${invoice.type.ar}  •  ${_formatDate(invoice.date)}',
                    style: const TextStyle(color: AppColors.muted),
                  ),
                  if (invoice.account.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      invoice.account,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_left, color: AppColors.muted),
          ],
        ),
      ),
    ),
  );

  Future<void> _showDetails(_SavedInvoice invoice) async {
    await showDialog<void>(
      context: context,
      builder: (context) => _InvoiceDetailsDialog(
        invoice: invoice,
        onPrint: () => _printInvoice(invoice),
      ),
    );
  }

  Future<void> _printInvoice(_SavedInvoice invoice) async {
    if (!await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'invoice.print',
    )) {
      return;
    }
    if (!mounted) return;

    try {
      final preferences = PrinterPreferences.fromJson(
        await Store.loadPrinterPreferences(),
      );
      final printerName = preferences.invoicePrinter;
      if (preferences.token.trim().isEmpty ||
          printerName == null ||
          printerName.trim().isEmpty) {
        throw const PrinterBridgeException(
          'عيّن طابعة الفواتير من الإدارة ثم أعد المحاولة',
        );
      }
      final printers = await _printerBridge.loadPrinters(preferences);
      if (!printers.any((printer) => printer.name == printerName)) {
        throw const PrinterBridgeException(
          'الطابعة المحددة للفواتير غير مثبتة على هذا الجهاز',
        );
      }
      final settings = await Store.loadInvoicePrintSettings(invoice.typeIndex);
      final document = await buildSavedInvoicePdf(
        typeIndex: invoice.typeIndex,
        invoice: invoice.data,
        fallbackDate: invoice.date,
        settings: settings,
      );
      if (!mounted) return;
      await _printerBridge.printPdf(
        preferences: preferences,
        printerName: printerName,
        jobType: 'invoice',
        pdfBytes: document,
        paperWidthMm: settings.paperWidthMm,
        paperHeightMm: settings.paperHeightMmFor(
          invoice.lines.length,
          notesLength: invoice.notes.length,
        ),
      );
      if (mounted) _showPrintMessage('تم إرسال الفاتورة المحفوظة للطباعة');
    } catch (error) {
      if (mounted) _showPrintMessage('تعذرت الطباعة: $error');
    }
  }

  void _showPrintMessage(String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 4)),
    );
  }
}

class _SavedInvoice {
  final int typeIndex;
  final String number;
  final DateTime date;
  final DateTime savedAt;
  final Map<String, dynamic> data;

  const _SavedInvoice({
    required this.typeIndex,
    required this.number,
    required this.date,
    required this.savedAt,
    required this.data,
  });

  factory _SavedInvoice.fromJson(Map<String, dynamic> json) {
    final rawData = json['invoice'];
    final data = rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : <String, dynamic>{};
    final savedAt =
        DateTime.tryParse('${json['savedAt'] ?? ''}') ?? DateTime(1970);
    final date = DateTime.tryParse('${data['invDate'] ?? ''}') ?? savedAt;
    final rawType = json['typeIndex'];
    final parsedType = rawType is num
        ? rawType.toInt()
        : int.tryParse('$rawType') ?? 0;
    final typeIndex = parsedType.clamp(0, invoiceTypes.length - 1);
    return _SavedInvoice(
      typeIndex: typeIndex,
      number: '${data['number'] ?? '—'}',
      date: date,
      savedAt: savedAt,
      data: data,
    );
  }

  InvoiceType get type => invoiceTypes[typeIndex];
  String get account => '${data['account'] ?? ''}'.trim();
  String get notes => '${data['notes'] ?? ''}'.trim();
  List<Map<String, dynamic>> get lines {
    final raw = data['lines'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((line) => Map<String, dynamic>.from(line))
        .toList();
  }

  double get subtotal => lines.fold<double>(
    0,
    (sum, line) =>
        sum + _number(line['qty'], fallback: 1) * _number(line['price']),
  );

  double get discount => _number(data['discount']);
  double get taxRate => _number(data['taxRate']);
  double get tax => '${data['taxable'] ?? ''}' == 'خاضع للضريبة'
      ? ((subtotal - discount).clamp(0, double.infinity)) * taxRate
      : 0;
  double get total => subtotal - discount + tax;

  static double _number(dynamic value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? fallback;
  }
}

class _InvoiceDetailsDialog extends StatefulWidget {
  final _SavedInvoice invoice;
  final Future<void> Function() onPrint;

  const _InvoiceDetailsDialog({required this.invoice, required this.onPrint});

  @override
  State<_InvoiceDetailsDialog> createState() => _InvoiceDetailsDialogState();
}

class _InvoiceDetailsDialogState extends State<_InvoiceDetailsDialog> {
  bool _printing = false;

  String _amount(double value) => value.toStringAsFixed(2);

  Future<void> _print() async {
    if (_printing) return;
    setState(() => _printing = true);
    try {
      await widget.onPrint();
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoice = widget.invoice;
    final lines = invoice.lines;
    return AlertDialog(
      key: const ValueKey('invoice-history-details'),
      title: Text(invoice.type.ar),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'رقم الفاتورة: ${invoice.number}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text('تاريخ الفاتورة: ${_formatDate(invoice.date)}'),
              if (invoice.account.isNotEmpty)
                _detailRow('الحساب', invoice.account),
              if ('${invoice.data['taxNo'] ?? ''}'.trim().isNotEmpty)
                _detailRow('الرقم الضريبي', '${invoice.data['taxNo']}'),
              if ('${invoice.data['delivDate'] ?? ''}'.trim().isNotEmpty)
                _detailRow(
                  'تاريخ التسليم',
                  _formatDate(
                    DateTime.tryParse('${invoice.data['delivDate']}') ??
                        invoice.date,
                  ),
                ),
              if (invoice.notes.isNotEmpty)
                _detailRow('ملاحظات', invoice.notes),
              const Divider(height: 24),
              const Text(
                'الأصناف',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              if (lines.isEmpty)
                const Text('لا توجد أصناف')
              else
                for (final line in lines) ...[
                  _detailRow(
                    '${line['name'] ?? 'صنف'}'
                        '${'${line['unit'] ?? ''}'.isEmpty ? '' : ' · ${line['unit']}'}',
                    '${line['qty'] ?? 1} × ${_amount(_SavedInvoice._number(line['price']))}'
                        ' = ${_amount(_SavedInvoice._number(line['qty'], fallback: 1) * _SavedInvoice._number(line['price']))}',
                  ),
                  const Divider(height: 12),
                ],
              _detailRow(
                'الإجمالي قبل الخصم والضريبة',
                _amount(invoice.subtotal),
              ),
              _detailRow('الخصم', _amount(invoice.discount)),
              _detailRow('الضريبة', _amount(invoice.tax)),
              _detailRow('الصافي', _amount(invoice.total), emphasize: true),
            ],
          ),
        ),
      ),
      actions: [
        FilledButton.icon(
          key: const ValueKey('invoice-history-print'),
          onPressed: _printing ? null : _print,
          icon: _printing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.print),
          label: Text(_printing ? 'جارٍ الطباعة…' : 'طباعة الفاتورة'),
        ),
        TextButton(
          key: const ValueKey('invoice-history-details-close'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value, {bool emphasize = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.muted,
                  fontWeight: emphasize ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: AppColors.ink,
                  fontWeight: emphasize ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
}

Future<void> showInvoiceHistoryDialog({
  required BuildContext context,
  required UserSession session,
  required AccountingAuthService authService,
}) => showDialog<void>(
  context: context,
  builder: (context) =>
      _InvoiceHistorySearchDialog(session: session, authService: authService),
);

class _InvoiceHistorySearchDialog extends StatefulWidget {
  final UserSession session;
  final AccountingAuthService authService;

  const _InvoiceHistorySearchDialog({
    required this.session,
    required this.authService,
  });

  @override
  State<_InvoiceHistorySearchDialog> createState() =>
      _InvoiceHistorySearchDialogState();
}

class _InvoiceHistorySearchDialogState
    extends State<_InvoiceHistorySearchDialog> {
  final _idController = TextEditingController();
  final _printerBridge = PrinterBridgeClient();
  List<_SavedInvoice> _allInvoices = [];
  List<_SavedInvoice> _results = [];
  _SavedInvoice? _selectedInvoice;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  bool _loading = true;
  bool _searched = false;
  bool _working = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  @override
  void dispose() {
    _idController.dispose();
    _printerBridge.dispose();
    super.dispose();
  }

  Future<void> _loadInvoices() async {
    final saved = await Store.loadInvoices();
    if (!mounted) return;
    setState(() {
      _allInvoices = saved.map(_SavedInvoice.fromJson).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      _loading = false;
    });
  }

  void _search() {
    if (_dateFrom != null && _dateTo != null && _dateFrom!.isAfter(_dateTo!)) {
      setState(() {
        _searched = true;
        _results = [];
        _selectedInvoice = null;
        _message = 'تاريخ البداية يجب ألا يتجاوز تاريخ النهاية';
      });
      return;
    }
    final id = _idController.text.trim().toLowerCase();
    setState(() {
      _searched = true;
      _message = null;
      _results = _allInvoices.where((invoice) {
        if (id.isNotEmpty && !invoice.number.toLowerCase().contains(id)) {
          return false;
        }
        final date = DateTime(
          invoice.date.year,
          invoice.date.month,
          invoice.date.day,
        );
        if (_dateFrom != null) {
          final from = DateTime(
            _dateFrom!.year,
            _dateFrom!.month,
            _dateFrom!.day,
          );
          if (date.isBefore(from)) return false;
        }
        if (_dateTo != null) {
          final through = DateTime(_dateTo!.year, _dateTo!.month, _dateTo!.day);
          if (date.isAfter(through)) return false;
        }
        return true;
      }).toList();
      _selectedInvoice = null;
    });
  }

  Future<void> _chooseDate({required bool from}) async {
    final current = from ? _dateFrom : _dateTo;
    final date = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 10, 12, 31),
      helpText: from ? 'اختر تاريخ البداية' : 'اختر تاريخ النهاية',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );
    if (!mounted || date == null) return;
    setState(() {
      if (from) {
        _dateFrom = date;
      } else {
        _dateTo = date;
      }
      _message = null;
    });
  }

  Future<Uint8List> _documentFor(_SavedInvoice invoice) async {
    final settings = await Store.loadInvoicePrintSettings(invoice.typeIndex);
    return buildSavedInvoicePdf(
      typeIndex: invoice.typeIndex,
      invoice: invoice.data,
      fallbackDate: invoice.date,
      settings: settings,
    );
  }

  Future<bool> _canExportInvoice() => requirePermission(
    context: context,
    session: widget.session,
    authService: widget.authService,
    permission: 'invoice.print',
  );

  Future<void> _downloadInvoice() async {
    final invoice = _selectedInvoice;
    if (invoice == null || _working || !await _canExportInvoice()) return;
    setState(() {
      _working = true;
      _message = null;
    });
    try {
      final bytes = await _documentFor(invoice);
      if (!mounted) return;
      final safeNumber = invoice.number.replaceAll(
        RegExp(r'[^A-Za-z0-9_-]'),
        '_',
      );
      final saved = await downloadInvoicePdf(
        bytes: bytes,
        fileName: 'invoice-$safeNumber.pdf',
      );
      if (mounted) {
        setState(
          () => _message = !saved
              ? 'تم إلغاء التنزيل'
              : 'تم حفظ الفاتورة بصيغة PDF',
        );
      }
    } catch (error) {
      if (mounted) setState(() => _message = 'تعذر تنزيل الفاتورة: $error');
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _printInvoice() async {
    final invoice = _selectedInvoice;
    if (invoice == null || _working || !await _canExportInvoice()) return;
    setState(() {
      _working = true;
      _message = null;
    });
    try {
      final preferences = PrinterPreferences.fromJson(
        await Store.loadPrinterPreferences(),
      );
      final printerName = preferences.invoicePrinter;
      if (preferences.token.trim().isEmpty ||
          printerName == null ||
          printerName.trim().isEmpty) {
        throw const PrinterBridgeException(
          'عيّن طابعة الفواتير من الإدارة ثم أعد المحاولة',
        );
      }
      final printers = await _printerBridge.loadPrinters(preferences);
      if (!printers.any((printer) => printer.name == printerName)) {
        throw const PrinterBridgeException(
          'الطابعة المحددة للفواتير غير مثبتة على هذا الجهاز',
        );
      }
      final settings = await Store.loadInvoicePrintSettings(invoice.typeIndex);
      final document = await _documentFor(invoice);
      if (!mounted) return;
      await _printerBridge.printPdf(
        preferences: preferences,
        printerName: printerName,
        jobType: 'invoice',
        pdfBytes: document,
        paperWidthMm: settings.paperWidthMm,
        paperHeightMm: settings.paperHeightMmFor(
          invoice.lines.length,
          notesLength: invoice.notes.length,
        ),
      );
      if (mounted) setState(() => _message = 'تم إرسال الفاتورة للطباعة');
    } catch (error) {
      if (mounted) setState(() => _message = 'تعذرت الطباعة: $error');
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Widget _dateFilter({
    required String label,
    required bool from,
    required DateTime? value,
  }) => OutlinedButton.icon(
    key: ValueKey(
      from ? 'invoice-history-date-from' : 'invoice-history-date-to',
    ),
    onPressed: _working ? null : () => _chooseDate(from: from),
    icon: const Icon(Icons.calendar_today, size: 18),
    label: Text(
      value == null ? label : '$label: ${_formatDate(value)}',
      overflow: TextOverflow.ellipsis,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    return AlertDialog(
      key: const ValueKey('invoice-history-search-dialog'),
      title: const Text('بحث الفواتير المحفوظة'),
      content: SizedBox(
        width: screen.width < 600 ? screen.width - 48 : 820,
        height: screen.height < 720 ? screen.height * .68 : 520,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: screen.width < 600 ? screen.width - 80 : 240,
                  child: TextField(
                    key: const ValueKey('invoice-history-id-filter'),
                    controller: _idController,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      labelText: 'رقم الفاتورة',
                      hintText: 'أدخل رقم الفاتورة',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                _dateFilter(label: 'من تاريخ', from: true, value: _dateFrom),
                _dateFilter(label: 'إلى تاريخ', from: false, value: _dateTo),
                FilledButton.icon(
                  key: const ValueKey('invoice-history-search-submit'),
                  onPressed: _loading || _working ? null : _search,
                  icon: const Icon(Icons.search),
                  label: const Text('بحث'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                key: const ValueKey('invoice-history-list'),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : !_searched
                    ? const Center(child: Text('أدخل معايير البحث ثم اضغط بحث'))
                    : _results.isEmpty
                    ? const Center(child: Text('لا توجد فواتير مطابقة'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(6),
                        itemCount: _results.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final invoice = _results[index];
                          return ListTile(
                            key: ValueKey(
                              'invoice-history-result-${invoice.number}',
                            ),
                            selected: identical(_selectedInvoice, invoice),
                            selectedTileColor: AppColors.greenLight,
                            onTap: () => setState(() {
                              _selectedInvoice = invoice;
                              _message = null;
                            }),
                            title: Text(
                              'فاتورة رقم ${invoice.number} · ${invoice.type.ar}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              '${_formatDate(invoice.date)}'
                              '${invoice.account.isEmpty ? '' : ' · ${invoice.account}'}'
                              ' · الصافي ${invoice.total.toStringAsFixed(2)}',
                            ),
                            trailing: _selectedInvoice == invoice
                                ? const Icon(
                                    Icons.check_circle,
                                    color: AppColors.green,
                                  )
                                : const Icon(Icons.chevron_left),
                          );
                        },
                      ),
              ),
            ),
            if (_message != null) ...[
              const SizedBox(height: 8),
              Text(
                _message!,
                key: const ValueKey('invoice-history-message'),
                style: const TextStyle(color: AppColors.ink),
              ),
            ],
          ],
        ),
      ),
      actions: [
        FilledButton.icon(
          key: const ValueKey('invoice-history-download'),
          onPressed: _selectedInvoice == null || _working
              ? null
              : _downloadInvoice,
          icon: const Icon(Icons.download),
          label: const Text('تنزيل الفاتورة'),
        ),
        FilledButton.icon(
          key: const ValueKey('invoice-history-print-selected'),
          onPressed: _selectedInvoice == null || _working
              ? null
              : _printInvoice,
          icon: const Icon(Icons.print),
          label: const Text('طباعة الفاتورة'),
        ),
        TextButton(
          onPressed: _working ? null : () => Navigator.of(context).pop(),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _formatDate(DateTime value) =>
    '${_twoDigits(value.day)}/${_twoDigits(value.month)}/${value.year}';
