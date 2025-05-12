import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  CategoryModel({
    this.id,
    this.title,
    this.code,
    this.image,
    this.quantityProduct,
  });

  final int? id;
  final String? title;
  final String? code;
  final String? image;

  @JsonKey(name: 'quantity_product')
  final num? quantityProduct;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
