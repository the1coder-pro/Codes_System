// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ReservationModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ReservationModel extends LegacySourceModel {
  ReservationModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ReservationModel',
    sourceFile: 'ReservationModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'UnitID', vbType: 'long'),
      LegacySourceProperty(name: 'ReservationDate', vbType: 'date'),
      LegacySourceProperty(name: 'RentTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'StartDate', vbType: 'date'),
      LegacySourceProperty(name: 'EndDate', vbType: 'date'),
      LegacySourceProperty(name: 'RentPrice', vbType: 'Single'),
      LegacySourceProperty(name: 'RequiredAdvancedSum', vbType: 'Single'),
      LegacySourceProperty(name: 'ConfirmationTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ReservationStatusID', vbType: 'Byte'),
      LegacySourceProperty(name: 'CustomerID', vbType: 'long'),
      LegacySourceProperty(name: 'ReservationTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'Note', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
