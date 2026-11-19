// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: PricingGroupModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class PricingGroupModel extends LegacySourceModel {
  PricingGroupModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'PricingGroupModel',
    sourceFile: 'PricingGroupModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Integer'),
      LegacySourceProperty(name: 'NameAr', vbType: 'String'),
      LegacySourceProperty(name: 'NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'Remark', vbType: 'String'),
      LegacySourceProperty(name: 'StartDate', vbType: 'date'),
      LegacySourceProperty(name: 'EndDate', vbType: 'date'),
      LegacySourceProperty(name: 'ByFraction', vbType: 'boolean'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
