import 'legacy_models.dart';

/// Identical CRUD contract for the offline SQLite and online Supabase adapters.
abstract interface class LegacyDataSource {
  Future<List<Map<String, Object?>>> select(
    LegacyTableMetadata table, {
    Map<String, Object?> equals = const {},
  });

  Future<Map<String, Object?>> upsert(
    LegacyTableMetadata table,
    Map<String, Object?> values,
  );

  Future<void> delete(
    LegacyTableMetadata table,
    Map<String, Object?> primaryKey,
  );
}

/// DAL-style repository that returns the same model regardless of backend.
class LegacyRepository<T extends LegacyModel> {
  const LegacyRepository({
    required LegacyDataSource dataSource,
    required LegacyModelDefinition definition,
  }) : _dataSource = dataSource,
       _definition = definition;

  final LegacyDataSource _dataSource;
  final LegacyModelDefinition _definition;

  Future<List<T>> list({Map<String, Object?> equals = const {}}) async {
    _validateWhere(equals);
    final rows = await _dataSource.select(_definition.metadata, equals: equals);
    return rows.map(_decode).toList(growable: false);
  }

  Future<T?> byKey(Map<String, Object?> primaryKey) async {
    _validatePrimaryKey(primaryKey);
    final rows = await _dataSource.select(
      _definition.metadata,
      equals: primaryKey,
    );
    return rows.isEmpty ? null : _decode(rows.first);
  }

  Future<T> save(T model) async {
    if (model.modelDefinition.metadata.tableName !=
        _definition.metadata.tableName) {
      throw ArgumentError(
        'Cannot save ${model.modelDefinition.metadata.tableName} through '
        '${_definition.metadata.tableName}.',
      );
    }
    _definition.metadata.validateFields(model.toMap(), requirePrimaryKey: true);
    return _decode(
      await _dataSource.upsert(_definition.metadata, model.toMap()),
    );
  }

  Future<void> deleteByKey(Map<String, Object?> primaryKey) {
    _validatePrimaryKey(primaryKey);
    return _dataSource.delete(_definition.metadata, primaryKey);
  }

  T _decode(Map<String, Object?> row) => _definition.fromMap(row) as T;

  void _validateWhere(Map<String, Object?> equals) {
    _definition.metadata.validateFields(equals);
  }

  void _validatePrimaryKey(Map<String, Object?> key) {
    _definition.metadata.validateFields(key, requirePrimaryKey: true);
    if (key.length != _definition.metadata.primaryKey.length) {
      throw ArgumentError('Supply only the complete primary key.');
    }
  }
}
