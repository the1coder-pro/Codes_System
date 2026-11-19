// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ReceiptInstallmentModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ReceiptInstallmentModel extends LegacySourceModel {
  ReceiptInstallmentModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ReceiptInstallmentModel',
    sourceFile: 'ReceiptInstallmentModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ReceiptID', vbType: 'String'),
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'InstallmentPlanID', vbType: 'long'),
      LegacySourceProperty(name: 'InstallmentID', vbType: 'Integer'),
      LegacySourceProperty(name: 'Amount', vbType: 'Single'),
      LegacySourceProperty(name: 'Remark', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
