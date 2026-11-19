// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: non_constant_identifier_names

import '../legacy_model.dart';

class ItemGroupModel extends LegacyModel {
  ItemGroupModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblItemGroup',
      primaryKey: ['ID'],
      columns: [
        'ID',
        'NameAr',
        'NameEn',
        'ShortName',
        'VAT',
        'NotUsed',
        'UseTypeID',
        'ItemTypeID',
        'FilePath',
        'ItemNote',
        'VaTCategoriesID',
      ],
    ),
    fromMap: ItemGroupModel.new,
  );

  factory ItemGroupModel.fromMap(Map<String, Object?> values) =>
      ItemGroupModel(values);

  Object? get ID => this['ID'];
  Object? get NameAr => this['NameAr'];
  Object? get NameEn => this['NameEn'];
  Object? get ShortName => this['ShortName'];
  Object? get VAT => this['VAT'];
  Object? get NotUsed => this['NotUsed'];
  Object? get UseTypeID => this['UseTypeID'];
  Object? get ItemTypeID => this['ItemTypeID'];
  Object? get FilePath => this['FilePath'];
  Object? get ItemNote => this['ItemNote'];
  Object? get VaTCategoriesID => this['VaTCategoriesID'];
}
