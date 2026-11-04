import 'package:accounting_ui/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shell renders ribbon and status bar', (tester) async {
    await tester.pumpWidget(const AccountingApp());
    await tester.pump();
    expect(find.text('القائمة الرئيسية'), findsOneWidget);
    expect(find.textContaining('مؤسسة العيدان'), findsOneWidget);
  });
}
