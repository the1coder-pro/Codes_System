import 'package:accounting_ui/auth_service.dart';
import 'package:accounting_ui/local_auth_service.dart';
import 'package:accounting_ui/local_web_companion_credentials.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemorySecureStore implements SecureKeyValueStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}

void main() {
  test('uses development defaults before any password setup', () async {
    final config =
        await LocalWebCompanionCredentials(
          secureStore: _MemorySecureStore(),
        ).load(
          environmentPasswords: null,
          environmentSessionSecret: null,
          generatedSessionSecret: 'generated-secret',
        );

    expect(config.wasStored, isFalse);
    expect(config.sessionSecret, 'generated-secret');
    expect(config.passwords.values, everyElement('1233'));
  });

  test('loads existing API role passwords from environment JSON', () async {
    const encoded =
        '{"admin":"admin-pass-1","cashier1":"cash-pass-1",'
        '"cashier2":"cash-pass-2","auditor":"audit-pass-1"}';
    final config =
        await LocalWebCompanionCredentials(
          secureStore: _MemorySecureStore(),
        ).load(
          environmentPasswords: encoded,
          environmentSessionSecret: 'existing-secret',
          generatedSessionSecret: 'unused',
        );

    expect(config.passwords[AccountingRole.admin], 'admin-pass-1');
    expect(config.sessionSecret, 'existing-secret');
    expect(config.wasStored, isFalse);
  });

  test('persists and reloads secure passwords and session secret', () async {
    final store = _MemorySecureStore();
    final config = LocalWebCompanionCredentialConfig(
      passwords: {
        AccountingRole.admin: 'admin-pass-1',
        AccountingRole.cashier1: 'cash-pass-1',
        AccountingRole.cashier2: 'cash-pass-2',
        AccountingRole.auditor: 'audit-pass-1',
      },
      sessionSecret: 'rotated-session-secret',
      wasStored: false,
    );
    final credentials = LocalWebCompanionCredentials(secureStore: store);
    await credentials.save(config);
    final loaded = await credentials.load(
      environmentPasswords: null,
      environmentSessionSecret: 'ignored',
      generatedSessionSecret: 'ignored',
    );

    expect(loaded.wasStored, isTrue);
    expect(loaded.encodedPasswords, config.encodedPasswords);
    expect(loaded.sessionSecret, config.sessionSecret);
  });

  test('rejects incomplete or weak environment password maps', () async {
    final credentials = LocalWebCompanionCredentials(
      secureStore: _MemorySecureStore(),
    );

    await expectLater(
      credentials.load(
        environmentPasswords: '{"admin":"admin-pass-1"}',
        environmentSessionSecret: null,
        generatedSessionSecret: 'secret',
      ),
      throwsFormatException,
    );
    await expectLater(
      credentials.load(
        environmentPasswords:
            '{"admin":"1233","cashier1":"cash-pass-1",'
            '"cashier2":"cash-pass-2","auditor":"audit-pass-1"}',
        environmentSessionSecret: null,
        generatedSessionSecret: 'secret',
      ),
      throwsFormatException,
    );
    await expectLater(
      credentials.load(
        environmentPasswords: '{"admin":"secret-visible-in-error"',
        environmentSessionSecret: null,
        generatedSessionSecret: 'secret',
      ),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          isNot(contains('secret-visible-in-error')),
        ),
      ),
    );
  });
}
