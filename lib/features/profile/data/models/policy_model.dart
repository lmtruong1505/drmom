import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'policy_model.g.dart';

@JsonSerializable()
class PolicyModel {
  final String? text;
  final int? level;
  @JsonKey(name: 'type_list')
  final String? typeList;
  final List<PolicyModel>? children;

  PolicyModel({
    this.text,
    this.level,
    this.typeList,
    this.children,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) =>
      _$PolicyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyModelToJson(this);

  PolicyModel copyWith({
    String? text,
    int? level,
    String? typeList,
    List<PolicyModel>? children,
  }) {
    return PolicyModel(
      text: text ?? this.text,
      level: level ?? this.level,
      typeList: typeList ?? this.typeList,
      children: children ?? this.children,
    );
  }
}
