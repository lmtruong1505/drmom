import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/features/product/data/models/category_model.dart';

part 'cart_model_v2.g.dart';
part 'cart_model_v2.freezed.dart';

@freezed
abstract class CartModelV2 with _$CartModelV2 {
  const factory CartModelV2({
    @Default(0) final num? quantity,
    @JsonKey(name: 'user_created') final num? userCreated,
    @JsonKey(name: 'user_updated') final num? userUpdated,
    @JsonKey(name: 'product_unit_id') final int? productUnitId,
    @JsonKey(name: 'price_list_uint_id') final int? priceUnitId,
    @JsonKey(name: 'retail_price') final num? retailPrice,
    final num? status,
    @JsonKey(name: 'category_id') final int? categoryId,
    @JsonKey(name: 'category_name') final String? categoryName,
    @JsonKey(name: 'product_id') final int? productId,
    @JsonKey(name: 'product_name') final String? productName,
    @JsonKey(name: 'product_code') final String? productCode,
    final List<ImageModel>? images,
    @JsonKey(name: 'unit_name') final String? unitName,
    @JsonKey(name: 'unit_id') final int? unitId,
    @Default(false) final bool isSelect,
    @JsonKey(name: 'mass_out') final num? massOut,
  }) = _CartModelV2;

  factory CartModelV2.fromJson(Map<String, dynamic> json) =>
      _$CartModelV2FromJson(json);
}
