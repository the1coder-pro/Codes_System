// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: AccountExperienceModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class AccountExperienceModel extends LegacySourceModel {
  AccountExperienceModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'AccountExperienceModel',
    sourceFile: 'AccountExperienceModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'AccountID', vbType: 'long'),
      LegacySourceProperty(name: 'ExperienceTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'OtherExperienceTypeName', vbType: 'String'),
      LegacySourceProperty(name: 'StartDate', vbType: 'date'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
