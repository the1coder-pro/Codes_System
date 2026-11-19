// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: RestHouse_SeasonRentGroupModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class RestHouse_SeasonRentGroupModel extends LegacySourceModel {
  RestHouse_SeasonRentGroupModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'RestHouse_SeasonRentGroupModel',
    sourceFile: 'RestHouse_SeasonRentGroupModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Integer'),
      LegacySourceProperty(name: 'SeasonID', vbType: 'Integer'),
      LegacySourceProperty(name: 'NameAr', vbType: 'String'),
      LegacySourceProperty(name: 'NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'StartTime', vbType: 'date'),
      LegacySourceProperty(name: 'EndTime', vbType: 'date'),
      LegacySourceProperty(name: 'Price', vbType: 'Single'),
      LegacySourceProperty(name: 'StartTimeText', vbType: 'String'),
      LegacySourceProperty(name: 'EndTimeText', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
