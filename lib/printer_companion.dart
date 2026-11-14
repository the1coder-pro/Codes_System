import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_printer_service.dart';
import 'theme.dart';

Future<void> runPrinterCompanion() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = PrinterCompanionController();
  await controller.start();
  runApp(PrinterCompanionApp(controller: controller));
}

class PrinterCompanionController extends ChangeNotifier {
  static const _tokenKey = 'local_printer_companion_token_v1';

  String _token = '';
  String _status = 'جارٍ تشغيل خدمة الطباعة...';
  bool _isReady = false;
  bool _supportsSilentPrinting = false;
  List<PrinterDevice> _printers = [];
  LocalPrinterHttpService? _service;

  String get token => _token;
  String get status => _status;
  bool get isReady => _isReady;
  bool get supportsSilentPrinting => _supportsSilentPrinting;
  List<PrinterDevice> get printers => List.unmodifiable(_printers);

  Future<void> start() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      _token = preferences.getString(_tokenKey) ?? _createToken();
      await preferences.setString(_tokenKey, _token);

      final capabilities = await Printing.info();
      _supportsSilentPrinting =
          capabilities.directPrint && capabilities.canListPrinters;
      if (!_supportsSilentPrinting) {
        _status =
            'الطباعة الصامتة أو اكتشاف الطابعات غير مدعوم على هذا النظام.';
        notifyListeners();
        return;
      }

      final allowedOrigins =
          (Platform.environment['PRINTER_ALLOWED_ORIGINS'] ?? '')
              .split(',')
              .map((origin) => origin.trim())
              .where((origin) => origin.isNotEmpty)
              .toList();
      _service = LocalPrinterHttpService(
        token: _token,
        extraOrigins: allowedOrigins,
        listPrinters: _discoverPrinters,
        printPdf: _printPdf,
      );
      await _service!.start();
      _isReady = true;
      _status = 'الخدمة تعمل على 127.0.0.1:${_service!.boundPort}';
      await refreshPrinters();
    } catch (error) {
      _status = 'تعذر تشغيل خدمة الطباعة: $error';
    }
    notifyListeners();
  }

  Future<List<PrinterDevice>> _discoverPrinters() async {
    final printers = await Printing.listPrinters();
    return printers
        .where((printer) => printer.isAvailable)
        .map(
          (printer) => PrinterDevice(
            name: printer.name,
            displayName: printer.name,
            description: [printer.model, printer.location]
                .whereType<String>()
                .where((value) => value.isNotEmpty)
                .join(' · '),
            isDefault: printer.isDefault,
          ),
        )
        .toList();
  }

  Future<bool> _printPdf({
    required PrinterDevice printer,
    required Uint8List pdfBytes,
    required double paperWidthMm,
    required double paperHeightMm,
    required String jobType,
  }) async {
    final systemPrinters = await Printing.listPrinters();
    final matches = systemPrinters
        .where((candidate) => candidate.name == printer.name)
        .toList();
    if (matches.isEmpty) return false;
    return Printing.directPrintPdf(
      printer: matches.first,
      name: jobType == 'invoice' ? 'Invoice' : 'Barcode labels',
      format: PdfPageFormat(
        paperWidthMm * PdfPageFormat.mm,
        paperHeightMm * PdfPageFormat.mm,
      ),
      dynamicLayout: false,
      onLayout: (_) async => pdfBytes,
    );
  }

  Future<void> refreshPrinters() async {
    try {
      _printers = await _discoverPrinters();
      if (_printers.isEmpty) {
        _status = 'الخدمة تعمل، لكن لم يتم العثور على طابعات مثبتة.';
      } else {
        _status = 'الخدمة تعمل، وتم اكتشاف ${_printers.length} طابعة.';
      }
    } catch (error) {
      _status = 'تعذر اكتشاف الطابعات: $error';
    }
    notifyListeners();
  }

  Future<void> stop() async {
    final service = _service;
    _service = null;
    if (service != null) await service.stop();
    _isReady = false;
    _status = 'خدمة الطباعة متوقفة.';
    notifyListeners();
  }

  String _createToken() {
    final random = Random.secure();
    const chars = '0123456789abcdef';
    return List.generate(64, (_) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  void dispose() {
    final service = _service;
    _service = null;
    if (service != null) unawaited(service.stop());
    super.dispose();
  }
}

class PrinterCompanionApp extends StatelessWidget {
  final PrinterCompanionController controller;

  const PrinterCompanionApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => fluent.FluentApp(
    title: 'خدمة الطباعة المحلية',
    debugShowCheckedModeBanner: false,
    theme: buildFluentTheme(),
    locale: const Locale('ar'),
    builder: (context, child) => Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTextStyle.merge(
        style: const TextStyle(fontFamily: appFontFamily),
        child: child!,
      ),
    ),
    home: fluent.NavigationView(
      content: fluent.ScaffoldPage(
        header: fluent.PageHeader(title: const Text('خدمة الطباعة المحلية')),
        content: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  fluent.InfoBar(
                    title: Text(controller.status),
                    severity: controller.isReady
                        ? fluent.InfoBarSeverity.success
                        : fluent.InfoBarSeverity.warning,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: AppColors.cyan,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'رمز الربط',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(12),
                          child: SelectableText(
                            controller.token,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: fluent.Button(
                            onPressed: controller.token.isEmpty
                                ? null
                                : () => Clipboard.setData(
                                    ClipboardData(text: controller.token),
                                  ),
                            child: const Text('نسخ رمز الربط'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'الطابعات المثبتة (${controller.printers.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      fluent.Button(
                        onPressed: controller.isReady
                            ? controller.refreshPrinters
                            : null,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(fluent.FluentIcons.refresh, size: 16),
                            SizedBox(width: 6),
                            Text('تحديث'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (controller.printers.isEmpty)
                    const Text('ثبّت الطابعات في نظام التشغيل ثم اضغط تحديث.')
                  else
                    for (final printer in controller.printers)
                      fluent.ListTile(
                        leading: Icon(
                          printer.isDefault
                              ? fluent.FluentIcons.print
                              : fluent.FluentIcons.print,
                        ),
                        title: Text(printer.displayName),
                        subtitle: printer.description.isEmpty
                            ? null
                            : Text(printer.description),
                        trailing: printer.isDefault
                            ? const Text('الافتراضية')
                            : null,
                      ),
                  const SizedBox(height: 16),
                  const Text(
                    'اترك هذه النافذة مفتوحة أثناء الطباعة. '
                    'تُرسل الفواتير والباركود إلى الطابعة المختارة دون نافذة المتصفح.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
