// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: SMSMessageSettingModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class SMSMessageSettingModel extends LegacySourceModel {
  SMSMessageSettingModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'SMSMessageSettingModel',
    sourceFile: 'SMSMessageSettingModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'UserName', vbType: 'String'),
      LegacySourceProperty(name: 'UserPassword', vbType: 'String'),
      LegacySourceProperty(name: 'SenderName', vbType: 'String'),
      LegacySourceProperty(name: 'SMSProviderID', vbType: 'Byte'),
      LegacySourceProperty(name: 'InvoiceSMSText', vbType: 'String'),
      LegacySourceProperty(name: 'FinishedRentPeriodSMSText', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
