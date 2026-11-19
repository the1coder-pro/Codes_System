// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: CalendarModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class CalendarModel extends LegacySourceModel {
  CalendarModel(Map<String, Object?> values) : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'CalendarModel',
    sourceFile: 'CalendarModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'YearID', vbType: 'Integer'),
      LegacySourceProperty(name: 'MonthID', vbType: 'Byte'),
      LegacySourceProperty(name: 'DayID', vbType: 'Byte'),
      LegacySourceProperty(name: 'TheDate', vbType: 'date'),
      LegacySourceProperty(name: 'SeasonID', vbType: 'Integer'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
