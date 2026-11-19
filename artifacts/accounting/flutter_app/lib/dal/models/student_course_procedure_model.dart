// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: StudentCourseProcedureModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class StudentCourseProcedureModel extends LegacySourceModel {
  StudentCourseProcedureModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'StudentCourseProcedureModel',
    sourceFile: 'StudentCourseProcedureModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'StudentAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'ApprovedCourseID', vbType: 'long'),
      LegacySourceProperty(name: 'ProcedureTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ProcedureDate', vbType: 'date'),
      LegacySourceProperty(name: 'ProcedureReason', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
