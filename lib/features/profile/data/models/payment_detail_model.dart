import 'package:json_annotation/json_annotation.dart';

part 'payment_detail_model.g.dart';

@JsonSerializable()
class PaymentDetailModel {
  PaymentDetailModel({
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

  @JsonKey(name: 'reference_code')
  final String? referenceOrderCode;
  final String? wallet;

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDetailModelToJson(this);
}
