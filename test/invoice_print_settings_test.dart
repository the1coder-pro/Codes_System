import 'package:accounting_ui/invoice_print_settings.dart';
import 'package:accounting_ui/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('persists separate print layouts for each invoice type', () async {
    SharedPreferences.setMockInitialValues({});
    const thermal = InvoicePrintSettings(
      paperSize: InvoicePaperSize.thermal80,
      language: InvoicePrintLanguage.bilingual,
      design: InvoiceDesignStyle.highlighted,
    );
    const landscape = InvoicePrintSettings(
      paperSize: InvoicePaperSize.a4Landscape,
      language: InvoicePrintLanguage.english,
      design: InvoiceDesignStyle.minimal,
    );

    expect(await Store.saveInvoicePrintSettings(0, thermal), isTrue);
    expect(await Store.saveInvoicePrintSettings(1, landscape), isTrue);

    final savedThermal = await Store.loadInvoicePrintSettings(0);
    final savedLandscape = await Store.loadInvoicePrintSettings(1);
    expect(savedThermal.paperSize, InvoicePaperSize.thermal80);
    expect(savedThermal.language, InvoicePrintLanguage.bilingual);
    expect(savedThermal.design, InvoiceDesignStyle.highlighted);
    expect(savedLandscape.paperSize, InvoicePaperSize.a4Landscape);
    expect(savedLandscape.language, InvoicePrintLanguage.english);
    expect(savedLandscape.design, InvoiceDesignStyle.minimal);
    expect(
      (await Store.loadInvoicePrintSettings(2)).paperSize,
      InvoicePaperSize.a4Portrait,
    );
  });

  test('exposes receipt and A4 print dimensions', () {
    const receipt = InvoicePrintSettings(paperSize: InvoicePaperSize.thermal58);
    const portrait = InvoicePrintSettings();
    const landscape = InvoicePrintSettings(
      paperSize: InvoicePaperSize.a4Landscape,
    );

    expect(receipt.isThermal, isTrue);
    expect(receipt.paperWidthMm, 58);
    expect(receipt.paperHeightMmFor(3), greaterThan(150));
    expect(portrait.paperWidthMm, 210);
    expect(portrait.paperHeightMmFor(3), 297);
    expect(landscape.paperWidthMm, 297);
    expect(landscape.paperHeightMmFor(3), 210);
  });
}
