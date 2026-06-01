import 'package:json_annotation/json_annotation.dart';

part 'health_post_model.g.dart';

@JsonSerializable()
class HealthPostModel {
  final int? id;
  final String? title;
  final String? content;
  final String? description;
  final String? author;
  final String? category;
  @JsonKey(name: 'published_at')
  final String? publishedAt;
  @JsonKey(name: 'read_time')
  final String? readTime;
  final String? views;
  final int? likes;
  @JsonKey(name: 'is_pinned')
  final bool? isPinned;
  @JsonKey(name: 'is_newest')
  final bool? isNewest;
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  HealthPostModel({
    this.id,
    this.title,
    this.content,
    this.description,
    this.author,
    this.category,
    this.publishedAt,
    this.readTime,
    this.views,
    this.likes,
    this.isPinned,
    this.isNewest,
    this.imageUrl,
  });

  factory HealthPostModel.fromJson(Map<String, dynamic> json) =>
      _$HealthPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$HealthPostModelToJson(this);
}
