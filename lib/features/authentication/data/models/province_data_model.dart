import 'package:json_annotation/json_annotation.dart';

part 'province_data_model.g.dart';

@JsonSerializable()
class ProvinceDataModel {
  final int? id;
  @JsonKey(name: 'province_code')
  final String? provinceCode;
  final String? name;
  @JsonKey(name: 'short_name')
  final String? shortName;
  final String? code;
  @JsonKey(name: 'place_type')
  final String? placeType;

  ProvinceDataModel({
    this.id,
    this.provinceCode,
    this.name,
    this.shortName,
    this.code,
    this.placeType,
  });

  factory ProvinceDataModel.fromJson(Map<String, dynamic> json) => _$ProvinceDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProvinceDataModelToJson(this);
}
