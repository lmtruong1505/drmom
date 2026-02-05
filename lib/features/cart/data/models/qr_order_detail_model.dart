import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_order_detail_model.g.dart';
part 'qr_order_detail_model.freezed.dart';

@freezed
abstract class QrOrderDetailModel with _$QrOrderDetailModel {
  const factory QrOrderDetailModel({
    final int? id,
    final String? title,
    final String? code,
    final num? discount,
    final String? note,
    // final Settings? settings,
    final num? company,
    @JsonKey(name: 'company_data') final CompanyDataV3? companyData,
    @JsonKey(name: 'user_created') final num? userCreated,
    @JsonKey(name: 'user_created_data') final UserCreatedData? userCreatedData,
    @JsonKey(name: 'user_updated') final num? userUpdated,
    @JsonKey(name: 'user_updated_data') final UserCreatedData? userUpdatedData,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    final num? status,
    @JsonKey(name: 'status_data') final StatusData? statusData,
    @JsonKey(name: 'order_items') final List<OrderItem>? orderItems,
    @JsonKey(name: 'order_type') final int? orderType,
    final num? total,
    @JsonKey(name: 'order_dlo_data') final OrderDlo? orderDlo,
    @JsonKey(name: 'payment_method_data') final PaymentMethod? paymentMethod,
    @JsonKey(name: 'customer_data') final UserCreatedData? customerData,
  }) = _QrOrderDetailModel;

  factory QrOrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$QrOrderDetailModelFromJson(json);
}

@freezed
abstract class CompanyDataV3 with _$CompanyDataV3 {
  const factory CompanyDataV3({
    final int? id,
    final String? title,
    final String? code,
    @JsonKey(name: 'tax_number') final String? taxNumber,
    final String? status,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    @JsonKey(name: 'account_data') final AccountData? accountData,
    @JsonKey(name: 'warehouse_data') final WarehouseData? warehouseData,
  }) = _CompanyDataV3;

  factory CompanyDataV3.fromJson(Map<String, dynamic> json) =>
      _$CompanyDataV3FromJson(json);
}

@freezed
abstract class AccountData with _$AccountData {
  const factory AccountData({
    final String? system,
    final UserCreatedData? account,
    final num? status,
    final int? id,
  }) = _AccountData;

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);
}

@freezed
abstract class UserCreatedData with _$UserCreatedData {
  const factory UserCreatedData({
    final int? id,
    @JsonKey(name: 'full_name') final String? fullName,
    final String? phone,
  }) = _UserCreatedData;

  factory UserCreatedData.fromJson(Map<String, dynamic> json) =>
      _$UserCreatedDataFromJson(json);
}

@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({
    final int? id,
    final num? quantity,
    final num? discount,
    final num? price,
    final num? variant,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    @JsonKey(name: 'variant_data') final VariantData? variantData,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
abstract class VariantData with _$VariantData {
  const factory VariantData({
    final int? id,
    final String? title,
    final String? code,
    final String? barcode,
    final num? weight,
    @JsonKey(name: 'price_sell') final num? priceSell,
    @JsonKey(name: 'price_import') final num? priceImport,
    final bool? status,
    final num? quantity,
    // final Settings? settings,
    final String? image,
    final num? product,
    @JsonKey(name: 'option_data') final List<OptionDataV1>? optionData,
  }) = _VariantData;

  factory VariantData.fromJson(Map<String, dynamic> json) =>
      _$VariantDataFromJson(json);
}

// @freezed
// class Settings {
//     Settings({required this.json});

//     factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

// }

@freezed
abstract class StatusData with _$StatusData {
  const factory StatusData({
    final int? id,
    final String? title,
    final String? code,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _StatusData;

  factory StatusData.fromJson(Map<String, dynamic> json) =>
      _$StatusDataFromJson(json);
}

@freezed
abstract class WarehouseData with _$WarehouseData {
  const factory WarehouseData({
    final num? address,
    @JsonKey(name: 'address_data') final AddressData? addressData,
    @JsonKey(name: 'address_full') final String? addressFull,
    final String? manager,
    final String? phone,
  }) = _WarehouseData;

  factory WarehouseData.fromJson(Map<String, dynamic> json) =>
      _$WarehouseDataFromJson(json);
}

@freezed
abstract class AddressData with _$AddressData {
  const factory AddressData({
    final int? id,
    final num? ward,
    final num? district,
    final num? province,
    @JsonKey(name: 'ward_data') final DistrictData? wardData,
    @JsonKey(name: 'district_data') final DistrictData? districtData,
    @JsonKey(name: 'province_data') final DistrictData? provinceData,
    final num? lat,
    final num? long,
    final String? title,
    @JsonKey(name: 'address_full') final String? addressFull,
  }) = _AddressData;

  factory AddressData.fromJson(Map<String, dynamic> json) =>
      _$AddressDataFromJson(json);
}

@freezed
abstract class DistrictData with _$DistrictData {
  const factory DistrictData({
    final int? id,
    final String? code,
    final String? title,
    final DistrictData? province,
    final DistrictData? district,
  }) = _DistrictData;

  factory DistrictData.fromJson(Map<String, dynamic> json) =>
      _$DistrictDataFromJson(json);
}

@freezed
abstract class OptionDataV1 with _$OptionDataV1 {
  const factory OptionDataV1({
    final int? id,
    final String? title,
    final String? type,
    final String? values,
  }) = _OptionDataV1;

  factory OptionDataV1.fromJson(Map<String, dynamic> json) =>
      _$OptionDataV1FromJson(json);
}

@freezed
abstract class OrderDlo with _$OrderDlo {
  const factory OrderDlo({
    final int? id,
    @JsonKey(name: 'title_service') final String? titleService,
    @JsonKey(name: 'transport_fee') final num? transportFee,
    @JsonKey(name: 'transport_partner') final String? transportPartner,
    @JsonKey(name: 'code_transport') final String? codeTransport,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    final num? order,
    @JsonKey(name: 'receiver_address') final num? receiverAddress,
    @JsonKey(name: 'receiver_address_data')
    final ReceiverAddressData? receiverAddressData,
  }) = _OrderDlo;

  factory OrderDlo.fromJson(Map<String, dynamic> json) =>
      _$OrderDloFromJson(json);
}

@freezed
abstract class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    final int? id,
    final String? title,
    final num? total,
    // final dynamic wallet,

    @JsonKey(name: 'wallet_type') final num? type,
    @JsonKey(name: 'wallet_data') final WallletData? walletData,
    final num? order,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
}

@freezed
abstract class WallletData with _$WallletData {
  const factory WallletData({
    final int? id,
    final String? title,
    final num? balance,
    final num? type,
    final num? account,
  }) = _WallletData;

  factory WallletData.fromJson(Map<String, dynamic> json) =>
      _$WallletDataFromJson(json);
}

@freezed
abstract class ReceiverAddressData with _$ReceiverAddressData {
  const factory ReceiverAddressData({
    final int? id,
    final String? title,
    final num? lat,
    final num? long,
    @JsonKey(name: 'address_full') final String? addressFull,
  }) = _ReceiverAddressData;

  factory ReceiverAddressData.fromJson(Map<String, dynamic> json) =>
      _$ReceiverAddressDataFromJson(json);
}
