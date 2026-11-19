// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: non_constant_identifier_names

import '../legacy_model.dart';

class ItemOtherDataModel extends LegacyModel {
  ItemOtherDataModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblItemOtherData',
      primaryKey: ['ItemID'],
      columns: [
        'ItemID',
        'ColorID',
        'BarcodeNo',
        'ItemPlaceID',
        'ItemSizeID',
        'UnitCount',
      ],
    ),
    fromMap: ItemOtherDataModel.new,
  );

  factory ItemOtherDataModel.fromMap(Map<String, Object?> values) =>
      ItemOtherDataModel(values);

  Object? get ItemID => this['ItemID'];
  Object? get ColorID => this['ColorID'];
  Object? get BarcodeNo => this['BarcodeNo'];
  Object? get ItemPlaceID => this['ItemPlaceID'];
  Object? get ItemSizeID => this['ItemSizeID'];
  Object? get UnitCount => this['UnitCount'];
}
