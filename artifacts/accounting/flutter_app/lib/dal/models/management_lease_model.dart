// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: ManagementLeaseModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class ManagementLeaseModel extends LegacySourceModel {
  ManagementLeaseModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'ManagementLeaseModel',
    sourceFile: 'ManagementLeaseModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'RealEstateID', vbType: 'long'),
      LegacySourceProperty(name: 'OwnerID', vbType: 'long'),
      LegacySourceProperty(name: 'LeaseDate', vbType: 'date'),
      LegacySourceProperty(name: 'StartDate', vbType: 'date'),
      LegacySourceProperty(name: 'DurationYearCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'PaymentsCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'Rent', vbType: 'long'),
      LegacySourceProperty(name: 'PaymentMethodID', vbType: 'Byte'),
      LegacySourceProperty(name: 'AdditionalConditions', vbType: 'String'),
      LegacySourceProperty(name: 'LastPaymentDate', vbType: 'date'),
      LegacySourceProperty(name: 'EndDate', vbType: 'date'),
      LegacySourceProperty(name: 'CollectionCommission', vbType: 'Single'),
      LegacySourceProperty(
        name: 'FirstYearCollectionCommission',
        vbType: 'Single',
      ),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
