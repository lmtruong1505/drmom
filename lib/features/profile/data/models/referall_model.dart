import 'package:json_annotation/json_annotation.dart';

part 'referall_model.g.dart';

@JsonSerializable()
class ReferallModel {
  ReferallModel({
    this.accountCode,
    this.accountId,
    this.accountName,
  });

  @JsonKey(name: 'account_code')
  final String? accountCode;
  @JsonKey(name: 'account_id')
  final int? accountId;
  @JsonKey(name: 'account_name')
  final String? accountName;

  factory ReferallModel.fromJson(Map<String, dynamic> json) =>
      _$ReferallModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferallModelToJson(this);
}
