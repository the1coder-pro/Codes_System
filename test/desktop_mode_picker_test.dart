import 'package:accounting_ui/desktop_mode_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows both desktop modes and launches the selected one', (
    tester,
  ) async {
    var standaloneSelected = false;
    var webCompanionSelected = false;

    await tester.pumpWidget(
      DesktopModePickerApp(
        onStandalone: () => standaloneSelected = true,
        onWebCompanion: () => webCompanionSelected = true,
      ),
    );

    expect(find.text('النظام المكتبي المستقل'), findsOneWidget);
    expect(find.text('رفيق واجهة الويب المحلية'), findsOneWidget);
    await tester.tap(find.text('تشغيل النظام المستقل'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(standaloneSelected, isTrue);
    expect(webCompanionSelected, isFalse);

    await tester.tap(find.text('تشغيل واجهة الويب'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(webCompanionSelected, isTrue);
  });
}
