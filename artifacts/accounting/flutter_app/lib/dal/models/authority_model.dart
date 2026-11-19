// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: AuthorityModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class authorityModel extends LegacySourceModel {
  authorityModel(Map<String, Object?> values) : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'authorityModel',
    sourceFile: 'AuthorityModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'UserGroupID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ObjectID', vbType: 'Integer'),
      LegacySourceProperty(name: 'allowShow', vbType: 'Boolean'),
      LegacySourceProperty(name: 'allowaddition', vbType: 'Boolean'),
      LegacySourceProperty(name: 'allowEdition', vbType: 'Boolean'),
      LegacySourceProperty(name: 'allowDeletion', vbType: 'Boolean'),
      LegacySourceProperty(name: 'allowPrint', vbType: 'Boolean'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
