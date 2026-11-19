// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ExamLateStudentModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ExamLateStudentModel extends LegacySourceModel {
  ExamLateStudentModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ExamLateStudentModel',
    sourceFile: 'ExamLateStudentModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'WeekDayID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ExamDate', vbType: 'String'),
      LegacySourceProperty(name: 'ExamPeriodID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ExamTypeID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
