// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: StudentFinalValuationModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class StudentFinalValuationModel extends LegacySourceModel {
  StudentFinalValuationModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'StudentFinalValuationModel',
    sourceFile: 'StudentFinalValuationModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'StudentAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'ApprovedCourseID', vbType: 'long'),
      LegacySourceProperty(
        name: 'ScientificEducationalValuation',
        vbType: 'String',
      ),
      LegacySourceProperty(name: 'ValuationFormID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ValuationDate', vbType: 'date'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
