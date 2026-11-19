// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: AccountDocumentModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class accountDocumentModel extends LegacySourceModel {
  accountDocumentModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'accountDocumentModel',
    sourceFile: 'AccountDocumentModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'accountID', vbType: 'Long'),
      LegacySourceProperty(name: 'DocumentTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'DocumentID', vbType: 'String'),
      LegacySourceProperty(name: 'DocumentDate', vbType: 'Date'),
      LegacySourceProperty(name: 'DocumentExpDate', vbType: 'Date'),
      LegacySourceProperty(name: 'DocumentSource', vbType: 'String'),
      LegacySourceProperty(name: 'DocumentNote', vbType: 'String'),
      LegacySourceProperty(name: 'DocumentImagePath', vbType: 'String'),
      LegacySourceProperty(name: 'OtherDocumentTypeName', vbType: 'String'),
      LegacySourceProperty(name: 'UseInReporting', vbType: 'Boolean'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
