// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: PCSettingModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class PCSettingModel extends LegacySourceModel {
  PCSettingModel(Map<String, Object?> values) : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'PCSettingModel',
    sourceFile: 'PCSettingModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'PCID', vbType: 'Integer'),
      LegacySourceProperty(name: 'OpenCashDrawer', vbType: 'Boolean'),
      LegacySourceProperty(name: 'CashDrawerSettings', vbType: 'String'),
      LegacySourceProperty(name: 'CashDrawerOutput', vbType: 'String'),
      LegacySourceProperty(name: 'CopyNo', vbType: 'String'),
      LegacySourceProperty(name: 'CopyStartDate', vbType: 'Date'),
      LegacySourceProperty(name: 'CopyEndDate', vbType: 'Date'),
      LegacySourceProperty(name: 'MyDrive', vbType: 'String'),
      LegacySourceProperty(name: 'MyDir', vbType: 'String'),
      LegacySourceProperty(name: 'LastUpdateDate', vbType: 'Date'),
      LegacySourceProperty(name: 'autoDownloadUpdate', vbType: 'Boolean'),
      LegacySourceProperty(name: 'TouchScreen', vbType: 'Boolean'),
      LegacySourceProperty(name: 'bilingualDisplay', vbType: 'Boolean'),
      LegacySourceProperty(name: 'RegistrationID', vbType: 'Long'),
      LegacySourceProperty(name: 'PrivateKey', vbType: 'String'),
      LegacySourceProperty(name: 'PublicKey', vbType: 'String'),
      LegacySourceProperty(name: 'UpdateStatus', vbType: 'Byte'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
