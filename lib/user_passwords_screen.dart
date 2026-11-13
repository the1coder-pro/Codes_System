import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'auth_service.dart';
import 'theme.dart';
import 'widgets.dart';

class UserPasswordsScreen extends StatefulWidget {
  final UserSession session;
  final AccountingAuthService authService;
  final AdminPasswordManagementService passwordService;
  final VoidCallback onExit;

  const UserPasswordsScreen({
    super.key,
    required this.session,
    required this.authService,
    required this.passwordService,
    required this.onExit,
  });

  @override
  State<UserPasswordsScreen> createState() => _UserPasswordsScreenState();
}

class _UserPasswordsScreenState extends State<UserPasswordsScreen> {
  static const _roles = [
    AccountingRole.admin,
    AccountingRole.cashier1,
    AccountingRole.cashier2,
    AccountingRole.auditor,
  ];

  static const _labels = {
    AccountingRole.admin: 'المسؤول (admin)',
    AccountingRole.cashier1: 'الكاشير الأول (cashier1)',
    AccountingRole.cashier2: 'الكاشير الثاني (cashier2)',
    AccountingRole.auditor: 'المراجع (auditor)',
  };

  final _newPasswords = {
    for (final role in _roles) role: TextEditingController(),
  };
  final _confirmPasswords = {
    for (final role in _roles) role: TextEditingController(),
  };
  String? _status;
  bool _saved = false;
  bool _saving = false;

  @override
  void dispose() {
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
        _showError('كلمة المرور وتأكيدها غير متطابقين: ${_labels[role]}');
        return;
      }
      if (password.length < 8) {
        _showError('يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.');
        return;
      }
      changes[role] = password;
    }
    if (changes.isEmpty) {
      _showError('أدخل كلمة مرور جديدة لحساب واحد على الأقل.');
      return;
    }
    if (!await requirePermission(
      context: context,
      session: widget.session,
      authService: widget.authService,
      permission: 'admin.users',
    )) {
      return;
    }

    setState(() {
      _saving = true;
      _status = null;
    });
    try {
      await widget.passwordService.setRolePasswords(widget.session, changes);
      for (final controller in _newPasswords.values) {
        controller.clear();
      }
      for (final controller in _confirmPasswords.values) {
        controller.clear();
      }
      if (mounted) {
        setState(() {
          _status = 'تم حفظ كلمات المرور الجديدة بأمان على هذا الجهاز.';
          _saved = true;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _status = error is FormatException
              ? error.message.toString()
              : 'تعذر حفظ كلمات المرور الآمنة على هذا الجهاز.';
          _saved = false;
        });
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
    setState(() {
      _status = message;
      _saved = false;
    });
  }

  Widget _roleCard(AccountingRole role) => Container(
    key: ValueKey('password-card-${role.name}'),
    padding: const EdgeInsets.all(14),
    color: AppColors.cyan,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _labels[role]!,
          textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 10),
        fluent.TextBox(
          key: ValueKey('new-password-${role.name}'),
          controller: _newPasswords[role],
          obscureText: true,
          textDirection: TextDirection.ltr,
          placeholder: 'كلمة المرور الجديدة',
        ),
        const SizedBox(height: 8),
        fluent.TextBox(
          key: ValueKey('confirm-password-${role.name}'),
          controller: _confirmPasswords[role],
          obscureText: true,
          textDirection: TextDirection.ltr,
          placeholder: 'تأكيد كلمة المرور الجديدة',
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(12),
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1050),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'إدارة كلمات المرور',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                fluent.Button(
                  key: const ValueKey('password-settings-exit'),
                  onPressed: widget.onExit,
                  child: const AppImageIcon(AppIcons.exit, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'يمكن للمسؤول تغيير كلمات مرور الحسابات الأربعة. '
              'اترك الحقول فارغة للحسابات التي لا تريد تغييرها. '
              'الحد الأدنى لكلمة المرور الجديدة 8 أحرف.',
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 700 ? 2 : 1;
                final gap = 12.0;
                final cardWidth =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final role in _roles)
                      SizedBox(width: cardWidth, child: _roleCard(role)),
                  ],
                );
              },
            ),
            if (_status != null) ...[
              const SizedBox(height: 12),
              fluent.InfoBar(
                title: Text(_status!),
                severity: _saved
                    ? fluent.InfoBarSeverity.success
                    : fluent.InfoBarSeverity.error,
              ),
            ],
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: fluent.FilledButton(
                key: const ValueKey('save-role-passwords'),
                onPressed: _saving ? null : _save,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_saving)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: fluent.ProgressRing(strokeWidth: 2),
                      )
                    else
                      const AppImageIcon(AppIcons.save, size: 20),
                    const SizedBox(width: 8),
                    const Text('حفظ كلمات المرور'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
