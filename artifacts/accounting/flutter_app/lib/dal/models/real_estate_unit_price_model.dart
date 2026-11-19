// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: RealEstateUnitPriceModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class RealEstateUnitPriceModel extends LegacySourceModel {
  RealEstateUnitPriceModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'RealEstateUnitPriceModel',
    sourceFile: 'RealEstateUnitPriceModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'UnitID', vbType: 'long'),
      LegacySourceProperty(name: 'RentTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'NormalPrice', vbType: 'long'),
      LegacySourceProperty(name: 'SeasonPrice', vbType: 'long'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
