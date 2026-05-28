import 'package:json_annotation/json_annotation.dart';

part 'community_post_user_model.g.dart';

@JsonSerializable()
class PostRoleModel {
  final String? label;
  final String? value;

  PostRoleModel({this.label, this.value});

  factory PostRoleModel.fromJson(Map<String, dynamic> json) =>
      _$PostRoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostRoleModelToJson(this);
}

@JsonSerializable()
class PostStatusValueModel {
  final String? label;
  final int? value;

  PostStatusValueModel({this.label, this.value});

  factory PostStatusValueModel.fromJson(Map<String, dynamic> json) =>
      _$PostStatusValueModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostStatusValueModelToJson(this);
}

@JsonSerializable()
class CommunityPostUserModel {
  final int? id;
  final String? username;
  final String? fullname;
  final PostStatusValueModel? status;
  final String? avatar;
  final PostRoleModel? role;
  final String? email;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? gender;
  final String? code;
  @JsonKey(name: 'affiliate_code')
  final String? affiliateCode;

  CommunityPostUserModel({
    this.id,
    this.username,
    this.fullname,
    this.status,
    this.avatar,
    this.role,
    this.email,
    this.phoneNumber,
    this.gender,
    this.code,
    this.affiliateCode,
  });

  factory CommunityPostUserModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityPostUserModelToJson(this);
}
