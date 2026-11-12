import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'barcode_print_stub.dart'
    if (dart.library.js_interop) 'barcode_print_web.dart'
    as printer;
import 'models.dart';
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
  const BarcodeScreen({super.key, required this.onExit});

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
    Store.loadItems().then((loaded) {
      if (!mounted) return;
      setState(() {
        items = loaded;
        loading = false;
        if (items.isNotEmpty) _select(items.first);
      });
    });
  }

  @override
  void dispose() {
    search.dispose();
    barcode.dispose();
    count.dispose();
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
      printer.printLabels(_printDocument(item, code, copies));
      if (mounted) {
        toast(
          context,
          'تم فتح نافذة الطباعة',
          severity: fluent.InfoBarSeverity.success,
        );
      }
    } catch (_) {
      if (mounted) {
        toast(
          context,
          'تعذر فتح نافذة الطباعة في المتصفح',
          severity: fluent.InfoBarSeverity.error,
        );
      }
    }
  }

  String _printDocument(Item item, String code, int copies) {
    final safeName = _escape(item.nameAr);
    final safeCode = _escape(code);
    final svg = _code39(code);
    final (labelWidth, labelHeight, columns) = switch (template) {
      'استيكر السعر صغير 20 * 35 مل - 2' => ('35mm', '20mm', 4),
      'بطاقة رف 30 * 60 مل - 3' => ('60mm', '30mm', 2),
      _ => ('50mm', '25mm', 3),
    };
    final labels = List.filled(copies, '''
      <article class="label">
        <div class="name" dir="rtl">$safeName</div>
        <svg viewBox="0 0 ${svg.$2} 44" role="img" aria-label="باركود $safeCode">
          <rect width="100%" height="44" fill="white"/>
          <g fill="#111">${svg.$1}</g>
        </svg>
        <div class="code">$safeCode</div>
        <div class="dates" dir="rtl">
          <span>إنتاج ${_dateText(productionDate)}</span>
          <span>انتهاء ${_dateText(expiryDate)}</span>
        </div>
      </article>
      ''').join();
    return '''
      <!doctype html><html lang="ar" dir="rtl"><head><meta charset="utf-8">
      <title>طباعة باركود</title>
      <style>
        *{box-sizing:border-box}body{font-family:Arial,sans-serif;margin:12mm;color:#111}
        main{display:grid;grid-template-columns:repeat($columns,minmax($labelWidth,1fr));gap:3mm}
        .label{height:$labelHeight;min-width:$labelWidth;border:1px dashed #aaa;padding:1mm 2mm;text-align:center;overflow:hidden}
        .name{font-size:9pt;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
        svg{width:100%;height:9mm;margin-top:.5mm}.code{font:8pt monospace;letter-spacing:1px}
        .dates{display:flex;justify-content:space-between;font-size:6pt;white-space:nowrap}
        @media print{body{margin:4mm}.label{break-inside:avoid;border-color:#ddd}}
      </style></head><body><main>$labels</main></body></html>
    ''';
  }

  String _escape(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');

  /// Renders Code 39 bars for the numeric product codes accepted here.
  (String, int) _code39(String code) {
    const patterns = <String, String>{
      '0': 'nnnwwnwnn',
      '1': 'wnnwnnnnw',
      '2': 'nnwwnnnnw',
      '3': 'wnwwnnnnn',
      '4': 'nnnwwnnnw',
      '5': 'wnnwwnnnn',
      '6': 'nnwwwnnnn',
      '7': 'nnnwnnwnw',
      '8': 'wnnwnnwnn',
      '9': 'nnwwnnwnn',
      '*': 'nwnnwnwnn',
    };
    final symbols = '*$code*'.split('');
    const narrow = 2;
    const wide = 5;
    var x = 0;
    final bars = StringBuffer();
    for (var s = 0; s < symbols.length; s++) {
      final pattern = patterns[symbols[s]]!;
      for (var i = 0; i < pattern.length; i++) {
        final width = pattern[i] == 'w' ? wide : narrow;
        if (i.isEven) {
          bars.write('<rect x="$x" y="0" width="$width" height="42"/>');
        }
        x += width;
      }
      if (s != symbols.length - 1) x += narrow;
    }
    return (bars.toString(), x);
  }

  String _dateText(DateTime date) => '${date.day}/${date.month}/${date.year}';

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
