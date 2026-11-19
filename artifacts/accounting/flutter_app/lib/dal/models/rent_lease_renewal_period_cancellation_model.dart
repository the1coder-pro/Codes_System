// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: RentLeaseRenewalPeriodCancellationModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class RentLeaseRenewalPeriodCancellationModel extends LegacySourceModel {
  RentLeaseRenewalPeriodCancellationModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'RentLeaseRenewalPeriodCancellationModel',
    sourceFile: 'RentLeaseRenewalPeriodCancellationModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'RentLeaseRenewalID', vbType: 'long'),
      LegacySourceProperty(name: 'CancellationDate', vbType: 'date'),
      LegacySourceProperty(name: 'CancellationReason', vbType: 'String'),
      LegacySourceProperty(name: 'DurationByMonth', vbType: 'Byte'),
      LegacySourceProperty(name: 'DurationByDay', vbType: 'Integer'),
      LegacySourceProperty(name: 'LastPaymentUntilDate', vbType: 'date'),
      LegacySourceProperty(name: 'LastPaymentStartDate', vbType: 'date'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
      LegacySourceProperty(name: 'Rent', vbType: 'Single'),
      LegacySourceProperty(name: 'Water', vbType: 'Single'),
      LegacySourceProperty(name: 'Commission', vbType: 'Single'),
      LegacySourceProperty(name: 'ReturnPeriodType', vbType: 'Byte'),
      LegacySourceProperty(name: 'ReturnPeriodCount', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
