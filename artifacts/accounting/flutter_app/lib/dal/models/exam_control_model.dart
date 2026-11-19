// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ExamControlModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ExamControlModel extends LegacySourceModel {
  ExamControlModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ExamControlModel',
    sourceFile: 'ExamControlModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ExamDistributionTableID', vbType: 'long'),
      LegacySourceProperty(name: 'WatcherAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'PaperCount', vbType: 'long'),
      LegacySourceProperty(name: 'CorrectionFinishDate', vbType: 'String'),
      LegacySourceProperty(name: 'SubjectStartName', vbType: 'String'),
      LegacySourceProperty(name: 'SubjectEndName', vbType: 'String'),
      LegacySourceProperty(name: 'MarkEntered', vbType: 'boolean'),
      LegacySourceProperty(name: 'Revision', vbType: 'boolean'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
