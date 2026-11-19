// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class tblMoneyTransactionModel extends LegacyModel {
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
