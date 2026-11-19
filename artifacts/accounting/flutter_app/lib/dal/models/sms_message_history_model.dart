// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: SMSMessageHistoryModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class SMSMessageHistoryModel extends LegacySourceModel {
  SMSMessageHistoryModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'SMSMessageHistoryModel',
    sourceFile: 'SMSMessageHistoryModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'SentTime', vbType: 'date'),
      LegacySourceProperty(name: 'MessageStatus', vbType: 'String'),
      LegacySourceProperty(name: 'MessageID', vbType: 'long'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
