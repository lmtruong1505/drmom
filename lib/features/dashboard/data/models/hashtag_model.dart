import 'package:json_annotation/json_annotation.dart';

part 'hashtag_model.g.dart';

@JsonSerializable()
class HashtagModel {
  final int? id;
  @JsonKey(name: 'modified_at')
  final String? modifiedAt;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? name;

  HashtagModel({
    this.id,
    this.modifiedAt,
    this.createdAt,
    this.name,
  });

  factory HashtagModel.fromJson(Map<String, dynamic> json) =>
      _$HashtagModelFromJson(json);

  Map<String, dynamic> toJson() => _$HashtagModelToJson(this);
}
