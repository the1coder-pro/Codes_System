// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: PointsModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class PointsModel extends LegacySourceModel {
  PointsModel(Map<String, Object?> values) : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'PointsModel',
    sourceFile: 'PointsModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'AccountID', vbType: 'long'),
      LegacySourceProperty(name: 'CollectedPoint', vbType: 'Single'),
      LegacySourceProperty(name: 'UsedPoint', vbType: 'Single'),
      LegacySourceProperty(name: 'StartDate', vbType: 'date'),
      LegacySourceProperty(name: 'LastPaiedDate', vbType: 'date'),
      LegacySourceProperty(name: 'LastExchangeDate', vbType: 'date'),
      LegacySourceProperty(name: 'ExpireDate', vbType: 'date'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
