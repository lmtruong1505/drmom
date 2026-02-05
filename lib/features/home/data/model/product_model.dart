import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/features/product/data/models/category_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  //  const ProductModel._();
  const factory ProductModel({
    final int? id,
    @JsonKey(name: 'product_name') final String? productName,
    @JsonKey(name: 'average_rating') final num? averageRating,
    @JsonKey(name: 'product_code') final String? productCode,
    final List<ImageModel>? images,
    @JsonKey(name: "number_of_sale") final num? quantitySold,
    // final num? status,
    // final num? category,
    @JsonKey(name: 'mass_in') final num? massIn,
    @JsonKey(name: 'mass_out') final num? massOut,
    @JsonKey(name: 'category__category_name') final String? categoryName,
    final List<UnitModel>? units,
    final String? description,
    @JsonKey(name: 'unit_default') final dynamic unitDefault,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

@freezed
abstract class UnitModel with _$UnitModel {
  // const UnitModel._();
  const factory UnitModel({
    final int? id,
    @JsonKey(name: 'unit_id') final int? unitId,
    @JsonKey(name: 'is_default') final bool? isDefault,
    @JsonKey(name: 'unit_name') final String? unitName,
    @JsonKey(name: 'retail_price') final num? retailPrice,
    @JsonKey(name: 'quantity_available') final num? quantityAvailable,
    @JsonKey(name: 'price_list_unit_id') final num? priceUnitId,
    @JsonKey(name: 'mass_in') final num? massIn,
    @JsonKey(name: 'mass_out') final num? massOut,
    final num? quantity,
    final num? weight,
  }) = _UnitModel;

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);
}
