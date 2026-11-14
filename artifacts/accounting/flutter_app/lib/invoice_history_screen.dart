import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import 'models.dart';
import 'storage.dart';
import 'theme.dart';

/// Read-only browser for invoices that have already been saved locally.
class InvoiceHistoryScreen extends StatefulWidget {
  final VoidCallback onExit;

  const InvoiceHistoryScreen({super.key, required this.onExit});

  @override
  State<InvoiceHistoryScreen> createState() => _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends State<InvoiceHistoryScreen> {
  final _searchController = TextEditingController();
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
      builder: (context) => _InvoiceDetailsDialog(invoice: invoice),
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

class _InvoiceDetailsDialog extends StatelessWidget {
  final _SavedInvoice invoice;

  const _InvoiceDetailsDialog({required this.invoice});

  String _amount(double value) => value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
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

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _formatDate(DateTime value) =>
    '${_twoDigits(value.day)}/${_twoDigits(value.month)}/${value.year}';
