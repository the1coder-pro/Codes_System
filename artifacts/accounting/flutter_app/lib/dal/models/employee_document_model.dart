// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: EmployeeDocumentModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class EmployeeDocumentModel extends LegacySourceModel {
  EmployeeDocumentModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'EmployeeDocumentModel',
    sourceFile: 'EmployeeDocumentModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'EmployeeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'DocumentTypeNo', vbType: 'Byte'),
      LegacySourceProperty(name: 'DocumentID', vbType: 'String'),
      LegacySourceProperty(name: 'DocumentDate', vbType: 'date'),
      LegacySourceProperty(name: 'DocumentExpDate', vbType: 'date'),
      LegacySourceProperty(name: 'DocumentSource', vbType: 'String'),
      LegacySourceProperty(name: 'DocumentNote', vbType: 'String'),
      LegacySourceProperty(name: 'DocumentImagePath', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
