// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: OrderExecutionModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class OrderExecutionModel extends LegacySourceModel {
  OrderExecutionModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'OrderExecutionModel',
    sourceFile: 'OrderExecutionModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'InvoiceID', vbType: 'String'),
      LegacySourceProperty(name: 'InvoiceItemID', vbType: 'Integer'),
      LegacySourceProperty(name: 'TeamGroupID', vbType: 'Integer'),
      LegacySourceProperty(name: 'OrderDate', vbType: 'date'),
      LegacySourceProperty(name: 'OrderExecutionDate', vbType: 'date'),
      LegacySourceProperty(name: 'OrderExecutionStartTime', vbType: 'date'),
      LegacySourceProperty(name: 'OrderExecutionEndTime', vbType: 'date'),
      LegacySourceProperty(name: 'ExecutionStatusID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ExecutionNote', vbType: 'String'),
      LegacySourceProperty(name: 'PCID', vbType: 'Integer'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
      LegacySourceProperty(name: 'ID1', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
