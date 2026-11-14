import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'local_web_companion_controller.dart';
import 'theme.dart';

class WebCompanionPasswordDialog extends StatefulWidget {
  final LocalWebCompanionController controller;

  const WebCompanionPasswordDialog({super.key, required this.controller});

  @override
  State<WebCompanionPasswordDialog> createState() =>
      _WebCompanionPasswordDialogState();
}

class _WebCompanionPasswordDialogState
    extends State<WebCompanionPasswordDialog> {
  static const _roles = AccountingRole.values;
  static const _labels = {
    AccountingRole.admin: 'المسؤول (admin)',
    AccountingRole.cashier1: 'الكاشير الأول (cashier1)',
    AccountingRole.cashier2: 'الكاشير الثاني (cashier2)',
    AccountingRole.auditor: 'المراجع (auditor)',
  };

  final _currentAdminPassword = TextEditingController();
  final _newPasswords = {
    for (final role in _roles) role: TextEditingController(),
  };
  final _confirmPasswords = {
    for (final role in _roles) role: TextEditingController(),
  };

  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _currentAdminPassword.dispose();
    for (final controller in _newPasswords.values) {
      controller.dispose();
    }
    for (final controller in _confirmPasswords.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final changes = <AccountingRole, String>{};
    for (final role in _roles) {
      final password = _newPasswords[role]!.text;
      final confirmation = _confirmPasswords[role]!.text;
      if (password.isEmpty && confirmation.isEmpty) continue;
      if (password.isEmpty || confirmation.isEmpty) {
        _showError('أدخل كلمة المرور وتأكيدها للحساب نفسه.');
        return;
      }
      if (password != confirmation) {
        _showError('كلمة المرور وتأكيدها غير متطابقتين: ${_labels[role]}');
        return;
      }
      if (password.length < 8) {
        _showError('يجب أن تتكون كلمة المرور الجديدة من 8 أحرف على الأقل.');
        return;
      }
      if (password.trim() != password) {
        _showError('لا تضع مسافات في بداية كلمة المرور أو نهايتها.');
        return;
      }
      changes[role] = password;
    }

    if (changes.isEmpty) {
      _showError('أدخل كلمة مرور جديدة لحساب واحد على الأقل.');
      return;
    }
    if (widget.controller.requiresInitialPasswordSetup &&
        changes.length != _roles.length) {
      _showError(
        'لأول إعداد آمن، أدخل كلمات مرور للحسابات الأربعة. '
        'بعدها يمكن تغيير حساب واحد فقط في كل مرة.',
      );
      return;
    }
    if (_currentAdminPassword.text.isEmpty) {
      _showError('أدخل كلمة مرور المسؤول الحالية للتحقق من هويتك.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.controller.updateRolePasswords(
        currentAdminPassword: _currentAdminPassword.text,
        changes: changes,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error is FormatException
              ? error.message.toString()
              : widget.controller.status;
          _saving = false;
        });
      }
    }
  }

  void _showError(String message) => setState(() => _error = message);

  Widget _roleCard(AccountingRole role) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.cyan,
      border: Border.all(color: AppColors.line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _labels[role]!,
          textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        fluent.TextBox(
          key: ValueKey('web-new-password-${role.name}'),
          controller: _newPasswords[role],
          obscureText: true,
          textDirection: TextDirection.ltr,
          placeholder: 'كلمة المرور الجديدة',
        ),
        const SizedBox(height: 7),
        fluent.TextBox(
          key: ValueKey('web-confirm-password-${role.name}'),
          controller: _confirmPasswords[role],
          obscureText: true,
          textDirection: TextDirection.ltr,
          placeholder: 'تأكيد كلمة المرور',
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => fluent.ContentDialog(
    constraints: const BoxConstraints(maxWidth: 760, maxHeight: 720),
    title: const Text('إدارة كلمات مرور واجهة الويب'),
    content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'هذه الإعدادات مستقلة عن كلمات مرور التطبيق المكتبي المستقل. '
            'تحقق من حساب المسؤول الحالي. كلمات المرور الجديدة تُحفظ في مخزن '
            'النظام الآمن على هذا الجهاز، ثم يُعاد تشغيل API لتطبيقها. '
            'سيُطلب من المستخدمين تسجيل الدخول مجدداً.',
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 12),
          fluent.TextBox(
            key: const ValueKey('web-current-admin-password'),
            controller: _currentAdminPassword,
            obscureText: true,
            textDirection: TextDirection.ltr,
            placeholder: 'كلمة مرور المسؤول الحالية',
          ),
          const SizedBox(height: 12),
          Text(
            widget.controller.requiresInitialPasswordSetup
                ? 'لأول إعداد، أدخل كلمات مرور للحسابات الأربعة. الحد الأدنى 8 أحرف.'
                : 'اترك الحسابات التي لا تريد تغييرها فارغة. الحد الأدنى 8 أحرف.',
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 640 ? 2 : 1;
              const gap = 10.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final role in _roles)
                    SizedBox(width: width, child: _roleCard(role)),
                ],
              );
            },
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            fluent.InfoBar(
              title: Text(_error!),
              severity: fluent.InfoBarSeverity.error,
            ),
          ],
        ],
      ),
    ),
    actions: [
      fluent.Button(
        onPressed: _saving ? null : () => Navigator.of(context).pop(),
        child: const Text('إلغاء'),
      ),
      fluent.FilledButton(
        key: const ValueKey('save-web-role-passwords'),
        onPressed: _saving ? null : _save,
        child: _saving
            ? const fluent.ProgressRing(strokeWidth: 2)
            : const Text('حفظ كلمات المرور'),
      ),
    ],
  );
}
