// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: AccountPricingGroupModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class AccountPricingGroupModel extends LegacySourceModel {
  AccountPricingGroupModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'AccountPricingGroupModel',
    sourceFile: 'AccountPricingGroupModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'AccountID', vbType: 'long'),
      LegacySourceProperty(name: 'PricingGroupID', vbType: 'Integer'),
      LegacySourceProperty(name: 'AllowDebit', vbType: 'boolean'),
      LegacySourceProperty(name: 'MaximumDebitBalance', vbType: 'Single'),
      LegacySourceProperty(name: 'Remark', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
