// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ReceivedOutsideSearchReportListModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ReceivedOutsideSearchReportListModel extends LegacySourceModel {
  ReceivedOutsideSearchReportListModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ReceivedOutsideSearchReportListModel',
    sourceFile: 'ReceivedOutsideSearchReportListModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(
        name: 'ReceivedOutsideSearchReportID',
        vbType: 'long',
      ),
      LegacySourceProperty(name: 'StudentAccountID', vbType: 'long'),
      LegacySourceProperty(name: 'ApprovedCourseID', vbType: 'long'),
      LegacySourceProperty(name: 'Notes', vbType: 'String'),
      LegacySourceProperty(name: 'ReceivedDate', vbType: 'date'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
