/// Metadata and value-preserving model wrappers for the Access-era tables.
///
/// Values stay dynamic on purpose: imported date fields can contain historical
/// values that Dart's DateTime parser cannot represent. Adapters must preserve
/// the original value and exact column spelling.
class LegacyTableMetadata {
  LegacyTableMetadata({
    required this.tableName,
    required List<String> columns,
    required List<String> primaryKey,
  }) : columns = Set.unmodifiable(columns),
       primaryKey = List.unmodifiable(primaryKey) {
    if (tableName.isEmpty || this.columns.isEmpty || this.primaryKey.isEmpty) {
      throw ArgumentError(
        'Legacy table metadata must include a table and key.',
      );
    }
    if (!this.columns.containsAll(this.primaryKey)) {
      throw ArgumentError('Every primary-key field must be a table column.');
    }
  }

  final String tableName;
  final Set<String> columns;
  final List<String> primaryKey;

  void validateFields(
    Map<String, Object?> values, {
    bool requirePrimaryKey = false,
  }) {
    final unknown = values.keys.where((name) => !columns.contains(name));
    if (unknown.isNotEmpty) {
      throw ArgumentError(
        'Unknown field for $tableName: ${unknown.join(', ')}',
      );
    }
    if (requirePrimaryKey &&
        primaryKey.any((field) => !values.containsKey(field))) {
      throw ArgumentError('A complete $tableName primary key is required.');
    }
  }
}

class LegacyModelDefinition {
  const LegacyModelDefinition({required this.metadata, required this.fromMap});

  final LegacyTableMetadata metadata;
  final LegacyModel Function(Map<String, Object?> values) fromMap;
}

abstract class LegacyModel {
  LegacyModel(this.modelDefinition, Map<String, Object?> values)
    : _values = Map.unmodifiable(Map<String, Object?>.of(values)) {
    modelDefinition.metadata.validateFields(_values);
  }

  final LegacyModelDefinition modelDefinition;
  final Map<String, Object?> _values;

  Object? operator [](String exactLegacyFieldName) =>
      _values[exactLegacyFieldName];

  Map<String, Object?> toMap() => Map<String, Object?>.of(_values);
}
