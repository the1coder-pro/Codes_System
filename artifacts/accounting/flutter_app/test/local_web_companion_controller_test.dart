import 'package:accounting_ui/local_web_companion_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reads .env assignments and ignores comments', () {
    final values = LocalWebCompanionController.parseDotEnv('''
# local-only configuration
export DATABASE_URL="postgres://user:pass@127.0.0.1:5432/accounting"
SESSION_SECRET=example-secret # ignored comment
EMPTY=
''');

    expect(
      values['DATABASE_URL'],
      'postgres://user:pass@127.0.0.1:5432/accounting',
    );
    expect(values['SESSION_SECRET'], 'example-secret');
    expect(values['EMPTY'], '');
  });

  test('keeps hash characters inside quoted environment values', () {
    final values = LocalWebCompanionController.parseDotEnv(
      "ACCOUNTING_ROLE_PASSWORDS='{\"admin\":\"pass#word\"}'",
    );

    expect(values['ACCOUNTING_ROLE_PASSWORDS'], '{"admin":"pass#word"}');
  });
}
