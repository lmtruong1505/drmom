import 'package:json_annotation/json_annotation.dart';

part 'account_bank_model.g.dart';

@JsonSerializable()
class AccountBankModel {
  AccountBankModel({
    this.id,
    this.bankId,
    this.bankAccount,
    this.isDefault,
    this.bin,
    this.bankAccountName,
    this.nameBank,
    this.bankCode,
    this.logo,
  });

  final int? id;
  @JsonKey(name: 'bank_id')
  final int? bankId;
  @JsonKey(name: 'bank_account')
  final String? bankAccount;
  @JsonKey(name: 'is_default')
  final bool? isDefault;
  final dynamic bin;
  @JsonKey(name: 'bank_account_name')
  final String? bankAccountName;
  @JsonKey(name: 'name_bank')
  final String? nameBank;
  @JsonKey(name: 'bank_code')
  final String? bankCode;
  final String? logo;

  factory AccountBankModel.fromJson(Map<String, dynamic> json) =>
      _$AccountBankModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountBankModelToJson(this);
}
