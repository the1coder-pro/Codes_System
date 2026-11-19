// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: TransactionHistoryModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class TransactionHistoryModel extends LegacySourceModel {
  TransactionHistoryModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'TransactionHistoryModel',
    sourceFile: 'TransactionHistoryModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Long'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
      LegacySourceProperty(name: 'TransactionTime', vbType: 'DateTime'),
      LegacySourceProperty(name: 'TransactionTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ObjectID', vbType: 'Integer'),
      LegacySourceProperty(name: 'RecordID', vbType: 'String'),
      LegacySourceProperty(name: 'PCID', vbType: 'Integer'),
      LegacySourceProperty(name: 'RecordData', vbType: 'String'),
      LegacySourceProperty(name: 'RecordDataar', vbType: 'String'),
      LegacySourceProperty(name: 'RecordDataEn', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
