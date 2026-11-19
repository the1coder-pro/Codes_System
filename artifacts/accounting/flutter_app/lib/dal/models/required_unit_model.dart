// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: RequiredUnitModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class RequiredUnitModel extends LegacySourceModel {
  RequiredUnitModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'RequiredUnitModel',
    sourceFile: 'RequiredUnitModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'NameAr', vbType: 'String'),
      LegacySourceProperty(name: 'NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'UnitTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'FloorsCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'RoomsCount', vbType: 'Integer'),
      LegacySourceProperty(name: 'BathroomsCount', vbType: 'Integer'),
      LegacySourceProperty(name: 'kitchensCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'IndependentBoard', vbType: 'boolean'),
      LegacySourceProperty(name: 'OtherSpecifications', vbType: 'String'),
      LegacySourceProperty(name: 'AnnualRentFrom', vbType: 'long'),
      LegacySourceProperty(name: 'AnnualRentTo', vbType: 'long'),
      LegacySourceProperty(name: 'UnitStatusID', vbType: 'Byte'),
      LegacySourceProperty(name: 'Furniture', vbType: 'String'),
      LegacySourceProperty(name: 'HousingTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'Comment', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
