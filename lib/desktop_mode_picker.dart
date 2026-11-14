import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import 'theme.dart';

class DesktopModePickerApp extends StatelessWidget {
  final VoidCallback onStandalone;
  final VoidCallback onWebCompanion;

  const DesktopModePickerApp({
    super.key,
    required this.onStandalone,
    required this.onWebCompanion,
  });

  Widget _option({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.cyan,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(icon, size: 52, color: AppColors.navy),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Expanded(child: Text(description, textAlign: TextAlign.center)),
        const SizedBox(height: 14),
        fluent.FilledButton(onPressed: onPressed, child: Text(buttonText)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => fluent.FluentApp(
    title: 'المحاسبة المالية العامة',
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
    home: fluent.ScaffoldPage(
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'اختر طريقة تشغيل النظام',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'يمكنك تشغيل نظام Flutter محلياً أو فتح واجهة الويب المحلية '
                  'مع رفيق الطباعة.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final vertical = constraints.maxWidth < 650;
                      final options = [
                        _option(
                          icon: Icons.desktop_windows_rounded,
                          title: 'النظام المكتبي المستقل',
                          description:
                              'واجهة Flutter وبيانات محلية على هذا الجهاز. '
                              'خدمة الطباعة تبدأ تلقائياً، ولا يحتاج هذا الوضع '
                              'إلى Node.js أو متصفح.',
                          buttonText: 'تشغيل النظام المستقل',
                          onPressed: onStandalone,
                        ),
                        _option(
                          icon: Icons.web_rounded,
                          title: 'رفيق واجهة الويب المحلية',
                          description:
                              'يشغّل خادم الويب والـAPI من نسخة Codes_System '
                              'المحلية، يبدأ خدمة الطباعة Dart، ثم يفتح النظام '
                              'في المتصفح.',
                          buttonText: 'تشغيل واجهة الويب',
                          onPressed: onWebCompanion,
                        ),
                      ];
                      return vertical
                          ? Column(
                              children: [
                                for (
                                  var index = 0;
                                  index < options.length;
                                  index++
                                ) ...[
                                  if (index > 0) const SizedBox(height: 14),
                                  Expanded(child: options[index]),
                                ],
                              ],
                            )
                          : Row(
                              children: [
                                for (
                                  var index = 0;
                                  index < options.length;
                                  index++
                                ) ...[
                                  if (index > 0) const SizedBox(width: 18),
                                  Expanded(child: options[index]),
                                ],
                              ],
                            );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'وضع الويب المحلي يحتاج إلى Node.js وpnpm وFlutter وقاعدة '
                  'PostgreSQL محلية مُعدّة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
