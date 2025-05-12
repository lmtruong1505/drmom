import 'package:json_annotation/json_annotation.dart';

part 'asbc_both_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AsbcBothModel {
  AsbcBothModel({
    this.id,
    this.title,
    this.code,
    this.taxNumber,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.accountData,
    this.warehouseData,
    this.products,
    this.variants,
    this.diff,
  });

  final int? id;
  final String? title;
  final String? code;

  @JsonKey(name: 'tax_number')
  final dynamic taxNumber;
  final String? status;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'account_data')
  final AccountData? accountData;

  @JsonKey(name: 'warehouse_data')
  final WarehouseData? warehouseData;
  final num? products;
  final num? variants;
  final num? diff;

  factory AsbcBothModel.fromJson(Map<String, dynamic> json) =>
      _$AsbcBothModelFromJson(json);

  Map<String, dynamic> toJson() => _$AsbcBothModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AccountData {
  AccountData({
    this.system,
    this.account,
    this.status,
    this.id,
  });

  final String? system;
  final Account? account;
  final num? status;
  final int? id;

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Account {
  Account({
    this.id,
    this.fullName,
    this.phone,
  });

  final int? id;

  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? phone;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WarehouseData {
  WarehouseData({
    this.address,
    this.addressData,
    this.manager,
    this.phone,
    this.addressFull,
  });

  final num? address;

  @JsonKey(name: 'address_data')
  final AddressData? addressData;
  final String? manager;
  final String? phone;

  @JsonKey(name: 'address_full')
  final String? addressFull;

  factory WarehouseData.fromJson(Map<String, dynamic> json) =>
      _$WarehouseDataFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AddressData {
  AddressData({
    this.id,
    this.ward,
    this.district,
    this.province,
    this.wardData,
    this.districtData,
    this.provinceData,
    this.lat,
    this.long,
    this.title,
  });

  final int? id;
  final num? ward;
  final num? district;
  final num? province;

  @JsonKey(name: 'ward_data')
  final DistrictData? wardData;

  @JsonKey(name: 'district_data')
  final DistrictData? districtData;

  @JsonKey(name: 'province_data')
  final DistrictData? provinceData;
  final num? lat;
  final num? long;
  final String? title;

  factory AddressData.fromJson(Map<String, dynamic> json) =>
      _$AddressDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DistrictData {
  DistrictData({
    this.id,
    this.code,
    this.title,
    this.province,
    this.district,
  });

  final int? id;
  final String? code;
  final String? title;
  final DistrictData? province;
  final DistrictData? district;

  factory DistrictData.fromJson(Map<String, dynamic> json) =>
      _$DistrictDataFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictDataToJson(this);
}
