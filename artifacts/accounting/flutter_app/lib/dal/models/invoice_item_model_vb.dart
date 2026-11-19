// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: InvoiceItemModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class InvoiceItemModel extends LegacySourceModel {
  InvoiceItemModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'InvoiceItemModel',
    sourceFile: 'InvoiceItemModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'InvoiceID', vbType: 'String'),
      LegacySourceProperty(name: 'ID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ItemID', vbType: 'Long'),
      LegacySourceProperty(name: 'Price', vbType: 'Single'),
      LegacySourceProperty(name: 'Qty', vbType: 'Single'),
      LegacySourceProperty(name: 'PlateQty', vbType: 'Integer'),
      LegacySourceProperty(name: 'Discount', vbType: 'Single'),
      LegacySourceProperty(name: 'DiscountPercent', vbType: 'Single'),
      LegacySourceProperty(name: 'UnitCost', vbType: 'Single'),
      LegacySourceProperty(name: 'ExpireDate', vbType: 'Date'),
      LegacySourceProperty(name: 'VaT', vbType: 'Single'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
