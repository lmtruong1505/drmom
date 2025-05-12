import 'bank_model.dart';

class CardModel {
  int? id;
  String? title;
  double? price;
  double? priceCurrent;
  double? cashback;
  String? image;
  int? company;
  int? userCreated;
  String? companyData;
  int? qty;
  BankModel? bank;
  bool? isMyCard;
  String? code;
  DateTime? createdAt;

  CardModel({
    this.id,
    this.title,
    this.price,
    this.cashback,
    this.image,
    this.company,
    this.userCreated,
    this.companyData,
    this.qty,
    this.bank,
    this.priceCurrent,
    this.isMyCard,
    this.code,
    this.createdAt,
  });

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = double.tryParse(json['price'].toString());
    cashback = double.tryParse(json['cashback'].toString());
    image = json['image'];
    company = json['company'];
    code = json['code'];
    createdAt = DateTime.tryParse(json['created_at'].toString());
    userCreated = json['user_created'];
    companyData = json['company_data'];
    bank = json['bank_data'] != null
        ? BankModel.fromJson(json['bank_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['cashback'] = cashback;
    data['image'] = image;
    data['company'] = company;
    data['user_created'] = userCreated;
    data['company_data'] = companyData;
    data['bank_data'] = bank?.toJson();
    return data;
  }
}
