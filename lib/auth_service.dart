import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum AccountingRole { admin, cashier1, cashier2, auditor }

class UserSession {
  final String username;
  final AccountingRole role;
  final String token;

  const UserSession({
    required this.username,
    required this.role,
    required this.token,
  });

  bool can(String permission) => _rolePermissions[role]!.contains(permission);

  static AccountingRole? parseRole(String value) {
    for (final role in AccountingRole.values) {
      if (role.name == value) return role;
    }
    return null;
  }
}

const Map<AccountingRole, Set<String>> _rolePermissions = {
  AccountingRole.admin: {
    'inventory.view',
    'inventory.manage',
    'inventory.delete',
    'accounts.view',
    'accounts.manage',
    'accounts.delete',
    'invoice.view',
    'invoice.save',
    'invoice.deleteDraft',
    'invoice.print',
    'invoice.discount',
    'invoice.approve',
    'barcode.view',
    'barcode.print',
    'admin.users',
    'printer.manage',
    'admin.company',
    'admin.backup',
  },
  AccountingRole.cashier1: {
    'inventory.view',
    'accounts.view',
    'invoice.view',
    'invoice.save',
    'invoice.print',
    'invoice.discount',
    'barcode.view',
    'barcode.print',
  },
  AccountingRole.cashier2: {
    'inventory.view',
    'accounts.view',
    'invoice.view',
    'invoice.save',
    'barcode.view',
    'barcode.print',
  },
  AccountingRole.auditor: {
    'inventory.view',
    'accounts.view',
    'invoice.view',
    'invoice.print',
    'barcode.view',
    'barcode.print',
  },
};

abstract interface class AccountingAuthService {
  Future<UserSession> login(String username, String password);
  Future<bool> authorize(UserSession session, String permission);
}

abstract interface class AdminPasswordManagementService {
  Future<void> setRolePasswords(
    UserSession administrator,
    Map<AccountingRole, String> passwords,
  );
}

class ApiAuthService implements AccountingAuthService {
  const ApiAuthService();

  Uri _uri(String path) => Uri.base.resolve('/api$path');

  @override
  Future<UserSession> login(String username, String password) async {
    final response = await http
        .post(
          _uri('/auth/login'),
          headers: const {'content-type': 'application/json'},
          body: jsonEncode({'username': username, 'password': password}),
        )
        .timeout(const Duration(seconds: 10));
    final body = _decode(response);
    if (response.statusCode != 200) {
      throw const FormatException(
        'بيانات الدخول غير صحيحة أو الخدمة غير متاحة',
      );
    }
    final role = UserSession.parseRole(body['role'] as String? ?? '');
    if (role == null || body['token'] is! String) {
      throw const FormatException('تعذر إنشاء جلسة آمنة');
    }
    return UserSession(
      username: body['username'] as String? ?? username,
      role: role,
      token: body['token'] as String,
    );
  }

  @override
  Future<bool> authorize(UserSession session, String permission) async {
    final response = await http
        .post(
          _uri('/auth/authorize'),
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer ${session.token}',
          },
          body: jsonEncode({'permission': permission}),
        )
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 403) return false;
    if (response.statusCode != 200) {
      throw const FormatException('تعذر التحقق من الصلاحية');
    }
    return _decode(response)['authorized'] == true;
  }

  Map<String, dynamic> _decode(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('استجابة غير صالحة من الخادم');
    }
    return decoded;
  }
}

Future<bool> requirePermission({
  required BuildContext context,
  required UserSession session,
  required AccountingAuthService authService,
  required String permission,
}) async {
  if (!session.can(permission)) {
    _permissionToast(context, 'لا تملك صلاحية تنفيذ هذا الإجراء');
    return false;
  }
  try {
    final allowed = await authService.authorize(session, permission);
    if (!allowed && context.mounted) {
      _permissionToast(context, 'رفض الخادم هذا الإجراء');
    }
    return allowed;
  } catch (_) {
    if (context.mounted) {
      _permissionToast(context, 'تعذر التحقق من الصلاحية؛ لم يتم الحفظ');
    }
    return false;
  }
}

void _permissionToast(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
  );
}
