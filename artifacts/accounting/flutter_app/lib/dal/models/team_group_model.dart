// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: TeamGroupModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class TeamGroupModel extends LegacySourceModel {
  TeamGroupModel(Map<String, Object?> values) : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'TeamGroupModel',
    sourceFile: 'TeamGroupModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Integer'),
      LegacySourceProperty(name: 'NameAr', vbType: 'String'),
      LegacySourceProperty(name: 'NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'GroupForemanAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'CreationDate', vbType: 'date'),
      LegacySourceProperty(name: 'StopDate', vbType: 'date'),
      LegacySourceProperty(name: 'GroupStatusID', vbType: 'Integer'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
