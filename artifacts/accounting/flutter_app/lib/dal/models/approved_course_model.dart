// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ApprovedCourseModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ApprovedCourseModel extends LegacySourceModel {
  ApprovedCourseModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ApprovedCourseModel',
    sourceFile: 'ApprovedCourseModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'StudentTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'StudyTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'StudyLevelID', vbType: 'Byte'),
      LegacySourceProperty(name: 'StudyYearID', vbType: 'Byte'),
      LegacySourceProperty(name: 'TermID', vbType: 'Byte'),
      LegacySourceProperty(name: 'TeacherAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'CourseID', vbType: 'Integer'),
      LegacySourceProperty(name: 'StudyBookID', vbType: 'Integer'),
      LegacySourceProperty(name: 'SubjectStartName', vbType: 'String'),
      LegacySourceProperty(name: 'SubjectStartPageNo', vbType: 'String'),
      LegacySourceProperty(name: 'SubjectEndName', vbType: 'String'),
      LegacySourceProperty(name: 'SubjectEndPageNo', vbType: 'String'),
      LegacySourceProperty(name: 'Notes', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
