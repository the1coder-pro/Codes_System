// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: StudentWeeklyValuationModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class StudentWeeklyValuationModel extends LegacySourceModel {
  StudentWeeklyValuationModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'StudentWeeklyValuationModel',
    sourceFile: 'StudentWeeklyValuationModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'EvaluationDate', vbType: 'date'),
      LegacySourceProperty(name: 'ApprovedCourseID', vbType: 'long'),
      LegacySourceProperty(name: 'SubjectStartName', vbType: 'String'),
      LegacySourceProperty(name: 'SubjectStartPageNo', vbType: 'String'),
      LegacySourceProperty(name: 'SubjectEndName', vbType: 'String'),
      LegacySourceProperty(name: 'SubjectEndPageNo', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
