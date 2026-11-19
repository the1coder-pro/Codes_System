// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: DailyScheduleModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class DailyScheduleModel extends LegacySourceModel {
  DailyScheduleModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'DailyScheduleModel',
    sourceFile: 'DailyScheduleModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ScheduleDate', vbType: 'date'),
      LegacySourceProperty(name: 'ScheduleTime', vbType: 'date'),
      LegacySourceProperty(name: 'Subject', vbType: 'String'),
      LegacySourceProperty(name: 'Location', vbType: 'String'),
      LegacySourceProperty(name: 'Remark', vbType: 'String'),
      LegacySourceProperty(name: 'ExecutionStatusID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
