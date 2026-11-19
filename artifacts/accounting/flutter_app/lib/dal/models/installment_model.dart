// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: InstallmentModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class InstallmentModel extends LegacySourceModel {
  InstallmentModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'InstallmentModel',
    sourceFile: 'InstallmentModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'InstallmentPlanID', vbType: 'long'),
      LegacySourceProperty(name: 'InstallmentID', vbType: 'Integer'),
      LegacySourceProperty(name: 'InstallmentDate', vbType: 'date'),
      LegacySourceProperty(name: 'InstallmentAmount', vbType: 'Single'),
      LegacySourceProperty(name: 'Remark', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
