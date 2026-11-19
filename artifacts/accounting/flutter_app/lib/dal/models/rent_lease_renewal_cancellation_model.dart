// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: RentLeaseRenewalCancellationModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class RentLeaseRenewalCancellationModel extends LegacySourceModel {
  RentLeaseRenewalCancellationModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'RentLeaseRenewalCancellationModel',
    sourceFile: 'RentLeaseRenewalCancellationModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'RentLeaseRenewalID', vbType: 'long'),
      LegacySourceProperty(name: 'CancellationDate', vbType: 'date'),
      LegacySourceProperty(name: 'CancellationReason', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
