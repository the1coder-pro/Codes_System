import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'models.dart';
import 'storage.dart';
import 'theme.dart';
import 'widgets.dart';

const _usageOpts = ['غير محدد', 'بيع وشراء', 'بيع فقط', 'شراء فقط'];
const _typeOpts = ['غير محدد', 'مخزني', 'خدمي', 'تجميعي'];
const _taxOpts = ['غير معفاة', 'معفاة', 'صفرية'];

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
  const InventoryScreen({super.key, required this.onExit});

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
  bool hasImage = false;

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

  void _new() => setState(() {
    final next =
        items.fold<int>(1000, (m, e) {
          final n = int.tryParse(e.id) ?? 0;
          return n > m ? n : m;
        }) +
        1;
    draft = Item(id: '$next');
    currentId = null;
    isNew = true;
    editing = true;
    hasImage = false;
    _bind();
  });

  void _edit() => setState(() => editing = true);

  Future<void> _save() async {
    _collect();
    if (draft.nameAr.isEmpty) {
      toast(context, 'اسم الصنف بالعربي مطلوب');
      return;
    }
    setState(() {
      final idx = items.indexWhere((e) => e.id == draft.id);
      if (idx >= 0) {
        items[idx] = draft.copy();
      } else {
        items.add(draft.copy());
      }
      currentId = draft.id;
      editing = false;
      isNew = false;
      _search();
    });
    await Store.saveItems(items);
    if (mounted) toast(context, 'تم حفظ الصنف ${draft.nameAr}');
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
    await Store.saveItems(items);
    if (mounted) toast(context, 'تم حذف الصنف');
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
    final u = UnitRow(unitNo: '${draft.units.length + 1}');
    draft.units.add(u);
    unitCtl.add(_rowCtl(u));
  });

  void _removeUnit() => setState(() {
    if (selectedUnit == null || draft.units.length <= 1) return;
    draft.units.removeAt(selectedUnit!);
    unitCtl.removeAt(selectedUnit!);
    selectedUnit = null;
  });

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
                SizedBox(
                  height: 236,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(width: 250, child: _actions()),
                      const SizedBox(width: 8),
                      Expanded(child: _headerForm(true)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(child: grid),
                const SizedBox(height: 8),
                SizedBox(
                  height: 236,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(width: 300, child: _searchPanel()),
                      const SizedBox(width: 8),
                      Expanded(child: _resultsPanel()),
                    ],
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
            ActionTile(
              glyph: '➕',
              label: 'جديد',
              glyphColor: AppColors.green,
              onTap: editing ? null : _new,
            ),
            ActionTile(
              glyph: '🖊️',
              label: 'تعديل',
              glyphColor: const Color(0xFF2B7BC4),
              onTap: editing || !hasCurrent ? null : _edit,
            ),
            ActionTile(
              glyph: '💾',
              label: 'حفظ',
              glyphColor: AppColors.muted,
              onTap: editing ? _save : null,
            ),
            ActionTile(
              glyph: '🚪',
              label: 'خروج',
              glyphColor: const Color(0xFF2B7BC4),
              onTap: widget.onExit,
            ),
            ActionTile(
              glyph: '🗑️',
              label: 'حذف',
              glyphColor: AppColors.red,
              onTap: editing || !hasCurrent ? null : _delete,
            ),
            ActionTile(
              glyph: '↩️',
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
          child: TextBox(controller: f['group']!, enabled: e),
        ),
        FieldRow(
          label: 'اسم الصنف بالعربي',
          child: TextBox(controller: f['nameAr']!, enabled: e),
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
            onChanged: e ? (v) => setState(() => draft.taxCat = v) : null,
          ),
        ),
        FieldRow(
          label: 'نسبة الضريبة',
          labelWidth: 100,
          child: TextBox(controller: f['taxRate']!, enabled: e),
        ),
        Row(
          children: [
            Checkbox(
              value: draft.unused,
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
              alignment: Alignment.center,
              child: Text(
                hasImage ? '▥▦▧' : 'لا توجد صورة',
                style: TextStyle(
                  fontSize: hasImage ? 40 : 13,
                  color: hasImage ? AppColors.greenLight : AppColors.muted,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _smallBtn('اضافة صورة', AppColors.mint, () {
                  setState(() => hasImage = true);
                }),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _smallBtn('ازالة صورة', AppColors.pink, () {
                  setState(() => hasImage = false);
                }),
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
                Expanded(flex: 5, child: colA),
                const SizedBox(width: 16),
                Expanded(flex: 4, child: colB),
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

  Widget _smallBtn(String t, Color bg, VoidCallback onTap) => fluent.Button(
    onPressed: editing ? onTap : null,
    style: fluent.ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(bg),
      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 8)),
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
                    child: Checkbox(
                      value: draft.units[r].quick,
                      onChanged: editing
                          ? (v) => setState(() => draft.units[r].quick = v!)
                          : null,
                    ),
                  );
                }
                return CellField(controller: unitCtl[r][c], enabled: editing);
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
      color: AppColors.cyan,
      padding: const EdgeInsets.all(8),
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
    );
  }

  Widget _resultsPanel() {
    return Container(
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
