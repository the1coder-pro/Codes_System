// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: EmployeeContactModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class EmployeeContactModel extends LegacySourceModel {
  EmployeeContactModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'EmployeeContactModel',
    sourceFile: 'EmployeeContactModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'EmployeeID', vbType: 'long'),
      LegacySourceProperty(name: 'ContactTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ContactID', vbType: 'String'),
      LegacySourceProperty(name: 'ContactNote', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
