// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: StoreMovementModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class StoreMovementModel extends LegacySourceModel {
  StoreMovementModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'StoreMovementModel',
    sourceFile: 'StoreMovementModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'String'),
      LegacySourceProperty(name: 'StoreCreditorID', vbType: 'long'),
      LegacySourceProperty(name: 'StoreDebtorID', vbType: 'long'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
