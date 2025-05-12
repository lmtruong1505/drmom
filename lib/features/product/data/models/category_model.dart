import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryModel {
  CategoryModel({
    this.id,
    this.categoryName,
    this.categoryCode,
    this.image,
    this.status,
    this.totalProduct,
  });

  final int? id;
  @JsonKey(name: 'category_name')
  final String? categoryName;
  @JsonKey(name: 'category_code')
  final String? categoryCode;
  final ImageModel? image;
  final bool? status;
  @JsonKey(name: 'total_product')
  final num? totalProduct;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

@JsonSerializable()
class ImageModel {
  ImageModel({
    this.alt,
    this.key,
    this.src,
    this.source,
    this.idImage,
    this.customId,
    this.thumbnail,
  });

  final String? alt;
  final String? key;
  final String? src;
  final String? source;
  @JsonKey(name: 'id_image')
  final int? idImage;
  @JsonKey(name: 'custom_id')
  final int? customId;
  final String? thumbnail;

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);
}

@JsonSerializable()
class UnitModelV2 {
  UnitModelV2({
    this.id,
    this.sku,
    this.barcode,
    this.status,
    this.image,
    this.unitId,
    this.isCustom,
    this.isDefault,
    this.weight,
    this.unitName,
    this.quantity,
    this.quantityAvailable,
    this.isCreatedByYou,
  });

  final int? id;
  final String? sku;
  final String? barcode;
  final bool? status;
  final ImageModel? image;

  @JsonKey(name: 'unit_id')
  final int? unitId;

  @JsonKey(name: 'is_custom')
  final bool? isCustom;

  @JsonKey(name: 'is_default')
  final bool? isDefault;
  final num? weight;

  @JsonKey(name: 'unit_name')
  final String? unitName;
  final num? quantity;

  @JsonKey(name: 'quantity_available')
  final num? quantityAvailable;

  @JsonKey(name: 'is_created_by_you')
  final bool? isCreatedByYou;

  factory UnitModelV2.fromJson(Map<String, dynamic> json) =>
      _$UnitModelV2FromJson(json);

  Map<String, dynamic> toJson() => _$UnitModelV2ToJson(this);
}
