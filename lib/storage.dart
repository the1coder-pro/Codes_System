import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'invoice_print_settings.dart';
import 'models.dart';

/// Local persistence (shared_preferences). Failures fall back silently.
class Store {
  static const _itemsKey = 'items_v1';
  static const _accountsKey = 'accounts_v1';
  static const _invoicesKey = 'invoices_v1';
  static const _invoiceSequenceKey = 'invoice_next_number_v1';
  static const _printerPreferencesKey = 'printer_preferences_v1';
  static const _invoicePrintSettingsKey = 'invoice_print_settings_v1';

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
