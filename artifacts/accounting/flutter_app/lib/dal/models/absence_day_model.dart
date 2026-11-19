// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: AbsenceDayModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class absenceDayModel extends LegacySourceModel {
  absenceDayModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'absenceDayModel',
    sourceFile: 'AbsenceDayModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'accountID', vbType: 'long'),
      LegacySourceProperty(name: 'absenceDate', vbType: 'date'),
      LegacySourceProperty(name: 'absenceType', vbType: 'Byte'),
      LegacySourceProperty(name: 'absenceDays', vbType: 'Byte'),
      LegacySourceProperty(name: 'absenceHours', vbType: 'Double'),
      LegacySourceProperty(name: 'absenceNote', vbType: 'String'),
      LegacySourceProperty(name: 'absenceDeduct', vbType: 'long'),
      LegacySourceProperty(name: 'HospitalNo', vbType: 'Integer'),
      LegacySourceProperty(name: 'SickenStatusNo', vbType: 'Byte'),
      LegacySourceProperty(name: 'MedicamentCost', vbType: 'Integer'),
      LegacySourceProperty(name: 'SendingNo', vbType: 'long'),
      LegacySourceProperty(name: 'SupposedReturnDate', vbType: 'date'),
      LegacySourceProperty(name: 'actuallyReturnDate', vbType: 'date'),
      LegacySourceProperty(name: 'DocumentImagePath', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
