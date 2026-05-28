import 'package:json_annotation/json_annotation.dart';
import 'thumbnail_data_model.dart';
import 'category_data_model.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final int? id;
  final String? title;
  final List<int>? category;
  @JsonKey(name: 'category_data')
  final List<CategoryDataModel>? categoryData;
  final String? status;
  @JsonKey(name: 'published_at')
  final String? publishedAt;
  @JsonKey(name: 'thumbnail_data')
  final ThumbnailDataModel? thumbnailData;
  final String? description;
  final String? author;
  final String? slug;
  @JsonKey(name: 'is_show')
  final bool? isShow;
  @JsonKey(name: 'is_pinned')
  final bool? isPinned;
  @JsonKey(name: 'pinned_at')
  final String? pinnedAt;

  PostModel({
    this.id,
    this.title,
    this.category,
    this.categoryData,
    this.status,
    this.publishedAt,
    this.thumbnailData,
    this.description,
    this.author,
    this.slug,
    this.isShow,
    this.isPinned,
    this.pinnedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
