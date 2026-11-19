// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: CustomerSourceDataModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class CustomerSourceDataModel extends LegacySourceModel {
  CustomerSourceDataModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'CustomerSourceDataModel',
    sourceFile: 'CustomerSourceDataModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'CustomerID', vbType: 'long'),
      LegacySourceProperty(name: 'SourceID', vbType: 'Integer'),
      LegacySourceProperty(name: 'SourceEmployeeID', vbType: 'long'),
      LegacySourceProperty(name: 'CityID', vbType: 'Integer'),
      LegacySourceProperty(name: 'RegistrationDate', vbType: 'date'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
