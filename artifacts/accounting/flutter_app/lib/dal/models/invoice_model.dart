// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class tblInvoiceModel extends LegacyModel {
  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'tblInvoiceModel',
    sourceFile: 'tblInvoiceModel.vb',
    tableName: 'tblInvoice',
    tableMappingStatus: LegacyModelTableMappingStatus.confirmed,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'text'),
      LegacySourceProperty(name: 'CodeID', vbType: 'short'),
      LegacySourceProperty(name: 'PCID', vbType: 'short'),
      LegacySourceProperty(name: 'InvoiceTypeID', vbType: 'byte'),
      LegacySourceProperty(name: 'CreditorID', vbType: 'long'),
      LegacySourceProperty(name: 'DebtorID', vbType: 'long'),
      LegacySourceProperty(name: 'InvoiceNo', vbType: 'text'),
      LegacySourceProperty(name: 'InvoiceDate', vbType: 'date'),
      LegacySourceProperty(name: 'CreditorPersonID', vbType: 'long'),
      LegacySourceProperty(name: 'DebitorPersonID', vbType: 'long'),
      LegacySourceProperty(name: 'Amount', vbType: 'Single'),
      LegacySourceProperty(name: 'Discount', vbType: 'Single'),
      LegacySourceProperty(name: 'BeforehandSum', vbType: 'Single'),
      LegacySourceProperty(name: 'RetrieveSum', vbType: 'Single'),
      LegacySourceProperty(name: 'PaidSum', vbType: 'Single'),
      LegacySourceProperty(name: 'DueDate', vbType: 'date'),
      LegacySourceProperty(name: 'Remark', vbType: 'text'),
      LegacySourceProperty(name: 'NoteTypeID', vbType: 'byte'),
      LegacySourceProperty(name: 'GivingDate', vbType: 'date'),
      LegacySourceProperty(name: 'AccountName', vbType: 'text'),
      LegacySourceProperty(name: 'GivingTime', vbType: 'date'),
      LegacySourceProperty(name: 'Pledge', vbType: 'Single'),
      LegacySourceProperty(name: 'PlateQty', vbType: 'short'),
      LegacySourceProperty(name: 'ReceivedPlateQty', vbType: 'short'),
      LegacySourceProperty(name: 'RemainSum', vbType: 'Single'),
      LegacySourceProperty(name: 'StoreCreditorID', vbType: 'long'),
      LegacySourceProperty(name: 'StoreDebtorID', vbType: 'long'),
      LegacySourceProperty(name: 'UserID', vbType: 'short'),
      LegacySourceProperty(name: 'AuthorizerID', vbType: 'byte'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'text'),
      LegacySourceProperty(name: 'UrgentTypeID', vbType: 'short'),
      LegacySourceProperty(name: 'TableID', vbType: 'byte'),
      LegacySourceProperty(name: 'OrderType', vbType: 'byte'),
      LegacySourceProperty(name: 'VATValue', vbType: 'Single'),
      LegacySourceProperty(name: 'VatTypeID', vbType: 'byte'),
      LegacySourceProperty(name: 'VATNo', vbType: 'text'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
  tblInvoiceModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblInvoice',
      primaryKey: ['ID'],
      columns: [
        'ID',
        'CodeID',
        'PCID',
        'InvoiceTypeID',
        'CreditorID',
        'DebtorID',
        'InvoiceNo',
        'InvoiceDate',
        'CreditorPersonID',
        'DebitorPersonID',
        'Amount',
        'Discount',
        'BeforehandSum',
        'RetrieveSum',
        'PaidSum',
        'DueDate',
        'Remark',
        'NoteTypeID',
        'GivingDate',
        'AccountName',
        'GivingTime',
        'Pledge',
        'PlateQty',
        'ReceivedPlateQty',
        'RemainSum',
        'StoreCreditorID',
        'StoreDebtorID',
        'UserID',
        'AuthorizerID',
        'MoneyTransactionID',
        'UrgentTypeID',
        'TableID',
        'OrderType',
        'VATValue',
        'VatTypeID',
        'VATNo',
        'InvoiceTime',
        'ReternedInvoiceID',
        'VAT',
        'IssueDate',
        'ReturnReason',
        'SubmissionStatusID',
      ],
    ),
    fromMap: tblInvoiceModel.new,
  );

  factory tblInvoiceModel.fromMap(Map<String, Object?> values) =>
      tblInvoiceModel(values);

  Object? get ID => this['ID'];
  Object? get InvoiceTypeID => this['InvoiceTypeID'];
  Object? get InvoiceNo => this['InvoiceNo'];
  Object? get InvoiceDate => this['InvoiceDate'];
  Object? get Amount => this['Amount'];
  Object? get MoneyTransactionID => this['MoneyTransactionID'];
}
