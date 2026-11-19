// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class tblInvoiceModel extends LegacyModel {
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
