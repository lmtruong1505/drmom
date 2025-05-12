import 'package:json_annotation/json_annotation.dart';

part 'bank_model.g.dart';

@JsonSerializable()
class BankModel {
  BankModel({
    this.id,
    this.name,
    this.code,
    this.bin,
    this.logo,
    this.shortName,
  });

  final int? id;
  final String? name;
  final String? code;
  final String? bin;
  final String? logo;

  @JsonKey(name: 'short_name')
  final String? shortName;

  factory BankModel.fromJson(Map<String, dynamic> json) =>
      _$BankModelFromJson(json);

  Map<String, dynamic> toJson() => _$BankModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MyBankModel {
  MyBankModel({
    this.id,
    this.bankData,
    this.accountNumber,
    this.accountName,
    this.isDefault,
  });

  final int? id;

  @JsonKey(name: 'bank_data')
  final BankModel? bankData;

  @JsonKey(name: 'account_number')
  final String? accountNumber;

  @JsonKey(name: 'account_name')
  final String? accountName;

  @JsonKey(name: 'is_default')
  final bool? isDefault;

  factory MyBankModel.fromJson(Map<String, dynamic> json) =>
      _$MyBankModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyBankModelToJson(this);
}
