import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/features/product/data/models/category_model.dart';

part 'rating_model.g.dart';
part 'rating_model.freezed.dart';

@freezed
class RatingModel with _$RatingModel {
  const factory RatingModel({
    final int? id,
    final num? star,
    @JsonKey(name: 'product_id') final int? productId,
    final List<ImageModel>? images,
    final String? comment,
    @JsonKey(name: 'user_created') final UserCreated? userCreated,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _RatingModel;

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);
}

@freezed
class UserCreated with _$UserCreated {
  const factory UserCreated({
    final int? id,
    final String? fullname,
    @JsonKey(name: 'account_code') final String? accountCode,
  }) = _UserCreated;

  factory UserCreated.fromJson(Map<String, dynamic> json) =>
      _$UserCreatedFromJson(json);
}
