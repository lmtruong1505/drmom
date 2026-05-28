import 'package:json_annotation/json_annotation.dart';

part 'thumbnail_data_model.g.dart';

@JsonSerializable()
class ThumbnailDataModel {
  final int? id;
  final String? image;
  final String? alt;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  ThumbnailDataModel({
    this.id,
    this.image,
    this.alt,
    this.createdAt,
    this.updatedAt,
  });

  factory ThumbnailDataModel.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThumbnailDataModelToJson(this);
}
