import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/features/order/data/models/order_model_v2.dart';
import 'package:bpg_retail/features/profile/data/models/promotion_model.dart';

part 'promotion_detail_model.g.dart';
part 'promotion_detail_model.freezed.dart';

@freezed
class PromotionDetailModel with _$PromotionDetailModel {
  const factory PromotionDetailModel({
    final int? id,
    final PromotionStatus? status,
    final Grocery? grocery,
    @JsonKey(name: 'end_date') final String? endDate,
    @JsonKey(name: 'start_date') final String? startDate,
    @JsonKey(name: 'promotion_name') final String? promotionName,
    @JsonKey(name: 'promotion_description') final String? promotionDescription,
    @JsonKey(name: 'promotion_details')
    final List<PromotionDetail>? promotionDetails,
  }) = _PromotionDetailModel;

  factory PromotionDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionDetailModelFromJson(json);
}

@freezed
class Grocery with _$Grocery {
  const factory Grocery({
    final int? id,
    final String? fullname,
    final String? username,
    final String? email,
    @JsonKey(name: 'is_active') final bool? isActive,
    final num? status,
    @JsonKey(name: 'account_code') final String? accountCode,
    @JsonKey(name: 'user_created') final num? userCreated,
    @JsonKey(name: 'created_at') final String? createdAt,
    final dynamic locate,
    final List<Profile>? profile,
  }) = _Grocery;

  factory Grocery.fromJson(Map<String, dynamic> json) =>
      _$GroceryFromJson(json);
}

@freezed
class Profile with _$Profile {
  const factory Profile({
    @JsonKey(name: 'profile_id') final int? profileId,
    final String? value,
    @JsonKey(name: 'profile_name') final String? profileName,
    @JsonKey(name: 'profile_type') final String? profileType,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
