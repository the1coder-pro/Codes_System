import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_service.dart';

abstract interface class SecureKeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

class FlutterSecureKeyValueStore implements SecureKeyValueStore {
  final FlutterSecureStorage _storage;

  const FlutterSecureKeyValueStore([
    this._storage = const FlutterSecureStorage(),
  ]);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
}

class LocalAuthService
    implements AccountingAuthService, AdminPasswordManagementService {
  static const _passwordsKey = 'accounting_role_passwords_v1';
  static const _initialPassword = '1233';
  static const _sessionLifetime = Duration(hours: 8);

  final SecureKeyValueStore _secureStore;
  final Map<String, _LocalSessionRecord> _sessions = {};
  Map<AccountingRole, String>? _passwords;

  LocalAuthService({SecureKeyValueStore? secureStore})
    : _secureStore = secureStore ?? const FlutterSecureKeyValueStore();

  Future<void> initialize() async {
    if (_passwords != null) return;

    final raw = await _secureStore.read(_passwordsKey);
    if (raw == null) {
      final defaults = {
        for (final role in AccountingRole.values) role: _initialPassword,
      };
      await _persist(defaults);
      return;
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('بيانات كلمات المرور المحلية غير صالحة');
    }
    final passwords = <AccountingRole, String>{};
    for (final role in AccountingRole.values) {
      final value = decoded[role.name];
      if (value is! String || value.isEmpty) {
        throw const FormatException('بيانات كلمات المرور المحلية غير مكتملة');
      }
      passwords[role] = value;
    }
    _passwords = passwords;
  }

  @override
  Future<UserSession> login(String username, String password) async {
    await initialize();
    final role = UserSession.parseRole(username);
    final expected = role == null ? null : _passwords![role];
    if (role == null ||
        expected == null ||
        !_constantTimeEquals(expected, password)) {
      throw const FormatException('بيانات الدخول غير صحيحة');
    }

    final token = _newToken();
    _sessions[token] = _LocalSessionRecord(
      role: role,
      expiresAt: DateTime.now().add(_sessionLifetime),
    );
    return UserSession(username: role.name, role: role, token: token);
  }

  @override
  Future<bool> authorize(UserSession session, String permission) async {
    final record = _sessions[session.token];
    if (record == null ||
        record.expiresAt.isBefore(DateTime.now()) ||
        record.role != session.role) {
      _sessions.remove(session.token);
      return false;
    }
    return session.can(permission);
  }

  @override
  Future<void> setRolePasswords(
    UserSession administrator,
    Map<AccountingRole, String> passwords,
  ) async {
    await initialize();
    final record = _sessions[administrator.token];
    if (administrator.role != AccountingRole.admin ||
        record?.role != AccountingRole.admin ||
        record!.expiresAt.isBefore(DateTime.now())) {
      throw const FormatException(
        'يلزم تسجيل دخول المسؤول لتغيير كلمات المرور',
      );
    }
    if (passwords.isEmpty) {
      throw const FormatException('أدخل كلمة مرور واحدة على الأقل');
    }

    final updated = Map<AccountingRole, String>.from(_passwords!);
    for (final entry in passwords.entries) {
      if (entry.value.length < 8) {
        throw const FormatException(
          'يجب أن تتكون كلمة المرور الجديدة من 8 أحرف على الأقل',
        );
      }
      if (entry.value.trim() != entry.value) {
        throw const FormatException(
          'لا تضع مسافات في بداية كلمة المرور أو نهايتها',
        );
      }
      updated[entry.key] = entry.value;
    }
    await _persist(updated);
  }

  Future<void> _persist(Map<AccountingRole, String> passwords) async {
    await _secureStore.write(
      _passwordsKey,
      jsonEncode({
        for (final entry in passwords.entries) entry.key.name: entry.value,
      }),
    );
    _passwords = passwords;
  }

  String _newToken() {
    final random = Random.secure();
    return List.generate(
      64,
      (_) => random.nextInt(16).toRadixString(16),
    ).join();
  }

  bool _constantTimeEquals(String expected, String supplied) {
    var difference = expected.length ^ supplied.length;
    final count = max(expected.length, supplied.length);
    for (var index = 0; index < count; index++) {
      final left = index < expected.length ? expected.codeUnitAt(index) : 0;
      final right = index < supplied.length ? supplied.codeUnitAt(index) : 0;
      difference |= left ^ right;
    }
    return difference == 0;
  }
}

class _LocalSessionRecord {
  final AccountingRole role;
  final DateTime expiresAt;

  const _LocalSessionRecord({required this.role, required this.expiresAt});
}
