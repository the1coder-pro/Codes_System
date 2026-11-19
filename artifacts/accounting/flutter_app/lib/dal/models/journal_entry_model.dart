// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: JournalEntryModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class JournalEntryModel extends LegacySourceModel {
  JournalEntryModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'JournalEntryModel',
    sourceFile: 'JournalEntryModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'String'),
      LegacySourceProperty(name: 'CodeID', vbType: 'Integer'),
      LegacySourceProperty(name: 'PCID', vbType: 'Integer'),
      LegacySourceProperty(name: 'EnteryDate', vbType: 'date'),
      LegacySourceProperty(name: 'Remark', vbType: 'String'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
