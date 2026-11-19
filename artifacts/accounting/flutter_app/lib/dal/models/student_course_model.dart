// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: StudentCourseModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class StudentCourseModel extends LegacySourceModel {
  StudentCourseModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'StudentCourseModel',
    sourceFile: 'StudentCourseModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'StudentAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'ApprovedCourseID', vbType: 'long'),
      LegacySourceProperty(name: 'MidTermMark', vbType: 'Single'),
      LegacySourceProperty(name: 'FinalMark', vbType: 'Single'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
