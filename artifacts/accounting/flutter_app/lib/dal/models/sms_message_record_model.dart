// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: SMSMessageRecordModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class SMSMessageRecordModel extends LegacySourceModel {
  SMSMessageRecordModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'SMSMessageRecordModel',
    sourceFile: 'SMSMessageRecordModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'SenderName', vbType: 'String'),
      LegacySourceProperty(name: 'MessageText', vbType: 'String'),
      LegacySourceProperty(name: 'NumbersList', vbType: 'String'),
      LegacySourceProperty(name: 'MessageTime', vbType: 'date'),
      LegacySourceProperty(name: 'SentTime', vbType: 'date'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
