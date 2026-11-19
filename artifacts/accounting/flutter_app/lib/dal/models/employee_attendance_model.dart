// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: EmployeeAttendanceModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class EmployeeAttendanceModel extends LegacySourceModel {
  EmployeeAttendanceModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'EmployeeAttendanceModel',
    sourceFile: 'EmployeeAttendanceModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'AccountID', vbType: 'long'),
      LegacySourceProperty(name: 'WorkPeriodID', vbType: 'Byte'),
      LegacySourceProperty(name: 'CheckInTime', vbType: 'date'),
      LegacySourceProperty(name: 'TimeOut', vbType: 'date'),
      LegacySourceProperty(name: 'Notes', vbType: 'String'),
      LegacySourceProperty(name: 'PCID', vbType: 'Integer'),
      LegacySourceProperty(name: 'InputMeansID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
