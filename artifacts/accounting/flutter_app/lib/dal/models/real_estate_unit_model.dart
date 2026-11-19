// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: RealEstateUnitModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class RealEstateUnitModel extends LegacySourceModel {
  RealEstateUnitModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'RealEstateUnitModel',
    sourceFile: 'RealEstateUnitModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'RealEstateID', vbType: 'long'),
      LegacySourceProperty(name: 'NameAr', vbType: 'String'),
      LegacySourceProperty(name: 'NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'UnitTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'FloorsCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'RoomsCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'BathroomsCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'kitchensCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'IndependentBoard', vbType: 'boolean'),
      LegacySourceProperty(name: 'OtherSpecifications', vbType: 'String'),
      LegacySourceProperty(name: 'AnnualRent', vbType: 'long'),
      LegacySourceProperty(name: 'UnitStatusID', vbType: 'Byte'),
      LegacySourceProperty(name: 'Furniture', vbType: 'String'),
      LegacySourceProperty(name: 'ElectricityMeterNo', vbType: 'String'),
      LegacySourceProperty(name: 'SubscriberNo', vbType: 'String'),
      LegacySourceProperty(name: 'HousingTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'Comment', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
