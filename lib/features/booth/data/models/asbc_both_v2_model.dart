import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/features/home/data/model/product_model_v2.dart';

part 'asbc_both_v2_model.g.dart';
part 'asbc_both_v2_model.freezed.dart';

@freezed
class AbbcBothV2Model with _$AbbcBothV2Model {
  const factory AbbcBothV2Model({
    final int? id,
    final String? title,
    final String? description,
    final String? status,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    @JsonKey(name: 'user_created_data') final UserCreatedData? userCreatedData,
    @JsonKey(name: 'total_product') final num? totalProduct,
    @JsonKey(name: 'quantity_product_sell') final num? quantityProductSell,
    @JsonKey(name: 'warehouse_data') final List<WarehouseDatum>? warehouseData,
    @JsonKey(name: 'product_sell_best')
    final List<ProductSellBest>? productSellBest,
  }) = _AbbcBothV2Model;

  factory AbbcBothV2Model.fromJson(Map<String, dynamic> json) =>
      _$AbbcBothV2ModelFromJson(json);
}

@freezed
class ProductSellBest with _$ProductSellBest {
  const factory ProductSellBest({
    @JsonKey(name: 'variant_id') final int? variantId,
    @JsonKey(name: 'total_sell') final num? totalSell,
    @JsonKey(name: 'product_data') final ProductData? productData,
  }) = _ProductSellBest;

  factory ProductSellBest.fromJson(Map<String, dynamic> json) =>
      _$ProductSellBestFromJson(json);
}

@freezed
class ProductData with _$ProductData {
  const factory ProductData({
    final int? id,
    final String? title,
    final String? code,
    @JsonKey(name: 'media_data') final List<MediaDatum>? mediaData,
  }) = _ProductData;

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);
}

@freezed
class MediaDatum with _$MediaDatum {
  const factory MediaDatum({
    final int? id,
    final String? alt,
    @JsonKey(name: 'created_at') final String? createdAt,
    final String? image,
  }) = _MediaDatum;

  factory MediaDatum.fromJson(Map<String, dynamic> json) =>
      _$MediaDatumFromJson(json);
}

@freezed
class UserCreatedData with _$UserCreatedData {
  const factory UserCreatedData({
    @JsonKey(name: 'full_name') final String? fullName,
    final String? phone,
    final String? image,
  }) = _UserCreatedData;

  factory UserCreatedData.fromJson(Map<String, dynamic> json) =>
      _$UserCreatedDataFromJson(json);
}

@freezed
class WarehouseDatum with _$WarehouseDatum {
  const factory WarehouseDatum({
    final String? manager,
    final String? phone,
    @JsonKey(name: 'is_default') final bool? isDefault,
    @JsonKey(name: 'address_id') final int? addressId,
    @JsonKey(name: 'address_data') final AddressData? addressData,
  }) = _WarehouseDatum;

  factory WarehouseDatum.fromJson(Map<String, dynamic> json) =>
      _$WarehouseDatumFromJson(json);
}
