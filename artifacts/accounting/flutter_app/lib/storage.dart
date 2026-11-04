import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Local persistence (shared_preferences). Failures fall back silently.
class Store {
  static const _itemsKey = 'items_v1';

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

  static Future<void> saveItems(List<Item> items) async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(
        _itemsKey,
        jsonEncode(items.map((e) => e.toJson()).toList()),
      );
    } catch (_) {}
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
