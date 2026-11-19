// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: AccountDiscountModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class AccountDiscountModel extends LegacySourceModel {
  AccountDiscountModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'AccountDiscountModel',
    sourceFile: 'AccountDiscountModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'AccountID', vbType: 'long'),
      LegacySourceProperty(name: 'CreationDate', vbType: 'date'),
      LegacySourceProperty(name: 'Discount', vbType: 'Byte'),
      LegacySourceProperty(name: 'StartDate', vbType: 'date'),
      LegacySourceProperty(name: 'EndDate', vbType: 'date'),
      LegacySourceProperty(name: 'Remark', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
