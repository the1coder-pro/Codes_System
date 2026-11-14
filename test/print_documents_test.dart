import 'dart:convert';

import 'package:accounting_ui/invoice_print_settings.dart';
import 'package:accounting_ui/print_documents.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('invoice document exports as a PDF with rows and totals', () async {
    final bytes = await buildInvoicePdf(
      titleAr: 'فاتورة شراء',
      titleEn: 'Purchase Invoice',
      invoiceNumber: '000001',
      invoiceDateTime: '11/14/2026 8:30:00 AM',
      deliveryDate: '11/14/2026',
      account: 'عميل تجريبي',
      taxNumber: '12345',
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
      ],
      totals: const [
        InvoicePrintTotal('الصافي', '23.00', labelEn: 'Net', emphasized: true),
      ],
      notes: 'ملاحظة تجريبية',
      settings: const InvoicePrintSettings(),
    );
    expect(ascii.decode(bytes.take(4).toList()), '%PDF');
    expect(bytes.length, greaterThan(1000));
  });

  test('thermal bilingual invoice exports with receipt page size', () async {
    final bytes = await buildInvoicePdf(
      titleAr: 'فاتورة بيع',
      titleEn: 'Sales Invoice',
      invoiceNumber: '000045',
      invoiceDateTime: '11/14/2026 8:30 AM',
      deliveryDate: '',
      account: 'عميل',
      taxNumber: '',
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
      ],
      totals: const [
        InvoicePrintTotal('الصافي', '23.00', labelEn: 'Net', emphasized: true),
      ],
      notes: '',
      settings: const InvoicePrintSettings(
        paperSize: InvoicePaperSize.thermal58,
        language: InvoicePrintLanguage.bilingual,
        design: InvoiceDesignStyle.highlighted,
      ),
    );

    expect(ascii.decode(bytes.take(4).toList()), '%PDF');
    expect(bytes.length, greaterThan(1000));
  });

  test('A4 landscape English invoice exports as a PDF', () async {
    final bytes = await buildInvoicePdf(
      titleAr: 'فاتورة بيع',
      titleEn: 'Sales Invoice',
      invoiceNumber: '000046',
      invoiceDateTime: '11/14/2026 8:30 AM',
      deliveryDate: '11/14/2026',
      account: 'Sample account',
      taxNumber: '',
      taxStatus: 'غير خاضع للضريبة',
      taxStatusEn: 'Not taxable',
      lines: const [],
      totals: const [
        InvoicePrintTotal('الصافي', '0.00', labelEn: 'Net', emphasized: true),
      ],
      notes: '',
      settings: const InvoicePrintSettings(
        paperSize: InvoicePaperSize.a4Landscape,
        language: InvoicePrintLanguage.english,
      ),
    );

    expect(ascii.decode(bytes.take(4).toList()), '%PDF');
  });

  test('barcode label sheet exports as a PDF', () async {
    final bytes = await buildBarcodePdf(
      itemName: 'صنف تجريبي',
      code: '1234567890',
      copies: 4,
      template: 'استيكر السعر كبير 50 * 25 مل - 1',
      productionDate: DateTime(2026, 11, 14),
      expiryDate: DateTime(2027, 11, 14),
    );
    expect(ascii.decode(bytes.take(4).toList()), '%PDF');
    expect(bytes.length, greaterThan(1000));
  });
}
