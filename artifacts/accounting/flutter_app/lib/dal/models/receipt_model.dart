// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ReceiptModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ReceiptModel extends LegacySourceModel {
  ReceiptModel(Map<String, Object?> values) : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ReceiptModel',
    sourceFile: 'ReceiptModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'String'),
      LegacySourceProperty(name: 'CodeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'PCID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ReceiptTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ReceiptDate', vbType: 'date'),
      LegacySourceProperty(name: 'Amount', vbType: 'Single'),
      LegacySourceProperty(name: 'Remark', vbType: 'String'),
      LegacySourceProperty(name: 'ReceptName', vbType: 'String'),
      LegacySourceProperty(name: 'MoneyTransactionMethodID', vbType: 'Byte'),
      LegacySourceProperty(name: 'CheckNo', vbType: 'String'),
      LegacySourceProperty(name: 'CheckBank', vbType: 'String'),
      LegacySourceProperty(name: 'CheckDate', vbType: 'date'),
      LegacySourceProperty(name: 'CreditorID', vbType: 'long'),
      LegacySourceProperty(name: 'DebtorID', vbType: 'long'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
      LegacySourceProperty(name: 'ReceiptSubjectID', vbType: 'Byte'),
      LegacySourceProperty(name: 'HandlyReceiptBy', vbType: 'String'),
      LegacySourceProperty(name: 'HandlyReceiptCode', vbType: 'String'),
      LegacySourceProperty(name: 'HandlyReceiptNo', vbType: 'long'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
