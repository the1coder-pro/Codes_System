// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: non_constant_identifier_names

import '../legacy_model.dart';

class ItemModel extends LegacyModel {
  ItemModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblItem',
      primaryKey: ['ID'],
      columns: [
        'ID',
        'Price',
        'MinimumPrice',
        'WholesalePrice',
        'quickitem',
        'ItemGroupID',
        'WithVatPrice',
      ],
    ),
    fromMap: ItemModel.new,
  );

  factory ItemModel.fromMap(Map<String, Object?> values) => ItemModel(values);

  Object? get ID => this['ID'];
  Object? get Price => this['Price'];
  Object? get MinimumPrice => this['MinimumPrice'];
  Object? get WholesalePrice => this['WholesalePrice'];
  Object? get quickitem => this['quickitem'];
  Object? get ItemGroupID => this['ItemGroupID'];
  Object? get WithVatPrice => this['WithVatPrice'];
}
