// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: PricingGroupItemForLaundryModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class PricingGroupItemForLaundryModel extends LegacySourceModel {
  PricingGroupItemForLaundryModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'PricingGroupItemForLaundryModel',
    sourceFile: 'PricingGroupItemForLaundryModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'PricingGroupID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ItemID', vbType: 'long'),
      LegacySourceProperty(name: 'UrgentTypeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ServiceTypeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'MaterialTypeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'Price', vbType: 'Single'),
      LegacySourceProperty(name: 'MinimumPrice', vbType: 'Single'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
