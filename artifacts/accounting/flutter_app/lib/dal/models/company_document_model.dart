// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: CompanyDocumentModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class CompanyDocumentModel extends LegacySourceModel {
  CompanyDocumentModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'CompanyDocumentModel',
    sourceFile: 'CompanyDocumentModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Integer'),
      LegacySourceProperty(name: 'DocumentTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'DocumentID', vbType: 'String'),
      LegacySourceProperty(name: 'DocumentDate', vbType: 'date'),
      LegacySourceProperty(name: 'DocumentExpDate', vbType: 'date'),
      LegacySourceProperty(name: 'DocumentSource', vbType: 'String'),
      LegacySourceProperty(name: 'DocumentNote', vbType: 'String'),
      LegacySourceProperty(name: 'DocumentImagePath', vbType: 'String'),
      LegacySourceProperty(name: 'OtherDocumentTypeName', vbType: 'String'),
      LegacySourceProperty(name: 'UseInReporting', vbType: 'Boolean'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
