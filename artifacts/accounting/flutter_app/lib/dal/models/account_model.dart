// Legacy DAL spelling/capitalization is part of the persisted schema contract.
// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../legacy_model.dart';

/// The class spelling is intentionally the same as the legacy DAL class.
class accountModel extends LegacyModel {
  accountModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblAccount',
      primaryKey: ['ID'],
      columns: [
        'ID',
        'AccountTypeID',
        'NameAr',
        'NameEn',
        'OpeningBalance',
        'CurrentBalance',
        'AcountNote',
        'BranchID',
        'NationalityID',
        'MoneyAccountTypeID',
        'StreetNameAr',
        'StreetNameEn',
        'CityAr',
        'CityEn',
        'CountryAlpha2Code',
        'BuildingNumber',
        'DistrictAr',
        'DistrictEn',
        'PostalCode',
        'PostalAdditionalNo',
      ],
    ),
    fromMap: accountModel.new,
  );

  factory accountModel.fromMap(Map<String, Object?> values) =>
      accountModel(values);

  Object? get ID => this['ID'];
  Object? get AccountTypeID => this['AccountTypeID'];
  Object? get NameAr => this['NameAr'];
  Object? get NameEn => this['NameEn'];
  Object? get OpeningBalance => this['OpeningBalance'];
  Object? get CurrentBalance => this['CurrentBalance'];
  Object? get AcountNote => this['AcountNote'];
  Object? get BranchID => this['BranchID'];
  Object? get MoneyAccountTypeID => this['MoneyAccountTypeID'];
}
