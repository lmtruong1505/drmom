import 'package:json_annotation/json_annotation.dart';

part 'my_group_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MyGroupModel {
  MyGroupModel({
    this.numberChildren,
    this.id,
    this.phone,
    this.keyAccount,
    this.fullName,
    this.email,
    this.referralCode,
    this.system,
    this.systemData,
    this.avatar,
    this.total,
    this.updatedAt,
    this.referralAt,
  });

  final int? id;
  final String? phone;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'number_children')
  final int? numberChildren;

  @JsonKey(name: 'key_account')
  final String? keyAccount;

  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? email;
  final num? total;

  @JsonKey(name: 'referral_code')
  final String? referralCode;
  final num? system;

  @JsonKey(name: 'system_data')
  final SystemData? systemData;
  final String? avatar;
  @JsonKey(name: 'referral_at')
  final String? referralAt;

  factory MyGroupModel.fromJson(Map<String, dynamic> json) => _$MyGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyGroupModelToJson(this);
}

@JsonSerializable()
class SystemData {
  SystemData({
    this.id,
    this.title,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.referralAt,
  });

  final int? id;
  final String? title;
  final String? code;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'referral_at')
  final String? referralAt;

  factory SystemData.fromJson(Map<String, dynamic> json) => _$SystemDataFromJson(json);
  Map<String, dynamic> toJson() => _$SystemDataToJson(this);
}
