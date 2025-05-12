class CardOrderModel {
  int? id;
  double? total;
  String? code;
  String? status;
  bool? isPay;
  double? price;
  DateTime? createdAt;
  BankData? bankData;

  CardOrderModel({
    this.id,
    this.total,
    this.code,
    this.price,
    this.createdAt,
    this.status,
    this.isPay,
    this.bankData,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'code': code,
      'price': price,
      'status': status,
      'bank_data': bankData,
      'created_at': createdAt?.toString(),
    };
  }

  factory CardOrderModel.fromMap(Map<String, dynamic> map) {
    print(map);
    return CardOrderModel(
      id: map['id']?.toInt(),
      total: map['total']?.toDouble(),
      code: map['code'].toString(),
      price: map['price']?.toDouble(),
      status: map['status'],
      bankData:
          map['bank_data'] == null ? null : BankData.fromJson(map['bank_data']),
      isPay: map['status'] == 'DONE',
      createdAt: DateTime.tryParse(map['created_at'].toString()),
    );
  }
}

class BankData {
  int? id;
  String? name;
  String? code;
  String? bin;
  String? logo;
  String? shortName;
  String? accountNumber;
  String? accountName;
  bool? isDefault;
  String? qr;
  double? amount;
  String? addInfo;

  BankData({
    this.id,
    this.name,
    this.code,
    this.bin,
    this.logo,
    this.shortName,
    this.accountNumber,
    this.accountName,
    this.isDefault,
    this.qr,
    this.amount,
    this.addInfo,
  });

  BankData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    bin = json['bin'];
    logo = json['logo'];
    shortName = json['short_name'];
    accountNumber = json['account_number'];
    accountName = json['account_name'];
    isDefault = json['is_default'];
    qr = json['qr'];
    amount = double.tryParse(json['amount'].toString());
    addInfo = json['add_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['bin'] = bin;
    data['logo'] = logo;
    data['short_name'] = shortName;
    data['account_number'] = accountNumber;
    data['account_name'] = accountName;
    data['is_default'] = isDefault;
    data['qr'] = qr;
    data['amount'] = amount;
    data['add_info'] = addInfo;
    return data;
  }
}
