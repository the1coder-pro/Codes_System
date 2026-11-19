// Legacy DAL capitalization is part of the persisted schema contract.
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class tblInvoiceItemModel extends LegacyModel {
  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'tblInvoiceItemModel',
    sourceFile: 'tblInvoiceItemModel.vb',
    tableName: 'tblInvoiceItem',
    tableMappingStatus: LegacyModelTableMappingStatus.confirmed,
    properties: [
      LegacySourceProperty(name: 'InvoiceID', vbType: 'String'),
      LegacySourceProperty(name: 'ID', vbType: 'Short'),
      LegacySourceProperty(name: 'ItemID', vbType: 'Long'),
      LegacySourceProperty(name: 'Price', vbType: 'Single'),
      LegacySourceProperty(name: 'Qty', vbType: 'Single'),
      LegacySourceProperty(name: 'PlateQty', vbType: 'Short'),
      LegacySourceProperty(name: 'Discount', vbType: 'Single'),
      LegacySourceProperty(name: 'DiscountPercent', vbType: 'Single'),
      LegacySourceProperty(name: 'UnitCost', vbType: 'Single'),
      LegacySourceProperty(name: 'ExpiryDate', vbType: 'Date'),
      LegacySourceProperty(name: 'VAT', vbType: 'Single'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
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
