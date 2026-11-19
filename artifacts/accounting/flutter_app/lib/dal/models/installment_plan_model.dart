// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: InstallmentPlanModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class InstallmentPlanModel extends LegacySourceModel {
  InstallmentPlanModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'InstallmentPlanModel',
    sourceFile: 'InstallmentPlanModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'InstallmentPlanTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'AccountID', vbType: 'long'),
      LegacySourceProperty(name: 'PlanDate', vbType: 'date'),
      LegacySourceProperty(name: 'PlanAmount', vbType: 'Single'),
      LegacySourceProperty(name: 'InstallmentCount', vbType: 'Integer'),
      LegacySourceProperty(name: 'FirstInstallmentDate', vbType: 'date'),
      LegacySourceProperty(name: 'InstallmentPeriodTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'Remark', vbType: 'String'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
      LegacySourceProperty(name: 'AuthorizerID', vbType: 'Byte'),
      LegacySourceProperty(name: 'PaymentMethodID', vbType: 'Byte'),
      LegacySourceProperty(name: 'SponsorID', vbType: 'long'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
      LegacySourceProperty(name: 'PaidInstallmentCount', vbType: 'Integer'),
      LegacySourceProperty(name: 'PaidAmount', vbType: 'Single'),
      LegacySourceProperty(name: 'LastInstallmentID', vbType: 'Integer'),
      LegacySourceProperty(name: 'LastPaymentDate', vbType: 'date'),
      LegacySourceProperty(name: 'Conditions', vbType: 'String'),
      LegacySourceProperty(name: 'ConditionClassID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
