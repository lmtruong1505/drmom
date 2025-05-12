import 'package:json_annotation/json_annotation.dart';
import 'package:BGP_Retail/features/profile/data/models/promotion_model.dart';

part 'first_gift_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FirstGiftModel {
  FirstGiftModel({
    this.details,
    this.code,
    this.id,
    this.startDate,
    this.endDate,
  });

  final List<PromotionDetail>? details;
  final String? code;
  @JsonKey(name: "account_promotion_id")
  final int? id;
  @JsonKey(name: "start_date")
  final String? startDate;
  @JsonKey(name: "end_date")
  final String? endDate;

  factory FirstGiftModel.fromJson(Map<String, dynamic> json) =>
      _$FirstGiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$FirstGiftModelToJson(this);
}
