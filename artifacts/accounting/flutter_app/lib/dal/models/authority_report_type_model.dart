// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: AuthorityReportTypeModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class authorityReportTypeModel extends LegacySourceModel {
  authorityReportTypeModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'authorityReportTypeModel',
    sourceFile: 'AuthorityReportTypeModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'Long'),
      LegacySourceProperty(name: 'UserGroupID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ObjectID', vbType: 'Integer'),
      LegacySourceProperty(name: 'ReportTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ToPrintDirect', vbType: 'Boolean'),
      LegacySourceProperty(name: 'OpenCashDrawer', vbType: 'Boolean'),
      LegacySourceProperty(name: 'IsUsed', vbType: 'Boolean'),
      LegacySourceProperty(name: 'printerName', vbType: 'String'),
      LegacySourceProperty(name: 'pageSize', vbType: 'String'),
      LegacySourceProperty(name: 'NumberOfCopies', vbType: 'Long'),
      LegacySourceProperty(name: 'PageMarginLeft', vbType: 'Long'),
      LegacySourceProperty(name: 'PageMarginRight', vbType: 'Long'),
      LegacySourceProperty(name: 'PageMarginTop', vbType: 'Long'),
      LegacySourceProperty(name: 'PageMarginBottom', vbType: 'Long'),
      LegacySourceProperty(name: 'Landscape', vbType: 'Boolean'),
      LegacySourceProperty(name: 'PaperSize', vbType: 'String'),
      LegacySourceProperty(name: 'PaperWidth', vbType: 'Long'),
      LegacySourceProperty(name: 'PaperHeight', vbType: 'Long'),
      LegacySourceProperty(name: 'IsCustomPaperSize', vbType: 'Boolean'),
      LegacySourceProperty(name: 'PaperSource', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
