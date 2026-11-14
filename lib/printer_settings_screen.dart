import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'auth_service.dart';
import 'invoice_print_design_tab.dart';
import 'printer_bridge.dart';
import 'storage.dart';
import 'theme.dart';
import 'widgets.dart';

class PrinterSettingsScreen extends StatefulWidget {
  final UserSession session;
  final AccountingAuthService authService;
  final String? embeddedPrinterToken;
  final VoidCallback onExit;

  const PrinterSettingsScreen({
    super.key,
    required this.session,
    required this.authService,
    this.embeddedPrinterToken,
    required this.onExit,
  });

  @override
  State<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends State<PrinterSettingsScreen> {
  final _tokenController = TextEditingController();
  final _bridge = PrinterBridgeClient();
  List<LocalPrinter> _printers = [];
  String? _invoicePrinter;
  String? _barcodePrinter;
  String? _status;
  bool _working = false;
  bool _connected = false;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _bridge.dispose();
    super.dispose();
  }

  Future<void> _loadSavedSettings() async {
    final saved = PrinterPreferences.fromJson(
      await Store.loadPrinterPreferences(),
    );
    if (!mounted) return;
    _tokenController.text =
        widget.embeddedPrinterToken?.trim().isNotEmpty == true
        ? widget.embeddedPrinterToken!.trim()
        : saved.token;
    setState(() {
      _invoicePrinter = saved.invoicePrinter;
      _barcodePrinter = saved.barcodePrinter;
    });
    if (saved.token.isNotEmpty) await _connect();
  }

  PrinterPreferences get _preferences => PrinterPreferences(
    token: _tokenController.text.trim(),
    invoicePrinter: _invoicePrinter,
    barcodePrinter: _barcodePrinter,
  );

  bool get _hasEmbeddedService =>
      widget.embeddedPrinterToken?.trim().isNotEmpty == true;

  Future<void> _connect() async {
    if (_tokenController.text.trim().isEmpty) {
      setState(() {
        _connected = false;
        _status = 'أدخل رمز الربط المعروض في خدمة الطباعة المحلية.';
      });
      return;
    }
    setState(() {
      _working = true;
      _status = 'جارٍ الاتصال واكتشاف الطابعات...';
    });
    try {
      await _bridge.checkConnection();
      final printers = await _bridge.loadPrinters(_preferences);
      if (!mounted) return;
      final fallback = printers.where((printer) => printer.isDefault);
      final fallbackName = fallback.isNotEmpty
          ? fallback.first.name
          : (printers.isEmpty ? null : printers.first.name);
      setState(() {
        _printers = printers;
        _connected = true;
        if (!printers.any((printer) => printer.name == _invoicePrinter)) {
          _invoicePrinter = fallbackName;
        }
        if (!printers.any((printer) => printer.name == _barcodePrinter)) {
          _barcodePrinter = fallbackName;
        }
        _status = printers.isEmpty
            ? 'الخدمة متصلة، لكن لم يتم العثور على طابعات مثبتة.'
            : 'تم اكتشاف ${printers.length} طابعة.';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _connected = false;
        _status = error.toString();
      });
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _save() async {
    if (!await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'printer.manage',
    )) {
      return;
    }
    if (_tokenController.text.trim().isEmpty ||
        _invoicePrinter == null ||
        _barcodePrinter == null) {
      setState(() => _status = 'اتصل بالخدمة واختر طابعة للفواتير والباركود.');
      return;
    }
    final saved = await Store.savePrinterPreferences(_preferences.toJson());
    if (!mounted) return;
    setState(() {
      _status = saved
          ? 'تم حفظ إعدادات الطابعات على هذا الجهاز.'
          : 'تعذر حفظ إعدادات الطابعات.';
      _connected = saved && _connected;
    });
  }

  Widget _printerPicker({
    required String label,
    required String? selected,
    required ValueChanged<String?> onChanged,
    required String keyName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, textAlign: TextAlign.right),
        const SizedBox(height: 5),
        SizedBox(
          height: 40,
          child: fluent.ComboBox<String>(
            key: ValueKey(keyName),
            value: _printers.any((printer) => printer.name == selected)
                ? selected
                : null,
            placeholder: const Text('اتصل لاكتشاف الطابعات'),
            isExpanded: true,
            items: [
              for (final printer in _printers)
                fluent.ComboBoxItem<String>(
                  value: printer.name,
                  child: Text(
                    printer.isDefault
                        ? '${printer.displayName} (الافتراضية)'
                        : printer.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: _working || _printers.isEmpty ? null : onChanged,
          ),
        ),
      ],
    );
  }

  Widget _tabs() {
    const names = ['الطابعات', 'الفواتير'];
    return Container(
      key: const ValueKey('printer-invoice-tabs-strip'),
      width: double.infinity,
      color: const Color(0xFFEFF1F3),
      padding: const EdgeInsets.only(top: 6, left: 6),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            for (var index = 0; index < names.length; index++)
              GestureDetector(
                key: ValueKey('printer-invoice-tab-$index'),
                onTap: () => setState(() => _activeTab = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _activeTab == index
                        ? Colors.white
                        : const Color(0xFFE2E5E8),
                    border: Border(
                      top: BorderSide(
                        color: _activeTab == index
                            ? AppColors.green
                            : AppColors.line,
                        width: _activeTab == index ? 2.5 : 1,
                      ),
                      left: const BorderSide(color: AppColors.line),
                      right: const BorderSide(color: AppColors.line),
                    ),
                  ),
                  child: Text(
                    names[index],
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: _activeTab == index
                          ? FontWeight.w800
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _printerTab() => SingleChildScrollView(
    padding: const EdgeInsets.all(12),
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1050),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.cyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _hasEmbeddedService
                        ? 'خدمة الطباعة تعمل ضمن النظام المستقل على هذا الجهاز.'
                        : 'تعمل الطباعة الصامتة عبر خدمة محلية على هذا الجهاز.',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _hasEmbeddedService
                        ? 'لا تحتاج لتشغيل تطبيق آخر أو إدخال رمز ربط. '
                              'تُحفظ اختيارات الطابعات على هذا الجهاز فقط.'
                        : 'شغّل تطبيق Local Printer Companion على هذا الجهاز، ثم أدخل رمز الربط الظاهر فيه. '
                              'تُحفظ الاختيارات في هذا المتصفح وعلى هذا الجهاز فقط.',
                    textAlign: TextAlign.right,
                  ),
                  if (!_hasEmbeddedService) ...[
                    SizedBox(height: 4),
                    Text(
                      'لا يحتاج التطبيق المرافق إلى Node.js.',
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ],
              ),
            ),
            if (!_hasEmbeddedService) ...[
              const SizedBox(height: 12),
              const Text('رمز الربط', textAlign: TextAlign.right),
              const SizedBox(height: 5),
              fluent.TextBox(
                key: const ValueKey('printer-pairing-token'),
                controller: _tokenController,
                obscureText: true,
                textDirection: TextDirection.ltr,
                placeholder: 'ألصق رمز الربط من خدمة الطباعة',
              ),
            ],
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: fluent.Button(
                key: const ValueKey('printer-discover-button'),
                onPressed: _working ? null : _connect,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_working)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: fluent.ProgressRing(strokeWidth: 2),
                      )
                    else
                      const Icon(fluent.FluentIcons.refresh, size: 16),
                    const SizedBox(width: 7),
                    Text(
                      _hasEmbeddedService
                          ? 'تحديث الطابعات'
                          : 'الاتصال واكتشاف الطابعات',
                    ),
                  ],
                ),
              ),
            ),
            if (_status != null) ...[
              const SizedBox(height: 10),
              fluent.InfoBar(
                title: Text(_status!),
                severity: _connected
                    ? fluent.InfoBarSeverity.success
                    : fluent.InfoBarSeverity.warning,
              ),
            ],
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _printerPicker(
                    label: 'الطابعة الافتراضية للفواتير',
                    selected: _invoicePrinter,
                    keyName: 'invoice-printer-choice',
                    onChanged: (value) =>
                        setState(() => _invoicePrinter = value),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _printerPicker(
                    label: 'الطابعة الافتراضية للباركود',
                    selected: _barcodePrinter,
                    keyName: 'barcode-printer-choice',
                    onChanged: (value) =>
                        setState(() => _barcodePrinter = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: fluent.FilledButton(
                key: const ValueKey('save-printer-settings'),
                onPressed: _working ? null : _save,
                child: const Text('حفظ الإعدادات'),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'إدارة الطابعات والفواتير',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
            ),
            fluent.Button(
              key: const ValueKey('printer-settings-exit'),
              onPressed: widget.onExit,
              child: const AppImageIcon(AppIcons.exit, size: 20),
            ),
          ],
        ),
      ),
      _tabs(),
      Expanded(
        child: IndexedStack(
          index: _activeTab,
          children: [
            _printerTab(),
            InvoicePrintDesignTab(
              session: widget.session,
              authService: widget.authService,
            ),
          ],
        ),
      ),
    ],
  );
}
