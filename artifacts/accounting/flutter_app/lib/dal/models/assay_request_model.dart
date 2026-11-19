// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: AssayRequestModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class AssayRequestModel extends LegacySourceModel {
  AssayRequestModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'AssayRequestModel',
    sourceFile: 'AssayRequestModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'RequestDate', vbType: 'date'),
      LegacySourceProperty(name: 'CustomerAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'IsClosed', vbType: 'boolean'),
      LegacySourceProperty(name: 'PCID', vbType: 'Integer'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
