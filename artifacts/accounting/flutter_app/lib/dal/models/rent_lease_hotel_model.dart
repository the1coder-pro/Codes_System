// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: RentLease_HotelModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class RentLease_HotelModel extends LegacySourceModel {
  RentLease_HotelModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'RentLease_HotelModel',
    sourceFile: 'RentLease_HotelModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'UnitID', vbType: 'long'),
      LegacySourceProperty(name: 'TenantID', vbType: 'long'),
      LegacySourceProperty(name: 'LeaseDate', vbType: 'date'),
      LegacySourceProperty(name: 'StartDate', vbType: 'date'),
      LegacySourceProperty(name: 'DurationMonthCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'Rent', vbType: 'Single'),
      LegacySourceProperty(name: 'Insurance', vbType: 'Single'),
      LegacySourceProperty(name: 'AdditionalConditions', vbType: 'String'),
      LegacySourceProperty(name: 'LastPaymentDate', vbType: 'date'),
      LegacySourceProperty(name: 'LastPaymentUntilDate', vbType: 'date'),
      LegacySourceProperty(name: 'EndDate', vbType: 'date'),
      LegacySourceProperty(name: 'UnitStatusID', vbType: 'Byte'),
      LegacySourceProperty(name: 'LastPaymentStartDate', vbType: 'date'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
      LegacySourceProperty(name: 'VAT', vbType: 'Single'),
      LegacySourceProperty(name: 'VATValue', vbType: 'Single'),
      LegacySourceProperty(name: 'VatTypeID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
