import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'invoice_print_settings.dart';
import 'models.dart';

/// Local persistence (shared_preferences). Failures fall back silently.
class Store {
  static const _backupFormat = 'accounting-local-backup';
  static const _backupSchemaVersion = 1;
  static const _itemsKey = 'items_v1';
  static const _accountsKey = 'accounts_v1';
  static const _invoicesKey = 'invoices_v1';
  static const _invoiceSequenceKey = 'invoice_next_number_v1';
  static const _printerPreferencesKey = 'printer_preferences_v1';
  static const _invoicePrintSettingsKey = 'invoice_print_settings_v1';
  static const _invoiceDraftPrefix = 'invoice_draft_v1_';

  static Future<String> exportBackup({DateTime? createdAt}) async {
    final prefs = await SharedPreferences.getInstance();
    final items = _decodeList(prefs.getString(_itemsKey), seedItems);
    final accounts = _decodeList(prefs.getString(_accountsKey), _seedAccounts);
    final invoices = _decodeList(
      prefs.getString(_invoicesKey),
      () => <dynamic>[],
    );
    final contents = <String, dynamic>{
      'format': _backupFormat,
      'schemaVersion': _backupSchemaVersion,
      'createdAt': (createdAt ?? DateTime.now()).toUtc().toIso8601String(),
      'inventory': items,
      'accounts': accounts,
      'invoices': invoices,
      'nextInvoiceNumber': prefs.getInt(_invoiceSequenceKey) ?? 1,
    };
    final encoded = jsonEncode(contents);
    parseBackup(encoded);
    return encoded;
  }

  static BackupContents parseBackup(String encoded) {
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! Map) {
        throw const FormatException('الملف ليس نسخة احتياطية صالحة.');
      }
      final backup = Map<String, dynamic>.from(decoded);
      if (backup['format'] != _backupFormat ||
          backup['schemaVersion'] != _backupSchemaVersion) {
        throw const FormatException(
          'إصدار النسخة الاحتياطية غير متوافق مع هذا التطبيق.',
        );
      }
      if (DateTime.tryParse('${backup['createdAt'] ?? ''}') == null) {
        throw const FormatException('تاريخ النسخة الاحتياطية غير صالح.');
      }
      final items = _requireList(backup['inventory'], 'المخزون');
      final accounts = _requireList(backup['accounts'], 'الحسابات');
      final invoices = _requireList(backup['invoices'], 'الفواتير');
      final nextInvoiceNumber = backup['nextInvoiceNumber'];
      if (nextInvoiceNumber is! int || nextInvoiceNumber < 1) {
        throw const FormatException('تسلسل أرقام الفواتير غير صالح.');
      }

      for (final value in items) {
        final item = _requireMap(value, 'صنف');
        if (item['id'] is! String || item['units'] is! List) {
          throw const FormatException('بيانات أحد الأصناف غير مكتملة.');
        }
        for (final unit in item['units'] as List) {
          _requireMap(unit, 'وحدة صنف');
        }
        Item.fromJson(item);
      }
      for (final value in accounts) {
        final account = _requireMap(value, 'حساب');
        if (account['code'] is! String || account['nameAr'] is! String) {
          throw const FormatException('بيانات أحد الحسابات غير مكتملة.');
        }
        Account.fromJson(account);
      }
      for (final value in invoices) {
        final saved = _requireMap(value, 'فاتورة');
        final typeIndex = saved['typeIndex'];
        final invoice = saved['invoice'] is Map
            ? Map<String, dynamic>.from(saved['invoice'] as Map)
            : null;
        if (typeIndex is! int ||
            typeIndex < 0 ||
            typeIndex >= invoiceTypes.length ||
            DateTime.tryParse('${saved['savedAt'] ?? ''}') == null ||
            invoice == null ||
            invoice['number'] is! String ||
            DateTime.tryParse('${invoice['invDate'] ?? ''}') == null ||
            DateTime.tryParse('${invoice['delivDate'] ?? ''}') == null ||
            invoice['lines'] is! List) {
          throw const FormatException('بيانات إحدى الفواتير غير صالحة.');
        }
        for (final line in invoice['lines'] as List) {
          final invoiceLine = _requireMap(line, 'بند فاتورة');
          if (invoiceLine['id'] is! String ||
              invoiceLine['name'] is! String ||
              invoiceLine['qty'] is! num ||
              invoiceLine['price'] is! num) {
            throw const FormatException('بيانات أحد بنود الفاتورة غير صالحة.');
          }
        }
      }
      return BackupContents(
        data: backup,
        inventoryCount: items.length,
        accountCount: accounts.length,
        invoiceCount: invoices.length,
      );
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException(
        'تعذر قراءة النسخة الاحتياطية أو أن بنيتها غير صالحة.',
      );
    }
  }

  static Future<void> restoreBackup(String encoded) async {
    final backup = parseBackup(encoded).data;
    final prefs = await SharedPreferences.getInstance();
    final keys = [_itemsKey, _accountsKey, _invoicesKey, _invoiceSequenceKey];
    final previous = <String, Object?>{
      for (final key in keys)
        key: key == _invoiceSequenceKey ? prefs.get(key) : prefs.getString(key),
    };
    final updates = <String, Object>{
      _itemsKey: jsonEncode(backup['inventory']),
      _accountsKey: jsonEncode(backup['accounts']),
      _invoicesKey: jsonEncode(backup['invoices']),
      _invoiceSequenceKey: backup['nextInvoiceNumber'] as int,
    };
    try {
      for (final entry in updates.entries) {
        final saved = entry.value is int
            ? await prefs.setInt(entry.key, entry.value as int)
            : await prefs.setString(entry.key, entry.value as String);
        if (!saved) throw StateError('تعذر حفظ بيانات النسخة الاحتياطية.');
      }
    } catch (_) {
      for (final key in keys) {
        final value = previous[key];
        if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is String) {
          await prefs.setString(key, value);
        } else {
          await prefs.remove(key);
        }
      }
      rethrow;
    }
  }

  static List<dynamic> _decodeList(
    String? raw,
    List<dynamic> Function() whenMissing,
  ) {
    if (raw == null) return whenMissing();
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      throw const FormatException(
        'تعذر إنشاء النسخة من بيانات محلية غير صالحة.',
      );
    }
    return decoded;
  }

  static List<dynamic> _requireList(Object? value, String field) {
    if (value is! List) {
      throw FormatException('قائمة $field غير صالحة.');
    }
    return value;
  }

  static Map<String, dynamic> _requireMap(Object? value, String field) {
    if (value is! Map) throw FormatException('بيانات $field غير صالحة.');
    return Map<String, dynamic>.from(value);
  }

  static List<Account> _seedAccounts() => [
    Account(code: '1000001', nameAr: 'النقدية'),
    Account(code: '1000002', nameAr: 'الشيكات المستلمة'),
    Account(code: '1000003', nameAr: 'البنك'),
    Account(code: '1000004', nameAr: 'نقدية المدير'),
    Account(code: '1000005', nameAr: 'رصيد مسترجعات'),
  ];

  static Future<List<Account>> loadAccounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_accountsKey);
      if (raw == null) return _seedAccounts();
      return (jsonDecode(raw) as List)
          .map((entry) => Account.fromJson(Map<String, dynamic>.from(entry)))
          .toList();
    } catch (_) {
      return _seedAccounts();
    }
  }

  static Future<void> saveAccounts(List<Account> accounts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _accountsKey,
        jsonEncode(accounts.map((account) => account.toJson()).toList()),
      );
    } catch (_) {}
  }

  static Future<List<Item>> loadItems() async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(_itemsKey);
      if (raw == null) return seedItems();
      return (jsonDecode(raw) as List)
          .map((e) => Item.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return seedItems();
    }
  }

  static Future<bool> saveItems(List<Item> items) async {
    try {
      final p = await SharedPreferences.getInstance();
      return await p.setString(
        _itemsKey,
        jsonEncode(items.map((e) => e.toJson()).toList()),
      );
    } catch (_) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> loadDraft(int type) async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString('draft_$type');
      return raw == null ? null : Map<String, dynamic>.from(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  static Future<List<InvoiceDraft>> loadInvoiceDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    final drafts = <InvoiceDraft>[];
    for (final key in prefs.getKeys()) {
      if (!key.startsWith(_invoiceDraftPrefix)) continue;
      try {
        final raw = prefs.getString(key);
        if (raw == null) continue;
        final draft = InvoiceDraft.fromJson(
          Map<String, dynamic>.from(jsonDecode(raw) as Map),
        );
        if (draft.typeIndex < 0 || draft.typeIndex >= invoiceTypes.length) {
          continue;
        }
        drafts.add(draft);
      } catch (_) {
        // Ignore malformed drafts without affecting other saved invoices.
      }
    }
    drafts.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
    return drafts;
  }

  static Future<bool> saveInvoiceDraft(InvoiceDraft draft) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(
        '$_invoiceDraftPrefix${draft.id}',
        jsonEncode(draft.toJson()),
      );
    } catch (_) {
      return false;
    }
  }

  static Future<bool> clearInvoiceDraft(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_invoiceDraftPrefix$id');
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> saveDraft(int type, Map<String, dynamic> data) async {
    try {
      final p = await SharedPreferences.getInstance();
      return p.setString('draft_$type', jsonEncode(data));
    } catch (_) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> loadInvoices() async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(_invoicesKey);
      if (raw == null) return [];
      return (jsonDecode(raw) as List)
          .map((entry) => Map<String, dynamic>.from(entry))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<String> nextInvoiceNumber() async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(_invoicesKey);
      var next = p.getInt(_invoiceSequenceKey) ?? 1;
      if (raw != null) {
        final entries = jsonDecode(raw) as List;
        if (entries.length + 1 > next) next = entries.length + 1;
        for (final entry in entries) {
          final saved = Map<String, dynamic>.from(entry);
          final invoice = Map<String, dynamic>.from(
            saved['invoice'] as Map? ?? const {},
          );
          final number = int.tryParse('${invoice['number'] ?? ''}');
          if (number != null && number >= next) next = number + 1;
        }
      }
      return next.toString().padLeft(6, '0');
    } catch (_) {
      return '000001';
    }
  }

  static Future<bool> saveInvoice(int type, Map<String, dynamic> data) async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(_invoicesKey);
      final invoices = raw == null
          ? <Map<String, dynamic>>[]
          : (jsonDecode(raw) as List)
                .map((entry) => Map<String, dynamic>.from(entry))
                .toList();
      invoices.add({
        'typeIndex': type,
        'savedAt': DateTime.now().toIso8601String(),
        'invoice': data,
      });
      final saved = await p.setString(_invoicesKey, jsonEncode(invoices));
      if (!saved) return false;
      final number = int.tryParse('${data['number'] ?? ''}');
      if (number != null) {
        final currentNext = p.getInt(_invoiceSequenceKey) ?? 1;
        if (number + 1 > currentNext) {
          await p.setInt(_invoiceSequenceKey, number + 1);
        }
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> clearDraft(int type) async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.remove('draft_$type');
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> loadPrinterPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_printerPreferencesKey);
      if (raw == null) return {};
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      return {};
    } catch (_) {
      return {};
    }
  }

  static Future<bool> savePrinterPreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.setString(_printerPreferencesKey, jsonEncode(preferences));
    } catch (_) {
      return false;
    }
  }

  static Future<InvoicePrintSettings> loadInvoicePrintSettings(
    int typeIndex,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_invoicePrintSettingsKey);
      if (raw == null) return const InvoicePrintSettings();
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return const InvoicePrintSettings();
      }
      final settings = decoded['$typeIndex'];
      if (settings is! Map) return const InvoicePrintSettings();
      return InvoicePrintSettings.fromJson(Map<String, dynamic>.from(settings));
    } catch (_) {
      return const InvoicePrintSettings();
    }
  }

  static Future<bool> saveInvoicePrintSettings(
    int typeIndex,
    InvoicePrintSettings settings,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_invoicePrintSettingsKey);
      final existing = raw == null
          ? <String, dynamic>{}
          : Map<String, dynamic>.from(jsonDecode(raw) as Map);
      existing['$typeIndex'] = settings.toJson();
      return prefs.setString(_invoicePrintSettingsKey, jsonEncode(existing));
    } catch (_) {
      return false;
    }
  }
}

class BackupContents {
  final Map<String, dynamic> data;
  final int inventoryCount;
  final int accountCount;
  final int invoiceCount;

  const BackupContents({
    required this.data,
    required this.inventoryCount,
    required this.accountCount,
    required this.invoiceCount,
  });
}
