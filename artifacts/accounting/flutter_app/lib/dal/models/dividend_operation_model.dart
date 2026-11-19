// GENERATED FILE: source model catalog; do not edit by hand.
// VB.NET source: DividendOperationModel.vb
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

class DividendOperationModel extends LegacySourceModel {
  DividendOperationModel(Map<String, Object?> values)
    : super(sourceDefinition, values);

  // BEGIN GENERATED LEGACY SOURCE DEFINITION
  static const sourceDefinition = LegacySourceModelDefinition(
    className: 'DividendOperationModel',
    sourceFile: 'DividendOperationModel.vb',
    tableName: null,
    tableMappingStatus: LegacyModelTableMappingStatus.unresolved,
    properties: [
      LegacySourceProperty(name: 'ID', vbType: 'long'),
      LegacySourceProperty(name: 'DividendDate', vbType: 'date'),
      LegacySourceProperty(name: 'Note', vbType: 'String'),
      LegacySourceProperty(name: 'MoneyTransactionID', vbType: 'String'),
      LegacySourceProperty(name: 'CurrentNetProfitAndloss', vbType: 'Single'),
      LegacySourceProperty(
        name: 'InvestorsBeforeDividendTotalBalance',
        vbType: 'Single',
      ),
      LegacySourceProperty(name: 'ManagementRate', vbType: 'Single'),
      LegacySourceProperty(name: 'InvestorsRate', vbType: 'Single'),
      LegacySourceProperty(name: 'AmanFundRate', vbType: 'Single'),
      LegacySourceProperty(name: 'ManagementRateAmount', vbType: 'Single'),
      LegacySourceProperty(name: 'InvestorsRateAmount', vbType: 'Single'),
      LegacySourceProperty(name: 'AmanFundRateAmount', vbType: 'Single'),
    ],
  );
  // END GENERATED LEGACY SOURCE DEFINITION
}
