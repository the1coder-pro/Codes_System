// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: DividendOperationInvestorsModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class DividendOperationInvestorsModel extends LegacySourceModel {
  DividendOperationInvestorsModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'DividendOperationInvestorsModel',
    sourceFile: 'DividendOperationInvestorsModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'DividendOperationID', vbType: 'long'),
      LegacySourceProperty(name: 'InvestorID', vbType: 'long'),
      LegacySourceProperty(
        name: 'InvestorBeforeDividendBalance',
        vbType: 'Single',
      ),
      LegacySourceProperty(
        name: 'InvestorBeforeDividendBalancePercentage',
        vbType: 'Single',
      ),
      LegacySourceProperty(name: 'DividendAmount', vbType: 'Single'),
      LegacySourceProperty(name: 'Remark', vbType: 'String'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
