// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: NoteOnEmployeeModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class NoteOnEmployeeModel extends LegacySourceModel {
  NoteOnEmployeeModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'NoteOnEmployeeModel',
    sourceFile: 'NoteOnEmployeeModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'NoteDate', vbType: 'date'),
      LegacySourceProperty(name: 'NoteTime', vbType: 'date'),
      LegacySourceProperty(name: 'CustomerAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'NoteTypeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'NoteDetail', vbType: 'String'),
      LegacySourceProperty(name: 'InvoiceID', vbType: 'String'),
      LegacySourceProperty(name: 'NoteSourceID', vbType: 'Integer'),
      LegacySourceProperty(name: 'PCID', vbType: 'Integer'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
