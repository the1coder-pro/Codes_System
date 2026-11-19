// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: Resthouse_RentLeaseCancellationModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class Resthouse_RentLeaseCancellationModel extends LegacySourceModel {
  Resthouse_RentLeaseCancellationModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'Resthouse_RentLeaseCancellationModel',
    sourceFile: 'Resthouse_RentLeaseCancellationModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ResthouseRentLeaseID', vbType: 'long'),
      LegacySourceProperty(name: 'CancellationDate', vbType: 'date'),
      LegacySourceProperty(name: 'CancellationReason', vbType: 'String'),
      LegacySourceProperty(name: 'MulctAmount', vbType: 'Single'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
