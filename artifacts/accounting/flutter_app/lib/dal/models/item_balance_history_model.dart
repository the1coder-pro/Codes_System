// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ItemBalanceHistoryModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ItemBalanceHistoryModel extends LegacySourceModel {
  ItemBalanceHistoryModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ItemBalanceHistoryModel',
    sourceFile: 'ItemBalanceHistoryModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'PeriodID', vbType: 'long'),
      LegacySourceProperty(name: 'ItemID', vbType: 'long'),
      LegacySourceProperty(name: 'StartPeriodBalance', vbType: 'Single'),
      LegacySourceProperty(name: 'PurchaseCount', vbType: 'Single'),
      LegacySourceProperty(name: 'PurchaseReturnCount', vbType: 'Single'),
      LegacySourceProperty(name: 'SalesCount', vbType: 'Single'),
      LegacySourceProperty(name: 'SalesReturnCount', vbType: 'Single'),
      LegacySourceProperty(name: 'SpentCount', vbType: 'Single'),
      LegacySourceProperty(name: 'SpentReturnCount', vbType: 'Single'),
      LegacySourceProperty(name: 'RentalCount', vbType: 'Single'),
      LegacySourceProperty(name: 'RentalReturnCount', vbType: 'Single'),
      LegacySourceProperty(name: 'OrderMinammBalance', vbType: 'Single'),
      LegacySourceProperty(name: 'OrderCount', vbType: 'Single'),
      LegacySourceProperty(name: 'DecayedCount', vbType: 'Single'),
      LegacySourceProperty(name: 'DecayedReturnCount', vbType: 'Single'),
      LegacySourceProperty(name: 'ProductionCount', vbType: 'Single'),
      LegacySourceProperty(name: 'ProductionCancelCount', vbType: 'Single'),
      LegacySourceProperty(name: 'ProductionReturnCount', vbType: 'Single'),
      LegacySourceProperty(name: 'PurchaseOrderCount', vbType: 'Single'),
      LegacySourceProperty(name: 'SalesOrderCount', vbType: 'Single'),
      LegacySourceProperty(name: 'PackingAndUnPackingCount', vbType: 'Single'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
