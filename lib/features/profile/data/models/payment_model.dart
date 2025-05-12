import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel {
  PaymentModel({
    this.id,
    this.code,
    this.amount,
    this.content,
    this.createdAt,
    this.referenceOrderCode,
    this.transType,
    this.walletData,
  });

  final int? id;
  final String? code;
  final num? amount;
  final String? content;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'reference_order_code')
  final String? referenceOrderCode;

  @JsonKey(name: 'trans_type')
  final num? transType;

  @JsonKey(name: 'wallet_data')
  final WalletData? walletData;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
}

@JsonSerializable()
class WalletData {
  WalletData({
    this.title,
    this.id,
    this.type,
    this.accountData,
  });

  final String? title;
  final int? id;
  final num? type;

  @JsonKey(name: 'account_data')
  final AccountData? accountData;

  factory WalletData.fromJson(Map<String, dynamic> json) =>
      _$WalletDataFromJson(json);

  Map<String, dynamic> toJson() => _$WalletDataToJson(this);
}

@JsonSerializable()
class AccountData {
  AccountData({
    this.id,
    this.fullName,
    this.phone,
  });

  final int? id;

  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? phone;

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDataToJson(this);
}
