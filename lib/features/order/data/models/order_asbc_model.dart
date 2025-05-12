import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_asbc_model.g.dart';
part 'order_asbc_model.freezed.dart';

@freezed
class OrderAsbcModel with _$OrderAsbcModel {
  const factory OrderAsbcModel({
    final int? id,
    final String? title,
    final num? total,
    final num? discount,
    final String? code,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    @JsonKey(name: 'status_order_data') final DataModel? statusOrderData,
    @JsonKey(name: 'user_created_data') final UserAtedData? userCreatedData,
    @JsonKey(name: 'user_updated_data') final UserAtedData? userUpdatedData,
    @JsonKey(name: 'company_data') final CompanyData? companyData,
    @JsonKey(name: 'shop_data') final ShopData? shopData,
    @JsonKey(name: 'payment_method_data') final PaymentMethodModel? paymentData,
    final List<Orderitem>? orderitems,
    @JsonKey(name: 'order_item_data') final List<Orderitem>? orderItemData,
  }) = _OrderAsbcModel;

  factory OrderAsbcModel.fromJson(Map<String, dynamic> json) =>
      _$OrderAsbcModelFromJson(json);
}

@freezed
class CompanyData with _$CompanyData {
  const factory CompanyData({
    final int? id,
    final String? title,
  }) = _CompanyData;

  factory CompanyData.fromJson(Map<String, dynamic> json) =>
      _$CompanyDataFromJson(json);
}

@freezed
class Orderitem with _$Orderitem {
  const factory Orderitem({
    final int? id,
    final num? quantity,
    final num? price,
    final num? discount,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'variant_id') final int? variantId,
    @JsonKey(name: 'variant_data') final VariantData? variantData,
  }) = _Orderitem;

  factory Orderitem.fromJson(Map<String, dynamic> json) =>
      _$OrderitemFromJson(json);
}

@freezed
class VariantData with _$VariantData {
  const factory VariantData({
    final int? id,
    final String? title,
    final String? code,
    @JsonKey(name: 'price_sell') final num? priceSell,
    final bool? status,
    final num? quantity,
    final num? weight,
    @JsonKey(name: 'product_id') final int? productId,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'options_data') final List<OptionsDatum>? optionsData,
    @JsonKey(name: 'product_data') final DataModel? productData,
    final String? image,
  }) = _VariantData;

  factory VariantData.fromJson(Map<String, dynamic> json) =>
      _$VariantDataFromJson(json);
}

@freezed
class OptionsDatum with _$OptionsDatum {
  const factory OptionsDatum({
    final int? id,
    final String? title,
    final dynamic code,
    final String? values,
    final bool? status,
  }) = _OptionsDatum;

  factory OptionsDatum.fromJson(Map<String, dynamic> json) =>
      _$OptionsDatumFromJson(json);
}

@freezed
class DataModel with _$DataModel {
  const factory DataModel({
    final int? id,
    final String? title,
    final String? code,
  }) = _DataModel;

  factory DataModel.fromJson(Map<String, dynamic> json) =>
      _$DataModelFromJson(json);
}

@freezed
class UserAtedData with _$UserAtedData {
  const factory UserAtedData({
    final int? id,
    @JsonKey(name: 'full_name') final String? fullName,
    @JsonKey(name: 'key_account') final String? keyAccount,
    @JsonKey(name: 'address_data') final DataModel? addressData,
  }) = _UserAtedData;

  factory UserAtedData.fromJson(Map<String, dynamic> json) =>
      _$UserAtedDataFromJson(json);
}

@freezed
class ShopData with _$ShopData {
  const factory ShopData({
    final int? id,
    final String? title,
    final String? phone,
    @JsonKey(name: 'address_shop') final String? addressShop,
  }) = _ShopData;

  factory ShopData.fromJson(Map<String, dynamic> json) =>
      _$ShopDataFromJson(json);
}

@freezed
class PaymentMethodModel with _$PaymentMethodModel {
  const factory PaymentMethodModel({
    final int? id,
    final String? title,
    final num? total,
  }) = _PaymentMethodModel;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);
}
