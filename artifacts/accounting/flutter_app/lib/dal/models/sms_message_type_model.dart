// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: SMSMessageTypeModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class SMSMessageTypeModel extends LegacySourceModel {
  SMSMessageTypeModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'SMSMessageTypeModel',
    sourceFile: 'SMSMessageTypeModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Byte'),
      LegacySourceProperty(name: 'NameAr', vbType: 'String'),
      LegacySourceProperty(name: 'NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'MessageTextAr', vbType: 'String'),
      LegacySourceProperty(name: 'MessageTextEn', vbType: 'String'),
      LegacySourceProperty(name: 'PeriodByDay', vbType: 'Integer'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
