// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: StoredItemBalanceModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class StoredItemBalanceModel extends LegacySourceModel {
  StoredItemBalanceModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'StoredItemBalanceModel',
    sourceFile: 'StoredItemBalanceModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'BuyQty', vbType: 'long'),
      LegacySourceProperty(name: 'OutQty', vbType: 'long'),
      LegacySourceProperty(name: 'CurrentQty', vbType: 'long'),
      LegacySourceProperty(name: 'ReturnFromCustomer', vbType: 'long'),
      LegacySourceProperty(name: 'ReturnToSupplier', vbType: 'long'),
      LegacySourceProperty(name: 'MaximumQty', vbType: 'long'),
      LegacySourceProperty(name: 'MinimumQty', vbType: 'long'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
