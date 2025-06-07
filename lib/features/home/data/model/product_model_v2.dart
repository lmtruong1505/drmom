import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/features/booth/data/models/asbc_both_model.dart';

part 'product_model_v2.g.dart';
part 'product_model_v2.freezed.dart';

@freezed
class ProductModelV2 with _$ProductModelV2 {
  const factory ProductModelV2({
    final int? id,
    final String? title,
    final String? code,
    @Default(1) final num? quantity,
    final num? weight,
    final num? width,
    final num? height,
    final num? length,
    @JsonKey(name: 'price_sell') final num? priceSell,
    final num? cashback,
    @JsonKey(name: 'media_data') final List<MediaDatumModel>? mediaData,
    final String? description,
    @JsonKey(name: 'options_data') final Map<String, dynamic>? optionsData,
    @JsonKey(name: 'options_cart') List<OptionData>? optionCart,
    @JsonKey(name: 'company_data') final CompanyDataV2? companyData,
    @JsonKey(name: 'total_quantity_sell') final num? productSell,
    @JsonKey(name: 'shop_data') final ProductShopData? shopData,
    @JsonKey(name: 'variant_data') final List<VariantModel>? variant,
    List<OptionData>? optionSelect,
    @Default(false) final bool? isSelect,
  }) = _ProductModelV2;

  factory ProductModelV2.fromJson(Map<String, dynamic> json) =>
      _$ProductModelV2FromJson(json);
}

@freezed
class MediaDatumModel with _$MediaDatumModel {
  const factory MediaDatumModel({
    final int? id,
    final String? alt,
    final String? image,
  }) = _MediaDatumModel;

  factory MediaDatumModel.fromJson(Map<String, dynamic> json) =>
      _$MediaDatumModelFromJson(json);
}

@freezed
class CompanyDataV2 with _$CompanyDataV2 {
  const factory CompanyDataV2({
    final int? id,
    final String? title,
    final CompanyAddressData? address,
    final String? phone,
  }) = _CompanyDataV2;

  factory CompanyDataV2.fromJson(Map<String, dynamic> json) =>
      _$CompanyDataV2FromJson(json);
}

@freezed
class OptionData with _$OptionData {
  const factory OptionData({
    final int? id,
    final String? title,
    final String? type,
    final String? values,
    final bool? status,
  }) = _OptionData;

  factory OptionData.fromJson(Map<String, dynamic> json) =>
      _$OptionDataFromJson(json);
}

@freezed
class AccountDataModel with _$AccountDataModel {
  const factory AccountDataModel({
    final String? system,
    final Account? account,
    final num? status,
    final int? id,
  }) = _AccountDataModel;

  factory AccountDataModel.fromJson(Map<String, dynamic> json) =>
      _$AccountDataModelFromJson(json);
}

@freezed
class Account with _$Account {
  const factory Account({
    final int? id,
    @JsonKey(name: 'full_name') final String? fullName,
    final String? phone,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}

@freezed
class CompanyAddressData with _$CompanyAddressData {
  const factory CompanyAddressData({
    final int? id,
    final String? title,
    final num? lat,
    final num? long,
    final DistrictData? province,
    final DistrictData? district,
    final DistrictData? ward,
    @JsonKey(name: 'address_full') final String? addressFull,
  }) = _CompanyAddressData;

  factory CompanyAddressData.fromJson(Map<String, dynamic> json) =>
      _$CompanyAddressDataFromJson(json);
}

@freezed
class ProductShopData with _$ProductShopData {
  const factory ProductShopData({
    final int? id,
    final String? title,
    @JsonKey(name: 'shop_warehouse_data')
    final ShopWarehouseData? shopWarehouseData,
  }) = _ProductShopData;

  factory ProductShopData.fromJson(Map<String, dynamic> json) =>
      _$ProductShopDataFromJson(json);
}

@freezed
class ShopWarehouseData with _$ShopWarehouseData {
  const factory ShopWarehouseData({
    @JsonKey(name: 'address_data') final AddressData? addressData,
  }) = _ShopWarehouseData;

  factory ShopWarehouseData.fromJson(Map<String, dynamic> json) =>
      _$ShopWarehouseDataFromJson(json);
}

@freezed
class AddressData with _$AddressData {
  const factory AddressData({
    final int? id,
    final String? title,
    final num? lat,
    final num? long,
    @JsonKey(name: 'province_data') final DataShop? provinceData,
    @JsonKey(name: 'district_data') final DataShop? districtData,
    @JsonKey(name: 'ward_data') final DataShop? wardData,
    @JsonKey(name: 'address_full') final String? addressFull,
  }) = _AddressData;

  factory AddressData.fromJson(Map<String, dynamic> json) =>
      _$AddressDataFromJson(json);
}

@freezed
class DataShop with _$DataShop {
  const factory DataShop({
    final int? id,
    final String? title,
    final String? code,
  }) = _DataShop;

  factory DataShop.fromJson(Map<String, dynamic> json) =>
      _$DataShopFromJson(json);
}

@freezed
class VariantModel with _$VariantModel {
  const factory VariantModel({
    final int? id,
    final String? title,
    final String? code,
    final String? image,
    final num? weight,
    final num? width,
    final num? height,
    final num? length,
    @JsonKey(name: 'price_sell') final num? priceSell,
    @JsonKey(name: 'shop_id') final int? shopId,
    @JsonKey(name: 'shop_name') final String? shopName,
    @JsonKey(name: 'options_data') final List<OptionData>? option,
    @JsonKey(name: 'option_data') final List<OptionData>? options,
  }) = _VariantModel;

  factory VariantModel.fromJson(Map<String, dynamic> json) =>
      _$VariantModelFromJson(json);
}
