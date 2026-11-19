// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: InvoiceModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class InvoiceModel extends LegacySourceModel {
  InvoiceModel(Map<String, Object?> values) : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'InvoiceModel',
    sourceFile: 'InvoiceModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'String'),
      LegacySourceProperty(name: 'CodeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'PCID', vbType: 'Integer'),
      LegacySourceProperty(name: 'InvoiceTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'CreditorID', vbType: 'Long'),
      LegacySourceProperty(name: 'DebtorID', vbType: 'Long'),
      LegacySourceProperty(name: 'InvoiceNo', vbType: 'String'),
      LegacySourceProperty(name: 'InvoiceDate', vbType: 'Date'),
      LegacySourceProperty(name: 'CreditorPersonID', vbType: 'Long'),
      LegacySourceProperty(name: 'DebitorPersonID', vbType: 'Long'),
      LegacySourceProperty(name: 'amount', vbType: 'Single'),
      LegacySourceProperty(name: 'Discount', vbType: 'Single'),
      LegacySourceProperty(name: 'BeforehandSum', vbType: 'Single'),
      LegacySourceProperty(name: 'RetrieveSum', vbType: 'Single'),
      LegacySourceProperty(name: 'PaidSum', vbType: 'Single'),
      LegacySourceProperty(name: 'DueDate', vbType: 'Date'),
      LegacySourceProperty(name: 'Remark', vbType: 'String'),
      LegacySourceProperty(name: 'NoteTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'GivingDate', vbType: 'Date'),
      LegacySourceProperty(name: 'accountName', vbType: 'String'),
      LegacySourceProperty(name: 'GivingTime', vbType: 'DateTime'),
      LegacySourceProperty(name: 'InvoiceTime', vbType: 'DateTime'),
      LegacySourceProperty(name: 'Pledge', vbType: 'Single'),
      LegacySourceProperty(name: 'PlateQty', vbType: 'Integer'),
      LegacySourceProperty(name: 'ReceivedPlateQty', vbType: 'Integer'),
      LegacySourceProperty(name: 'RemainSum', vbType: 'Single'),
      LegacySourceProperty(name: 'StoreCreditorID', vbType: 'Long'),
      LegacySourceProperty(name: 'StoreDebtorID', vbType: 'Long'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
      LegacySourceProperty(name: 'authorizerID', vbType: 'Byte'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
      LegacySourceProperty(name: 'UrgentTypeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'TableID', vbType: 'Byte'),
      LegacySourceProperty(name: 'OrderType', vbType: 'Byte'),
      LegacySourceProperty(name: 'VaTValue', vbType: 'Single'),
      LegacySourceProperty(name: 'VatTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'VaTNo', vbType: 'String'),
      LegacySourceProperty(name: 'ReternedInvoiceID', vbType: 'String'),
      LegacySourceProperty(name: 'VaT', vbType: 'Single'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
