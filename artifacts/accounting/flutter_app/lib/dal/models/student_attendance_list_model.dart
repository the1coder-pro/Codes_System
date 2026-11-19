// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: StudentAttendanceListModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class StudentAttendanceListModel extends LegacySourceModel {
  StudentAttendanceListModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'StudentAttendanceListModel',
    sourceFile: 'StudentAttendanceListModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'StudentAttendanceID', vbType: 'long'),
      LegacySourceProperty(name: 'StudentAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'AttendanceCaseID', vbType: 'Byte'),
      LegacySourceProperty(name: 'Notes', vbType: 'String'),
      LegacySourceProperty(name: 'LateOrLeaveMinutes', vbType: 'Integer'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
