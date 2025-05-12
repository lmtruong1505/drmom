class BankModel {
  int? id;
  String? name;
  String? code;
  String? bin;
  String? logo;
  String? shortName;
  String? accountNumber;
  String? accountName;
  bool? isDefault;

  BankModel({
    this.id,
    this.name,
    this.code,
    this.bin,
    this.logo,
    this.shortName,
    this.accountNumber,
    this.accountName,
    this.isDefault,
  });

  BankModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    bin = json['bin'];
    logo = json['logo'];
    shortName = json['short_name'];
    accountNumber = json['account_number'];
    accountName = json['account_name'];
    isDefault = json['is_default'];
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
    return data;
  }
}
