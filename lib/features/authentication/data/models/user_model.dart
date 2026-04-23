import 'package:drmom/features/authentication/data/models/info_add_model.dart';
import 'package:drmom/features/authentication/data/models/status_model.dart';
import 'package:drmom/features/authentication/data/models/ward_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int? id;
  final String? fullname;
  final String? username;
  final String? code;
  final double? point;
  final String? avatar;
  final String? email;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'referral_code')
  final String? referralCode;
  final StatusModel? status;
  final String? gender;
  final int? ward;
  @JsonKey(name: 'detail_address')
  final String? detailAddress;
  final String? role;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'modified_at')
  final String? modifiedAt;
  @JsonKey(name: 'ward_data')
  final WardDataModel? wardData;
  @JsonKey(name: 'affiliate_code')
  final String? affiliateCode;
  @JsonKey(name: 'infor_add')
  final InforAddModel? inforAdd;
  final String? birthday;

  UserModel({
    this.id,
    this.fullname,
    this.username,
    this.code,
    this.point,
    this.avatar,
    this.email,
    this.phoneNumber,
    this.referralCode,
    this.status,
    this.gender,
    this.ward,
    this.detailAddress,
    this.role,
    this.createdAt,
    this.modifiedAt,
    this.wardData,
    this.affiliateCode,
    this.inforAdd,
    this.birthday,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
