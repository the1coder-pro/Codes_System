// Legacy DAL spelling/capitalization is part of the persisted schema contract.
// ignore_for_file: camel_case_types, non_constant_identifier_names

/// Metadata and value-preserving model wrappers for the Access-era tables.
///
/// Values stay dynamic on purpose: imported date fields can contain historical
/// values that Dart's DateTime parser cannot represent. Adapters must preserve
/// the original value and exact column spelling.
class LegacyTableMetadata {
  LegacyTableMetadata({
    required this.tableName,
    required List<String> columns,
    required List<String> primaryKey,
  }) : columns = Set.unmodifiable(columns),
       primaryKey = List.unmodifiable(primaryKey) {
    if (tableName.isEmpty || this.columns.isEmpty || this.primaryKey.isEmpty) {
      throw ArgumentError(
        'Legacy table metadata must include a table and key.',
      );
    }
    if (!this.columns.containsAll(this.primaryKey)) {
      throw ArgumentError('Every primary-key field must be a table column.');
    }
  }

  final String tableName;
  final Set<String> columns;
  final List<String> primaryKey;

  void validateFields(
    Map<String, Object?> values, {
    bool requirePrimaryKey = false,
  }) {
    final unknown = values.keys.where((name) => !columns.contains(name));
    if (unknown.isNotEmpty) {
      throw ArgumentError(
        'Unknown field for $tableName: ${unknown.join(', ')}',
      );
    }
    if (requirePrimaryKey &&
        primaryKey.any((field) => !values.containsKey(field))) {
      throw ArgumentError('A complete $tableName primary key is required.');
    }
  }
}

class LegacyModelDefinition {
  const LegacyModelDefinition({required this.metadata, required this.fromMap});

  final LegacyTableMetadata metadata;
  final LegacyModel Function(Map<String, Object?> values) fromMap;
}

abstract class LegacyModel {
  LegacyModel(this.modelDefinition, Map<String, Object?> values)
    : _values = Map.unmodifiable(Map<String, Object?>.of(values)) {
    modelDefinition.metadata.validateFields(_values);
  }

  final LegacyModelDefinition modelDefinition;
  final Map<String, Object?> _values;

  Object? operator [](String exactLegacyFieldName) =>
      _values[exactLegacyFieldName];

  Map<String, Object?> toMap() => Map<String, Object?>.of(_values);
}

class ItemGroupModel extends LegacyModel {
  ItemGroupModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblItemGroup',
      primaryKey: ['ID'],
      columns: [
        'ID',
        'NameAr',
        'NameEn',
        'ShortName',
        'VAT',
        'NotUsed',
        'UseTypeID',
        'ItemTypeID',
        'FilePath',
        'ItemNote',
        'VaTCategoriesID',
      ],
    ),
    fromMap: ItemGroupModel.new,
  );

  factory ItemGroupModel.fromMap(Map<String, Object?> values) =>
      ItemGroupModel(values);

  Object? get ID => this['ID'];
  Object? get NameAr => this['NameAr'];
  Object? get NameEn => this['NameEn'];
  Object? get ShortName => this['ShortName'];
  Object? get VAT => this['VAT'];
  Object? get NotUsed => this['NotUsed'];
  Object? get UseTypeID => this['UseTypeID'];
  Object? get ItemTypeID => this['ItemTypeID'];
  Object? get FilePath => this['FilePath'];
  Object? get ItemNote => this['ItemNote'];
  Object? get VaTCategoriesID => this['VaTCategoriesID'];
}

class ItemModel extends LegacyModel {
  ItemModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblItem',
      primaryKey: ['ID'],
      columns: [
        'ID',
        'Price',
        'MinimumPrice',
        'WholesalePrice',
        'quickitem',
        'ItemGroupID',
        'WithVatPrice',
      ],
    ),
    fromMap: ItemModel.new,
  );

  factory ItemModel.fromMap(Map<String, Object?> values) => ItemModel(values);

  Object? get ID => this['ID'];
  Object? get Price => this['Price'];
  Object? get MinimumPrice => this['MinimumPrice'];
  Object? get WholesalePrice => this['WholesalePrice'];
  Object? get quickitem => this['quickitem'];
  Object? get ItemGroupID => this['ItemGroupID'];
  Object? get WithVatPrice => this['WithVatPrice'];
}

class ItemOtherDataModel extends LegacyModel {
  ItemOtherDataModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblItemOtherData',
      primaryKey: ['ItemID'],
      columns: [
        'ItemID',
        'ColorID',
        'BarcodeNo',
        'ItemPlaceID',
        'ItemSizeID',
        'UnitCount',
      ],
    ),
    fromMap: ItemOtherDataModel.new,
  );

  factory ItemOtherDataModel.fromMap(Map<String, Object?> values) =>
      ItemOtherDataModel(values);

  Object? get ItemID => this['ItemID'];
  Object? get ColorID => this['ColorID'];
  Object? get BarcodeNo => this['BarcodeNo'];
  Object? get ItemPlaceID => this['ItemPlaceID'];
  Object? get ItemSizeID => this['ItemSizeID'];
  Object? get UnitCount => this['UnitCount'];
}

class ItemBalanceModel extends LegacyModel {
  ItemBalanceModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblItemBalance',
      primaryKey: ['ItemID'],
      columns: [
        'ItemID',
        'StartPeriodBalance',
        'PurchaseCount',
        'PurchaseReturnCount',
        'SalesCount',
        'SalesReturnCount',
        'SpentCount',
        'SpentReturnCount',
        'RentalCount',
        'RentalReturnCount',
        'OrderMinammBalance',
        'OrderCount',
        'DecayedCount',
        'DecayedReturnCount',
        'ProductionCount',
        'ProductionCancelCount',
        'ProductionReturnCount',
        'PurchaseOrderCount',
        'SalesOrderCount',
        'PackingAndUnPackingCount',
        'StartPeriodBalanceReturn',
        'LastPurchaseDate',
        'MinPurchasePrice',
        'MaxPurchasePrice',
        'LastPurchasePrice',
        'Qty',
        'CostPrice',
        'LastSalesDate',
        'MinSalesPrice',
        'MaxSalesPrice',
        'LastSalesPrice',
      ],
    ),
    fromMap: ItemBalanceModel.new,
  );

  factory ItemBalanceModel.fromMap(Map<String, Object?> values) =>
      ItemBalanceModel(values);

  Object? get ItemID => this['ItemID'];
  Object? get Qty => this['Qty'];
  Object? get CostPrice => this['CostPrice'];
  Object? get LastPurchaseDate => this['LastPurchaseDate'];
  Object? get LastSalesDate => this['LastSalesDate'];
}

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

class tblInvoiceModel extends LegacyModel {
  tblInvoiceModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblInvoice',
      primaryKey: ['ID'],
      columns: [
        'ID',
        'CodeID',
        'PCID',
        'InvoiceTypeID',
        'CreditorID',
        'DebtorID',
        'InvoiceNo',
        'InvoiceDate',
        'CreditorPersonID',
        'DebitorPersonID',
        'Amount',
        'Discount',
        'BeforehandSum',
        'RetrieveSum',
        'PaidSum',
        'DueDate',
        'Remark',
        'NoteTypeID',
        'GivingDate',
        'AccountName',
        'GivingTime',
        'Pledge',
        'PlateQty',
        'ReceivedPlateQty',
        'RemainSum',
        'StoreCreditorID',
        'StoreDebtorID',
        'UserID',
        'AuthorizerID',
        'MoneyTransactionID',
        'UrgentTypeID',
        'TableID',
        'OrderType',
        'VATValue',
        'VatTypeID',
        'VATNo',
        'InvoiceTime',
        'ReternedInvoiceID',
        'VAT',
        'IssueDate',
        'ReturnReason',
        'SubmissionStatusID',
      ],
    ),
    fromMap: tblInvoiceModel.new,
  );

  factory tblInvoiceModel.fromMap(Map<String, Object?> values) =>
      tblInvoiceModel(values);

  Object? get ID => this['ID'];
  Object? get InvoiceTypeID => this['InvoiceTypeID'];
  Object? get InvoiceNo => this['InvoiceNo'];
  Object? get InvoiceDate => this['InvoiceDate'];
  Object? get Amount => this['Amount'];
  Object? get MoneyTransactionID => this['MoneyTransactionID'];
}

class tblInvoiceItemModel extends LegacyModel {
  tblInvoiceItemModel(Map<String, Object?> values) : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblInvoiceItem',
      primaryKey: ['InvoiceID', 'ID'],
      columns: [
        'InvoiceID',
        'ID',
        'ItemID',
        'Price',
        'Qty',
        'PlateQty',
        'Discount',
        'DiscountPercent',
        'UnitCost',
        'VAT',
        'ExpireDate',
      ],
    ),
    fromMap: tblInvoiceItemModel.new,
  );

  factory tblInvoiceItemModel.fromMap(Map<String, Object?> values) =>
      tblInvoiceItemModel(values);

  Object? get InvoiceID => this['InvoiceID'];
  Object? get ID => this['ID'];
  Object? get ItemID => this['ItemID'];
  Object? get Price => this['Price'];
  Object? get Qty => this['Qty'];
  Object? get VAT => this['VAT'];
  Object? get ExpireDate => this['ExpireDate'];
}

class tblMoneyTransactionModel extends LegacyModel {
  tblMoneyTransactionModel(Map<String, Object?> values)
    : super(definition, values);

  static final definition = LegacyModelDefinition(
    metadata: LegacyTableMetadata(
      tableName: 'tblMoneyTransaction',
      primaryKey: ['ID'],
      columns: ['ID', 'CodeID', 'PCID', 'TransactionDate'],
    ),
    fromMap: tblMoneyTransactionModel.new,
  );

  factory tblMoneyTransactionModel.fromMap(Map<String, Object?> values) =>
      tblMoneyTransactionModel(values);

  Object? get ID => this['ID'];
  Object? get CodeID => this['CodeID'];
  Object? get PCID => this['PCID'];
  Object? get TransactionDate => this['TransactionDate'];
}
