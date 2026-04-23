import 'package:drmom/features/authentication/data/models/social_link_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'info_add_model.g.dart';

@JsonSerializable()
class InforAddModel {
  @JsonKey(name: 'social_link')
  final SocialLinkModel? socialLink;

  InforAddModel({this.socialLink});

  factory InforAddModel.fromJson(Map<String, dynamic> json) => _$InforAddModelFromJson(json);
  Map<String, dynamic> toJson() => _$InforAddModelToJson(this);
}
