import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;

import 'invoice_print_settings.dart';

const _mm = pdf.PdfPageFormat.mm;
const _pageMarginMm = 12.0;

class InvoicePrintLine {
  final String name;
  final String nameEn;
  final String unit;
  final String quantity;
  final String unitPrice;
  final String total;

  const InvoicePrintLine({
    required this.name,
    this.nameEn = '',
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}

class InvoicePrintTotal {
  final String label;
  final String labelEn;
  final String value;
  final bool emphasized;

  const InvoicePrintTotal(
    this.label,
    this.value, {
    this.labelEn = '',
    this.emphasized = false,
  });
}

class PrintFonts {
  final pw.Font regular;
  final pw.Font bold;

  const PrintFonts({required this.regular, required this.bold});

  static Future<PrintFonts> load() async {
    final regularData = await rootBundle.load(
      'assets/fonts/IBMPlexSansArabic-Regular.ttf',
    );
    final boldData = await rootBundle.load(
      'assets/fonts/IBMPlexSansArabic-Bold.ttf',
    );
    return PrintFonts(
      regular: pw.Font.ttf(regularData),
      bold: pw.Font.ttf(boldData),
    );
  }

  pw.ThemeData get theme => pw.ThemeData.withFont(base: regular, bold: bold);
}

Future<Uint8List> buildInvoicePdf({
  required String titleAr,
  required String titleEn,
  required String invoiceNumber,
  required String invoiceDateTime,
  required String deliveryDate,
  required String account,
  required String taxNumber,
  required String taxStatus,
  required List<InvoicePrintLine> lines,
  required List<InvoicePrintTotal> totals,
  required String notes,
  required String taxStatusEn,
  required InvoicePrintSettings settings,
}) async {
  final fonts = await PrintFonts.load();
  final document = pw.Document(theme: fonts.theme);
  if (settings.isThermal) {
    final height = settings.thermalHeightMm(
      lines.length,
      notesLength: notes.length,
    );
    document.addPage(
      pw.Page(
        pageFormat: pdf.PdfPageFormat(
          settings.paperWidthMm * _mm,
          height * _mm,
        ),
        margin: pw.EdgeInsets.symmetric(
          horizontal: (settings.paperWidthMm == 58 ? 3 : 4) * _mm,
          vertical: 4 * _mm,
        ),
        build: (context) => _thermalInvoice(
          titleAr: titleAr,
          titleEn: titleEn,
          invoiceNumber: invoiceNumber,
          invoiceDateTime: invoiceDateTime,
          deliveryDate: deliveryDate,
          account: account,
          taxNumber: taxNumber,
          taxStatus: taxStatus,
          taxStatusEn: taxStatusEn,
          lines: lines,
          totals: totals,
          notes: notes,
          fonts: fonts,
          settings: settings,
        ),
      ),
    );
    return document.save();
  }

  final rowsPerPage = _hasBusinessBranding(settings)
      ? (settings.paperSize == InvoicePaperSize.a4Landscape ? 19 : 12)
      : (settings.paperSize == InvoicePaperSize.a4Landscape ? 24 : 16);
  final pageCount = (lines.length / rowsPerPage).ceil().clamp(1, 1000);
  final format = settings.paperSize == InvoicePaperSize.a4Landscape
      ? pdf.PdfPageFormat.a4.landscape
      : pdf.PdfPageFormat.a4;

  for (var pageIndex = 0; pageIndex < pageCount; pageIndex++) {
    final pageLines = lines.skip(pageIndex * rowsPerPage).take(rowsPerPage);
    final isFirstPage = pageIndex == 0;
    final isLastPage = pageIndex == pageCount - 1;
    document.addPage(
      pw.Page(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(_pageMarginMm * _mm),
        build: (context) => pw.Directionality(
          textDirection: _textDirection(settings.language),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              if (isFirstPage && _hasBusinessBranding(settings)) ...[
                _businessBranding(settings, fonts, thermal: false),
                pw.SizedBox(height: 12),
              ],
              _invoiceHeading(
                titleAr,
                titleEn,
                invoiceNumber,
                fonts,
                settings: settings,
                compact: !isFirstPage,
              ),
              if (isFirstPage) ...[
                pw.SizedBox(height: 10),
                _invoiceDetails(
                  [
                    (
                      _label('رقم الفاتورة', 'Invoice No.', settings),
                      invoiceNumber,
                    ),
                    (
                      _label(
                        'تاريخ ووقت الفاتورة',
                        'Invoice date & time',
                        settings,
                      ),
                      invoiceDateTime,
                    ),
                    (
                      _label('تاريخ التسليم', 'Delivery date', settings),
                      deliveryDate,
                    ),
                    (_label('اسم الحساب', 'Account', settings), account),
                    (
                      _label('الرقم الضريبي', 'Tax number', settings),
                      taxNumber,
                    ),
                    (
                      _label('حالة الضريبة', 'Tax status', settings),
                      _label(taxStatus, taxStatusEn, settings),
                    ),
                  ],
                  fonts,
                  settings,
                ),
                pw.SizedBox(height: 14),
              ] else
                pw.SizedBox(height: 12),
              _invoiceTable(
                pageLines.toList(),
                fonts,
                settings: settings,
                startIndex: pageIndex * rowsPerPage,
              ),
              if (isLastPage) ...[
                pw.SizedBox(height: 12),
                _invoiceTotals(totals, fonts, settings),
                if (notes.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 12),
                  pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        top: pw.BorderSide(color: pdf.PdfColors.blueGrey),
                      ),
                    ),
                    child: pw.RichText(
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                            text: '${_label('ملاحظات', 'Notes', settings)}: ',
                            style: pw.TextStyle(font: fonts.bold, fontSize: 10),
                          ),
                          pw.TextSpan(
                            text: notes.trim(),
                            style: pw.TextStyle(
                              font: fonts.regular,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (settings.receiptFooter.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 14),
                  pw.Text(
                    settings.receiptFooter.trim(),
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: fonts.regular,
                      fontSize: 9,
                      color: pdf.PdfColors.blueGrey,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
  return document.save();
}

pw.Widget _thermalInvoice({
  required String titleAr,
  required String titleEn,
  required String invoiceNumber,
  required String invoiceDateTime,
  required String deliveryDate,
  required String account,
  required String taxNumber,
  required String taxStatus,
  required String taxStatusEn,
  required List<InvoicePrintLine> lines,
  required List<InvoicePrintTotal> totals,
  required String notes,
  required PrintFonts fonts,
  required InvoicePrintSettings settings,
}) {
  final accent = settings.design == InvoiceDesignStyle.highlighted
      ? pdf.PdfColors.blue700
      : pdf.PdfColors.grey800;
  final dense = settings.design == InvoiceDesignStyle.compact;
  final title = settings.language == InvoicePrintLanguage.english
      ? titleEn
      : titleAr;
  final details = <(String, String)>[
    (_label('رقم الفاتورة', 'Invoice No.', settings), invoiceNumber),
    (_label('التاريخ والوقت', 'Date & time', settings), invoiceDateTime),
    if (deliveryDate.trim().isNotEmpty)
      (_label('التسليم', 'Delivery', settings), deliveryDate),
    if (account.trim().isNotEmpty)
      (_label('الحساب', 'Account', settings), account),
    if (taxNumber.trim().isNotEmpty)
      (_label('الرقم الضريبي', 'Tax No.', settings), taxNumber),
    (
      _label('الضريبة', 'Tax', settings),
      _label(taxStatus, taxStatusEn, settings),
    ),
  ];
  return pw.Directionality(
    textDirection: _textDirection(settings.language),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        if (_hasBusinessBranding(settings)) ...[
          _businessBranding(settings, fonts, thermal: true),
          pw.SizedBox(height: dense ? 3 : 5),
        ],
        pw.Container(
          padding: pw.EdgeInsets.symmetric(
            vertical: dense ? 3 : 6,
            horizontal: dense ? 2 : 4,
          ),
          decoration: settings.design == InvoiceDesignStyle.highlighted
              ? pw.BoxDecoration(
                  color: accent,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(3),
                  ),
                )
              : null,
          child: pw.Column(
            children: [
              pw.Text(
                title,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: fonts.bold,
                  fontSize: settings.paperWidthMm == 58 ? 12 : 15,
                  color: settings.design == InvoiceDesignStyle.highlighted
                      ? pdf.PdfColors.white
                      : accent,
                ),
              ),
              if (settings.language == InvoicePrintLanguage.bilingual) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  titleEn,
                  textDirection: pw.TextDirection.ltr,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: fonts.regular,
                    fontSize: 8,
                    color: settings.design == InvoiceDesignStyle.highlighted
                        ? pdf.PdfColors.white
                        : accent,
                  ),
                ),
              ],
            ],
          ),
        ),
        pw.SizedBox(height: dense ? 4 : 7),
        _receiptDivider(accent),
        for (final detail in details)
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: dense ? 1 : 2),
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    detail.$1,
                    style: pw.TextStyle(
                      font: fonts.regular,
                      fontSize: dense ? 7 : 8,
                      color: pdf.PdfColors.grey700,
                    ),
                  ),
                ),
                pw.SizedBox(width: 4),
                pw.Flexible(
                  child: pw.Text(
                    detail.$2,
                    textAlign: settings.language == InvoicePrintLanguage.english
                        ? pw.TextAlign.left
                        : pw.TextAlign.right,
                    style: pw.TextStyle(
                      font: fonts.bold,
                      fontSize: dense ? 7 : 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        pw.SizedBox(height: dense ? 3 : 5),
        _receiptDivider(accent),
        for (var index = 0; index < lines.length; index++)
          _thermalLine(lines[index], index, fonts, settings),
        _receiptDivider(accent),
        pw.SizedBox(height: dense ? 3 : 5),
        for (final total in totals) _thermalTotal(total, fonts, settings),
        if (notes.trim().isNotEmpty) ...[
          pw.SizedBox(height: dense ? 4 : 7),
          _receiptDivider(accent),
          pw.Text(
            '${_label('ملاحظات', 'Notes', settings)}: ${notes.trim()}',
            textAlign: settings.language == InvoicePrintLanguage.english
                ? pw.TextAlign.left
                : pw.TextAlign.right,
            style: pw.TextStyle(font: fonts.regular, fontSize: dense ? 7 : 8),
          ),
        ],
        pw.SizedBox(height: dense ? 5 : 9),
        _receiptDivider(accent),
        pw.SizedBox(height: dense ? 3 : 5),
        pw.Text(
          _label('شكراً لكم', 'Thank you', settings),
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: fonts.bold, fontSize: dense ? 8 : 9),
        ),
        if (settings.receiptFooter.trim().isNotEmpty) ...[
          pw.SizedBox(height: dense ? 3 : 5),
          pw.Text(
            settings.receiptFooter.trim(),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: fonts.regular, fontSize: dense ? 7 : 8),
          ),
        ],
      ],
    ),
  );
}

bool _hasBusinessBranding(InvoicePrintSettings settings) =>
    settings.businessName.trim().isNotEmpty ||
    settings.businessAddress.trim().isNotEmpty ||
    settings.businessPhone.trim().isNotEmpty ||
    settings.businessEmail.trim().isNotEmpty ||
    settings.logoBase64.trim().isNotEmpty;

pw.Widget _businessBranding(
  InvoicePrintSettings settings,
  PrintFonts fonts, {
  required bool thermal,
}) {
  final textStyle = pw.TextStyle(
    font: fonts.regular,
    fontSize: thermal ? 7 : 9,
    color: pdf.PdfColors.blueGrey,
  );
  final logo = _businessLogo(settings, thermal: thermal);
  final details = <String>[
    if (settings.businessAddress.trim().isNotEmpty)
      settings.businessAddress.trim(),
    if (settings.businessPhone.trim().isNotEmpty) settings.businessPhone.trim(),
    if (settings.businessEmail.trim().isNotEmpty) settings.businessEmail.trim(),
  ];
  if (thermal) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        if (logo != null) ...[pw.Center(child: logo), pw.SizedBox(height: 2)],
        if (settings.businessName.trim().isNotEmpty)
          pw.Text(
            settings.businessName.trim(),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: settings.paperSize == InvoicePaperSize.thermal58
                  ? 10
                  : 12,
            ),
          ),
        for (final detail in details)
          pw.Text(detail, textAlign: pw.TextAlign.center, style: textStyle),
      ],
    );
  }
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      if (logo != null) ...[logo, pw.SizedBox(width: 12)],
      pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            if (settings.businessName.trim().isNotEmpty)
              pw.Text(
                settings.businessName.trim(),
                textAlign: settings.language == InvoicePrintLanguage.english
                    ? pw.TextAlign.left
                    : pw.TextAlign.right,
                style: pw.TextStyle(font: fonts.bold, fontSize: 14),
              ),
            for (final detail in details)
              pw.Text(
                detail,
                textAlign: settings.language == InvoicePrintLanguage.english
                    ? pw.TextAlign.left
                    : pw.TextAlign.right,
                style: textStyle,
              ),
          ],
        ),
      ),
    ],
  );
}

pw.Widget? _businessLogo(
  InvoicePrintSettings settings, {
  required bool thermal,
}) {
  final encoded = settings.logoBase64.trim();
  if (encoded.isEmpty) return null;
  try {
    return pw.Image(
      pw.MemoryImage(base64Decode(encoded)),
      width: thermal ? 34 : 64,
      height: thermal ? 24 : 48,
      fit: pw.BoxFit.contain,
    );
  } on FormatException {
    return null;
  }
}

pw.Widget _thermalLine(
  InvoicePrintLine line,
  int index,
  PrintFonts fonts,
  InvoicePrintSettings settings,
) {
  final name = _itemName(line, settings);
  final unit = _unitName(line.unit, settings);
  final dense = settings.design == InvoiceDesignStyle.compact;
  return pw.Container(
    padding: pw.EdgeInsets.symmetric(vertical: dense ? 2 : 4),
    decoration: settings.design == InvoiceDesignStyle.minimal
        ? null
        : const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: pdf.PdfColors.grey300, width: 0.4),
            ),
          ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Text(
          '${index + 1}. $name',
          textAlign: settings.language == InvoicePrintLanguage.english
              ? pw.TextAlign.left
              : pw.TextAlign.right,
          style: pw.TextStyle(
            font: fonts.bold,
            fontSize: settings.paperWidthMm == 58 ? 8 : 9,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(
                '$unit  ${line.quantity} × ${line.unitPrice}',
                style: pw.TextStyle(
                  font: fonts.regular,
                  fontSize: dense ? 7 : 8,
                ),
              ),
            ),
            pw.Text(
              line.total,
              style: pw.TextStyle(font: fonts.bold, fontSize: dense ? 7 : 8),
            ),
          ],
        ),
      ],
    ),
  );
}

pw.Widget _thermalTotal(
  InvoicePrintTotal total,
  PrintFonts fonts,
  InvoicePrintSettings settings,
) => pw.Container(
  padding: const pw.EdgeInsets.symmetric(vertical: 2),
  decoration: total.emphasized
      ? const pw.BoxDecoration(
          border: pw.Border(
            top: pw.BorderSide(color: pdf.PdfColors.black, width: 0.8),
          ),
        )
      : null,
  child: pw.Row(
    children: [
      pw.Expanded(
        child: pw.Text(
          _label(total.label, total.labelEn, settings),
          style: pw.TextStyle(
            font: total.emphasized ? fonts.bold : fonts.regular,
            fontSize: total.emphasized ? 10 : 8,
          ),
        ),
      ),
      pw.Text(
        total.value,
        style: pw.TextStyle(
          font: fonts.bold,
          fontSize: total.emphasized ? 11 : 8,
        ),
      ),
    ],
  ),
);

pw.Widget _receiptDivider(pdf.PdfColor color) =>
    pw.Container(height: 0.7, color: color);

String _label(String arabic, String english, InvoicePrintSettings settings) =>
    switch (settings.language) {
      InvoicePrintLanguage.arabic => arabic,
      InvoicePrintLanguage.english => english,
      InvoicePrintLanguage.bilingual => '$arabic / $english',
    };

String _itemName(InvoicePrintLine line, InvoicePrintSettings settings) {
  final english = line.nameEn.trim().isEmpty ? line.name : line.nameEn;
  return _label(line.name, english, settings);
}

String _unitName(String unit, InvoicePrintSettings settings) {
  const translations = {
    'حبة': 'piece',
    'قطعة': 'piece',
    'كرتون': 'carton',
    'كجم': 'kg',
    'كيلو': 'kg',
    'جرام': 'g',
    'لتر': 'liter',
    'مل': 'ml',
    'متر': 'meter',
    'علبة': 'box',
    'عبوة': 'bottle',
    'كيس': 'bag',
    'صندوق': 'box',
    'يوم': 'day',
    'ساعة': 'hour',
    'خدمة': 'service',
  };
  return _label(unit, translations[unit] ?? unit, settings);
}

pw.TextDirection _textDirection(InvoicePrintLanguage language) =>
    language == InvoicePrintLanguage.english
    ? pw.TextDirection.ltr
    : pw.TextDirection.rtl;

pw.Widget _invoiceHeading(
  String titleAr,
  String titleEn,
  String invoiceNumber,
  PrintFonts fonts, {
  required InvoicePrintSettings settings,
  required bool compact,
}) => pw.Column(
  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
  children: [
    pw.Text(
      settings.language == InvoicePrintLanguage.english ? titleEn : titleAr,
      textAlign: settings.language == InvoicePrintLanguage.english
          ? pw.TextAlign.left
          : pw.TextAlign.right,
      style: pw.TextStyle(
        font: fonts.bold,
        fontSize: compact ? 15 : 22,
        color: settings.design == InvoiceDesignStyle.highlighted
            ? pdf.PdfColors.blue700
            : pdf.PdfColors.black,
      ),
    ),
    if (settings.language == InvoicePrintLanguage.bilingual)
      pw.Text(
        titleEn,
        textAlign: pw.TextAlign.left,
        textDirection: pw.TextDirection.ltr,
        style: pw.TextStyle(
          font: fonts.regular,
          fontSize: compact ? 8 : 10,
          color: pdf.PdfColors.blueGrey,
        ),
      ),
    if (compact)
      pw.Text(
        '${_label('رقم الفاتورة', 'Invoice No.', settings)}: $invoiceNumber',
        textAlign: settings.language == InvoicePrintLanguage.english
            ? pw.TextAlign.left
            : pw.TextAlign.right,
        style: pw.TextStyle(font: fonts.bold, fontSize: 9),
      ),
  ],
);

pw.Widget _invoiceDetails(
  List<(String, String)> details,
  PrintFonts fonts,
  InvoicePrintSettings settings,
) => pw.Container(
  padding: const pw.EdgeInsets.all(10),
  decoration: pw.BoxDecoration(
    border: pw.Border.all(
      color: settings.design == InvoiceDesignStyle.highlighted
          ? pdf.PdfColors.blue700
          : pdf.PdfColors.blueGrey,
      width: settings.design == InvoiceDesignStyle.compact ? 0.4 : 0.7,
    ),
    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
  ),
  child: pw.Table(
    columnWidths: const {0: pw.FlexColumnWidth(1), 1: pw.FlexColumnWidth(1)},
    children: [
      for (var i = 0; i < details.length; i += 2)
        pw.TableRow(
          children: settings.language == InvoicePrintLanguage.english
              ? [
                  _detailCell(details[i], fonts, settings),
                  _detailCell(details[i + 1], fonts, settings),
                ]
              : [
                  _detailCell(details[i + 1], fonts, settings),
                  _detailCell(details[i], fonts, settings),
                ],
        ),
    ],
  ),
);

pw.Widget _detailCell(
  (String, String) detail,
  PrintFonts fonts,
  InvoicePrintSettings settings,
) => pw.Padding(
  padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 5),
  child: pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      pw.Text(
        detail.$1,
        textAlign: settings.language == InvoicePrintLanguage.english
            ? pw.TextAlign.left
            : pw.TextAlign.right,
        style: pw.TextStyle(
          font: fonts.regular,
          fontSize: 8,
          color: pdf.PdfColors.blueGrey,
        ),
      ),
      pw.SizedBox(height: 2),
      pw.Text(
        detail.$2.trim().isEmpty ? '—' : detail.$2,
        textAlign: settings.language == InvoicePrintLanguage.english
            ? pw.TextAlign.left
            : pw.TextAlign.right,
        style: pw.TextStyle(font: fonts.bold, fontSize: 9),
      ),
    ],
  ),
);

pw.Widget _invoiceTable(
  List<InvoicePrintLine> lines,
  PrintFonts fonts, {
  required InvoicePrintSettings settings,
  required int startIndex,
}) {
  final labels = [
    _label('م', 'No.', settings),
    _label('اسم الصنف', 'Item', settings),
    _label('الوحدة', 'Unit', settings),
    _label('الكمية', 'Quantity', settings),
    _label('سعر الوحدة قبل الضريبة', 'Unit price before tax', settings),
    _label('الإجمالي قبل الضريبة', 'Total before tax', settings),
  ];
  final headers = settings.language == InvoicePrintLanguage.english
      ? labels
      : labels.reversed.toList();
  final headerCells = headers.map((label) {
    return _tableCell(
      label,
      fonts,
      isHeader: true,
      settings: settings,
      alignment: pw.TextAlign.center,
    );
  }).toList();
  final rows = <pw.TableRow>[];
  final headerColor = switch (settings.design) {
    InvoiceDesignStyle.classic => pdf.PdfColors.blue100,
    InvoiceDesignStyle.compact => pdf.PdfColors.grey200,
    InvoiceDesignStyle.minimal => pdf.PdfColors.white,
    InvoiceDesignStyle.highlighted => pdf.PdfColors.blue700,
  };
  rows.add(
    pw.TableRow(
      decoration: pw.BoxDecoration(color: headerColor),
      children: headerCells,
    ),
  );
  for (var index = 0; index < lines.length; index++) {
    final line = lines[index];
    final values = settings.language == InvoicePrintLanguage.english
        ? [
            '${startIndex + index + 1}',
            _itemName(line, settings),
            _unitName(line.unit, settings),
            line.quantity,
            line.unitPrice,
            line.total,
          ]
        : [
            line.total,
            line.unitPrice,
            line.quantity,
            _unitName(line.unit, settings),
            _itemName(line, settings),
            '${startIndex + index + 1}',
          ];
    rows.add(
      pw.TableRow(
        decoration: index.isOdd && settings.design != InvoiceDesignStyle.minimal
            ? const pw.BoxDecoration(color: pdf.PdfColors.grey100)
            : null,
        children: values
            .map((value) => _tableCell(value, fonts, settings: settings))
            .toList(),
      ),
    );
  }
  return pw.Table(
    border: settings.design == InvoiceDesignStyle.minimal
        ? pw.TableBorder(
            horizontalInside: pw.BorderSide(
              color: pdf.PdfColors.grey400,
              width: 0.35,
            ),
          )
        : pw.TableBorder.all(
            color: settings.design == InvoiceDesignStyle.highlighted
                ? pdf.PdfColors.blueGrey
                : pdf.PdfColors.blueGrey,
            width: settings.design == InvoiceDesignStyle.compact ? 0.3 : 0.5,
          ),
    columnWidths: const {
      0: pw.FlexColumnWidth(1.15),
      1: pw.FlexColumnWidth(1.25),
      2: pw.FlexColumnWidth(0.65),
      3: pw.FlexColumnWidth(0.8),
      4: pw.FlexColumnWidth(2.8),
      5: pw.FlexColumnWidth(0.45),
    },
    children: rows,
  );
}

pw.Widget _tableCell(
  String value,
  PrintFonts fonts, {
  required InvoicePrintSettings settings,
  bool isHeader = false,
  pw.TextAlign alignment = pw.TextAlign.right,
}) => pw.Padding(
  padding: pw.EdgeInsets.symmetric(
    vertical: settings.design == InvoiceDesignStyle.compact ? 2 : 5,
    horizontal: settings.design == InvoiceDesignStyle.compact ? 2 : 4,
  ),
  child: pw.Text(
    value,
    textAlign: alignment,
    maxLines: isHeader ? 3 : 2,
    style: pw.TextStyle(
      font: isHeader || settings.design == InvoiceDesignStyle.highlighted
          ? fonts.bold
          : fonts.regular,
      color: isHeader && settings.design == InvoiceDesignStyle.highlighted
          ? pdf.PdfColors.white
          : null,
      fontSize: isHeader ? 7.3 : 8.2,
    ),
  ),
);

pw.Widget _invoiceTotals(
  List<InvoicePrintTotal> totals,
  PrintFonts fonts,
  InvoicePrintSettings settings,
) => pw.Align(
  alignment: pw.Alignment.centerLeft,
  child: pw.Container(
    width: 280,
    child: pw.Column(
      children: [
        for (final total in totals)
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 3),
            decoration: total.emphasized
                ? const pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(
                        color: pdf.PdfColors.blueGrey,
                        width: 1.2,
                      ),
                    ),
                  )
                : null,
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    _label(total.label, total.labelEn, settings),
                    textAlign: settings.language == InvoicePrintLanguage.english
                        ? pw.TextAlign.left
                        : pw.TextAlign.right,
                    style: pw.TextStyle(
                      font: total.emphasized ? fonts.bold : fonts.regular,
                      fontSize: total.emphasized ? 11 : 8.5,
                    ),
                  ),
                ),
                pw.Text(
                  total.value,
                  style: pw.TextStyle(
                    font: fonts.bold,
                    fontSize: total.emphasized ? 12 : 8.5,
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  ),
);

Future<Uint8List> buildBarcodePdf({
  required String itemName,
  required String code,
  required int copies,
  required String template,
  required DateTime productionDate,
  required DateTime expiryDate,
}) async {
  final fonts = await PrintFonts.load();
  final document = pw.Document(theme: fonts.theme);
  final (labelWidthMm, labelHeightMm, columns) = switch (template) {
    'استيكر السعر صغير 20 * 35 مل - 2' => (35.0, 20.0, 4),
    'بطاقة رف 30 * 60 مل - 3' => (60.0, 30.0, 2),
    _ => (50.0, 25.0, 3),
  };
  const pageHeightMm = 297.0;
  const marginMm = _pageMarginMm;
  const gapMm = 3.0;
  final rows =
      ((pageHeightMm - (2 * marginMm) + gapMm) / (labelHeightMm + gapMm))
          .floor();
  final perPage = columns * rows;
  final pageCount = (copies / perPage).ceil();

  for (var pageIndex = 0; pageIndex < pageCount; pageIndex++) {
    final start = pageIndex * perPage;
    final end = (start + perPage).clamp(0, copies);
    final pageCopies = end - start;
    final pageRows = (pageCopies / columns).ceil();
    document.addPage(
      pw.Page(
        pageFormat: pdf.PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(marginMm * _mm),
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (var row = 0; row < pageRows; row++) ...[
                if (row > 0) pw.SizedBox(height: gapMm * _mm),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    for (var column = 0; column < columns; column++) ...[
                      if (column > 0) pw.SizedBox(width: gapMm * _mm),
                      if ((row * columns) + column < pageCopies)
                        _barcodeLabel(
                          itemName: itemName,
                          code: code,
                          widthMm: labelWidthMm,
                          heightMm: labelHeightMm,
                          productionDate: productionDate,
                          expiryDate: expiryDate,
                          fonts: fonts,
                        )
                      else
                        pw.SizedBox(
                          width: labelWidthMm * _mm,
                          height: labelHeightMm * _mm,
                        ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  return document.save();
}

pw.Widget _barcodeLabel({
  required String itemName,
  required String code,
  required double widthMm,
  required double heightMm,
  required DateTime productionDate,
  required DateTime expiryDate,
  required PrintFonts fonts,
}) => pw.Container(
  width: widthMm * _mm,
  height: heightMm * _mm,
  padding: const pw.EdgeInsets.symmetric(
    horizontal: 2 * _mm,
    vertical: 1 * _mm,
  ),
  decoration: pw.BoxDecoration(
    border: pw.Border.all(color: pdf.PdfColors.grey500, width: 0.4),
  ),
  child: pw.Column(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(
        itemName,
        maxLines: 1,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(font: fonts.regular, fontSize: 7),
      ),
      pw.SizedBox(
        height: 7 * _mm,
        width: widthMm * _mm - 4 * _mm,
        child: _code39Bars(code, widthMm * _mm - 4 * _mm),
      ),
      pw.Text(
        code,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(font: fonts.regular, fontSize: 6),
      ),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'إنتاج ${_formatDate(productionDate)}',
            style: pw.TextStyle(font: fonts.regular, fontSize: 4.4),
          ),
          pw.Text(
            'انتهاء ${_formatDate(expiryDate)}',
            style: pw.TextStyle(font: fonts.regular, fontSize: 4.4),
          ),
        ],
      ),
    ],
  ),
);

pw.Widget _code39Bars(String code, double width) {
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
  var units = 0;
  for (var symbolIndex = 0; symbolIndex < symbols.length; symbolIndex++) {
    final pattern = patterns[symbols[symbolIndex]]!;
    for (final module in pattern.split('')) {
      units += module == 'w' ? 5 : 2;
    }
    if (symbolIndex < symbols.length - 1) units += 2;
  }
  final narrowWidth = width / units;
  final bars = <pw.Widget>[];
  for (var symbolIndex = 0; symbolIndex < symbols.length; symbolIndex++) {
    final pattern = patterns[symbols[symbolIndex]]!;
    for (var index = 0; index < pattern.length; index++) {
      final moduleWidth = pattern[index] == 'w' ? 5.0 : 2.0;
      if (index.isEven) {
        bars.add(
          pw.Container(
            width: narrowWidth * moduleWidth,
            height: 7 * _mm,
            color: pdf.PdfColors.black,
          ),
        );
      } else {
        bars.add(pw.SizedBox(width: narrowWidth * moduleWidth));
      }
    }
    if (symbolIndex < symbols.length - 1) {
      bars.add(pw.SizedBox(width: narrowWidth * 2));
    }
  }
  return pw.Row(children: bars);
}

String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
