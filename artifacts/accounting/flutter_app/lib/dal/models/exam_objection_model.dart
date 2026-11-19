// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ExamObjectionModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ExamObjectionModel extends LegacySourceModel {
  ExamObjectionModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ExamObjectionModel',
    sourceFile: 'ExamObjectionModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'ObjectionDate', vbType: 'String'),
      LegacySourceProperty(name: 'StudentAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'ExamDistributionTableID', vbType: 'long'),
      LegacySourceProperty(name: 'ObjectionTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ObjectionText', vbType: 'String'),
      LegacySourceProperty(name: 'ReviewerAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'Accepted', vbType: 'boolean'),
      LegacySourceProperty(name: 'Reason', vbType: 'String'),
      LegacySourceProperty(name: 'ExaminationUnitNote', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
