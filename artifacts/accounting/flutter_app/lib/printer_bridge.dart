import 'dart:convert';

import 'package:http/http.dart' as http;

const _printerServiceBase = 'http://127.0.0.1:17863';

class PrinterPreferences {
  final String token;
  final String? invoicePrinter;
  final String? barcodePrinter;

  const PrinterPreferences({
    this.token = '',
    this.invoicePrinter,
    this.barcodePrinter,
  });

  factory PrinterPreferences.fromJson(Map<String, dynamic> json) =>
      PrinterPreferences(
        token: json['token'] as String? ?? '',
        invoicePrinter: json['invoicePrinter'] as String?,
        barcodePrinter: json['barcodePrinter'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'token': token,
    'invoicePrinter': invoicePrinter,
    'barcodePrinter': barcodePrinter,
  };
}

class LocalPrinter {
  final String name;
  final String displayName;
  final String description;
  final bool isDefault;

  const LocalPrinter({
    required this.name,
    required this.displayName,
    required this.description,
    required this.isDefault,
  });

  factory LocalPrinter.fromJson(Map<String, dynamic> json) => LocalPrinter(
    name: json['name'] as String? ?? '',
    displayName:
        json['displayName'] as String? ?? json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    isDefault: json['isDefault'] == true,
  );
}

class PrinterBridgeException implements Exception {
  final String message;
  const PrinterBridgeException(this.message);

  @override
  String toString() => message;
}

class PrinterBridgeClient {
  final http.Client _client;

  PrinterBridgeClient({http.Client? client})
    : _client = client ?? http.Client();

  Future<void> checkConnection() async {
    try {
      final response = await _client
          .get(Uri.parse('$_printerServiceBase/health'))
          .timeout(const Duration(seconds: 4));
      if (response.statusCode != 200) {
        throw const PrinterBridgeException('خدمة الطباعة المحلية غير متاحة');
      }
    } on PrinterBridgeException {
      rethrow;
    } catch (_) {
      throw const PrinterBridgeException(
        'تعذر الاتصال بخدمة الطباعة المحلية على هذا الجهاز',
      );
    }
  }

  Future<List<LocalPrinter>> loadPrinters(
    PrinterPreferences preferences,
  ) async {
    if (preferences.token.trim().isEmpty) {
      throw const PrinterBridgeException('أدخل رمز الربط أولاً');
    }
    try {
      final response = await _client
          .get(
            Uri.parse('$_printerServiceBase/api/printers'),
            headers: {'authorization': 'Bearer ${preferences.token.trim()}'},
          )
          .timeout(const Duration(seconds: 6));
      if (response.statusCode == 401) {
        throw const PrinterBridgeException('رمز الربط غير صحيح');
      }
      if (response.statusCode != 200) {
        throw const PrinterBridgeException('تعذر جلب قائمة الطابعات');
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const PrinterBridgeException('استجابة الطابعات غير صالحة');
      }
      return decoded
          .whereType<Map>()
          .map(
            (entry) => LocalPrinter.fromJson(Map<String, dynamic>.from(entry)),
          )
          .where((printer) => printer.name.isNotEmpty)
          .toList();
    } on PrinterBridgeException {
      rethrow;
    } catch (_) {
      throw const PrinterBridgeException('تعذر الاتصال بخدمة الطباعة المحلية');
    }
  }

  Future<void> printHtml({
    required PrinterPreferences preferences,
    required String printerName,
    required String jobType,
    required String html,
  }) async {
    if (preferences.token.trim().isEmpty) {
      throw const PrinterBridgeException('لم يتم إعداد خدمة الطباعة المحلية');
    }
    if (printerName.trim().isEmpty) {
      throw const PrinterBridgeException('اختر طابعة من إدارة الطابعات');
    }
    try {
      final response = await _client
          .post(
            Uri.parse('$_printerServiceBase/api/print'),
            headers: {
              'authorization': 'Bearer ${preferences.token.trim()}',
              'content-type': 'application/json',
            },
            body: jsonEncode({
              'printerName': printerName,
              'jobType': jobType,
              'html': html,
            }),
          )
          .timeout(const Duration(seconds: 45));
      if (response.statusCode == 401) {
        throw const PrinterBridgeException('رمز الربط غير صحيح');
      }
      if (response.statusCode == 409) {
        throw const PrinterBridgeException(
          'الطابعة المحددة غير مثبتة على هذا الجهاز',
        );
      }
      if (response.statusCode != 202) {
        throw const PrinterBridgeException('فشلت مهمة الطباعة الصامتة');
      }
    } on PrinterBridgeException {
      rethrow;
    } catch (_) {
      throw const PrinterBridgeException(
        'تعذر إرسال المهمة إلى خدمة الطباعة المحلية',
      );
    }
  }

  void dispose() => _client.close();
}
