// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: AccountContactModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class accountContactModel extends LegacySourceModel {
  accountContactModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'accountContactModel',
    sourceFile: 'AccountContactModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'accountID', vbType: 'Long'),
      LegacySourceProperty(name: 'ContactTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ContactID', vbType: 'String'),
      LegacySourceProperty(name: 'ContactNote', vbType: 'String'),
      LegacySourceProperty(name: 'ToSend', vbType: 'Boolean'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
