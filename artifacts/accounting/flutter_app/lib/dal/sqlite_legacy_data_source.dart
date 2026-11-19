import 'package:drift/drift.dart';

import 'legacy_data_source.dart';
import 'legacy_models.dart';

/// SQLite implementation of the shared legacy-table CRUD contract.
///
/// It expects the exact legacy tables to exist in the supplied Drift database.
/// Schema installation/import stays a separate, explicit migration step.
class SqliteLegacyDataSource implements LegacyDataSource {
  const SqliteLegacyDataSource(this.database);

  final GeneratedDatabase database;

  @override
  Future<List<Map<String, Object?>>> select(
    LegacyTableMetadata table, {
    Map<String, Object?> equals = const {},
  }) async {
    table.validateFields(equals);
    final where = _whereClause(equals);
    final rows = await database
        .customSelect(
          'SELECT * FROM ${_quote(table, table.tableName)}${where.sql}',
          variables: where.variables,
        )
        .get();
    return rows
        .map((row) => Map<String, Object?>.from(row.data))
        .toList(growable: false);
  }

  @override
  Future<Map<String, Object?>> upsert(
    LegacyTableMetadata table,
    Map<String, Object?> values,
  ) async {
    table.validateFields(values, requirePrimaryKey: true);
    if (values.isEmpty) throw ArgumentError('Cannot save an empty row.');

    final columns = values.keys.toList(growable: false);
    final quotedColumns = columns.map((name) => _quote(table, name)).join(', ');
    final placeholders = List.filled(columns.length, '?').join(', ');
    final conflict = table.primaryKey
        .map((name) => _quote(table, name))
        .join(', ');
    final updates = columns
        .where((name) => !table.primaryKey.contains(name))
        .map(
          (name) => '${_quote(table, name)} = excluded.${_quote(table, name)}',
        )
        .join(', ');
    final conflictAction = updates.isEmpty
        ? 'DO NOTHING'
        : 'DO UPDATE SET $updates';

    await database.customStatement(
      'INSERT INTO ${_quote(table, table.tableName)} ($quotedColumns) '
      'VALUES ($placeholders) ON CONFLICT ($conflict) $conflictAction',
      columns.map((name) => _sqliteValue(values[name])).toList(growable: false),
    );

    final key = {for (final name in table.primaryKey) name: values[name]};
    final saved = await select(table, equals: key);
    if (saved.isEmpty) {
      throw StateError('Saved ${table.tableName} row could not be read back.');
    }
    return saved.first;
  }

  @override
  Future<void> delete(
    LegacyTableMetadata table,
    Map<String, Object?> primaryKey,
  ) async {
    table.validateFields(primaryKey, requirePrimaryKey: true);
    if (primaryKey.length != table.primaryKey.length) {
      throw ArgumentError('Supply only the complete primary key.');
    }
    final where = _whereClause(primaryKey);
    await database.customStatement(
      'DELETE FROM ${_quote(table, table.tableName)}${where.sql}',
      where.values.map(_sqliteValue).toList(growable: false),
    );
  }

  ({String sql, List<Variable> variables, List<Object?> values}) _whereClause(
    Map<String, Object?> equals,
  ) {
    if (equals.isEmpty) return (sql: '', variables: const [], values: const []);
    final conditions = <String>[];
    final variables = <Variable>[];
    final values = <Object?>[];
    for (final entry in equals.entries) {
      if (entry.value == null) {
        conditions.add('${_quoteColumn(entry.key)} IS NULL');
      } else {
        conditions.add('${_quoteColumn(entry.key)} = ?');
        variables.add(_variable(entry.value!));
        values.add(entry.value);
      }
    }
    return (
      sql: ' WHERE ${conditions.join(' AND ')}',
      variables: variables,
      values: values,
    );
  }

  String _quote(LegacyTableMetadata table, String identifier) {
    if (identifier != table.tableName && !table.columns.contains(identifier)) {
      throw ArgumentError('Unknown identifier for ${table.tableName}.');
    }
    return _quoteColumn(identifier);
  }

  String _quoteColumn(String identifier) =>
      '"${identifier.replaceAll('"', '""')}"';

  Variable _variable(Object value) {
    if (value is bool) return Variable.withInt(value ? 1 : 0);
    if (value is int) return Variable.withInt(value);
    if (value is double) return Variable.withReal(value);
    if (value is String) return Variable.withString(value);
    if (value is Uint8List) return Variable.withBlob(value);
    throw ArgumentError.value(
      value,
      'value',
      'Pass legacy dates as their original string representation.',
    );
  }

  Object? _sqliteValue(Object? value) {
    if (value is bool) return value ? 1 : 0;
    if (value == null ||
        value is int ||
        value is double ||
        value is String ||
        value is Uint8List) {
      return value;
    }
    throw ArgumentError.value(
      value,
      'value',
      'Pass legacy dates as their original string representation.',
    );
  }
}
