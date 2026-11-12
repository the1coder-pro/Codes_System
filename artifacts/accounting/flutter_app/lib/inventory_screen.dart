import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'auth_service.dart';
import 'item_image.dart';
import 'item_image_picker.dart';
import 'models.dart';
import 'resizable_split.dart';
import 'storage.dart';
import 'theme.dart';
import 'widgets.dart';

const _usageOpts = ['غير محدد', 'بيع وشراء', 'بيع فقط', 'شراء فقط'];
const _typeOpts = ['غير محدد', 'مخزني', 'خدمي', 'تجميعي'];
const _taxOpts = ['غير معفاة', 'معفاة', 'صفرية'];
const _unitTypeOpts = [
  'حبة',
  'قطعة',
  'وحدة',
  'عبوة',
  'علبة',
  'كيس',
  'كرتون',
  'صندوق',
  'طقم',
  'كيلوجرام',
  'جرام',
  'طن',
  'لتر',
  'ملليلتر',
  'متر',
  'سنتيمتر',
  'متر مربع',
  'متر مكعب',
  'ساعة',
  'يوم',
  'شهر',
  'خدمة',
];

typedef ItemImageBytesPicker = Future<Uint8List?> Function();

const _unitCols = [
  GridColumn('رقم الصنف', 92),
  GridColumn('السعر قبل الضريبة', 104),
  GridColumn('أقل سعر', 92),
  GridColumn('سعر الجملة', 100),
  GridColumn('السعر شامل الضريبة', 104),
  GridColumn('الباركود', 130),
  GridColumn('حجم الصنف', 96),
  GridColumn('عدد الوحدات', 84),
  GridColumn('صنف سريع', 76),
  GridColumn('اللون', 80),
];

/// Item card (الأصناف): cyan header form, action tiles, unit grid, search.
class InventoryScreen extends StatefulWidget {
  final VoidCallback onExit;
  final UserSession session;
  final AccountingAuthService authService;
  final ItemImageBytesPicker? pickImageBytes;

  const InventoryScreen({
    super.key,
    required this.onExit,
    required this.session,
    required this.authService,
    this.pickImageBytes,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Item> items = [];
  bool loading = true;
  bool editing = false;
  bool isNew = false;
  String? currentId;
  Item draft = Item(id: '');
  int? selectedUnit;

  final f = <String, TextEditingController>{
    for (final k in [
      'group',
      'nameAr',
      'nameEn',
      'shortName',
      'notes',
      'taxRate',
    ])
      k: TextEditingController(),
  };
  List<List<TextEditingController>> unitCtl = [];

  // search
  String sUsage = 'الكل';
  String sType = 'الكل';
  String sField = 'جميع الحقول';
  final sText = TextEditingController();
  final _searchScrollController = ScrollController();
  List<Item> results = [];

  @override
  void initState() {
    super.initState();
    Store.loadItems().then((v) {
      if (!mounted) return;
      setState(() {
        items = v;
        loading = false;
        results = List.of(v);
        if (v.isNotEmpty) _load(v.first);
      });
    });
  }

  void _load(Item it) {
    currentId = it.id;
    draft = it.copy();
    isNew = false;
    editing = false;
    selectedUnit = null;
    _bind();
  }

  void _bind() {
    f['group']!.text = draft.group;
    f['nameAr']!.text = draft.nameAr;
    f['nameEn']!.text = draft.nameEn;
    f['shortName']!.text = draft.shortName;
    f['notes']!.text = draft.notes;
    f['taxRate']!.text = draft.taxRate;
    unitCtl = draft.units.map(_rowCtl).toList();
  }

  List<TextEditingController> _rowCtl(UnitRow u) => [
    u.unitNo,
    u.priceBefore,
    u.minPrice,
    u.wholesale,
    u.priceInc,
    u.barcode,
    u.size,
    u.count,
    '',
    u.color,
  ].map((s) => TextEditingController(text: s)).toList();

  void _collect() {
    draft
      ..group = f['group']!.text.trim()
      ..nameAr = f['nameAr']!.text.trim()
      ..nameEn = f['nameEn']!.text.trim()
      ..shortName = f['shortName']!.text.trim()
      ..notes = f['notes']!.text.trim()
      ..taxRate = f['taxRate']!.text.trim();
    for (var i = 0; i < draft.units.length; i++) {
      final c = unitCtl[i];
      draft.units[i]
        ..unitNo = c[0].text
        ..priceBefore = c[1].text
        ..minPrice = c[2].text
        ..wholesale = c[3].text
        ..priceInc = c[4].text
        ..barcode = c[5].text
        ..size = c[6].text
        ..count = c[7].text
        ..color = c[9].text;
    }
  }

  double? _effectiveTaxRate() {
    if (draft.taxCat != 'غير معفاة') return 0;
    final rate = double.tryParse(f['taxRate']!.text.trim());
    if (rate == null || rate < 0) return null;
    return rate / 100;
  }

  void _syncPricePair(int row, int sourceColumn, String value) {
    if (row < 0 || row >= unitCtl.length) return;
    final target = unitCtl[row][sourceColumn == 1 ? 4 : 1];
    final text = value.trim();
    if (text.isEmpty) {
      target.clear();
      return;
    }
    final amount = double.tryParse(text);
    final rate = _effectiveTaxRate();
    if (amount == null || amount < 0 || rate == null) return;

    final factor = 1 + rate;
    target.text = money(sourceColumn == 1 ? amount * factor : amount / factor);
  }

  void _syncAllPricePairs() {
    if (_effectiveTaxRate() == null) return;
    for (var row = 0; row < unitCtl.length; row++) {
      final beforeTax = unitCtl[row][1].text.trim();
      final includingTax = unitCtl[row][4].text.trim();
      if (beforeTax.isNotEmpty) {
        _syncPricePair(row, 1, beforeTax);
      } else if (includingTax.isNotEmpty) {
        _syncPricePair(row, 4, includingTax);
      }
    }
  }

  bool get _canManage => widget.session.can('inventory.manage');

  Future<void> _new() async {
    if (!await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'inventory.manage',
    )) {
      return;
    }
    if (!mounted) return;
    if (editing) {
      _collect();
      _addUnit();
      return;
    }
    final group = f['group']!.text.trim();
    final next =
        items.fold<int>(1000, (m, e) {
          final n = int.tryParse(e.id) ?? 0;
          return n > m ? n : m;
        }) +
        1;
    setState(() {
      draft = Item(
        id: '$next',
        group: group,
        units: [UnitRow(unitNo: '$next')],
      );
      currentId = null;
      selectedUnit = null;
      isNew = true;
      editing = true;
      _bind();
    });
  }

  Future<void> _edit() async {
    if (!await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'inventory.manage',
    )) {
      return;
    }
    if (mounted) setState(() => editing = true);
  }

  Future<void> _pickImage() async {
    try {
      final bytes = widget.pickImageBytes == null
          ? await _pickImageBytesFromFile()
          : await widget.pickImageBytes!();
      if (bytes == null || !mounted) return;
      final imageData = optimizeItemImage(bytes);
      setState(() => draft.imageBase64 = imageData);
      toast(
        context,
        'تم تحميل صورة الصنف',
        severity: fluent.InfoBarSeverity.success,
      );
    } on FormatException catch (error) {
      if (mounted) {
        toast(
          context,
          error.message.toString(),
          severity: fluent.InfoBarSeverity.warning,
        );
      }
    } catch (error) {
      debugPrint('Item image selection failed: $error');
      if (mounted) {
        toast(
          context,
          'تعذر اختيار الصورة. جرّب JPG أو PNG أو WebP',
          severity: fluent.InfoBarSeverity.error,
        );
      }
    }
  }

  Future<Uint8List?> _pickImageBytesFromFile() async {
    return pickItemImageBytes();
  }

  Future<bool> _persistDraft() async {
    if (!await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'inventory.manage',
    )) {
      return false;
    }
    if (!mounted) return false;
    _collect();
    if (draft.nameAr.isEmpty) {
      toast(
        context,
        'اسم الصنف بالعربي مطلوب',
        severity: fluent.InfoBarSeverity.warning,
      );
      return false;
    }
    final updatedItems = List<Item>.of(items);
    final idx = updatedItems.indexWhere((e) => e.id == draft.id);
    if (idx >= 0) {
      updatedItems[idx] = draft.copy();
    } else {
      updatedItems.add(draft.copy());
    }
    final saved = await Store.saveItems(updatedItems);
    if (!mounted) return false;
    if (!saved) {
      toast(
        context,
        'تعذر حفظ الصنف. قد تكون مساحة تخزين المتصفح ممتلئة',
        severity: fluent.InfoBarSeverity.error,
      );
      return false;
    }
    setState(() {
      items = updatedItems;
      currentId = draft.id;
      editing = false;
      isNew = false;
      _search();
    });
    return true;
  }

  Future<void> _save() async {
    if (await _persistDraft() && mounted) {
      toast(
        context,
        'تم حفظ الصنف ${draft.nameAr}',
        severity: fluent.InfoBarSeverity.success,
      );
    }
  }

  void _undo() => setState(() {
    final cur = items.where((e) => e.id == currentId);
    if (cur.isNotEmpty) {
      _load(cur.first);
    } else if (items.isNotEmpty) {
      _load(items.first);
    } else {
      draft = Item(id: '');
      editing = false;
      isNew = false;
      _bind();
    }
  });

  Future<void> _delete() async {
    if (currentId == null) return;
    final ok = await confirmDialog(
      context,
      'حذف الصنف',
      'هل تريد حذف الصنف "${draft.nameAr}" نهائياً؟',
    );
    if (!ok || !mounted) return;
    if (!await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'inventory.delete',
    )) {
      return;
    }
    if (!mounted) return;
    setState(() {
      items.removeWhere((e) => e.id == currentId);
      currentId = null;
      _search();
      if (items.isNotEmpty) {
        _load(items.first);
      } else {
        draft = Item(id: '');
        _bind();
      }
    });
    final saved = await Store.saveItems(items);
    if (!mounted) return;
    if (!saved) {
      toast(
        context,
        'تعذر حفظ التغييرات. قد تكون مساحة تخزين المتصفح ممتلئة',
        severity: fluent.InfoBarSeverity.error,
      );
      return;
    }
    toast(context, 'تم حذف الصنف', severity: fluent.InfoBarSeverity.success);
  }

  void _search() {
    final q = sText.text.trim().toLowerCase();
    results = items.where((e) {
      if (sUsage != 'الكل' && e.usage != sUsage) return false;
      if (sType != 'الكل' && e.type != sType) return false;
      if (q.isEmpty) return true;
      final barcodes = e.units.map((u) => u.barcode).join(' ');
      final hay = switch (sField) {
        'الاسم' => '${e.nameAr} ${e.nameEn} ${e.shortName}',
        'الباركود' => barcodes,
        'رقم المجموعة' => e.group,
        _ =>
          '${e.id} ${e.group} ${e.nameAr} ${e.nameEn} ${e.shortName} $barcodes',
      };
      return hay.toLowerCase().contains(q);
    }).toList();
  }

  void _addUnit() => setState(() {
    final lastUnitNumber = draft.units.fold<int>(0, (max, unit) {
      final value = int.tryParse(unit.unitNo) ?? 0;
      return value > max ? value : max;
    });
    final u = UnitRow(
      unitNo:
          '${lastUnitNumber == 0 ? draft.units.length : lastUnitNumber + 1}',
    );
    draft.units.add(u);
    unitCtl.add(_rowCtl(u));
    selectedUnit = draft.units.length - 1;
  });

  void _removeUnit() => setState(() {
    if (selectedUnit == null || draft.units.length <= 1) return;
    draft.units.removeAt(selectedUnit!);
    unitCtl.removeAt(selectedUnit!);
    selectedUnit = null;
  });

  @override
  void dispose() {
    _searchScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        color: AppColors.paper,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(
            5,
            (i) => Container(
              height: 34,
              margin: const EdgeInsets.only(bottom: 10),
              color: i == 0 ? AppColors.cyan : AppColors.grid,
            ),
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, box) {
        final wide = box.maxWidth >= 980;
        final grid = _unitGrid();
        if (wide) {
          return Container(
            color: AppColors.paper,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    key: const ValueKey('inventory-resize-viewport'),
                    child: ResizableVerticalSplit(
                      dividerKey: const ValueKey(
                        'splitter-inventory-search-section',
                      ),
                      collapseToggleKey: const ValueKey(
                        'splitter-inventory-search-section-toggle',
                      ),
                      secondExtentKey: const ValueKey(
                        'inventory-search-section-size',
                      ),
                      initialSecondExtent: 188,
                      minFirstExtent: 0,
                      minSecondExtent: 0,
                      overlaySecond: true,
                      first: Column(
                        children: [
                          SizedBox(
                            height: 236,
                            child: ResizableSplit(
                              dividerKey: const ValueKey(
                                'splitter-inventory-header',
                              ),
                              collapseToggleKey: const ValueKey(
                                'splitter-inventory-header-toggle',
                              ),
                              first: _actions(),
                              second: _headerForm(true),
                              initialFirstFraction: .27,
                              minFirstWidth: 210,
                              minSecondWidth: 480,
                              collapsibleFirst: true,
                              collapsedLabel: 'الإجراءات',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Container(
                              key: const ValueKey('inventory-items-grid-area'),
                              child: grid,
                            ),
                          ),
                        ],
                      ),
                      second: Container(
                        key: const ValueKey('inventory-search-section'),
                        color: AppColors.paper,
                        child: ResizableSplit(
                          dividerKey: const ValueKey(
                            'splitter-inventory-search',
                          ),
                          collapseToggleKey: const ValueKey(
                            'splitter-inventory-search-toggle',
                          ),
                          first: _searchPanel(),
                          second: _resultsPanel(),
                          firstOnLeft: true,
                          initialFirstFraction: .31,
                          minFirstWidth: 220,
                          minSecondWidth: 380,
                          collapsibleFirst: true,
                          collapsedLabel: 'التصفية',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          color: AppColors.paper,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              _actions(),
              const SizedBox(height: 8),
              _headerForm(false),
              const SizedBox(height: 8),
              SizedBox(height: 300, child: grid),
              const SizedBox(height: 8),
              _searchPanel(),
              const SizedBox(height: 8),
              SizedBox(height: 220, child: _resultsPanel()),
            ],
          ),
        );
      },
    );
  }

  Widget _actions() {
    final hasCurrent = currentId != null;
    return Column(
      key: const ValueKey('inventory-actions-panel'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 4),
          child: Row(
            children: [
              const Text(
                'الأصناف',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 10),
              if (editing)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  color: const Color(0xFFFFF1C2),
                  child: Text(
                    isNew ? 'صنف جديد' : 'تعديل',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (_canManage)
              ActionTile(
                key: const ValueKey('inventory-new-item'),
                assetPath: AppIcons.add,
                label: 'جديد',
                glyphColor: AppColors.green,
                onTap: _new,
              ),
            if (_canManage)
              ActionTile(
                assetPath: AppIcons.edit,
                label: 'تعديل',
                glyphColor: const Color(0xFF2B7BC4),
                onTap: editing || !hasCurrent ? null : _edit,
              ),
            if (_canManage)
              ActionTile(
                assetPath: AppIcons.save,
                label: 'حفظ',
                glyphColor: AppColors.muted,
                onTap: editing ? _save : null,
              ),
            ActionTile(
              assetPath: AppIcons.exit,
              label: 'خروج',
              hideLabel: true,
              glyphColor: const Color(0xFF2B7BC4),
              onTap: widget.onExit,
            ),
            if (widget.session.can('inventory.delete'))
              ActionTile(
                assetPath: AppIcons.delete,
                label: 'حذف',
                glyphColor: AppColors.red,
                onTap: editing || !hasCurrent ? null : _delete,
              ),
            if (_canManage)
              ActionTile(
                assetPath: AppIcons.undo,
                label: 'تراجع',
                glyphColor: AppColors.muted,
                onTap: editing ? _undo : null,
              ),
          ],
        ),
      ],
    );
  }

  Widget _headerForm(bool wide) {
    final e = editing;
    final colA = Column(
      children: [
        FieldRow(
          label: 'رقم المجموعة',
          child: TextBox(
            key: const ValueKey('inventory-group-number'),
            controller: f['group']!,
            enabled: e,
          ),
        ),
        FieldRow(
          label: 'اسم الصنف بالعربي',
          child: TextBox(
            key: const ValueKey('inventory-name-ar'),
            controller: f['nameAr']!,
            enabled: e,
          ),
        ),
        FieldRow(
          label: 'اسم الصنف بالانجليزي',
          child: TextBox(controller: f['nameEn']!, enabled: e),
        ),
        FieldRow(
          label: 'الاسم المختصر',
          child: TextBox(controller: f['shortName']!, enabled: e),
        ),
        FieldRow(
          label: 'الملاحظات',
          child: TextBox(controller: f['notes']!, enabled: e, maxLines: 2),
        ),
      ],
    );
    final colB = Column(
      children: [
        FieldRow(
          label: 'طريقة الاستخدام',
          labelWidth: 100,
          child: DropBox(
            value: draft.usage,
            options: _usageOpts,
            onChanged: e ? (v) => setState(() => draft.usage = v) : null,
          ),
        ),
        FieldRow(
          label: 'نوع الصنف',
          labelWidth: 100,
          child: DropBox(
            value: draft.type,
            options: _typeOpts,
            onChanged: e ? (v) => setState(() => draft.type = v) : null,
          ),
        ),
        FieldRow(
          label: 'الفئة الضريبية',
          labelWidth: 100,
          child: DropBox(
            value: draft.taxCat,
            options: _taxOpts,
            onChanged: e
                ? (v) => setState(() {
                    draft.taxCat = v;
                    _syncAllPricePairs();
                  })
                : null,
          ),
        ),
        FieldRow(
          label: 'نسبة الضريبة',
          labelWidth: 100,
          child: TextBox(
            controller: f['taxRate']!,
            enabled: e,
            onChanged: e ? (_) => setState(_syncAllPricePairs) : null,
          ),
        ),
        Row(
          children: [
            fluent.Checkbox(
              checked: draft.unused,
              onChanged: e ? (v) => setState(() => draft.unused = v!) : null,
            ),
            const Text(
              'غير مستخدم',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
    final image = SizedBox(
      width: 150,
      child: Column(
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 110),
              width: double.infinity,
              color: Colors.white,
              child: ItemImage(
                base64Data: draft.imageBase64,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _smallBtn(
                  'رفع صورة',
                  AppColors.mint,
                  () {
                    unawaited(_pickImage());
                  },
                  key: const ValueKey('inventory-image-upload'),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _smallBtn(
                  'ازالة صورة',
                  AppColors.pink,
                  () {
                    setState(() => draft.imageBase64 = null);
                  },
                  key: const ValueKey('inventory-image-remove'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return Container(
      color: AppColors.cyan,
      padding: const EdgeInsets.all(10),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(primary: false, child: colA),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(primary: false, child: colB),
                ),
                const SizedBox(width: 16),
                image,
              ],
            )
          : Column(
              children: [
                colA,
                const SizedBox(height: 6),
                colB,
                SizedBox(height: 170, child: Center(child: image)),
              ],
            ),
    );
  }

  Widget _smallBtn(String t, Color bg, VoidCallback onTap, {Key? key}) =>
      fluent.Button(
        key: key,
        onPressed: editing ? onTap : null,
        style: fluent.ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(bg),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 8),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        child: Text(
          t,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13),
        ),
      );

  Widget _unitGrid() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Column(
        children: [
          Expanded(
            child: EditableGrid(
              columns: _unitCols,
              rowCount: draft.units.length,
              selectedRow: selectedUnit,
              onSelectRow: (r) => setState(() => selectedUnit = r),
              cell: (r, c) {
                if (c == 8) {
                  return Center(
                    child: fluent.Checkbox(
                      key: ValueKey('inventory-unit-quick-$r'),
                      checked: draft.units[r].quick,
                      onChanged: editing
                          ? (v) => setState(() => draft.units[r].quick = v!)
                          : null,
                    ),
                  );
                }
                if (c == 6) {
                  return DropBox(
                    key: ValueKey('inventory-unit-type-$r'),
                    value: draft.units[r].size,
                    options: _unitTypeOpts,
                    onChanged: editing
                        ? (value) => setState(() {
                            draft.units[r].size = value;
                            unitCtl[r][6].text = value;
                          })
                        : null,
                  );
                }
                return CellField(
                  key: ValueKey('inventory-unit-cell-$r-$c'),
                  controller: unitCtl[r][c],
                  enabled: editing,
                  onChanged: editing && (c == 1 || c == 4)
                      ? (value) => _syncPricePair(r, c, value)
                      : null,
                );
              },
            ),
          ),
          if (editing)
            Container(
              color: const Color(0xFFF1F3F5),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  fluent.Button(
                    onPressed: _addUnit,
                    child: const Text('+ إضافة وحدة'),
                  ),
                  fluent.Button(
                    onPressed: selectedUnit == null ? null : _removeUnit,
                    child: const Text('− حذف السطر المحدد'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _searchPanel() {
    return Container(
      key: const ValueKey('inventory-search-panel'),
      color: AppColors.cyan,
      padding: const EdgeInsets.all(8),
      child: Scrollbar(
        controller: _searchScrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _searchScrollController,
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FieldRow(
                label: 'طريقة الاستخدام',
                labelWidth: 96,
                child: DropBox(
                  value: sUsage,
                  options: ['الكل', ..._usageOpts],
                  onChanged: (v) => setState(() => sUsage = v),
                ),
              ),
              FieldRow(
                label: 'نوع الصنف',
                labelWidth: 96,
                child: DropBox(
                  value: sType,
                  options: ['الكل', ..._typeOpts],
                  onChanged: (v) => setState(() => sType = v),
                ),
              ),
              FieldRow(
                label: 'البحث في',
                labelWidth: 96,
                child: DropBox(
                  value: sField,
                  options: const [
                    'جميع الحقول',
                    'الاسم',
                    'الباركود',
                    'رقم المجموعة',
                  ],
                  onChanged: (v) => setState(() => sField = v),
                ),
              ),
              FieldRow(
                label: 'البحث عن',
                labelWidth: 96,
                child: TextBox(
                  controller: sText,
                  onSubmitted: (_) => setState(_search),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: fluent.Button(
                  style: fluent.ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(
                      Color(0xFFF4F8FA),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  onPressed: () => setState(_search),
                  child: const Text(
                    'بحث',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultsPanel() {
    return Container(
      key: const ValueKey('inventory-search-results-panel'),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEFF1),
        border: Border.all(color: AppColors.line),
      ),
      child: results.isEmpty
          ? const Center(
              child: Text(
                'لا توجد أصناف مطابقة — عدّل معايير البحث أو أضف صنفاً جديداً',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted),
              ),
            )
          : ListView.separated(
              primary: false,
              itemCount: results.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: AppColors.grid),
              itemBuilder: (_, i) {
                final it = results[i];
                final sel = it.id == currentId;
                return fluent.Button(
                  onPressed: editing ? null : () => setState(() => _load(it)),
                  style: fluent.ButtonStyle(
                    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.hovered)
                          ? const Color(0xFFEAF2FB)
                          : sel
                          ? const Color(0xFFDDEBFA)
                          : Colors.white,
                    ),
                    shape: const WidgetStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 52,
                            child: Text(
                              it.id,
                              style: const TextStyle(color: AppColors.muted),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              it.nameAr,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            it.type,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(money(it.price)),
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
