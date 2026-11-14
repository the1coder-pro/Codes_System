import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'auth_service.dart';
import 'desktop_mode_picker.dart';
import 'local_auth_service_stub.dart'
    if (dart.library.io) 'local_auth_service.dart'
    as local_auth;
import 'printer_companion_stub.dart'
    if (dart.library.io) 'printer_companion.dart'
    as printer_companion;
import 'shell.dart';
import 'theme.dart';
import 'web_companion_stub.dart'
    if (dart.library.io) 'web_companion.dart'
    as web_companion;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && const bool.fromEnvironment('PRINTER_SERVICE_ONLY')) {
    await printer_companion.runPrinterCompanion();
    return;
  }
  if (!kIsWeb && const bool.fromEnvironment('PRINTER_WEB_COMPANION')) {
    runApp(const web_companion.WebCompanionApp());
    return;
  }
  if (!kIsWeb && const bool.fromEnvironment('PRINTER_COMPANION')) {
    await _startStandalone();
    return;
  }
  if (!kIsWeb) {
    runApp(
      DesktopModePickerApp(
        onStandalone: () => _startStandalone(),
        onWebCompanion: () => runApp(const web_companion.WebCompanionApp()),
      ),
    );
    return;
  }
  runApp(const AccountingApp());
}

Future<void> _startStandalone() async {
  final authService = local_auth.LocalAuthService();
  final printerController = printer_companion.PrinterCompanionController();
  try {
    await authService.initialize();
    await printerController.start();
    runApp(
      AccountingApp(
        authService: authService,
        printerController: printerController,
      ),
    );
  } catch (error) {
    runApp(_StartupErrorApp(error: error));
  }
}

class AccountingApp extends StatelessWidget {
  final AccountingAuthService authService;
  final printer_companion.PrinterCompanionController? printerController;

  const AccountingApp({
    super.key,
    this.authService = const ApiAuthService(),
    this.printerController,
  });

  @override
  Widget build(BuildContext context) {
    return fluent.FluentApp(
      title: 'المحاسبة المالية العامة',
      debugShowCheckedModeBanner: false,
      theme: buildFluentTheme(),
      locale: const Locale('ar'),
      builder: (context, child) {
        final baseTheme = Theme.of(context);
        final arabicTheme = baseTheme.copyWith(
          textTheme: baseTheme.textTheme.apply(fontFamily: appFontFamily),
          primaryTextTheme: baseTheme.primaryTextTheme.apply(
            fontFamily: appFontFamily,
          ),
        );
        return Theme(
          data: arabicTheme,
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontFamily: appFontFamily),
            child: ScaffoldMessenger(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              ),
            ),
          ),
        );
      },
      home: AppShell(
        authService: authService,
        embeddedPrinterToken: printerController?.token,
      ),
    );
  }
}

class _StartupErrorApp extends StatelessWidget {
  final Object error;

  const _StartupErrorApp({required this.error});

  @override
  Widget build(BuildContext context) => fluent.FluentApp(
    title: 'المحاسبة المالية العامة',
    theme: buildFluentTheme(),
    locale: const Locale('ar'),
    home: fluent.ScaffoldPage(
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: fluent.InfoBar(
            title: const Text('تعذر تشغيل النظام المستقل'),
            content: Text(
              'تعذر الوصول إلى مخزن كلمات المرور الآمن في نظام التشغيل. '
              'أعد تشغيل التطبيق أو تحقق من صلاحيات التخزين الآمن.\\n$error',
            ),
            severity: fluent.InfoBarSeverity.error,
          ),
        ),
      ),
    ),
  );
}
