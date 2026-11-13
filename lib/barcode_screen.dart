import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'auth_service.dart';
import 'models.dart';
import 'printer_bridge.dart';
import 'print_documents.dart';
import 'resizable_split.dart';
import 'storage.dart';
import 'theme.dart';
import 'widgets.dart';

const _labelTemplates = [
  'استيكر السعر كبير 25 * 50 مل - 1',
  'استيكر السعر صغير 20 * 35 مل - 2',
  'بطاقة رف 30 * 60 مل - 3',
];

/// Barcode-label form backed by the inventory items already in the app.
class BarcodeScreen extends StatefulWidget {
  final VoidCallback onExit;
  final UserSession session;
  final AccountingAuthService authService;
  const BarcodeScreen({
    super.key,
    required this.onExit,
    required this.session,
    required this.authService,
  });

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  List<Item> items = [];
  Item? selected;
  bool loading = true;
  String template = _labelTemplates.first;
  DateTime productionDate = DateTime.now();
  DateTime expiryDate = DateTime.now();
  final search = TextEditingController();
  final barcode = TextEditingController();
  final count = TextEditingController(text: '1');
  final _printerBridge = PrinterBridgeClient();
  List<LocalPrinter> _availablePrinters = [];
  String? _selectedPrinter;

  String _dateText(DateTime date) => '${date.day}/${date.month}/${date.year}';

  List<Item> get visibleItems {
    final query = search.text.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items.where((item) {
      final codes = item.units.map((unit) => unit.barcode).join(' ');
      return '${item.id} ${item.nameAr} ${item.nameEn} $codes'
          .toLowerCase()
          .contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadPrinterPreferences();
    Store.loadItems().then((loaded) {
      if (!mounted) return;
      setState(() {
        items = loaded;
        loading = false;
        if (items.isNotEmpty) _select(items.first);
      });
    });
  }

  Future<void> _loadPrinterPreferences() async {
    final preferences = PrinterPreferences.fromJson(
      await Store.loadPrinterPreferences(),
    );
    if (!mounted) return;
    if (preferences.token.isEmpty) return;
    try {
      final printers = await _printerBridge.loadPrinters(preferences);
      if (!mounted) return;
      final savedName = preferences.barcodePrinter;
      final defaultPrinters = printers.where((printer) => printer.isDefault);
      setState(() {
        _availablePrinters = printers;
        _selectedPrinter = printers.any((printer) => printer.name == savedName)
            ? savedName
            : (defaultPrinters.isNotEmpty
                  ? defaultPrinters.first.name
                  : (printers.isEmpty ? null : printers.first.name));
      });
    } catch (_) {
      // The printer management page reports connection errors with details.
    }
  }

  @override
  void dispose() {
    search.dispose();
    barcode.dispose();
    count.dispose();
    _printerBridge.dispose();
    super.dispose();
  }

  void _select(Item item) {
    selected = item;
    barcode.text = item.units.isEmpty ? '' : item.units.first.barcode;
  }

  Future<void> _chooseDate(bool production) async {
    final initial = production ? productionDate : expiryDate;
    var selectedDate = initial;
    final confirmed = await fluent.showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => fluent.ContentDialog(
          title: Text(production ? 'تاريخ الإنتاج' : 'تاريخ الانتهاء'),
          content: SizedBox(
            width: 340,
            child: fluent.DatePicker(
              selected: selectedDate,
              startDate: DateTime(2000),
              endDate: DateTime(2100),
              onChanged: (date) => setDialogState(() => selectedDate = date),
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
    if (confirmed != true || !mounted) return;
    setState(() {
      if (production) {
        productionDate = selectedDate;
      } else {
        expiryDate = selectedDate;
      }
    });
  }

  Future<void> _print() async {
    if (!await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'barcode.print',
    )) {
      return;
    }
    if (!mounted) return;
    final item = selected;
    final copies = int.tryParse(count.text.trim());
    final code = barcode.text.trim();
    if (item == null) {
      toast(
        context,
        'اختر صنفاً أولاً',
        severity: fluent.InfoBarSeverity.warning,
      );
      return;
    }
    if (copies == null || copies < 1 || copies > 500) {
      toast(
        context,
        'أدخل عدداً من 1 إلى 500',
        severity: fluent.InfoBarSeverity.warning,
      );
      return;
    }
    if (code.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(code)) {
      toast(
        context,
        'أدخل باركوداً رقمياً',
        severity: fluent.InfoBarSeverity.warning,
      );
      return;
    }
    try {
      final preferences = PrinterPreferences.fromJson(
        await Store.loadPrinterPreferences(),
      );
      final printerName = _selectedPrinter ?? preferences.barcodePrinter;
      final pdfBytes = await buildBarcodePdf(
        itemName: item.nameAr,
        code: code,
        copies: copies,
        template: template,
        productionDate: productionDate,
        expiryDate: expiryDate,
      );
      await _printerBridge.printPdf(
        preferences: preferences,
        printerName: printerName ?? '',
        jobType: 'barcode',
        pdfBytes: pdfBytes,
      );
      if (mounted) {
        toast(
          context,
          'تم إرسال الباركود للطابعة المحددة',
          severity: fluent.InfoBarSeverity.success,
        );
      }
    } catch (error) {
      if (mounted) {
        toast(
          context,
          error.toString(),
          severity: fluent.InfoBarSeverity.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) {
      if (bounds.maxWidth >= 860) {
        return ResizableSplit(
          dividerKey: const ValueKey('splitter-barcode'),
          first: _settings(compact: false),
          second: _itemBrowser(),
          initialFirstFraction: .39,
          minFirstWidth: 300,
          minSecondWidth: 420,
        );
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            _settings(compact: true),
            const SizedBox(height: 8),
            SizedBox(height: 390, child: _itemBrowser()),
          ],
        ),
      );
    },
  );

  Widget _settings({required bool compact}) => Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          key: ValueKey('barcode-screen-title'),
          'طباعة الباركود',
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Container(
          key: const ValueKey('barcode-settings-panel'),
          padding: const EdgeInsets.all(10),
          color: AppColors.cyan,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                key: const ValueKey('barcode-field-header'),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: const Color(0xFF4F8DB8),
                alignment: AlignmentDirectional.centerEnd,
                child: const Text(
                  'الباركود',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              TextBox(
                key: const ValueKey('barcode-value'),
                controller: barcode,
                textDirection: TextDirection.ltr,
                align: TextAlign.end,
                keyboard: TextInputType.number,
              ),
              const SizedBox(height: 10),
              const Text('نموذج الباركود:', textAlign: TextAlign.end),
              const SizedBox(height: 4),
              DropBox(
                value: template,
                options: _labelTemplates,
                onChanged: (value) => setState(() => template = value),
              ),
              const SizedBox(height: 10),
              const Text('الطابعة:', textAlign: TextAlign.end),
              const SizedBox(height: 4),
              SizedBox(
                height: 36,
                child: fluent.ComboBox<String>(
                  key: const ValueKey('barcode-printer-choice'),
                  value:
                      _availablePrinters.any(
                        (printer) => printer.name == _selectedPrinter,
                      )
                      ? _selectedPrinter
                      : null,
                  placeholder: const Text('اختر طابعة الباركود'),
                  isExpanded: true,
                  items: [
                    for (final printer in _availablePrinters)
                      fluent.ComboBoxItem<String>(
                        value: printer.name,
                        child: Text(
                          printer.isDefault
                              ? '${printer.displayName} (الافتراضية)'
                              : printer.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: _availablePrinters.isEmpty
                      ? null
                      : (value) => setState(() => _selectedPrinter = value),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _labeledValue(
                      'اسم الصنف:',
                      selected?.nameAr ?? '',
                      key: const ValueKey('barcode-item-name'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _labeledValue(
                      'رقم الصنف:',
                      selected?.id ?? '',
                      key: const ValueKey('barcode-item-code'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _dateButton(
                      'تاريخ الإنتاج',
                      productionDate,
                      () => _chooseDate(true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _dateButton(
                      'تاريخ الانتهاء',
                      expiryDate,
                      () => _chooseDate(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('العدد:', textAlign: TextAlign.end),
              const SizedBox(height: 4),
              TextBox(
                key: const ValueKey('barcode-count'),
                controller: count,
                textDirection: TextDirection.ltr,
                align: TextAlign.end,
                keyboard: TextInputType.number,
              ),
            ],
          ),
        ),
        if (compact) const SizedBox(height: 12) else const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              key: const ValueKey('barcode-action-buttons'),
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ActionTile(
                  key: const ValueKey('barcode-exit-button'),
                  assetPath: AppIcons.exit,
                  label: 'خروج',
                  hideLabel: true,
                  glyphColor: const Color(0xFF178BD0),
                  width: 76,
                  height: 78,
                  onTap: widget.onExit,
                ),
                const SizedBox(width: 8),
                ActionTile(
                  key: const ValueKey('barcode-print-button'),
                  assetPath: AppIcons.printer,
                  label: 'طباعة',
                  glyphColor: const Color(0xFF178BD0),
                  width: 180,
                  height: 78,
                  onTap: loading ? null : _print,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _labeledValue(String label, String value, {Key? key}) => Column(
    key: key,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        textAlign: TextAlign.end,
        style: const TextStyle(fontSize: 13),
      ),
      const SizedBox(height: 4),
      Container(
        constraints: const BoxConstraints(minHeight: 31),
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE8ECEF),
          border: Border.all(color: AppColors.line),
        ),
        child: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    ],
  );

  Widget _dateButton(String label, DateTime date, VoidCallback onTap) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        textAlign: TextAlign.end,
        style: const TextStyle(fontSize: 13),
      ),
      const SizedBox(height: 4),
      fluent.Button(
        key: ValueKey('barcode-date-$label'),
        onPressed: onTap,
        style: fluent.ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 6, vertical: 7),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        child: Text(_dateText(date), textAlign: TextAlign.center),
      ),
    ],
  );

  Widget _itemBrowser() => Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            key: const ValueKey('barcode-search-row'),
            children: [
              SizedBox(
                width: 82,
                child: ActionTile(
                  key: const ValueKey('barcode-search-button'),
                  assetPath: AppIcons.search,
                  label: 'بحث',
                  width: 76,
                  height: 78,
                  onTap: () => setState(() {}),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'تصنيف الأسماء',
                      key: ValueKey('barcode-search-title'),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 4),
                    TextBox(
                      key: const ValueKey('barcode-search-field'),
                      controller: search,
                      textDirection: TextDirection.rtl,
                      align: TextAlign.end,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(flex: 2, child: _HeaderCell('السعر قبل الضريبة')),
                    Expanded(flex: 2, child: _HeaderCell('السعر شامل الضريبة')),
                    Expanded(
                      flex: 3,
                      child: _HeaderCell('اسم الصنف بالإنجليزي'),
                    ),
                    Expanded(flex: 4, child: _HeaderCell('اسم الصنف بالعربي')),
                  ],
                ),
                const Divider(height: 1),
                Expanded(
                  child: loading
                      ? const Center(child: fluent.ProgressRing())
                      : visibleItems.isEmpty
                      ? const Center(child: Text('لا توجد أصناف مطابقة'))
                      : ListView.builder(
                          itemCount: visibleItems.length,
                          itemBuilder: (context, index) {
                            final item = visibleItems[index];
                            final active = item.id == selected?.id;
                            final unit = item.units.isEmpty
                                ? null
                                : item.units.first;
                            final rowColor = active
                                ? const Color(0xFF1680C9)
                                : index.isEven
                                ? Colors.white
                                : const Color(0xFFF3F3F3);
                            return fluent.Button(
                              key: ValueKey('barcode-row-${item.id}'),
                              onPressed: () => setState(() => _select(item)),
                              style: fluent.ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.zero,
                                ),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith(
                                      (states) =>
                                          states.contains(
                                                WidgetState.hovered,
                                              ) &&
                                              !active
                                          ? const Color(0xFFEAF2FB)
                                          : rowColor,
                                    ),
                                shape: const WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: 33,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _itemCell(
                                        unit?.priceBefore ?? '',
                                        active,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: _itemCell(
                                        unit?.priceInc ?? '',
                                        active,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: _itemCell(item.nameEn, active),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: _itemCell(item.nameAr, active),
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
        ),
      ],
    ),
  );

  Widget _itemCell(String text, bool active) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    alignment: AlignmentDirectional.centerEnd,
    child: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: active ? Colors.white : AppColors.ink),
    ),
  );
}

class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell(this.label);
  @override
  Widget build(BuildContext context) => Container(
    height: 46,
    alignment: AlignmentDirectional.centerEnd,
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Text(
      label,
      textAlign: TextAlign.end,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
    ),
  );
}
