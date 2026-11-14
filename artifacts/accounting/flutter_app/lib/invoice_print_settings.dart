enum InvoicePaperSize { thermal58, thermal80, a4Portrait, a4Landscape }

enum InvoicePrintLanguage { arabic, english, bilingual }

enum InvoiceDesignStyle { classic, compact, minimal, highlighted }

class InvoicePrintSettings {
  final InvoicePaperSize paperSize;
  final InvoicePrintLanguage language;
  final InvoiceDesignStyle design;
  final String businessName;
  final String businessAddress;
  final String businessPhone;
  final String businessEmail;
  final String receiptFooter;
  final String logoBase64;

  const InvoicePrintSettings({
    this.paperSize = InvoicePaperSize.a4Portrait,
    this.language = InvoicePrintLanguage.arabic,
    this.design = InvoiceDesignStyle.classic,
    this.businessName = '',
    this.businessAddress = '',
    this.businessPhone = '',
    this.businessEmail = '',
    this.receiptFooter = '',
    this.logoBase64 = '',
  });

  bool get isThermal =>
      paperSize == InvoicePaperSize.thermal58 ||
      paperSize == InvoicePaperSize.thermal80;

  double get paperWidthMm => switch (paperSize) {
    InvoicePaperSize.thermal58 => 58,
    InvoicePaperSize.thermal80 => 80,
    InvoicePaperSize.a4Portrait => 210,
    InvoicePaperSize.a4Landscape => 297,
  };

  double get paperHeightMm => switch (paperSize) {
    InvoicePaperSize.a4Portrait => 297,
    InvoicePaperSize.a4Landscape => 210,
    _ => 0,
  };

  double paperHeightMmFor(int lineCount, {int notesLength = 0}) => isThermal
      ? thermalHeightMm(lineCount, notesLength: notesLength)
      : paperHeightMm;

  double thermalHeightMm(int lineCount, {int notesLength = 0}) {
    final perLine = paperSize == InvoicePaperSize.thermal58 ? 16.0 : 12.0;
    final noteLines =
        (notesLength / (paperSize == InvoicePaperSize.thermal58 ? 24 : 36))
            .ceil();
    final lineCapacity = paperSize == InvoicePaperSize.thermal58 ? 24 : 36;
    final brandLines =
        [businessName, businessAddress, businessPhone, businessEmail]
            .where((value) => value.trim().isNotEmpty)
            .fold<int>(
              0,
              (count, value) => count + (value.length / lineCapacity).ceil(),
            );
    final brandHeight =
        (logoBase64.trim().isNotEmpty ? 28.0 : 0.0) +
        (brandLines * 4.0) +
        (logoBase64.trim().isNotEmpty && brandLines > 0 ? 2.0 : 0.0);
    final footerHeight = receiptFooter.trim().isEmpty
        ? 0.0
        : (receiptFooter.length / lineCapacity).ceil() * 4.0;
    return 150 +
        brandHeight +
        footerHeight +
        (lineCount * perLine) +
        (noteLines * 6);
  }

  InvoicePrintSettings copyWith({
    InvoicePaperSize? paperSize,
    InvoicePrintLanguage? language,
    InvoiceDesignStyle? design,
    String? businessName,
    String? businessAddress,
    String? businessPhone,
    String? businessEmail,
    String? receiptFooter,
    String? logoBase64,
  }) => InvoicePrintSettings(
    paperSize: paperSize ?? this.paperSize,
    language: language ?? this.language,
    design: design ?? this.design,
    businessName: businessName ?? this.businessName,
    businessAddress: businessAddress ?? this.businessAddress,
    businessPhone: businessPhone ?? this.businessPhone,
    businessEmail: businessEmail ?? this.businessEmail,
    receiptFooter: receiptFooter ?? this.receiptFooter,
    logoBase64: logoBase64 ?? this.logoBase64,
  );

  Map<String, dynamic> toJson() => {
    'paperSize': paperSize.name,
    'language': language.name,
    'design': design.name,
    'businessName': businessName,
    'businessAddress': businessAddress,
    'businessPhone': businessPhone,
    'businessEmail': businessEmail,
    'receiptFooter': receiptFooter,
    'logoBase64': logoBase64,
  };

  factory InvoicePrintSettings.fromJson(Map<String, dynamic> json) =>
      InvoicePrintSettings(
        paperSize: InvoicePaperSize.values.firstWhere(
          (value) => value.name == json['paperSize'],
          orElse: () => InvoicePaperSize.a4Portrait,
        ),
        language: InvoicePrintLanguage.values.firstWhere(
          (value) => value.name == json['language'],
          orElse: () => InvoicePrintLanguage.arabic,
        ),
        design: InvoiceDesignStyle.values.firstWhere(
          (value) => value.name == json['design'],
          orElse: () => InvoiceDesignStyle.classic,
        ),
        businessName: json['businessName'] as String? ?? '',
        businessAddress: json['businessAddress'] as String? ?? '',
        businessPhone: json['businessPhone'] as String? ?? '',
        businessEmail: json['businessEmail'] as String? ?? '',
        receiptFooter: json['receiptFooter'] as String? ?? '',
        logoBase64: json['logoBase64'] as String? ?? '',
      );
}
