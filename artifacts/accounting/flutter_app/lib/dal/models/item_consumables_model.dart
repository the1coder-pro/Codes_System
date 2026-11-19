// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ItemConsumablesModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ItemConsumablesModel extends LegacySourceModel {
  ItemConsumablesModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ItemConsumablesModel',
    sourceFile: 'ItemConsumablesModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ItemID', vbType: 'long'),
      LegacySourceProperty(name: 'ConsumableItemID', vbType: 'long'),
      LegacySourceProperty(name: 'Qty', vbType: 'Single'),
      LegacySourceProperty(name: 'InvoiceTypeID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
