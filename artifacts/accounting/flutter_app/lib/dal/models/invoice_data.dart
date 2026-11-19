// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ItemModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class InvoiceData extends LegacySourceModel {
  InvoiceData(Map<String, Object?> values) : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'InvoiceData',
    sourceFile: 'ItemModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Integer'),
      LegacySourceProperty(name: 'Price', vbType: 'Decimal'),
      LegacySourceProperty(name: 'MinimumPrice', vbType: 'Decimal'),
      LegacySourceProperty(name: 'WholesalePrice', vbType: 'Decimal'),
      LegacySourceProperty(name: 'QuickItem', vbType: 'Boolean'),
      LegacySourceProperty(name: 'ItemGroupID', vbType: 'Integer'),
      LegacySourceProperty(name: 'WithVatPrice', vbType: 'Decimal'),
      LegacySourceProperty(name: 'ItemSize_ID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ItemSize_NameAr', vbType: 'String'),
      LegacySourceProperty(name: 'ItemSize_NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'ItemSize_Code', vbType: 'String'),
      LegacySourceProperty(name: 'ItemType_ID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ItemType_NameAr', vbType: 'String'),
      LegacySourceProperty(name: 'ItemType_NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'ItemType_ShortNameAr', vbType: 'String'),
      LegacySourceProperty(name: 'ItemType_ShortNameEn', vbType: 'String'),
      LegacySourceProperty(name: 'ItemGroup_ID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ItemGroup_NameAr', vbType: 'String'),
      LegacySourceProperty(name: 'ItemGroup_NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'ItemGroup_ShortName', vbType: 'String'),
      LegacySourceProperty(name: 'ItemGroup_VAT', vbType: 'Decimal'),
      LegacySourceProperty(name: 'ItemGroup_NotUsed', vbType: 'Boolean'),
      LegacySourceProperty(name: 'ItemGroup_UseTypeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ItemGroup_ItemTypeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ItemGroup_FilePath', vbType: 'String'),
      LegacySourceProperty(name: 'ItemGroup_ItemNote', vbType: 'String'),
      LegacySourceProperty(name: 'TaxExemptionReasonCode', vbType: 'String'),
      LegacySourceProperty(name: 'TaxExemptionReason', vbType: 'String'),
      LegacySourceProperty(name: 'TaxExemptionReasonEn', vbType: 'String'),
      LegacySourceProperty(name: 'TaxCode', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
