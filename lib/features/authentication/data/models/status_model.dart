import 'package:json_annotation/json_annotation.dart';

part 'status_model.g.dart';

@JsonSerializable()
class StatusModel {
  final String? label;
  final dynamic value;

  StatusModel({this.label, this.value});

  factory StatusModel.fromJson(Map<String, dynamic> json) => _$StatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$StatusModelToJson(this);
}
