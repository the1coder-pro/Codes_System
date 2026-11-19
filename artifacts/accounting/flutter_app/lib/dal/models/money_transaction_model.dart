// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class tblMoneyTransactionModel extends LegacyModel {
  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'tblMoneyTransactionModel',
    sourceFile: 'tblMoneyTransactionModel.vb',
    tableName: 'tblMoneyTransaction',
    tableMappingStatus: LegacyModelTableMappingStatus.confirmed,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'text'),
      LegacySourceProperty(name: 'CodeID', vbType: 'short'),
      LegacySourceProperty(name: 'PCID', vbType: 'short'),
      LegacySourceProperty(name: 'TransactionDate', vbType: 'date'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
  tblMoneyTransactionModel(Map<String, Object?> values)
    : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblMoneyTransaction',
      primaryKey: ['ID'],
      columns: ['ID', 'CodeID', 'PCID', 'TransactionDate'],
    ),
    fromMap: tblMoneyTransactionModel.new,
  );

  factory tblMoneyTransactionModel.fromMap(Map<String, Object?> values) =>
      tblMoneyTransactionModel(values);

  Object? get ID => this['ID'];
  Object? get CodeID => this['CodeID'];
  Object? get PCID => this['PCID'];
  Object? get TransactionDate => this['TransactionDate'];
}
