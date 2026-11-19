// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: non_constant_identifier_names

import '../legacy_model.dart';

class ItemOtherDataModel extends LegacyModel {
  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ItemOtherDataModel',
    sourceFile: 'ItemOtherDataModel.vb',
    tableName: 'tblItemOtherData',
    tableMappingStatus: LegacyModelTableMappingStatus.confirmed,
    properties: [
      LegacySourceProperty(name: 'ItemID', vbType: 'Long'),
      LegacySourceProperty(name: 'ColorID', vbType: 'Byte'),
      LegacySourceProperty(name: 'BarcodeNo', vbType: 'String'),
      LegacySourceProperty(name: 'ItemPlaceID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ItemSizeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'UnitCount', vbType: 'Single'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
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
