import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

@JsonSerializable()
class WalletModel {
  WalletModel({
    this.title,
    this.balance,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.config,
    this.isPayable,
  });

  final String? title;
  final num? balance;
  final num? type;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final Config? config;

  @JsonKey(name: 'is_payable')
  final bool? isPayable;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);
}

@JsonSerializable()
class Config {
  Config({
    this.percentWithdraw,
    this.percentShopping,
  });

  @JsonKey(name: 'percent_withdraw')
  final num? percentWithdraw;

  @JsonKey(name: 'percent_shopping')
  final num? percentShopping;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
