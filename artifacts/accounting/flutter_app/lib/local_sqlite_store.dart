import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dal/legacy_data_source.dart';
import 'dal/sqlite_legacy_data_source.dart';

abstract interface class LocalSettingsStore {
  Future<void> initialize();
  Future<Object?> get(String key);
  Future<Set<String>> getKeys();
  Future<bool> setString(String key, String value);
  Future<bool> setInt(String key, int value);
  Future<bool> remove(String key);
}

extension LocalSettingsStoreTypedReads on LocalSettingsStore {
  Future<String?> getString(String key) async {
    final value = await get(key);
    return value is String ? value : null;
  }

  Future<int?> getInt(String key) async {
    final value = await get(key);
    return value is int ? value : null;
  }
}

class SharedPreferencesSettingsStore implements LocalSettingsStore {
  Future<SharedPreferences> get _preferences => SharedPreferences.getInstance();

  @override
  Future<void> initialize() async {}

  @override
  Future<Object?> get(String key) async => (await _preferences).get(key);

  @override
  Future<Set<String>> getKeys() async => (await _preferences).getKeys();

  @override
  Future<bool> setString(String key, String value) async =>
      (await _preferences).setString(key, value);

  @override
  Future<bool> setInt(String key, int value) async =>
      (await _preferences).setInt(key, value);

  @override
  Future<bool> remove(String key) async => (await _preferences).remove(key);
}

/// SQL-backed store for app-local settings and the existing form snapshots.
///
/// The `app_local_*` tables are deliberately separate from the legacy schema.
/// The business screens will move to exact legacy tables as each field mapping
/// is verified against Access metadata.
class SqliteSettingsStore implements LocalSettingsStore {
  SqliteSettingsStore({QueryExecutor? executor})
    : _database = _LocalSettingsDatabase(
        executor ??
            driftDatabase(
              name: 'codes_system_local',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );

  final _LocalSettingsDatabase _database;
  Future<void>? _initialization;

  /// Uses the same SQLite connection as local settings once legacy tables are
  /// installed or imported into this database.
  late final LegacyDataSource legacyDataSource =
      SqliteLegacyDataSource(_database);

  static const _migrationName = 'shared_preferences_v1';
  static const _legacyKeys = {
    'items_v1',
    'accounts_v1',
    'invoices_v1',
    'invoice_next_number_v1',
    'printer_preferences_v1',
    'invoice_print_settings_v1',
  };

  @override
  Future<void> initialize() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    await _database.customStatement('''
      CREATE TABLE IF NOT EXISTS app_local_settings (
        setting_key TEXT PRIMARY KEY NOT NULL,
        setting_value TEXT NOT NULL,
        value_type INTEGER NOT NULL
      )
    ''');
    await _database.customStatement('''
      CREATE TABLE IF NOT EXISTS app_local_migrations (
        migration_name TEXT PRIMARY KEY NOT NULL,
        applied_at TEXT NOT NULL
      )
    ''');
    await _migrateSharedPreferences();
  }

  Future<void> _migrateSharedPreferences() async {
    final applied = await _database
        .customSelect(
          'SELECT 1 FROM app_local_migrations WHERE migration_name = ?',
          variables: [Variable.withString(_migrationName)],
        )
        .getSingleOrNull();
    if (applied != null) return;

    final preferences = await SharedPreferences.getInstance();
    final keys = preferences.getKeys().where(_isStoreKey).toList()..sort();
    final values = <String, Object>{};
    for (final key in keys) {
      final value = preferences.get(key);
      if (value != null) values[key] = value;
    }

    await _database.transaction(() async {
      final marker = await _database
          .customSelect(
            'SELECT 1 FROM app_local_migrations WHERE migration_name = ?',
            variables: [Variable.withString(_migrationName)],
          )
          .getSingleOrNull();
      if (marker != null) return;

      for (final entry in values.entries) {
        final encoded = _encodeValue(entry.value);
        await _database.customStatement(
          '''
          INSERT INTO app_local_settings
            (setting_key, setting_value, value_type)
          VALUES (?, ?, ?)
          ON CONFLICT(setting_key) DO NOTHING
          ''',
          [entry.key, encoded.value, encoded.type],
        );
      }
      await _database.customStatement(
        'INSERT INTO app_local_migrations (migration_name, applied_at) VALUES (?, ?)',
        [_migrationName, DateTime.now().toUtc().toIso8601String()],
      );
    });
    // Keep the original preferences untouched as a recovery copy.
  }

  static bool _isStoreKey(String key) =>
      _legacyKeys.contains(key) ||
      key.startsWith('invoice_draft_v1_') ||
      (key.startsWith('draft_') &&
          int.tryParse(key.substring('draft_'.length)) != null);

  @override
  Future<Object?> get(String key) async {
    await initialize();
    final row = await _database
        .customSelect(
          'SELECT setting_value, value_type FROM app_local_settings WHERE setting_key = ?',
          variables: [Variable.withString(key)],
        )
        .getSingleOrNull();
    if (row == null) return null;
    return _decodeValue(
      row.data['setting_value'] as String,
      row.data['value_type'] as int,
    );
  }

  @override
  Future<Set<String>> getKeys() async {
    await initialize();
    final rows = await _database
        .customSelect('SELECT setting_key FROM app_local_settings')
        .get();
    return rows.map((row) => row.data['setting_key'] as String).toSet();
  }

  @override
  Future<bool> setString(String key, String value) => _setValue(key, value);

  @override
  Future<bool> setInt(String key, int value) => _setValue(key, value);

  Future<bool> _setValue(String key, Object value) async {
    await initialize();
    final encoded = _encodeValue(value);
    await _database.customStatement(
      '''
      INSERT INTO app_local_settings
        (setting_key, setting_value, value_type)
      VALUES (?, ?, ?)
      ON CONFLICT(setting_key) DO UPDATE SET
        setting_value = excluded.setting_value,
        value_type = excluded.value_type
      ''',
      [key, encoded.value, encoded.type],
    );
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    await initialize();
    await _database.customStatement(
      'DELETE FROM app_local_settings WHERE setting_key = ?',
      [key],
    );
    return true;
  }

  Future<void> close() => _database.close();

  static ({String value, int type}) _encodeValue(Object value) {
    if (value is String) return (value: value, type: 0);
    if (value is int) return (value: value.toString(), type: 1);
    if (value is bool) return (value: value ? 'true' : 'false', type: 2);
    if (value is double) return (value: value.toString(), type: 3);
    if (value is List<String>) {
      return (value: jsonEncode(value), type: 4);
    }
    throw ArgumentError.value(value, 'value', 'Unsupported local setting type');
  }

  static Object _decodeValue(String value, int type) => switch (type) {
    0 => value,
    1 => int.parse(value),
    2 => value == 'true',
    3 => double.parse(value),
    4 => (jsonDecode(value) as List).cast<String>(),
    _ => throw StateError('Unsupported local setting type: $type'),
  };
}

class _LocalSettingsDatabase extends GeneratedDatabase {
  _LocalSettingsDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  Iterable<TableInfo> get allTables => const [];
}
