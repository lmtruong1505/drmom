import 'package:json_annotation/json_annotation.dart';

part 'warehouse_model.g.dart';

@JsonSerializable()
class WarehouseModel {
  WarehouseModel({
    this.id,
    this.name,
    this.code,
    this.city,
    this.district,
    this.ward,
    this.address,
    this.fullAddress,
    this.createdAt,
    this.modifiedAt,
    this.stockMoney,
  });

  final int? id;
  final String? name;
  final String? code;
  final AddressDataModel? city;
  final AddressDataModel? district;
  final AddressDataModel? ward;
  final String? address;

  @JsonKey(name: 'full_address')
  final String? fullAddress;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'modified_at')
  final DateTime? modifiedAt;
  // final User? user;

  @JsonKey(name: 'stock_money')
  final num? stockMoney;

  factory WarehouseModel.fromJson(Map<String, dynamic> json) =>
      _$WarehouseModelFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseModelToJson(this);
}

@JsonSerializable()
class AddressDataModel {
  AddressDataModel({
    this.id,
    this.name,
    this.slug,
    this.type,
    this.nameWithType,
    this.path,
    this.pathWithType,
    this.code,
    this.parent,
  });

  final int? id;
  final String? name;
  final String? slug;
  final String? type;

  @JsonKey(name: 'name_with_type')
  final String? nameWithType;
  final String? path;

  @JsonKey(name: 'path_with_type')
  final String? pathWithType;
  final num? code;
  final num? parent;

  factory AddressDataModel.fromJson(Map<String, dynamic> json) =>
      _$AddressDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDataModelToJson(this);
}

// @JsonSerializable()
// class User {
//   User({
//     this.id,
//     this.code,
//     this.fullname,
//     this.representative,
//     this.phoneNumber,
//     this.taxCode,
//     this.type,
//   });

//   final int? id;
//   final String? code;
//   final String? fullname;
//   final dynamic representative;

//   @JsonKey(name: 'phone_number')
//   final String? phoneNumber;

//   @JsonKey(name: 'tax_code')
//   final String? taxCode;
//   final num? type;

//   factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

//   Map<String, dynamic> toJson() => _$UserToJson(this);
// }
