// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ContractInstalllmentModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ContractInstalllmentModel extends LegacySourceModel {
  ContractInstalllmentModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ContractInstalllmentModel',
    sourceFile: 'ContractInstalllmentModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'ContractID', vbType: 'long'),
      LegacySourceProperty(name: 'StageID', vbType: 'Byte'),
      LegacySourceProperty(name: 'Amount', vbType: 'long'),
      LegacySourceProperty(name: 'Note', vbType: 'String'),
      LegacySourceProperty(name: 'OfferedStartDate', vbType: 'date'),
      LegacySourceProperty(name: 'OfferedEndDate', vbType: 'date'),
      LegacySourceProperty(name: 'ActuallyStartDate', vbType: 'date'),
      LegacySourceProperty(name: 'ActuallyEndDate', vbType: 'date'),
      LegacySourceProperty(name: 'FilePath', vbType: 'String'),
      LegacySourceProperty(name: 'VAT', vbType: 'Single'),
      LegacySourceProperty(name: 'VATValue', vbType: 'Single'),
      LegacySourceProperty(name: 'VatTypeID', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
