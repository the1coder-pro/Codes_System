// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: LastRentLeaseRenewalModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class LastRentLeaseRenewalModel extends LegacySourceModel {
  LastRentLeaseRenewalModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'LastRentLeaseRenewalModel',
    sourceFile: 'LastRentLeaseRenewalModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'LeaseID', vbType: 'long'),
      LegacySourceProperty(name: 'LastOfRenewalDate', vbType: 'date'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
