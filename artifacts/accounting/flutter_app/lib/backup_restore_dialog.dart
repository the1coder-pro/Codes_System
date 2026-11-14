import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import 'storage.dart';
import 'theme.dart';

typedef BackupSavePicker =
    Future<String?> Function(String contents, String fileName);
typedef BackupOpenPicker = Future<String?> Function();

class BackupRestoreDialog extends StatefulWidget {
  final BackupSavePicker? saveBackup;
  final BackupOpenPicker? openBackup;

  const BackupRestoreDialog({super.key, this.saveBackup, this.openBackup});

  @override
  State<BackupRestoreDialog> createState() => _BackupRestoreDialogState();
}

class _BackupRestoreDialogState extends State<BackupRestoreDialog> {
  bool _busy = false;
  String? _error;
  String? _notice;

  Future<void> _export() async {
    setState(() {
      _busy = true;
      _error = null;
      _notice = null;
    });
    try {
      final now = DateTime.now();
      final contents = await Store.exportBackup(createdAt: now);
      final path = await (widget.saveBackup ?? _saveBackup)(
        contents,
        'accounting-backup-${_fileTimestamp(now)}.json',
      );
      if (path != null && mounted) {
        setState(() => _notice = 'تم حفظ النسخة الاحتياطية بنجاح.');
      }
    } catch (error) {
      if (mounted) setState(() => _error = _displayError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    setState(() {
      _busy = true;
      _error = null;
      _notice = null;
    });
    try {
      final contents = await (widget.openBackup ?? _openBackup)();
      if (contents == null) return;
      final backup = Store.parseBackup(contents);
      if (!mounted) return;
      final confirmed = await fluent.showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => fluent.ContentDialog(
          key: const ValueKey('backup-restore-confirmation'),
          title: const Text('تأكيد استعادة النسخة الاحتياطية'),
          content: Text(
            'سيتم استبدال البيانات المحلية الحالية بالكامل. '
            'تحتوي النسخة على ${backup.inventoryCount} صنف، '
            '${backup.accountCount} حساب، و${backup.invoiceCount} فاتورة. '
            'لا يمكن التراجع عن هذا الإجراء.',
          ),
          actions: [
            fluent.Button(
              key: const ValueKey('backup-restore-cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('إلغاء'),
            ),
            fluent.FilledButton(
              key: const ValueKey('backup-restore-confirm'),
              style: const fluent.ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.red),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('استبدال البيانات واستعادة النسخة'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
      await Store.restoreBackup(contents);
      if (!mounted) return;
      setState(
        () => _notice =
            'تمت استعادة النسخة الاحتياطية. أعد تشغيل التطبيق لتحديث الشاشات.',
      );
    } catch (error) {
      if (mounted) setState(() => _error = _displayError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _displayError(Object error) {
    if (error is FormatException) return error.message;
    return 'تعذر إكمال العملية. لم يتم استبدال البيانات المحلية.';
  }

  static Future<String?> _saveBackup(String contents, String fileName) =>
      FilePicker.saveFile(
        dialogTitle: 'حفظ النسخة الاحتياطية',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: const ['json'],
        bytes: Uint8List.fromList(utf8.encode(contents)),
      );

  static Future<String?> _openBackup() async {
    final result = await FilePicker.pickFiles(
      dialogTitle: 'اختيار نسخة احتياطية',
      type: FileType.custom,
      allowedExtensions: const ['json'],
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;
    final bytes = result.files.single.bytes;
    if (bytes == null) {
      throw const FormatException('تعذر قراءة محتوى ملف النسخة الاحتياطية.');
    }
    try {
      return utf8.decode(bytes);
    } on FormatException {
      throw const FormatException('ملف النسخة الاحتياطية ليس بترميز صالح.');
    }
  }

  static String _fileTimestamp(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${date.year}${twoDigits(date.month)}${twoDigits(date.day)}-'
        '${twoDigits(date.hour)}${twoDigits(date.minute)}${twoDigits(date.second)}';
  }

  @override
  Widget build(BuildContext context) => fluent.ContentDialog(
    key: const ValueKey('backup-restore-dialog'),
    title: const Text('النسخ الاحتياطي والاستعادة'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'احفظ نسخة من المخزون والحسابات والفواتير على جهاز أو وسيط آمن. '
          'يمكن استعادة النسخة لاحقًا على هذا الجهاز أو جهاز آخر.',
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          fluent.InfoBar(
            title: const Text('تعذر إكمال العملية'),
            content: Text(_error!),
            severity: fluent.InfoBarSeverity.error,
          ),
        ],
        if (_notice != null) ...[
          const SizedBox(height: 12),
          fluent.InfoBar(
            title: const Text('اكتملت العملية'),
            content: Text(_notice!),
            severity: fluent.InfoBarSeverity.success,
          ),
        ],
        if (_busy) ...[
          const SizedBox(height: 12),
          const LinearProgressIndicator(),
        ],
      ],
    ),
    actions: [
      fluent.Button(
        key: const ValueKey('backup-export'),
        onPressed: _busy ? null : _export,
        child: const Text('إنشاء نسخة احتياطية'),
      ),
      fluent.Button(
        key: const ValueKey('backup-restore'),
        onPressed: _busy ? null : _restore,
        child: const Text('استعادة نسخة احتياطية'),
      ),
      fluent.Button(
        onPressed: _busy ? null : () => Navigator.of(context).pop(),
        child: const Text('إغلاق'),
      ),
    ],
  );
}
