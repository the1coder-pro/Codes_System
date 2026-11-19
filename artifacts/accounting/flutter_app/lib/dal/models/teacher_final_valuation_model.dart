// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: TeacherFinalValuationModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class TeacherFinalValuationModel extends LegacySourceModel {
  TeacherFinalValuationModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'TeacherFinalValuationModel',
    sourceFile: 'TeacherFinalValuationModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'StudyYearID', vbType: 'Byte'),
      LegacySourceProperty(name: 'TermID', vbType: 'Byte'),
      LegacySourceProperty(name: 'TeacherAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'ValuationFormID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ValuationDate', vbType: 'date'),
      LegacySourceProperty(name: 'StrengthPoint', vbType: 'String'),
      LegacySourceProperty(name: 'WeakPoint', vbType: 'String'),
      LegacySourceProperty(name: 'Recommendation', vbType: 'String'),
      LegacySourceProperty(name: 'ManagerOpinion', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
