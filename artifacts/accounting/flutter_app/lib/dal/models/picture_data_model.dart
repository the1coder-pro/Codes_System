// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: PictureDataModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class PictureDataModel extends LegacySourceModel {
  PictureDataModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'PictureDataModel',
    sourceFile: 'PictureDataModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'PictureDate', vbType: 'String'),
      LegacySourceProperty(name: 'Title', vbType: 'String'),
      LegacySourceProperty(name: 'Occasion', vbType: 'Byte'),
      LegacySourceProperty(name: 'PlaceID', vbType: 'Byte'),
      LegacySourceProperty(name: 'SourceID', vbType: 'Byte'),
      LegacySourceProperty(name: 'OtherInformation', vbType: 'String'),
      LegacySourceProperty(name: 'ImagePath', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
