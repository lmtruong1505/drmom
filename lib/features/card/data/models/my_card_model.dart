class MyCardModel {
  CardInfor? cardInfor;
  List<UserCards>? userCards;

  MyCardModel({this.cardInfor, this.userCards});

  MyCardModel.fromJson(Map<String, dynamic> json) {
    cardInfor = json['card_infor'] != null
        ? CardInfor.fromJson(json['card_infor'])
        : null;
    if (json['user_cards'] != null) {
      userCards = <UserCards>[];
      json['user_cards'].forEach((v) {
        userCards!.add(UserCards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cardInfor != null) {
      data['card_infor'] = cardInfor!.toJson();
    }
    if (userCards != null) {
      data['user_cards'] = userCards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CardInfor {
  int? id;
  String? title;
  String? image;

  CardInfor({
    this.id,
    this.title,
    this.image,
  });

  CardInfor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    return data;
  }
}

class UserCards {
  int? id;
  String? code;
  double? price;
  double? receiveAmount;
  double? totalCashback;
  double? cashback;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? lastScanAt;

  UserCards({
    this.id,
    this.code,
    this.price,
    this.receiveAmount,
    this.cashback,
    this.createdAt,
    this.updatedAt,
    this.lastScanAt,
  });

  UserCards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    price = double.tryParse(json['price'].toString());
    receiveAmount = double.tryParse(json['receive_amount'].toString());
    totalCashback = double.tryParse(json['total_cashback'].toString());
    cashback = json['cashback'];
    createdAt = DateTime.tryParse(json['created_at'].toString());
    updatedAt = DateTime.tryParse(json['updated_at'].toString());
    lastScanAt = DateTime.tryParse(json['last_scan_at'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['price'] = price;
    data['receive_amount'] = receiveAmount;
    data['total_cashback'] = totalCashback;
    data['cashback'] = cashback;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
