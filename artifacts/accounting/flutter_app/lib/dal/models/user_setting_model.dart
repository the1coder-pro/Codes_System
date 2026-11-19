// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: UserSettingModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class UserSettingModel extends LegacySourceModel {
  UserSettingModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'UserSettingModel',
    sourceFile: 'UserSettingModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
      LegacySourceProperty(name: 'CodeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'QuickInvoiceTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'QuickInvoiceCreditorID', vbType: 'Long'),
      LegacySourceProperty(name: 'QuickInvoiceDebtorID', vbType: 'Long'),
      LegacySourceProperty(name: 'QuickInvoiceStoreCreditorID', vbType: 'Long'),
      LegacySourceProperty(name: 'QuickInvoiceStoreDebtorID', vbType: 'Long'),
      LegacySourceProperty(name: 'DiscountPercentage', vbType: 'Single'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
