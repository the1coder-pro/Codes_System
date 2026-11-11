class UnitRow {
  String unitNo;
  String priceBefore;
  String minPrice;
  String wholesale;
  String priceInc;
  String barcode;
  String size;
  String count;
  String color;
  bool quick;

  UnitRow({
    this.unitNo = '',
    this.priceBefore = '',
    this.minPrice = '',
    this.wholesale = '',
    this.priceInc = '',
    this.barcode = '',
    this.size = 'حبة',
    this.count = '1',
    this.color = '',
    this.quick = false,
  });

  Map<String, dynamic> toJson() => {
    'unitNo': unitNo,
    'priceBefore': priceBefore,
    'minPrice': minPrice,
    'wholesale': wholesale,
    'priceInc': priceInc,
    'barcode': barcode,
    'size': size,
    'count': count,
    'color': color,
    'quick': quick,
  };

  factory UnitRow.fromJson(Map<String, dynamic> j) => UnitRow(
    unitNo: j['unitNo'] ?? '',
    priceBefore: j['priceBefore'] ?? '',
    minPrice: j['minPrice'] ?? '',
    wholesale: j['wholesale'] ?? '',
    priceInc: j['priceInc'] ?? '',
    barcode: j['barcode'] ?? '',
    size: j['size'] ?? 'حبة',
    count: j['count'] ?? '1',
    color: j['color'] ?? '',
    quick: j['quick'] ?? false,
  );

  UnitRow copy() => UnitRow.fromJson(toJson());
}

class Item {
  String id;
  String group;
  String nameAr;
  String nameEn;
  String shortName;
  String notes;
  String usage;
  String type;
  String taxCat;
  String taxRate;
  bool unused;
  String? imageBase64;
  List<UnitRow> units;

  Item({
    required this.id,
    this.group = '',
    this.nameAr = '',
    this.nameEn = '',
    this.shortName = '',
    this.notes = '',
    this.usage = 'غير محدد',
    this.type = 'غير محدد',
    this.taxCat = 'غير معفاة',
    this.taxRate = '15',
    this.unused = false,
    this.imageBase64,
    List<UnitRow>? units,
  }) : units = units ?? [UnitRow()];

  Map<String, dynamic> toJson() => {
    'id': id,
    'group': group,
    'nameAr': nameAr,
    'nameEn': nameEn,
    'shortName': shortName,
    'notes': notes,
    'usage': usage,
    'type': type,
    'taxCat': taxCat,
    'taxRate': taxRate,
    'unused': unused,
    'imageBase64': imageBase64,
    'units': units.map((u) => u.toJson()).toList(),
  };

  factory Item.fromJson(Map<String, dynamic> j) => Item(
    id: j['id'],
    group: j['group'] ?? '',
    nameAr: j['nameAr'] ?? '',
    nameEn: j['nameEn'] ?? '',
    shortName: j['shortName'] ?? '',
    notes: j['notes'] ?? '',
    usage: j['usage'] ?? 'غير محدد',
    type: j['type'] ?? 'غير محدد',
    taxCat: j['taxCat'] ?? 'غير معفاة',
    taxRate: j['taxRate'] ?? '15',
    unused: j['unused'] ?? false,
    imageBase64: j['imageBase64'] as String?,
    units: ((j['units'] as List?) ?? [])
        .map((e) => UnitRow.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
  );

  Item copy() => Item.fromJson(toJson());

  double get price =>
      double.tryParse(units.isEmpty ? '' : units.first.priceBefore) ?? 0;
}

class Account {
  String code;
  String nameAr;
  String nameEn;
  String type;
  String paymentType;
  String branch;
  String notes;
  String streetAr;
  String streetEn;
  String cityAr;
  String cityEn;
  String districtAr;
  String districtEn;
  String nationality;
  String country;
  String postalCode;
  String extraNumber;
  String buildingNumber;
  String commercialNumber;
  String taxNumber;
  String identityNumber;
  String phone;
  String mobile;
  String email;

  Account({
    this.code = '',
    this.nameAr = '',
    this.nameEn = '',
    this.type = 'الحسابات المالية',
    this.paymentType = 'حساب نقدي',
    this.branch = 'المركز الرئيسي',
    this.notes = '',
    this.streetAr = '',
    this.streetEn = '',
    this.cityAr = '',
    this.cityEn = '',
    this.districtAr = '',
    this.districtEn = '',
    this.nationality = 'سعودي',
    this.country = 'السعودية',
    this.postalCode = '',
    this.extraNumber = '',
    this.buildingNumber = '',
    this.commercialNumber = '',
    this.taxNumber = '',
    this.identityNumber = '',
    this.phone = '',
    this.mobile = '',
    this.email = '',
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'nameAr': nameAr,
    'nameEn': nameEn,
    'type': type,
    'paymentType': paymentType,
    'branch': branch,
    'notes': notes,
    'streetAr': streetAr,
    'streetEn': streetEn,
    'cityAr': cityAr,
    'cityEn': cityEn,
    'districtAr': districtAr,
    'districtEn': districtEn,
    'nationality': nationality,
    'country': country,
    'postalCode': postalCode,
    'extraNumber': extraNumber,
    'buildingNumber': buildingNumber,
    'commercialNumber': commercialNumber,
    'taxNumber': taxNumber,
    'identityNumber': identityNumber,
    'phone': phone,
    'mobile': mobile,
    'email': email,
  };

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    code: json['code'] ?? '',
    nameAr: json['nameAr'] ?? '',
    nameEn: json['nameEn'] ?? '',
    type: json['type'] ?? 'الحسابات المالية',
    paymentType: json['paymentType'] ?? 'حساب نقدي',
    branch: json['branch'] ?? 'المركز الرئيسي',
    notes: json['notes'] ?? '',
    streetAr: json['streetAr'] ?? '',
    streetEn: json['streetEn'] ?? '',
    cityAr: json['cityAr'] ?? '',
    cityEn: json['cityEn'] ?? '',
    districtAr: json['districtAr'] ?? '',
    districtEn: json['districtEn'] ?? '',
    nationality: json['nationality'] ?? 'سعودي',
    country: json['country'] ?? 'السعودية',
    postalCode: json['postalCode'] ?? '',
    extraNumber: json['extraNumber'] ?? '',
    buildingNumber: json['buildingNumber'] ?? '',
    commercialNumber: json['commercialNumber'] ?? '',
    taxNumber: json['taxNumber'] ?? '',
    identityNumber: json['identityNumber'] ?? '',
    phone: json['phone'] ?? '',
    mobile: json['mobile'] ?? '',
    email: json['email'] ?? '',
  );

  Account copy() => Account.fromJson(toJson());
}

class InvoiceLine {
  final String id;
  String code;
  String name;
  double qty;
  double price;

  InvoiceLine({
    required this.id,
    this.code = '',
    this.name = '',
    this.qty = 1,
    this.price = 0,
  });

  double get total => qty * price;

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'qty': qty,
    'price': price,
  };

  factory InvoiceLine.fromJson(Map<String, dynamic> j) => InvoiceLine(
    id: j['id'],
    code: j['code'] ?? '',
    name: j['name'] ?? '',
    qty: (j['qty'] as num?)?.toDouble() ?? 1,
    price: (j['price'] as num?)?.toDouble() ?? 0,
  );
}

class InvoiceType {
  final String ar;
  final String en;
  const InvoiceType(this.ar, this.en);
}

const invoiceTypes = <InvoiceType>[
  InvoiceType('فاتورة شراء', 'Purchases Invoice'),
  InvoiceType('فاتورة إرجاع مشتريات', 'Purchases Return Invoice'),
  InvoiceType('فاتورة ضريبية مبسطة', 'Simplified Tax Invoice'),
  InvoiceType(
    'رجيع فاتورة ضريبية مبسطة (دائن)',
    'Simplified Tax Invoice Return',
  ),
  InvoiceType('فاتورة تأجير', 'Rental Invoices'),
  InvoiceType('فاتورة رجيع تأجير', 'Rental Return Invoices'),
  InvoiceType('فاتورة مصاريف', 'Spent Invoice'),
  InvoiceType('فاتورة إرجاع مصاريف', 'Spent Return Invoice'),
];

List<Item> seedItems() => [
  Item(
    id: '1001',
    group: '10',
    nameAr: 'أرز بسمتي ٥ كجم',
    nameEn: 'Basmati Rice 5kg',
    shortName: 'أرز بسمتي',
    type: 'مخزني',
    usage: 'بيع وشراء',
    units: [
      UnitRow(
        unitNo: '1',
        priceBefore: '38.50',
        minPrice: '35.00',
        wholesale: '34.25',
        priceInc: '44.28',
        barcode: '6281007310421',
        size: 'كيس',
      ),
    ],
  ),
  Item(
    id: '1002',
    group: '10',
    nameAr: 'زيت دوار الشمس ١.٨ لتر',
    nameEn: 'Sunflower Oil 1.8L',
    shortName: 'زيت',
    type: 'مخزني',
    usage: 'بيع وشراء',
    units: [
      UnitRow(
        unitNo: '1',
        priceBefore: '21.70',
        minPrice: '19.90',
        wholesale: '18.60',
        priceInc: '24.96',
        barcode: '6281035930117',
        size: 'عبوة',
      ),
      UnitRow(
        unitNo: '2',
        priceBefore: '125.40',
        minPrice: '118.00',
        wholesale: '110.00',
        priceInc: '144.21',
        barcode: '6281035930124',
        size: 'كرتون',
        count: '6',
      ),
    ],
  ),
  Item(
    id: '2004',
    group: '20',
    nameAr: 'ورق تصوير A4',
    nameEn: 'A4 Copy Paper',
    shortName: 'ورق A4',
    type: 'خدمي',
    usage: 'شراء فقط',
    units: [
      UnitRow(
        unitNo: '1',
        priceBefore: '17.25',
        minPrice: '16.00',
        wholesale: '15.40',
        priceInc: '19.84',
        barcode: '4006381333931',
        size: 'رزمة',
      ),
    ],
  ),
];
