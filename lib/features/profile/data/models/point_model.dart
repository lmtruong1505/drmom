import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'point_model.g.dart';

@JsonSerializable()
class PointModel {
  final int id;
  final double point;
  @JsonKey(name: 'point_code')
  final String pointCode;
  final String title;
  @JsonKey(name: 'sub_title')
  final String? subTitle;
  final String? description;
  @JsonKey(name: 'created_at')
  final String createdAt;

  PointModel({
    required this.id,
    required this.point,
    required this.pointCode,
    required this.title,
    this.subTitle,
    this.description,
    required this.createdAt,
  });

  factory PointModel.fromJson(Map<String, dynamic> json) =>
      _$PointModelFromJson(json);

  Map<String, dynamic> toJson() => _$PointModelToJson(this);

  PointModel copyWith({
    int? id,
    double? point,
    String? pointCode,
    String? title,
    String? subTitle,
    String? description,
    String? createdAt,
  }) {
    return PointModel(
      id: id ?? this.id,
      point: point ?? this.point,
      pointCode: pointCode ?? this.pointCode,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
