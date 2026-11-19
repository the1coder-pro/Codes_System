// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: RentLeaseModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class RentLeaseModel extends LegacySourceModel {
  RentLeaseModel(Map<String, Object?> values) : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'RentLeaseModel',
    sourceFile: 'RentLeaseModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'BranchID', vbType: 'Byte'),
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'UnitID', vbType: 'long'),
      LegacySourceProperty(name: 'TenantID', vbType: 'long'),
      LegacySourceProperty(name: 'LeaseDate', vbType: 'date'),
      LegacySourceProperty(name: 'StartDate', vbType: 'date'),
      LegacySourceProperty(name: 'Rent', vbType: 'Single'),
      LegacySourceProperty(name: 'Insurance', vbType: 'Single'),
      LegacySourceProperty(name: 'Water', vbType: 'Single'),
      LegacySourceProperty(name: 'AdditionalConditions', vbType: 'String'),
      LegacySourceProperty(name: 'LastPaymentDate', vbType: 'date'),
      LegacySourceProperty(name: 'LastPaymentUntilDate', vbType: 'date'),
      LegacySourceProperty(name: 'EndDate', vbType: 'date'),
      LegacySourceProperty(name: 'UnitStatusID', vbType: 'Byte'),
      LegacySourceProperty(name: 'LastPaymentStartDate', vbType: 'date'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
      LegacySourceProperty(name: 'ReservationID', vbType: 'long'),
      LegacySourceProperty(name: 'RentTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'DurationCount', vbType: 'Integer'),
      LegacySourceProperty(name: 'PaymentMethodID', vbType: 'Byte'),
      LegacySourceProperty(name: 'PaymentPeriodType', vbType: 'Byte'),
      LegacySourceProperty(name: 'PaymentPeriodCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'HousingTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'UserID', vbType: 'Integer'),
      LegacySourceProperty(name: 'PaymentsCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'DurationMonthCount', vbType: 'Byte'),
      LegacySourceProperty(name: 'Seeking', vbType: 'Single'),
      LegacySourceProperty(name: 'IsRentBeforeManagement', vbType: 'boolean'),
      LegacySourceProperty(name: 'KeepInsuranceWithOwner', vbType: 'boolean'),
      LegacySourceProperty(name: 'CalendarTypeID', vbType: 'Byte'),
      LegacySourceProperty(name: 'SendSMS', vbType: 'boolean'),
      LegacySourceProperty(name: 'VAT', vbType: 'Single'),
      LegacySourceProperty(name: 'VATValue', vbType: 'Single'),
      LegacySourceProperty(name: 'IsVATed', vbType: 'boolean'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
