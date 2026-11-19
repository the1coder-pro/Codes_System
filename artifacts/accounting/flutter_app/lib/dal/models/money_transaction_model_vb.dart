// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: MoneyTransactionModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class MoneyTransactionModel extends LegacySourceModel {
  MoneyTransactionModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'MoneyTransactionModel',
    sourceFile: 'MoneyTransactionModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'String'),
      LegacySourceProperty(name: 'CodeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'PCID', vbType: 'Integer'),
      LegacySourceProperty(name: 'TransactionDate', vbType: 'Date'),
      LegacySourceProperty(name: 'EntryTypeID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
