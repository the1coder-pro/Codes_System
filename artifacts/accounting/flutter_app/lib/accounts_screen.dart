import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'models.dart';
import 'resizable_split.dart';
import 'storage.dart';
import 'theme.dart';
import 'widgets.dart';

const _accountTypes = ['الحسابات المالية', 'العملاء', 'الموردون', 'الموظفون'];
const _paymentTypes = ['حساب نقدي', 'حساب شبكة', 'حساب بنكي', 'حساب آجل'];

/// Arabic account directory and editor. Account changes are saved locally.
class AccountsScreen extends StatefulWidget {
  final VoidCallback onExit;
  const AccountsScreen({super.key, required this.onExit});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<Account> accounts = [];
  bool loading = true;
  bool editing = false;
  bool isNew = false;
  String? currentCode;
  Account draft = Account();
  int tab = 0;
  final search = TextEditingController();
  final fields = <String, TextEditingController>{
    for (final key in [
      'code',
      'nameAr',
      'nameEn',
      'branch',
      'notes',
      'streetAr',
      'streetEn',
      'cityAr',
      'cityEn',
      'districtAr',
      'districtEn',
      'nationality',
      'country',
      'postalCode',
      'extraNumber',
      'buildingNumber',
      'commercialNumber',
      'taxNumber',
      'identityNumber',
      'phone',
      'mobile',
      'email',
    ])
      key: TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    Store.loadAccounts().then((loaded) {
      if (!mounted) return;
      setState(() {
        accounts = loaded;
        loading = false;
        if (accounts.isNotEmpty) _load(accounts.first);
      });
    });
  }

  @override
  void dispose() {
    search.dispose();
    for (final controller in fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _load(Account account) {
    draft = account.copy();
    currentCode = account.code;
    isNew = false;
    editing = false;
    _bind();
  }

  void _bind() {
    final data = draft.toJson();
    for (final entry in fields.entries) {
      entry.value.text = '${data[entry.key] ?? ''}';
    }
  }

  void _collect() {
    draft
      ..code = fields['code']!.text.trim()
      ..nameAr = fields['nameAr']!.text.trim()
      ..nameEn = fields['nameEn']!.text.trim()
      ..branch = fields['branch']!.text.trim()
      ..notes = fields['notes']!.text.trim()
      ..streetAr = fields['streetAr']!.text.trim()
      ..streetEn = fields['streetEn']!.text.trim()
      ..cityAr = fields['cityAr']!.text.trim()
      ..cityEn = fields['cityEn']!.text.trim()
      ..districtAr = fields['districtAr']!.text.trim()
      ..districtEn = fields['districtEn']!.text.trim()
      ..nationality = fields['nationality']!.text.trim()
      ..country = fields['country']!.text.trim()
      ..postalCode = fields['postalCode']!.text.trim()
      ..extraNumber = fields['extraNumber']!.text.trim()
      ..buildingNumber = fields['buildingNumber']!.text.trim()
      ..commercialNumber = fields['commercialNumber']!.text.trim()
      ..taxNumber = fields['taxNumber']!.text.trim()
      ..identityNumber = fields['identityNumber']!.text.trim()
      ..phone = fields['phone']!.text.trim()
      ..mobile = fields['mobile']!.text.trim()
      ..email = fields['email']!.text.trim();
  }

  void _new() {
    final next =
        accounts.fold<int>(1000000, (max, account) {
          final value = int.tryParse(account.code) ?? 0;
          return value > max ? value : max;
        }) +
        1;
    setState(() {
      draft = Account(code: '$next');
      currentCode = null;
      editing = true;
      isNew = true;
      tab = 0;
      _bind();
    });
  }

  void _edit() {
    if (currentCode == null) return;
    setState(() => editing = true);
  }

  Future<void> _save() async {
    _collect();
    if (draft.code.isEmpty || draft.nameAr.isEmpty) {
      toast(context, 'رقم الحساب والاسم بالعربي مطلوبان');
      return;
    }
    if (accounts.any((a) => a.code == draft.code && a.code != currentCode)) {
      toast(context, 'رقم الحساب مستخدم من قبل');
      return;
    }
    setState(() {
      final index = accounts.indexWhere((a) => a.code == currentCode);
      if (index >= 0) {
        accounts[index] = draft.copy();
      } else {
        accounts.add(draft.copy());
      }
      currentCode = draft.code;
      editing = false;
      isNew = false;
    });
    await Store.saveAccounts(accounts);
    if (mounted) toast(context, 'تم حفظ الحساب ${draft.nameAr}');
  }

  void _undo() {
    setState(() {
      final current = accounts.where((a) => a.code == currentCode);
      if (current.isNotEmpty) {
        _load(current.first);
      } else if (accounts.isNotEmpty) {
        _load(accounts.first);
      } else {
        draft = Account();
        currentCode = null;
        editing = false;
        isNew = false;
        _bind();
      }
    });
  }

  Future<void> _delete() async {
    if (currentCode == null) return;
    final confirmed = await confirmDialog(
      context,
      'حذف الحساب',
      'هل تريد حذف الحساب "${draft.nameAr}" نهائياً؟',
    );
    if (!confirmed || !mounted) return;
    setState(() {
      accounts.removeWhere((a) => a.code == currentCode);
      if (accounts.isEmpty) {
        currentCode = null;
        draft = Account();
        editing = false;
        _bind();
      } else {
        _load(accounts.first);
      }
    });
    await Store.saveAccounts(accounts);
    if (mounted) toast(context, 'تم حذف الحساب');
  }

  List<Account> get visibleAccounts {
    final query = search.text.trim().toLowerCase();
    return accounts.where((account) {
      return query.isEmpty ||
          '${account.code} ${account.nameAr} ${account.nameEn}'
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  void _setType(String value) => setState(() => draft.type = value);
  void _setPaymentType(String value) =>
      setState(() => draft.paymentType = value);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, bounds) {
        final wide = bounds.maxWidth >= 920;
        if (wide) {
          return ResizableSplit(
            dividerKey: const ValueKey('splitter-accounts'),
            first: _directory(),
            second: _editor(compact: false),
            initialFirstFraction: .38,
            minFirstWidth: 270,
            minSecondWidth: 460,
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              SizedBox(height: 390, child: _directory()),
              const SizedBox(height: 6),
              _editor(compact: true),
            ],
          ),
        );
      },
    );
  }

  Widget _directory() => Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: Text(
            'الحسابات',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _labeledDrop(
                'نوع الحساب',
                draft.type,
                _accountTypes,
                editing ? _setType : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _labeledDrop(
                'نوع حساب الدفع',
                draft.paymentType,
                _paymentTypes,
                editing ? _setPaymentType : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 31,
          color: const Color(0xFFF2F3F4),
          child: const Row(
            children: [
              Expanded(flex: 4, child: _TableHeader('الاسم بالعربي')),
              SizedBox(width: 92, child: _TableHeader('م')),
            ],
          ),
        ),
        Expanded(
          child: loading
              ? const Center(child: fluent.ProgressRing())
              : visibleAccounts.isEmpty
              ? const Center(child: Text('لا توجد حسابات'))
              : ListView.builder(
                  itemCount: visibleAccounts.length,
                  itemBuilder: (context, index) {
                    final account = visibleAccounts[index];
                    final selected = account.code == currentCode;
                    final rowColor = selected
                        ? AppColors.navy
                        : index.isEven
                        ? Colors.white
                        : const Color(0xFFE5E5E5);
                    return fluent.Button(
                      key: ValueKey('account-row-${account.code}'),
                      onPressed: () => setState(() => _load(account)),
                      style: fluent.ButtonStyle(
                        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (states) =>
                              states.contains(WidgetState.hovered) && !selected
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
                        height: 28,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: Text(
                                  account.nameAr,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : AppColors.ink,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 92,
                              child: Text(
                                account.code,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.ink,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            SizedBox(
              width: 68,
              child: ActionTile(
                glyph: '🔎',
                label: 'بحث',
                width: 68,
                height: 66,
                onTap: () => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextBox(
                key: const ValueKey('accounts-search'),
                controller: search,
                onChanged: (_) => setState(() {}),
                placeholder: 'بحث عن حساب',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 4,
          runSpacing: 4,
          children: [
            _action('➕', 'جديد', _new, color: AppColors.greenLight),
            _action('🖊', 'تعديل', _edit, enabled: !editing),
            _action('💾', 'حفظ', editing ? _save : null),
            _action('↶', 'تراجع', editing ? _undo : null),
            _action(
              '🗑',
              'حذف',
              !editing ? _delete : null,
              color: AppColors.red,
            ),
            _action('🚪', 'خروج', widget.onExit),
          ],
        ),
      ],
    ),
  );

  Widget _editor({required bool compact}) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          alignment: AlignmentDirectional.centerEnd,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: const Text(
            'بيانات المؤسسة',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(9),
          color: AppColors.cyan,
          child: LayoutBuilder(
            builder: (context, bounds) {
              final fieldWidth = bounds.maxWidth < 570
                  ? bounds.maxWidth
                  : (bounds.maxWidth - 18) / 2;
              return Wrap(
                spacing: 9,
                runSpacing: 7,
                children: [
                  _field('code', 'رقم الحساب', width: fieldWidth),
                  _field('branch', 'الفرع', width: fieldWidth),
                  _field('nameAr', 'الاسم بالعربي', width: fieldWidth),
                  _field('nameEn', 'الاسم بالإنجليزي', width: fieldWidth),
                  _field(
                    'notes',
                    'ملاحظات',
                    width: bounds.maxWidth,
                    maxLines: 2,
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          children: [
            for (var i = 0; i < 3; i++)
              Container(
                decoration: BoxDecoration(
                  color: tab == i ? AppColors.cyan : AppColors.chrome,
                  border: Border.all(color: AppColors.line),
                ),
                child: fluent.Button(
                  onPressed: () => setState(() => tab = i),
                  style: fluent.ButtonStyle(
                    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.hovered)
                          ? const Color(0xFFEAF2FB)
                          : Colors.transparent,
                    ),
                    shape: const WidgetStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    child: Text(
                      ['العنوان', 'الوثائق والمستندات', 'وسائل التواصل'][i],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Expanded(child: _tabContent()),
      ],
    );
    if (compact) {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...content.children.take(content.children.length - 1),
            SizedBox(height: 300, child: _tabContent()),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.line),
        ),
        child: content,
      ),
    );
  }

  Widget _tabContent() {
    final parts = switch (tab) {
      0 => [
        ('streetAr', 'اسم الشارع بالعربي'),
        ('streetEn', 'اسم الشارع بالإنجليزي'),
        ('cityAr', 'المدينة بالعربي'),
        ('cityEn', 'المدينة بالإنجليزي'),
        ('districtAr', 'الحي بالعربي'),
        ('districtEn', 'الحي بالإنجليزي'),
        ('nationality', 'الجنسية'),
        ('country', 'الدولة'),
        ('postalCode', 'الرمز البريدي'),
        ('extraNumber', 'الرقم الإضافي'),
        ('buildingNumber', 'رقم المبنى'),
      ],
      1 => [
        ('commercialNumber', 'رقم السجل التجاري'),
        ('taxNumber', 'الرقم الضريبي'),
        ('identityNumber', 'رقم الهوية'),
      ],
      _ => [
        ('phone', 'رقم الهاتف'),
        ('mobile', 'رقم الجوال'),
        ('email', 'البريد الإلكتروني'),
      ],
    };
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(9),
        color: AppColors.cyan,
        child: LayoutBuilder(
          builder: (context, bounds) {
            final fieldWidth = bounds.maxWidth < 500
                ? bounds.maxWidth
                : (bounds.maxWidth - 18) / 2;
            return Wrap(
              spacing: 9,
              runSpacing: 8,
              children: [
                for (final part in parts)
                  _field(part.$1, part.$2, width: fieldWidth),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _field(
    String key,
    String label, {
    required double width,
    int maxLines = 1,
  }) => SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        TextBox(
          key: ValueKey('account-field-$key'),
          controller: fields[key]!,
          enabled: editing,
          maxLines: maxLines,
        ),
      ],
    ),
  );

  Widget _labeledDrop(
    String label,
    String value,
    List<String> options,
    ValueChanged<String>? onChanged,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(label, style: const TextStyle(fontSize: 13)),
      ),
      DropBox(value: value, options: options, onChanged: onChanged),
    ],
  );

  Widget _action(
    String glyph,
    String label,
    VoidCallback? onTap, {
    Color color = AppColors.navy,
    bool enabled = true,
  }) => ActionTile(
    glyph: glyph,
    label: label,
    glyphColor: color,
    width: 56,
    height: 65,
    onTap: enabled ? onTap : null,
  );
}

class _TableHeader extends StatelessWidget {
  final String label;
  const _TableHeader(this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
    ),
  );
}
