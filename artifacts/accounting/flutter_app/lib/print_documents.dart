import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;

const _mm = pdf.PdfPageFormat.mm;
const _pageMarginMm = 12.0;

class InvoicePrintLine {
  final String name;
  final String unit;
  final String quantity;
  final String unitPrice;
  final String total;

  const InvoicePrintLine({
    required this.name,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}

class InvoicePrintTotal {
  final String label;
  final String value;
  final bool emphasized;

  const InvoicePrintTotal(this.label, this.value, {this.emphasized = false});
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
}) async {
  final fonts = await PrintFonts.load();
  final document = pw.Document(theme: fonts.theme);
  const rowsPerPage = 16;
  final pageCount = (lines.length / rowsPerPage).ceil().clamp(1, 1000);

  for (var pageIndex = 0; pageIndex < pageCount; pageIndex++) {
    final pageLines = lines.skip(pageIndex * rowsPerPage).take(rowsPerPage);
    final isFirstPage = pageIndex == 0;
    final isLastPage = pageIndex == pageCount - 1;
    document.addPage(
      pw.Page(
        pageFormat: pdf.PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(_pageMarginMm * _mm),
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _invoiceHeading(
                titleAr,
                titleEn,
                invoiceNumber,
                fonts,
                compact: !isFirstPage,
              ),
              if (isFirstPage) ...[
                pw.SizedBox(height: 10),
                _invoiceDetails([
                  ('رقم الفاتورة', invoiceNumber),
                  ('تاريخ ووقت الفاتورة', invoiceDateTime),
                  ('تاريخ التسليم', deliveryDate),
                  ('اسم الحساب', account),
                  ('الرقم الضريبي', taxNumber),
                  ('حالة الضريبة', taxStatus),
                ], fonts),
                pw.SizedBox(height: 14),
              ] else
                pw.SizedBox(height: 12),
              _invoiceTable(
                pageLines.toList(),
                fonts,
                startIndex: pageIndex * rowsPerPage,
              ),
              if (isLastPage) ...[
                pw.SizedBox(height: 12),
                _invoiceTotals(totals, fonts),
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
                            text: 'ملاحظات: ',
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
              ],
            ],
          ),
        ),
      ),
    );
  }
  return document.save();
}

pw.Widget _invoiceHeading(
  String titleAr,
  String titleEn,
  String invoiceNumber,
  PrintFonts fonts, {
  required bool compact,
}) => pw.Column(
  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
  children: [
    pw.Text(
      titleAr,
      textAlign: pw.TextAlign.right,
      style: pw.TextStyle(font: fonts.bold, fontSize: compact ? 15 : 22),
    ),
    pw.Row(
      children: [
        pw.Expanded(
          child: pw.Text(
            titleEn,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              font: fonts.regular,
              fontSize: compact ? 8 : 10,
              color: pdf.PdfColors.blueGrey,
            ),
          ),
        ),
        if (compact)
          pw.Text(
            'رقم الفاتورة: $invoiceNumber',
            style: pw.TextStyle(font: fonts.bold, fontSize: 9),
          ),
      ],
    ),
  ],
);

pw.Widget _invoiceDetails(List<(String, String)> details, PrintFonts fonts) =>
    pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: pdf.PdfColors.blueGrey, width: 0.7),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Table(
        columnWidths: const {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(1),
        },
        children: [
          for (var i = 0; i < details.length; i += 2)
            pw.TableRow(
              children: [
                _detailCell(details[i + 1], fonts),
                _detailCell(details[i], fonts),
              ],
            ),
        ],
      ),
    );

pw.Widget _detailCell((String, String) detail, PrintFonts fonts) => pw.Padding(
  padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 5),
  child: pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      pw.Text(
        detail.$1,
        textAlign: pw.TextAlign.right,
        style: pw.TextStyle(
          font: fonts.regular,
          fontSize: 8,
          color: pdf.PdfColors.blueGrey,
        ),
      ),
      pw.SizedBox(height: 2),
      pw.Text(
        detail.$2.trim().isEmpty ? '—' : detail.$2,
        textAlign: pw.TextAlign.right,
        style: pw.TextStyle(font: fonts.bold, fontSize: 9),
      ),
    ],
  ),
);

pw.Widget _invoiceTable(
  List<InvoicePrintLine> lines,
  PrintFonts fonts, {
  required int startIndex,
}) {
  const labels = [
    'م',
    'اسم الصنف',
    'الوحدة',
    'الكمية',
    'سعر الوحدة قبل الضريبة',
    'الإجمالي قبل الضريبة',
  ];
  final headerCells = labels.reversed.map((label) {
    return _tableCell(
      label,
      fonts,
      isHeader: true,
      alignment: pw.TextAlign.center,
    );
  }).toList();
  final rows = <pw.TableRow>[
    pw.TableRow(
      decoration: const pw.BoxDecoration(color: pdf.PdfColors.blue100),
      children: headerCells,
    ),
    for (var index = 0; index < lines.length; index++)
      pw.TableRow(
        decoration: index.isOdd
            ? const pw.BoxDecoration(color: pdf.PdfColors.grey100)
            : null,
        children: [
          lines[index].total,
          lines[index].unitPrice,
          lines[index].quantity,
          lines[index].unit,
          lines[index].name,
          '${startIndex + index + 1}',
        ].map((value) => _tableCell(value, fonts)).toList(),
      ),
  ];
  return pw.Table(
    border: pw.TableBorder.all(color: pdf.PdfColors.blueGrey, width: 0.5),
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
  bool isHeader = false,
  pw.TextAlign alignment = pw.TextAlign.right,
}) => pw.Padding(
  padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 4),
  child: pw.Text(
    value,
    textAlign: alignment,
    maxLines: isHeader ? 3 : 2,
    style: pw.TextStyle(
      font: isHeader ? fonts.bold : fonts.regular,
      fontSize: isHeader ? 7.3 : 8.2,
    ),
  ),
);

pw.Widget _invoiceTotals(List<InvoicePrintTotal> totals, PrintFonts fonts) =>
    pw.Align(
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
                        total.label,
                        textAlign: pw.TextAlign.right,
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
