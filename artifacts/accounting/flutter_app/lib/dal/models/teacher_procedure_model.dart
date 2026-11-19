// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: TeacherProcedureModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class TeacherProcedureModel extends LegacySourceModel {
  TeacherProcedureModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'TeacherProcedureModel',
    sourceFile: 'TeacherProcedureModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'TeacherAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'StudyYearID', vbType: 'Byte'),
      LegacySourceProperty(name: 'TermID', vbType: 'Byte'),
      LegacySourceProperty(name: 'TeacherProcedureSubjectID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ProcedureDate', vbType: 'date'),
      LegacySourceProperty(name: 'StudyTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ApprovedCourseID', vbType: 'long'),
      LegacySourceProperty(name: 'TeacherProcedureID', vbType: 'Byte'),
      LegacySourceProperty(name: 'MeetDate', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
