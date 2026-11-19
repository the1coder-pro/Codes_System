// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: GeneralGradeModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class GeneralGradeModel extends LegacySourceModel {
  GeneralGradeModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'GeneralGradeModel',
    sourceFile: 'GeneralGradeModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Byte'),
      LegacySourceProperty(name: 'NameAr', vbType: 'String'),
      LegacySourceProperty(name: 'NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'LaterAr', vbType: 'String'),
      LegacySourceProperty(name: 'LaterEn', vbType: 'String'),
      LegacySourceProperty(name: 'StartMark', vbType: 'Single'),
      LegacySourceProperty(name: 'EndMark', vbType: 'Single'),
      LegacySourceProperty(name: 'StartMarkIncluded', vbType: 'boolean'),
      LegacySourceProperty(name: 'EndMarkIncluded', vbType: 'boolean'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
