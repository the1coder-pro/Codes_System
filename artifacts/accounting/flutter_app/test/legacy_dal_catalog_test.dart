import 'dart:convert';
import 'dart:io';

import 'package:accounting_ui/dal/legacy_model_catalog.dart';
import 'package:accounting_ui/dal/legacy_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sourceManifest =
      jsonDecode(
            File('migration/legacy_dal_model_catalog.json').readAsStringSync(),
          )
          as Map<String, dynamic>;
  final expectedModels = sourceManifest['models'] as List<dynamic>;

  test('Flutter catalog matches every legacy model class and property', () {
    expect(legacySourceModelCatalog, hasLength(sourceManifest['class_count']));
    expect(sourceManifest['model_file_count'], 355);
    expect(sourceManifest['class_count'], 357);
    expect(sourceManifest['property_count'], 2136);

    for (var index = 0; index < expectedModels.length; index++) {
      final expected = Map<String, dynamic>.from(expectedModels[index] as Map);
      final definition = legacySourceModelCatalog[index];

      expect(definition.className, expected['class_name']);
      expect(definition.sourceFile, expected['source_file']);
      expect(definition.tableName, expected['table_mapping']['table']);
      expect(
        definition.tableMappingStatus.name,
        expected['table_mapping']['status'],
      );
      expect(definition.properties, hasLength(expected['properties'].length));

      for (
        var fieldIndex = 0;
        fieldIndex < definition.properties.length;
        fieldIndex++
      ) {
        final expectedField = Map<String, dynamic>.from(
          expected['properties'][fieldIndex] as Map,
        );
        expect(definition.properties[fieldIndex].name, expectedField['name']);
        expect(
          definition.properties[fieldIndex].vbType,
          expectedField['vb_type'],
        );
      }
    }
  });

  test('unresolved source model keeps exact keys and raw values', () {
    final model = AbsenceTypeModel({
      'ID': '001',
      'NameAr': null,
      'NameEn': 'Leave',
    });

    expect(model.toMap(), {'ID': '001', 'NameAr': null, 'NameEn': 'Leave'});
    expect(model.modelMetadata.tableName, isNull);
    expect(
      () => AbsenceTypeModel({'ID': 1, 'NameAR': 'wrong case'}),
      throwsArgumentError,
    );
  });

  test('every source model preserves raw Access values without coercion', () {
    const sampleValues = <Object?>[
      null,
      '',
      '001',
      '31/00/2020',
      0,
      0.0,
      false,
      true,
    ];

    for (final definition in legacySourceModelCatalog) {
      final values = <String, Object?>{
        for (var index = 0; index < definition.properties.length; index++)
          definition.properties[index].name:
              sampleValues[index % sampleValues.length],
      };
      final model = _RawSourceModel(definition, values);

      expect(model.toMap(), values, reason: definition.className);
      expect(
        model.modelMetadata,
        same(definition),
        reason: definition.className,
      );
    }
  });
}

class _RawSourceModel extends LegacySourceModel {
  _RawSourceModel(super.modelMetadata, super.values);
}
