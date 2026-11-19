// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: SubscriptionCardModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class SubscriptionCardModel extends LegacySourceModel {
  SubscriptionCardModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'SubscriptionCardModel',
    sourceFile: 'SubscriptionCardModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'CardNo', vbType: 'long'),
      LegacySourceProperty(name: 'CardCode', vbType: 'String'),
      LegacySourceProperty(name: 'AccountID', vbType: 'long'),
      LegacySourceProperty(name: 'CardDate', vbType: 'date'),
      LegacySourceProperty(name: 'CardClassID', vbType: 'Integer'),
      LegacySourceProperty(name: 'Price', vbType: 'Single'),
      LegacySourceProperty(name: 'FreePalance', vbType: 'Single'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
