import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Local persistence (shared_preferences). Failures fall back silently.
class Store {
  static const _itemsKey = 'items_v1';
  static const _accountsKey = 'accounts_v1';

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

  static Future<void> clearDraft(int type) async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.remove('draft_$type');
    } catch (_) {}
  }
}
