// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: non_constant_identifier_names

import '../legacy_model.dart';

class ItemBalanceModel extends LegacyModel {
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
