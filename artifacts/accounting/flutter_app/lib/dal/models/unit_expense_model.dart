// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: UnitExpenseModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class UnitExpenseModel extends LegacySourceModel {
  UnitExpenseModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'UnitExpenseModel',
    sourceFile: 'UnitExpenseModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'UnitID', vbType: 'long'),
      LegacySourceProperty(name: 'ExpenseDate', vbType: 'date'),
      LegacySourceProperty(name: 'ExpenseTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'Amount', vbType: 'long'),
      LegacySourceProperty(name: 'Remark', vbType: 'String'),
      LegacySourceProperty(name: 'StaffID', vbType: 'long'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
