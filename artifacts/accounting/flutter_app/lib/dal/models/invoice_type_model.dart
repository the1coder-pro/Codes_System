// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: InvoiceTypeModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class InvoiceTypeModel extends LegacySourceModel {
  InvoiceTypeModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'InvoiceTypeModel',
    sourceFile: 'InvoiceTypeModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Byte'),
      LegacySourceProperty(name: 'Namear', vbType: 'String'),
      LegacySourceProperty(name: 'NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'CreditorTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'DebtorTypeID', vbType: 'Long'),
      LegacySourceProperty(name: 'StoreCreditorTypeID', vbType: 'Long'),
      LegacySourceProperty(name: 'StoreDebitorTypeID', vbType: 'Long'),
      LegacySourceProperty(name: 'Used', vbType: 'Boolean'),
      LegacySourceProperty(name: 'ColorCode', vbType: 'String'),
      LegacySourceProperty(name: 'BalnceSign', vbType: 'Integer'),
      LegacySourceProperty(name: 'DiscountPriceCheck', vbType: 'Boolean'),
      LegacySourceProperty(name: 'ObjectID', vbType: 'Integer'),
      LegacySourceProperty(name: 'affectsItemCost', vbType: 'Boolean'),
      LegacySourceProperty(name: 'personaccountRole', vbType: 'Byte'),
      LegacySourceProperty(name: 'ItemBalanceColumn', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
