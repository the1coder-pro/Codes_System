// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: RentLeaseRenewalModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class RentLeaseRenewalModel extends LegacySourceModel {
  RentLeaseRenewalModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'RentLeaseRenewalModel',
    sourceFile: 'RentLeaseRenewalModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'LeaseID', vbType: 'long'),
      LegacySourceProperty(name: 'DurationByMonth', vbType: 'Byte'),
      LegacySourceProperty(name: 'DurationByDay', vbType: 'Integer'),
      LegacySourceProperty(name: 'LastPaymentUntilDate', vbType: 'date'),
      LegacySourceProperty(name: 'LastPaymentStartDate', vbType: 'date'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
      LegacySourceProperty(name: 'Rent', vbType: 'Single'),
      LegacySourceProperty(name: 'Water', vbType: 'Single'),
      LegacySourceProperty(name: 'Commission', vbType: 'Single'),
      LegacySourceProperty(name: 'RenewalDate', vbType: 'date'),
      LegacySourceProperty(name: 'DurationCount', vbType: 'Integer'),
      LegacySourceProperty(name: 'PaymentPeriodType', vbType: 'Byte'),
      LegacySourceProperty(name: 'PaymentPeriodCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'VAT', vbType: 'Single'),
      LegacySourceProperty(name: 'VATValue', vbType: 'Single'),
      LegacySourceProperty(name: 'VatTypeID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
