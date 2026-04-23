import 'package:drmom/features/authentication/data/models/province_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ward_data_model.g.dart';

@JsonSerializable()
class WardDataModel {
  final int? id;
  @JsonKey(name: 'ward_code')
  final String? wardCode;
  final String? name;
  @JsonKey(name: 'province_data')
  final ProvinceDataModel? provinceData;

  WardDataModel({this.id, this.wardCode, this.name, this.provinceData});

  factory WardDataModel.fromJson(Map<String, dynamic> json) => _$WardDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$WardDataModelToJson(this);
}
