// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: Resthouse_RentLeaseModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class Resthouse_RentLeaseModel extends LegacySourceModel {
  Resthouse_RentLeaseModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'Resthouse_RentLeaseModel',
    sourceFile: 'Resthouse_RentLeaseModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'UnitID', vbType: 'long'),
      LegacySourceProperty(name: 'LeaseDate', vbType: 'date'),
      LegacySourceProperty(name: 'TenantID', vbType: 'long'),
      LegacySourceProperty(name: 'HousingTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'AdditionalConditions', vbType: 'String'),
      LegacySourceProperty(name: 'Rent', vbType: 'Single'),
      LegacySourceProperty(name: 'Insurance', vbType: 'Single'),
      LegacySourceProperty(name: 'ReservationID', vbType: 'long'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
      LegacySourceProperty(name: 'VAT', vbType: 'Single'),
      LegacySourceProperty(name: 'VATValue', vbType: 'Single'),
      LegacySourceProperty(name: 'VatTypeID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
