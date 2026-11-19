// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: CustomerNoteOnCompanyModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class CustomerNoteOnCompanyModel extends LegacySourceModel {
  CustomerNoteOnCompanyModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'CustomerNoteOnCompanyModel',
    sourceFile: 'CustomerNoteOnCompanyModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'NoteDate', vbType: 'date'),
      LegacySourceProperty(name: 'NoteTime', vbType: 'date'),
      LegacySourceProperty(name: 'CustomerAccountID', vbType: 'long'),
      LegacySourceProperty(
        name: 'CustomerNoteTypeOnCompanyID',
        vbType: 'Integer',
      ),
      LegacySourceProperty(name: 'NoteDetail', vbType: 'String'),
      LegacySourceProperty(name: 'PCID', vbType: 'Integer'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
      LegacySourceProperty(name: 'InvoiceID', vbType: 'String'),
      LegacySourceProperty(name: 'ItemID', vbType: 'long'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
