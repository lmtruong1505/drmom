import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

// @JsonSerializable()
// class LoginModel {
//   @JsonKey(name: 'phone_number')
//   final String? phoneNumber;
//   final String? password;
//   @JsonKey(name: 'access_token')
//   final String? accessToken;
//   @JsonKey(name: 'refresh_token')
//   final String? refreshToken;
//   final UserModel? user;

//   LoginModel({
//     this.phoneNumber,
//     this.password,
//     this.accessToken,
//     this.refreshToken,
//     this.user,
//   });

//   factory LoginModel.fromJson(Map<String, dynamic> json) =>
//       _$LoginModelFromJson(json);

//   Map<String, dynamic> toJson() => _$LoginModelToJson(this);
// }

@JsonSerializable()
class LoginModel {
  LoginModel({
    this.id,
    this.email,
    this.code,
    this.fullname,
    this.representative,
    this.taxCode,
    this.phoneNumber,
    this.address,
    this.city,
    this.district,
    this.ward,
    this.fullAddress,
    this.isSuperuser,
    this.state,
    this.note,
    this.createdAt,
    this.modifiedAt,
    this.statusLabel,
    this.statusName,
    this.status,
    this.typeLabel,
    this.typeName,
    this.type,
  });

  final int? id;
  final String? email;
  final String? code;
  final String? fullname;
  final dynamic representative;

  @JsonKey(name: 'tax_code')
  final dynamic taxCode;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final dynamic address;
  final dynamic city;
  final dynamic district;
  final dynamic ward;

  @JsonKey(name: 'full_address')
  final String? fullAddress;

  @JsonKey(name: 'is_superuser')
  final bool? isSuperuser;
  final dynamic state;
  final String? note;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'modified_at')
  final DateTime? modifiedAt;

  @JsonKey(name: 'status_label')
  final String? statusLabel;

  @JsonKey(name: 'status_name')
  final String? statusName;
  final num? status;

  @JsonKey(name: 'type_label')
  final String? typeLabel;

  @JsonKey(name: 'type_name')
  final String? typeName;
  final num? type;

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
