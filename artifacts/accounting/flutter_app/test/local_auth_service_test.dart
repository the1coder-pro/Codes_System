import 'package:accounting_ui/auth_service.dart';
import 'package:accounting_ui/local_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemorySecureStore implements SecureKeyValueStore {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}

void main() {
  test(
    'initializes all roles and lets admin change selected passwords',
    () async {
      final service = LocalAuthService(secureStore: _MemorySecureStore());
      await service.initialize();

      final admin = await service.login('admin', '1233');
      final cashier = await service.login('cashier1', '1233');
      expect(await service.authorize(admin, 'admin.users'), isTrue);
      expect(await service.authorize(cashier, 'admin.users'), isFalse);

      await service.setRolePasswords(admin, {
        AccountingRole.cashier1: 'Cashier#2026!',
      });

      await expectLater(
        service.login('cashier1', '1233'),
        throwsFormatException,
      );
      expect(
        (await service.login('cashier1', 'Cashier#2026!')).role,
        AccountingRole.cashier1,
      );
      expect(
        (await service.login('cashier2', '1233')).role,
        AccountingRole.cashier2,
      );
    },
  );

  test('only an active administrator can change role passwords', () async {
    final service = LocalAuthService(secureStore: _MemorySecureStore());
    await service.initialize();
    final cashier = await service.login('cashier1', '1233');
    final admin = await service.login('admin', '1233');

    await expectLater(
      service.setRolePasswords(cashier, {
        AccountingRole.admin: 'Changed#2026!',
      }),
      throwsFormatException,
    );
    await expectLater(
      service.setRolePasswords(admin, {AccountingRole.admin: 'short'}),
      throwsFormatException,
    );
  });

  test('does not silently reset malformed secure password data', () async {
    final store = _MemorySecureStore()
      ..values['accounting_role_passwords_v1'] = '{"admin":"only one"}';
    final service = LocalAuthService(secureStore: store);

    await expectLater(service.initialize(), throwsFormatException);
    expect(
      store.values['accounting_role_passwords_v1'],
      '{"admin":"only one"}',
    );
  });
}
