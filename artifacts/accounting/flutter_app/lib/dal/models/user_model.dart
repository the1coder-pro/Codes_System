// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: UserModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class UserModel extends LegacySourceModel {
  UserModel(Map<String, Object?> values) : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'UserModel',
    sourceFile: 'UserModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Integer'),
      LegacySourceProperty(name: 'Namear', vbType: 'String'),
      LegacySourceProperty(name: 'NameEn', vbType: 'String'),
      LegacySourceProperty(name: 'UserName', vbType: 'String'),
      LegacySourceProperty(name: 'Password', vbType: 'String'),
      LegacySourceProperty(name: 'FirstEntry', vbType: 'Date'),
      LegacySourceProperty(name: 'LastEntry', vbType: 'Date'),
      LegacySourceProperty(name: 'UserGroupID', vbType: 'Byte'),
      LegacySourceProperty(name: 'CurrentStatusID', vbType: 'Integer'),
      LegacySourceProperty(name: 'Stopped', vbType: 'Boolean'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
