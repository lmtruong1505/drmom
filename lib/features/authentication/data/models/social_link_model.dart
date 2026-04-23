import 'package:json_annotation/json_annotation.dart';

part 'social_link_model.g.dart';

@JsonSerializable()
class SocialLinkModel {
  final String? zalo;
  final String? facebook;

  SocialLinkModel({this.zalo, this.facebook});

  factory SocialLinkModel.fromJson(Map<String, dynamic> json) => _$SocialLinkModelFromJson(json);
  Map<String, dynamic> toJson() => _$SocialLinkModelToJson(this);
}
