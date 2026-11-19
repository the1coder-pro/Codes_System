// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: RealEstateModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class RealEstateModel extends LegacySourceModel {
  RealEstateModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'RealEstateModel',
    sourceFile: 'RealEstateModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'NameAr', vbType: 'String'),
      LegacySourceProperty(name: 'NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'QuarterID', vbType: 'Integer'),
      LegacySourceProperty(name: 'Address', vbType: 'String'),
      LegacySourceProperty(name: 'Phone', vbType: 'String'),
      LegacySourceProperty(name: 'Fax', vbType: 'String'),
      LegacySourceProperty(name: 'UnitsCount', vbType: 'Integer'),
      LegacySourceProperty(name: 'CollectionCommission', vbType: 'Single'),
      LegacySourceProperty(name: 'OwnerID', vbType: 'long'),
      LegacySourceProperty(name: 'OutOfService', vbType: 'boolean'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
