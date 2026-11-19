// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: non_constant_identifier_names

import '../legacy_model.dart';

class ItemBalanceModel extends LegacyModel {
  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ItemBalanceModel',
    sourceFile: 'ItemBalanceModel.vb',
    tableName: 'tblItemBalance',
    tableMappingStatus: LegacyModelTableMappingStatus.confirmed,
    properties: [
      LegacySourceProperty(name: 'ItemID', vbType: 'Long'),
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
      LegacySourceProperty(name: 'PackingandUnPackingCount', vbType: 'Single'),
      LegacySourceProperty(name: 'StartPeriodBalanceReturn', vbType: 'Single'),
      LegacySourceProperty(name: 'CostPrice', vbType: 'Single'),
      LegacySourceProperty(name: 'LastPurchasePrice', vbType: 'Single'),
      LegacySourceProperty(name: 'Qty', vbType: 'Single'),
      LegacySourceProperty(name: 'MaxPurchasePrice', vbType: 'Single'),
      LegacySourceProperty(name: 'MinPurchasePrice', vbType: 'Single'),
      LegacySourceProperty(name: 'LastPurchaseDate', vbType: 'Date'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
  ItemBalanceModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblItemBalance',
      primaryKey: ['ItemID'],
      columns: [
        'ItemID',
        'StartPeriodBalance',
        'PurchaseCount',
        'PurchaseReturnCount',
        'SalesCount',
        'SalesReturnCount',
        'SpentCount',
        'SpentReturnCount',
        'RentalCount',
        'RentalReturnCount',
        'OrderMinammBalance',
        'OrderCount',
        'DecayedCount',
        'DecayedReturnCount',
        'ProductionCount',
        'ProductionCancelCount',
        'ProductionReturnCount',
        'PurchaseOrderCount',
        'SalesOrderCount',
        'PackingAndUnPackingCount',
        'StartPeriodBalanceReturn',
        'LastPurchaseDate',
        'MinPurchasePrice',
        'MaxPurchasePrice',
        'LastPurchasePrice',
        'Qty',
        'CostPrice',
        'LastSalesDate',
        'MinSalesPrice',
        'MaxSalesPrice',
        'LastSalesPrice',
      ],
    ),
    fromMap: ItemBalanceModel.new,
  );

  factory ItemBalanceModel.fromMap(Map<String, Object?> values) =>
      ItemBalanceModel(values);

  Object? get ItemID => this['ItemID'];
  Object? get Qty => this['Qty'];
  Object? get CostPrice => this['CostPrice'];
  Object? get LastPurchaseDate => this['LastPurchaseDate'];
  Object? get LastSalesDate => this['LastSalesDate'];
}
