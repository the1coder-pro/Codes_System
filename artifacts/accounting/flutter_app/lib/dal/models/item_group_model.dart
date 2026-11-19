// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: non_constant_identifier_names

import '../legacy_model.dart';

class ItemGroupModel extends LegacyModel {
  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ItemGroupModel',
    sourceFile: 'ItemGroupModel.vb',
    tableName: 'tblItemGroup',
    tableMappingStatus: LegacyModelTableMappingStatus.confirmed,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Long'),
      LegacySourceProperty(name: 'Namear', vbType: 'String'),
      LegacySourceProperty(name: 'NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'NotUsed', vbType: 'Boolean'),
      LegacySourceProperty(name: 'ShortName', vbType: 'String'),
      LegacySourceProperty(name: 'VaT', vbType: 'Single'),
      LegacySourceProperty(name: 'ItemTypeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'UseTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'FilePath', vbType: 'String'),
      LegacySourceProperty(name: 'ItemNote', vbType: 'String'),
      LegacySourceProperty(name: 'VaTCategoriesID', vbType: 'Integer'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
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
