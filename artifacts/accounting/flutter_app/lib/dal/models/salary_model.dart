// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: SalaryModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class SalaryModel extends LegacySourceModel {
  SalaryModel(Map<String, Object?> values) : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'SalaryModel',
    sourceFile: 'SalaryModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'AccountID', vbType: 'long'),
      LegacySourceProperty(name: 'SalaryYear', vbType: 'Integer'),
      LegacySourceProperty(name: 'SalaryMonth', vbType: 'Byte'),
      LegacySourceProperty(name: 'Salary', vbType: 'Integer'),
      LegacySourceProperty(name: 'SalaryHousingEquivalent', vbType: 'Integer'),
      LegacySourceProperty(name: 'SalaryLiveEquivalent', vbType: 'Integer'),
      LegacySourceProperty(name: 'InsuranceByCompany', vbType: 'Integer'),
      LegacySourceProperty(name: 'InsuranceByEmployee', vbType: 'Integer'),
      LegacySourceProperty(
        name: 'SalaryTransportationEquivalent',
        vbType: 'Integer',
      ),
      LegacySourceProperty(name: 'LoanNo', vbType: 'Integer'),
      LegacySourceProperty(name: 'LoanPayment', vbType: 'long'),
      LegacySourceProperty(name: 'PolicyNo', vbType: 'String'),
      LegacySourceProperty(name: 'DocumentImagePath', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
