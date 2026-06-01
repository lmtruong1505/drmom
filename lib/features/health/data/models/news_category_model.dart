import 'package:json_annotation/json_annotation.dart';

part 'news_category_model.g.dart';

@JsonSerializable()
class NewsCategoryModel {
  final int? id;
  final String? name;
  final String? description;
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @JsonKey(name: 'updated_by')
  final int? updatedBy;
  @JsonKey(name: 'modified_at')
  final String? modifiedAt;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final int? parent;
  @JsonKey(name: 'children_data')
  final List<ChildCategoryModel>? childrenData;

  NewsCategoryModel({
    this.id,
    this.name,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.modifiedAt,
    this.createdAt,
    this.parent,
    this.childrenData,
  });

  factory NewsCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$NewsCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsCategoryModelToJson(this);
}

@JsonSerializable()
class ChildCategoryModel {
  final int? id;
  final String? name;

  ChildCategoryModel({
    this.id,
    this.name,
  });

  factory ChildCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ChildCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChildCategoryModelToJson(this);
}
