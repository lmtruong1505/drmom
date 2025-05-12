import 'package:json_annotation/json_annotation.dart';

part 'address_asbc_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AsbcAddressModel {
  AsbcAddressModel({
    this.id,
    this.account,
    this.address,
    this.addressData,
    this.accountData,
    this.isDefault,
    this.fullname,
    this.phone,
    this.addressFull,
  });

  final int? id;
  final num? account;
  final num? address;

  @JsonKey(name: 'address_data')
  final AddressData? addressData;

  @JsonKey(name: 'account_data')
  final AccountData? accountData;

  @JsonKey(name: 'is_default')
  final bool? isDefault;
  final String? fullname;
  final String? phone;
  @JsonKey(name: 'address_full')
  final String? addressFull;

  factory AsbcAddressModel.fromJson(Map<String, dynamic> json) =>
      _$AsbcAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AsbcAddressModelToJson(this);
}

@JsonSerializable()
class AccountData {
  AccountData({
    this.id,
    this.phone,
    this.fullName,
    // this.parentList,
    this.createdAt,
    this.level,
  });

  final int? id;
  final String? phone;

  @JsonKey(name: 'full_name')
  final String? fullName;

  // @JsonKey(name: 'parent_list')
  // final List<dynamic>? parentList;

  @JsonKey(name: 'created_at')
  final String? createdAt;
  final num? level;

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AddressData {
  AddressData({
    this.id,
    this.title,
    this.lat,
    this.long,
    this.province,
    this.district,
    this.ward,
    this.addressFull,
  });

  final int? id;
  final String? title;
  final num? lat;
  final num? long;
  final Province? province;
  final District? district;
  final District? ward;
  @JsonKey(name: 'address_full')
  final String? addressFull;

  factory AddressData.fromJson(Map<String, dynamic> json) =>
      _$AddressDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDataToJson(this);
}

@JsonSerializable()
class District {
  District({
    this.id,
    this.title,
    this.code,
  });

  final int? id;
  final String? title;
  final String? code;

  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}

@JsonSerializable()
class Province {
  Province({
    this.id,
    this.title,
    this.provinceCode,
  });

  final int? id;
  final String? title;

  @JsonKey(name: 'province_code')
  final String? provinceCode;

  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);

  Map<String, dynamic> toJson() => _$ProvinceToJson(this);
}
