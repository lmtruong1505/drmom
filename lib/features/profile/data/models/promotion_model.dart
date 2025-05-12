import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/features/product/data/models/category_model.dart';

part 'promotion_model.g.dart';
part 'promotion_model.freezed.dart';

@freezed
class PromotionModel with _$PromotionModel {
  const factory PromotionModel({
    final PromotionStatus? status,
    @JsonKey(name: 'promotion_name') final String? promotionName,
    @JsonKey(name: 'end_date') final String? endDate,
    @JsonKey(name: 'start_date') final String? startDate,
    @JsonKey(name: 'promotion_description') final String? promotionDescription,
    @JsonKey(name: 'promotion_details')
    final List<PromotionDetail>? promotionDetails,
    final int? id,
  }) = _PromotionModel;

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);
}

@freezed
class PromotionDetail with _$PromotionDetail {
  const factory PromotionDetail({
    final num? quantity,
    @JsonKey(name: 'product_unit_id') final int? productUnitId,
    @JsonKey(name: 'product_name') final String? productName,
    final ImageModel? image,
    @JsonKey(name: 'product_code') final String? productCode,
    @JsonKey(name: 'product_unit_name') final String? productUnitName,
  }) = _PromotionDetail;

  factory PromotionDetail.fromJson(Map<String, dynamic> json) =>
      _$PromotionDetailFromJson(json);
}

@freezed
class PromotionStatus with _$PromotionStatus {
  const factory PromotionStatus({
    final String? label,
    final num? status,
  }) = _PromotionStatus;

  factory PromotionStatus.fromJson(Map<String, dynamic> json) =>
      _$PromotionStatusFromJson(json);
}
