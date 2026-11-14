import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import 'auth_service.dart';
import 'invoice_print_settings.dart';
import 'models.dart';
import 'print_documents.dart';
import 'storage.dart';
import 'theme.dart';

class InvoicePrintDesignTab extends StatefulWidget {
  final UserSession session;
  final AccountingAuthService authService;

  const InvoicePrintDesignTab({
    super.key,
    required this.session,
    required this.authService,
  });

  @override
  State<InvoicePrintDesignTab> createState() => _InvoicePrintDesignTabState();
}

class _InvoicePrintDesignTabState extends State<InvoicePrintDesignTab> {
  final Map<int, InvoicePrintSettings> _settings = {};
  int _selectedType = 0;
  bool _loading = true;
  bool _saving = false;
  String? _status;
  bool _saved = false;

  InvoicePrintSettings get _current =>
      _settings[_selectedType] ?? const InvoicePrintSettings();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = <int, InvoicePrintSettings>{};
    for (var index = 0; index < invoiceTypes.length; index++) {
      loaded[index] = await Store.loadInvoicePrintSettings(index);
    }
    if (!mounted) return;
    setState(() {
      _settings.addAll(loaded);
      _loading = false;
    });
  }

  void _changeSettings(InvoicePrintSettings settings) {
    setState(() {
      _settings[_selectedType] = settings;
      _status = null;
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'printer.manage',
    )) {
      return;
    }
    setState(() {
      _saving = true;
      _status = null;
    });
    final success = await Store.saveInvoicePrintSettings(
      _selectedType,
      _current,
    );
    if (!mounted) return;
    setState(() {
      _saving = false;
      _saved = success;
      _status = success
          ? 'تم حفظ إعدادات ${invoiceTypes[_selectedType].ar} على هذا الجهاز.'
          : 'تعذر حفظ إعدادات الفاتورة.';
    });
  }

  Future<Uint8List> _previewPdf() {
    final type = invoiceTypes[_selectedType];
    return buildInvoicePdf(
      titleAr: type.ar,
      titleEn: type.en,
      invoiceNumber: '000045',
      invoiceDateTime: '14/11/2026 09:30 AM',
      deliveryDate: '14/11/2026',
      account: 'شركة تجريبية / Sample account',
      taxNumber: '310000000000003',
      taxStatus: 'خاضع للضريبة',
      taxStatusEn: 'Taxable',
      lines: const [
        InvoicePrintLine(
          name: 'صنف تجريبي',
          nameEn: 'Sample item',
          unit: 'قطعة',
          quantity: '2',
          unitPrice: '10.00',
          total: '20.00',
        ),
        InvoicePrintLine(
          name: 'منتج آخر',
          nameEn: 'Another product',
          unit: 'علبة',
          quantity: '1',
          unitPrice: '15.00',
          total: '15.00',
        ),
      ],
      totals: const [
        InvoicePrintTotal(
          'الإجمالي قبل الخصم',
          '35.00',
          labelEn: 'Gross before discount',
        ),
        InvoicePrintTotal('الضريبة', '5.25', labelEn: 'Tax'),
        InvoicePrintTotal('الصافي', '40.25', labelEn: 'Net', emphasized: true),
        InvoicePrintTotal('نقداً', '40.25', labelEn: 'Cash'),
        InvoicePrintTotal('المتبقي', '0.00', labelEn: 'Remaining'),
      ],
      notes: '',
      settings: _current,
    );
  }

  Widget _combo<T>({
    required String label,
    required T value,
    required List<(T, String)> choices,
    required ValueChanged<T?> onChanged,
    required String keyName,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(label, textAlign: TextAlign.right),
      const SizedBox(height: 5),
      SizedBox(
        height: 42,
        child: fluent.ComboBox<T>(
          key: ValueKey(keyName),
          value: value,
          isExpanded: true,
          items: [
            for (final choice in choices)
              fluent.ComboBoxItem<T>(value: choice.$1, child: Text(choice.$2)),
          ],
          onChanged: _saving ? null : onChanged,
        ),
      ),
    ],
  );

  Widget _settingsPanel() => Container(
    padding: const EdgeInsets.all(12),
    color: AppColors.cyan,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'إعداد مستقل لكل نوع فاتورة',
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 10),
        _combo<int>(
          label: 'نوع الفاتورة',
          keyName: 'invoice-print-type',
          value: _selectedType,
          choices: [
            for (var i = 0; i < invoiceTypes.length; i++)
              (i, '${invoiceTypes[i].ar} · ${invoiceTypes[i].en}'),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _selectedType = value);
          },
        ),
        const SizedBox(height: 10),
        _combo<InvoicePaperSize>(
          label: 'حجم الورق والاتجاه',
          keyName: 'invoice-paper-size',
          value: _current.paperSize,
          choices: const [
            (InvoicePaperSize.thermal58, 'حراري 58 مم'),
            (InvoicePaperSize.thermal80, 'حراري 80 مم'),
            (InvoicePaperSize.a4Portrait, 'A4 عمودي'),
            (InvoicePaperSize.a4Landscape, 'A4 أفقي'),
          ],
          onChanged: (value) {
            if (value != null) {
              _changeSettings(_current.copyWith(paperSize: value));
            }
          },
        ),
        const SizedBox(height: 10),
        _combo<InvoiceDesignStyle>(
          label: 'تصميم الفاتورة',
          keyName: 'invoice-design-style',
          value: _current.design,
          choices: const [
            (InvoiceDesignStyle.classic, 'كلاسيكي'),
            (InvoiceDesignStyle.compact, 'مضغوط'),
            (InvoiceDesignStyle.minimal, 'بسيط'),
            (InvoiceDesignStyle.highlighted, 'عنوان بارز'),
          ],
          onChanged: (value) {
            if (value != null) {
              _changeSettings(_current.copyWith(design: value));
            }
          },
        ),
        const SizedBox(height: 10),
        _combo<InvoicePrintLanguage>(
          label: 'لغة الطباعة',
          keyName: 'invoice-print-language',
          value: _current.language,
          choices: const [
            (InvoicePrintLanguage.arabic, 'العربية'),
            (InvoicePrintLanguage.english, 'English'),
            (InvoicePrintLanguage.bilingual, 'العربية والإنجليزية'),
          ],
          onChanged: (value) {
            if (value != null) {
              _changeSettings(_current.copyWith(language: value));
            }
          },
        ),
        const SizedBox(height: 12),
        fluent.FilledButton(
          key: const ValueKey('save-invoice-print-settings'),
          onPressed: _saving ? null : _save,
          child: _saving
              ? const fluent.ProgressRing(strokeWidth: 2)
              : const Text('حفظ إعدادات الفاتورة'),
        ),
        if (_status != null) ...[
          const SizedBox(height: 10),
          fluent.InfoBar(
            title: Text(_status!),
            severity: _saved
                ? fluent.InfoBarSeverity.success
                : fluent.InfoBarSeverity.error,
          ),
        ],
      ],
    ),
  );

  Widget _previewPanel() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: const Color(0xFFEFF1F3),
          child: Text(
            'معاينة: ${invoiceTypes[_selectedType].ar}',
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: PdfPreview(
            key: ValueKey(
              '$_selectedType-${_current.paperSize.name}-'
              '${_current.language.name}-${_current.design.name}',
            ),
            build: (_) => _previewPdf(),
            allowPrinting: false,
            allowSharing: false,
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
            useActions: false,
            maxPageWidth: 620,
            padding: const EdgeInsets.all(12),
            loadingWidget: const Center(child: fluent.ProgressRing()),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: fluent.ProgressRing());
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        if (wide) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 330,
                    child: SingleChildScrollView(child: _settingsPanel()),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _previewPanel()),
                ],
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                height: constraints.maxHeight.clamp(230, 330),
                child: SingleChildScrollView(child: _settingsPanel()),
              ),
              const SizedBox(height: 8),
              Expanded(child: _previewPanel()),
            ],
          ),
        );
      },
    );
  }
}
