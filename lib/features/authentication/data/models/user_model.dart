import 'package:bpg_retail/features/authentication/data/models/profile_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  final int? id;
  final int? point;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? fullname;
  final String? email;
  @JsonKey(name: 'account_code')
  final String? accountCode;
  final List<ProfileModel>? profiles;
  final String? birthday;
  final int? gender;
  final String? identified;
  @JsonKey(name: 'date_provided')
  final String? dateProvided;
  @JsonKey(name: 'place_provided')
  final String? placeProvided;
  final UserAddressModel? address;

  UserModel({
    this.id,
    this.point,
    this.phoneNumber,
    this.fullname,
    this.email,
    this.accountCode,
    this.profiles,
    this.birthday,
    this.gender,
    this.identified,
    this.dateProvided,
    this.address,
    this.placeProvided,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class UserAddressModel {
  final int? province;
  final int? district;
  final int? ward;
  final String? title;
  final double? lat;
  final double? long;

  UserAddressModel({
    this.province,
    this.district,
    this.ward,
    this.title,
    this.lat,
    this.long,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) =>
      _$UserAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAddressModelToJson(this);
}
