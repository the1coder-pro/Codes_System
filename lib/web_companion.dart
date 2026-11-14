import 'dart:async';
import 'dart:ui' show AppExitResponse;

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import 'local_web_companion_controller.dart';
import 'theme.dart';

class WebCompanionApp extends StatefulWidget {
  const WebCompanionApp({super.key});

  @override
  State<WebCompanionApp> createState() => _WebCompanionAppState();
}

class _WebCompanionAppState extends State<WebCompanionApp>
    with WidgetsBindingObserver {
  late final LocalWebCompanionController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = LocalWebCompanionController();
    unawaited(_controller.restoreLastWorkspace());
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    await _controller.stop();
    return AppExitResponse.exit;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => fluent.FluentApp(
    title: 'رفيق واجهة الويب المحلية',
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
    home: _WebCompanionScreen(controller: _controller),
  );
}

class _WebCompanionScreen extends StatelessWidget {
  final LocalWebCompanionController controller;

  const _WebCompanionScreen({required this.controller});

  Widget _tokenPanel() {
    final token = controller.printerController.token;
    if (token.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(12),
      color: AppColors.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'رمز ربط الطباعة',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: SelectableText(
              token,
              textDirection: TextDirection.ltr,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'أدخل هذا الرمز مرة واحدة في إدارة الطابعات داخل واجهة الويب.',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => fluent.ScaffoldPage(
    header: fluent.PageHeader(title: const Text('رفيق واجهة الويب المحلية')),
    content: AnimatedBuilder(
      animation: controller,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 760;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    fluent.InfoBar(
                      title: Text(controller.status),
                      severity: controller.isRunning
                          ? fluent.InfoBarSeverity.success
                          : controller.isBusy
                          ? fluent.InfoBarSeverity.info
                          : fluent.InfoBarSeverity.warning,
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      color: AppColors.cyan,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'مجلد المشروع المحلي',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 5),
                          SelectableText(
                            controller.workspacePath.isEmpty
                                ? 'لم يتم اختيار مجلد'
                                : controller.workspacePath,
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: fluent.Button(
                              onPressed: controller.isBusy
                                  ? null
                                  : controller.chooseWorkspace,
                              child: const Text('اختيار مجلد Codes_System'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'اختر نسخة المشروع الكاملة التي تحتوي على '
                      'pnpm-workspace.yaml. يجب تثبيت Node.js وpnpm وFlutter، '
                      'وإعداد DATABASE_URL في ملف .env لقاعدة PostgreSQL المحلية.',
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 14),
                    _tokenPanel(),
                    const SizedBox(height: 14),
                    if (narrow)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _serviceCard(
                            'واجهة الويب',
                            controller.isRunning
                                ? controller.webUrl
                                : 'تبدأ على المنفذ 24339',
                            controller.isRunning,
                          ),
                          const SizedBox(height: 10),
                          _serviceCard(
                            'خادم API',
                            '127.0.0.1:8080',
                            controller.isRunning,
                          ),
                          const SizedBox(height: 10),
                          _serviceCard(
                            'خدمة الطباعة Dart',
                            controller.printerController.status,
                            controller.printerController.isReady,
                          ),
                        ],
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _serviceCard(
                              'واجهة الويب',
                              controller.isRunning
                                  ? controller.webUrl
                                  : 'تبدأ على المنفذ 24339',
                              controller.isRunning,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _serviceCard(
                              'خادم API',
                              '127.0.0.1:8080',
                              controller.isRunning,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _serviceCard(
                              'خدمة الطباعة Dart',
                              controller.printerController.status,
                              controller.printerController.isReady,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.start,
                      children: [
                        fluent.FilledButton(
                          onPressed: controller.isBusy
                              ? null
                              : controller.isRunning
                              ? controller.stop
                              : controller.start,
                          child: Text(
                            controller.isRunning
                                ? 'إيقاف النظام المحلي'
                                : controller.isBusy
                                ? 'جارٍ التشغيل...'
                                : 'تشغيل الواجهة والطباعة',
                          ),
                        ),
                        if (controller.isBusy)
                          fluent.Button(
                            onPressed: controller.stop,
                            child: const Text('إلغاء'),
                          ),
                        if (controller.isRunning)
                          fluent.Button(
                            onPressed: controller.openInBrowser,
                            child: const Text('فتح الواجهة في المتصفح'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'سجل التشغيل',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 220,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: controller.logs.isEmpty
                          ? const Align(
                              alignment: Alignment.topRight,
                              child: Text('ستظهر هنا حالة البناء والخدمات.'),
                            )
                          : ListView.builder(
                              reverse: true,
                              itemCount: controller.logs.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: SelectableText(
                                  controller.logs[controller.logs.length -
                                      index -
                                      1],
                                  textDirection: TextDirection.ltr,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );

  Widget _serviceCard(String title, String detail, bool ready) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: ready ? const Color(0xFFE8F4E8) : Colors.white,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              ready ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: ready ? AppColors.green : AppColors.muted,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(detail, textAlign: TextAlign.right),
      ],
    ),
  );
}
