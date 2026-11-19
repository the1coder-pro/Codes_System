// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: AbsenceProcedureRuleModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class AbsenceProcedureRuleModel extends LegacySourceModel {
  AbsenceProcedureRuleModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'AbsenceProcedureRuleModel',
    sourceFile: 'AbsenceProcedureRuleModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Byte'),
      LegacySourceProperty(name: 'WeeklyLessonsNo', vbType: 'Byte'),
      LegacySourceProperty(name: 'AbsencePercentage', vbType: 'Single'),
      LegacySourceProperty(name: 'AbsenceLessonsNo', vbType: 'Byte'),
      LegacySourceProperty(name: 'AttendanceCaseID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ProcedureTypeID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
