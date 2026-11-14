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

    expect(find.text('تطبيق سطح المكتب'), findsOneWidget);
    expect(find.text('واجهة الويب في المتصفح'), findsOneWidget);
    await tester.tap(find.text('فتح تطبيق سطح المكتب'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(standaloneSelected, isTrue);
    expect(webCompanionSelected, isFalse);

    await tester.tap(find.text('فتح واجهة الويب'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(webCompanionSelected, isTrue);
  });
}
