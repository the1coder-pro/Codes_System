import 'dart:convert';

import 'package:http/http.dart' as http;

import 'legacy_data_source.dart';
import 'legacy_models.dart';

typedef SupabaseAccessTokenProvider = Future<String?> Function();

/// Supabase/PostgREST implementation of the shared legacy-table CRUD contract.
///
/// Pass a publishable/anon key and the signed-in user's access token provider.
/// Never pass a Supabase service-role key to a Flutter client.
class SupabaseLegacyDataSource implements LegacyDataSource {
  SupabaseLegacyDataSource({
    required String projectUrl,
    required this.anonKey,
    http.Client? client,
    this.accessTokenProvider,
  }) : _projectUri = _validateProjectUrl(projectUrl),
       _client = client ?? http.Client(),
       _ownsClient = client == null {
    if (anonKey.trim().isEmpty) {
      throw ArgumentError.value(
        anonKey,
        'anonKey',
        'A public key is required.',
      );
    }
  }

  final Uri _projectUri;
  final String anonKey;
  final http.Client _client;
  final bool _ownsClient;
  final SupabaseAccessTokenProvider? accessTokenProvider;

  static Uri _validateProjectUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw ArgumentError.value(
        value,
        'projectUrl',
        'Use the Supabase project URL without query parameters.',
      );
    }
    return uri;
  }

  @override
  Future<List<Map<String, Object?>>> select(
    LegacyTableMetadata table, {
    Map<String, Object?> equals = const {},
  }) async {
    table.validateFields(equals);
    final query = <String, String>{'select': '*'};
    for (final entry in equals.entries) {
      query[entry.key] = _postgrestFilter(entry.value);
    }
    final response = await _client.get(
      _tableUri(table, query),
      headers: await _headers(),
    );
    final decoded = _decodeResponse(response);
    if (decoded == null) return [];
    if (decoded is! List) {
      throw const FormatException('Supabase returned a non-list table result.');
    }
    return decoded
        .map((row) {
          if (row is! Map) {
            throw const FormatException('Supabase returned an invalid row.');
          }
          final values = Map<String, Object?>.from(row);
          table.validateFields(values);
          return values;
        })
        .toList(growable: false);
  }

  @override
  Future<Map<String, Object?>> upsert(
    LegacyTableMetadata table,
    Map<String, Object?> values,
  ) async {
    table.validateFields(values, requirePrimaryKey: true);
    final response = await _client.post(
      _tableUri(table, {'on_conflict': table.primaryKey.join(',')}),
      headers: {
        ...await _headers(),
        'Content-Type': 'application/json',
        'Prefer': 'resolution=merge-duplicates,return=representation',
      },
      body: jsonEncode(values),
    );
    final decoded = _decodeResponse(response);
    if (decoded is List && decoded.isNotEmpty && decoded.first is Map) {
      final saved = Map<String, Object?>.from(decoded.first as Map);
      table.validateFields(saved);
      return saved;
    }
    if (decoded is Map) {
      final saved = Map<String, Object?>.from(decoded);
      table.validateFields(saved);
      return saved;
    }
    return Map<String, Object?>.of(values);
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
    final query = {
      for (final entry in primaryKey.entries)
        entry.key: _postgrestFilter(entry.value),
    };
    final response = await _client.delete(
      _tableUri(table, query),
      headers: await _headers(),
    );
    _decodeResponse(response);
  }

  Uri _tableUri(LegacyTableMetadata table, Map<String, String> query) {
    table.validateFields({
      for (final name in query.keys)
        if (name != 'select' && name != 'on_conflict') name: null,
    });
    final basePath = _projectUri.path.replaceFirst(RegExp(r'/+$'), '');
    return _projectUri.replace(
      path: '$basePath/rest/v1/${table.tableName}',
      queryParameters: query,
    );
  }

  Future<Map<String, String>> _headers() async {
    final accessToken = await accessTokenProvider?.call();
    return {
      'apikey': anonKey,
      'Authorization':
          'Bearer ${accessToken?.trim().isNotEmpty == true ? accessToken : anonKey}',
      'Accept': 'application/json',
    };
  }

  String _postgrestFilter(Object? value) {
    if (value == null) return 'is.null';
    if (value is bool) return 'eq.${value ? 'true' : 'false'}';
    if (value is num) return 'eq.$value';
    if (value is String) {
      final escaped = value.replaceAll(r'\', r'\\').replaceAll('"', r'\"');
      return 'eq."$escaped"';
    }
    throw ArgumentError.value(value, 'value', 'Unsupported Supabase filter.');
  }

  Object? _decodeResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw SupabaseDataSourceException(
        statusCode: response.statusCode,
        responseBody: response.body,
      );
    }
    if (response.body.trim().isEmpty) return null;
    return jsonDecode(response.body);
  }

  void close() {
    if (_ownsClient) _client.close();
  }
}

class SupabaseDataSourceException implements Exception {
  const SupabaseDataSourceException({
    required this.statusCode,
    required this.responseBody,
  });

  final int statusCode;
  final String responseBody;

  @override
  String toString() => 'Supabase request failed with HTTP $statusCode.';
}
