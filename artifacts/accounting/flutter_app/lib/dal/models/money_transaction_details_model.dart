// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: MoneyTransactionDetailsModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class MoneyTransactionDetailsModel extends LegacySourceModel {
  MoneyTransactionDetailsModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'MoneyTransactionDetailsModel',
    sourceFile: 'MoneyTransactionDetailsModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Long'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
      LegacySourceProperty(name: 'accountSideID', vbType: 'Long'),
      LegacySourceProperty(name: 'accountID', vbType: 'Long'),
      LegacySourceProperty(name: 'amount', vbType: 'Double'),
      LegacySourceProperty(name: 'Description', vbType: 'String'),
      LegacySourceProperty(name: 'DescriptionID', vbType: 'Byte'),
      LegacySourceProperty(name: 'MoneyTransactionMethodID', vbType: 'Byte'),
      LegacySourceProperty(name: 'Paidamount', vbType: 'Double'),
      LegacySourceProperty(name: 'CurrencyID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ToDelete', vbType: 'Boolean'),
      LegacySourceProperty(
        name: 'MoneyTransactionDetailTypeID',
        vbType: 'Byte',
      ),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
