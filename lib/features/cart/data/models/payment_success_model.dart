import 'package:json_annotation/json_annotation.dart';

part 'payment_success_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PaymentSuccessModel {
  PaymentSuccessModel({
    this.code,
    this.companyTrans,
    this.customerTrans,
  });

  final String? code;
  @JsonKey(name: 'company_trans')
  final Trans? companyTrans;
  @JsonKey(name: 'customer_trans')
  final Trans? customerTrans;

  factory PaymentSuccessModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentSuccessModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentSuccessModelToJson(this);
}

@JsonSerializable()
class Trans {
  Trans({
    this.code,
    this.amount,
    this.content,
    this.transType,
    this.createdAt,
    this.referenceOrderCode,
    this.wallet,
  });

  final String? code;
  final num? amount;
  final String? content;

  @JsonKey(name: 'trans_type')
  final num? transType;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'reference_order_code')
  final String? referenceOrderCode;
  final String? wallet;

  factory Trans.fromJson(Map<String, dynamic> json) => _$TransFromJson(json);

  Map<String, dynamic> toJson() => _$TransToJson(this);
}
