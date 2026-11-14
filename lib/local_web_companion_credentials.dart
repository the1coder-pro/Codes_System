import 'dart:convert';

import 'auth_service.dart';
import 'local_auth_service.dart';

class LocalWebCompanionCredentialConfig {
  final Map<AccountingRole, String> passwords;
  final String sessionSecret;
  final bool wasStored;

  LocalWebCompanionCredentialConfig({
    required Map<AccountingRole, String> passwords,
    required this.sessionSecret,
    required this.wasStored,
  }) : passwords = Map.unmodifiable(passwords);

  String get encodedPasswords => jsonEncode({
    for (final entry in passwords.entries) entry.key.name: entry.value,
  });
}

class LocalWebCompanionCredentials {
  static const storageKey = 'accounting_web_companion_credentials_v1';

  static const _initialPassword = '1233';
  static const _roles = AccountingRole.values;

  final SecureKeyValueStore _secureStore;

  const LocalWebCompanionCredentials({required SecureKeyValueStore secureStore})
    : _secureStore = secureStore;

  Future<LocalWebCompanionCredentialConfig> load({
    required String? environmentPasswords,
    required String? environmentSessionSecret,
    required String generatedSessionSecret,
  }) async {
    final raw = await _secureStore.read(storageKey);
    if (raw != null) {
      final Object? decoded;
      try {
        decoded = jsonDecode(raw);
      } catch (_) {
        throw const FormatException(
          'إعدادات كلمات مرور رفيق الويب المخزنة غير صالحة',
        );
      }
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          'إعدادات كلمات مرور رفيق الويب المخزنة غير صالحة',
        );
      }
      final passwords = _parsePasswordMap(decoded['passwords']);
      final sessionSecret = decoded['sessionSecret'];
      if (sessionSecret is! String || sessionSecret.isEmpty) {
        throw const FormatException('مفتاح جلسات رفيق الويب المخزن غير صالح');
      }
      _validateStrongPasswords(passwords);
      return LocalWebCompanionCredentialConfig(
        passwords: passwords,
        sessionSecret: sessionSecret,
        wasStored: true,
      );
    }

    final hasEnvironmentPasswords =
        environmentPasswords != null && environmentPasswords.trim().isNotEmpty;
    final passwords = hasEnvironmentPasswords
        ? _parseEnvironmentPasswordMap(environmentPasswords)
        : {for (final role in _roles) role: _initialPassword};
    return LocalWebCompanionCredentialConfig(
      passwords: passwords,
      sessionSecret: environmentSessionSecret?.trim().isNotEmpty == true
          ? environmentSessionSecret!
          : generatedSessionSecret,
      wasStored: false,
    );
  }

  Future<void> save(LocalWebCompanionCredentialConfig config) async {
    _validateStrongPasswords(config.passwords);
    if (config.sessionSecret.isEmpty) {
      throw const FormatException('مفتاح الجلسات لا يمكن أن يكون فارغاً');
    }
    await _secureStore.write(
      storageKey,
      jsonEncode({
        'passwords': {
          for (final entry in config.passwords.entries)
            entry.key.name: entry.value,
        },
        'sessionSecret': config.sessionSecret,
      }),
    );
  }

  static Map<AccountingRole, String> _parseEnvironmentPasswordMap(String raw) {
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      throw const FormatException(
        'قيمة ACCOUNTING_ROLE_PASSWORDS ليست JSON صالحة',
      );
    }
    final passwords = _parsePasswordMap(decoded);
    _validateStrongPasswords(passwords);
    return passwords;
  }

  static Map<AccountingRole, String> _parsePasswordMap(Object? value) {
    if (value is! Map<String, dynamic>) {
      throw const FormatException(
        'يجب ضبط كلمات المرور للأدوار الأربعة بصيغة JSON صحيحة',
      );
    }
    final passwords = <AccountingRole, String>{};
    for (final role in _roles) {
      final password = value[role.name];
      if (password is! String || password.isEmpty) {
        throw const FormatException(
          'إعداد كلمات المرور يجب أن يحتوي على الحسابات الأربعة',
        );
      }
      passwords[role] = password;
    }
    return passwords;
  }

  static void _validateStrongPasswords(Map<AccountingRole, String> passwords) {
    if (passwords.length != _roles.length) {
      throw const FormatException(
        'إعداد كلمات المرور يجب أن يحتوي على الحسابات الأربعة',
      );
    }
    for (final role in _roles) {
      final password = passwords[role];
      if (password == null || password.length < 8) {
        throw const FormatException(
          'يجب أن تتكون كلمات مرور الحسابات الأربعة من 8 أحرف على الأقل',
        );
      }
      if (password.trim() != password) {
        throw const FormatException(
          'لا تضع مسافات في بداية كلمة المرور أو نهايتها',
        );
      }
    }
  }
}
