// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: InstallmentPlanTypeModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class InstallmentPlanTypeModel extends LegacySourceModel {
  InstallmentPlanTypeModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'InstallmentPlanTypeModel',
    sourceFile: 'InstallmentPlanTypeModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Byte'),
      LegacySourceProperty(name: 'NameAr', vbType: 'String'),
      LegacySourceProperty(name: 'NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'CreditorAccountTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'DebtorAccountTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'CreditorAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'DebtorAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'SMSMessageText', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
