// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: AccountHealthStatusModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class AccountHealthStatusModel extends LegacySourceModel {
  AccountHealthStatusModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'AccountHealthStatusModel',
    sourceFile: 'AccountHealthStatusModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'AccountID', vbType: 'long'),
      LegacySourceProperty(name: 'DiseaseID', vbType: 'Byte'),
      LegacySourceProperty(name: 'OtherDiseaseName', vbType: 'String'),
      LegacySourceProperty(name: 'StartDate', vbType: 'date'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
