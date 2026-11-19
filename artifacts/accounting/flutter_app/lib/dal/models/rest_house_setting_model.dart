// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: RestHouse_SettingModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class RestHouse_SettingModel extends LegacySourceModel {
  RestHouse_SettingModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'RestHouse_SettingModel',
    sourceFile: 'RestHouse_SettingModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'RentInsurance', vbType: 'Single'),
      LegacySourceProperty(
        name: 'SendMessageInRegistration',
        vbType: 'boolean',
      ),
      LegacySourceProperty(name: 'SendMessageBefore', vbType: 'Integer'),
      LegacySourceProperty(name: 'MessageText', vbType: 'String'),
      LegacySourceProperty(
        name: 'RentLeaseCancellationMulctAccountID',
        vbType: 'long',
      ),
      LegacySourceProperty(
        name: 'RentLeaseCancellationMulct',
        vbType: 'Single',
      ),
      LegacySourceProperty(name: 'StudySeasonID', vbType: 'Integer'),
      LegacySourceProperty(name: 'WeekendSeasonID', vbType: 'Integer'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
