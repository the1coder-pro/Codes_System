// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: SMSMessageRentLeaseRenewalModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class SMSMessageRentLeaseRenewalModel extends LegacySourceModel {
  SMSMessageRentLeaseRenewalModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'SMSMessageRentLeaseRenewalModel',
    sourceFile: 'SMSMessageRentLeaseRenewalModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'RentLeaseRenewalID', vbType: 'long'),
      LegacySourceProperty(name: 'SMSMessageTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'SMSMessageRecordID', vbType: 'long'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
