// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: RestHouse_RentLeaseRentGroupModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class RestHouse_RentLeaseRentGroupModel extends LegacySourceModel {
  RestHouse_RentLeaseRentGroupModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'RestHouse_RentLeaseRentGroupModel',
    sourceFile: 'RestHouse_RentLeaseRentGroupModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'RestHouseRentLeaseID', vbType: 'long'),
      LegacySourceProperty(name: 'RentGroupID', vbType: 'Integer'),
      LegacySourceProperty(name: 'RentDate', vbType: 'date'),
      LegacySourceProperty(name: 'Price', vbType: 'Single'),
      LegacySourceProperty(name: 'VAT', vbType: 'Single'),
      LegacySourceProperty(name: 'VATValue', vbType: 'Single'),
      LegacySourceProperty(name: 'VatTypeID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
