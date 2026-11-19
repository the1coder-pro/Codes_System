// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: TeamGroupMemberModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class TeamGroupMemberModel extends LegacySourceModel {
  TeamGroupMemberModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'TeamGroupMemberModel',
    sourceFile: 'TeamGroupMemberModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'TeamGroupID', vbType: 'Integer'),
      LegacySourceProperty(name: 'MemberAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'StartDate', vbType: 'date'),
      LegacySourceProperty(name: 'StopDate', vbType: 'date'),
      LegacySourceProperty(name: 'StatusID', vbType: 'Integer'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
