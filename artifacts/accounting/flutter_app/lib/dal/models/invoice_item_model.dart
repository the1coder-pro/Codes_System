// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class tblInvoiceItemModel extends LegacyModel {
  tblInvoiceItemModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblInvoiceItem',
      primaryKey: ['InvoiceID', 'ID'],
      columns: [
        'InvoiceID',
        'ID',
        'ItemID',
        'Price',
        'Qty',
        'PlateQty',
        'Discount',
        'DiscountPercent',
        'UnitCost',
        'VAT',
        'ExpireDate',
      ],
    ),
    fromMap: tblInvoiceItemModel.new,
  );

  factory tblInvoiceItemModel.fromMap(Map<String, Object?> values) =>
      tblInvoiceItemModel(values);

  Object? get InvoiceID => this['InvoiceID'];
  Object? get ID => this['ID'];
  Object? get ItemID => this['ItemID'];
  Object? get Price => this['Price'];
  Object? get Qty => this['Qty'];
  Object? get VAT => this['VAT'];
  Object? get ExpireDate => this['ExpireDate'];
}
