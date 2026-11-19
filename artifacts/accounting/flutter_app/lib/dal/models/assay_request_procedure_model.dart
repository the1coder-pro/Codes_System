// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: AssayRequestProcedureModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class AssayRequestProcedureModel extends LegacySourceModel {
  AssayRequestProcedureModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'AssayRequestProcedureModel',
    sourceFile: 'AssayRequestProcedureModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'AssayRequestID', vbType: 'long'),
      LegacySourceProperty(name: 'ProcedureDate', vbType: 'date'),
      LegacySourceProperty(name: 'StartTime', vbType: 'date'),
      LegacySourceProperty(name: 'EndTime', vbType: 'date'),
      LegacySourceProperty(name: 'SendToDelegateAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'AssayStatusID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ProcedureNote', vbType: 'String'),
      LegacySourceProperty(name: 'PCID', vbType: 'Integer'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ExecutedByDelegateAccountID', vbType: 'long'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
