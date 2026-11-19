// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ContractModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ContractModel extends LegacySourceModel {
  ContractModel(Map<String, Object?> values) : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ContractModel',
    sourceFile: 'ContractModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'CustomerID', vbType: 'long'),
      LegacySourceProperty(name: 'ContractNameAr', vbType: 'String'),
      LegacySourceProperty(name: 'ContractNameEn', vbType: 'String'),
      LegacySourceProperty(name: 'ContractDate', vbType: 'date'),
      LegacySourceProperty(name: 'ContractAmount', vbType: 'long'),
      LegacySourceProperty(name: 'Note', vbType: 'String'),
      LegacySourceProperty(name: 'Condition', vbType: 'String'),
      LegacySourceProperty(name: 'VATValue', vbType: 'Single'),
      LegacySourceProperty(name: 'VatTypeID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
