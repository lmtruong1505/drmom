import 'package:json_annotation/json_annotation.dart';

part 'deposit_history_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DepositHistoryModel {
  DepositHistoryModel({
    this.id,
    this.code,
    this.user,
    this.requestType,
    this.status,
    this.bank,
    this.amount,
    this.referenceCode,
    this.reason,
    this.userData,
    this.bankData,
    this.wallet,
    this.walletData,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? code;
  final num? user;

  @JsonKey(name: 'request_type')
  final num? requestType;
  final int? status;
  final num? bank;
  final num? amount;

  @JsonKey(name: 'reference_code')
  final String? referenceCode;
  final String? reason;

  @JsonKey(name: 'user_data')
  final UserData? userData;

  @JsonKey(name: 'bank_data')
  final DepositHistoryModelBankData? bankData;
  final dynamic wallet;

  @JsonKey(name: 'wallet_data')
  final dynamic walletData;
  final String? note;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  factory DepositHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$DepositHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepositHistoryModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DepositHistoryModelBankData {
  DepositHistoryModelBankData({
    this.id,
    this.bankData,
    this.accountNumber,
    this.accountName,
    this.isDefault,
    this.branch,
  });

  final int? id;

  @JsonKey(name: 'bank_data')
  final BankDataBankData? bankData;

  @JsonKey(name: 'account_number')
  final String? accountNumber;

  @JsonKey(name: 'account_name')
  final String? accountName;

  @JsonKey(name: 'is_default')
  final bool? isDefault;
  final dynamic branch;

  factory DepositHistoryModelBankData.fromJson(Map<String, dynamic> json) =>
      _$DepositHistoryModelBankDataFromJson(json);

  Map<String, dynamic> toJson() => _$DepositHistoryModelBankDataToJson(this);
}

@JsonSerializable()
class BankDataBankData {
  BankDataBankData({
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

  factory BankDataBankData.fromJson(Map<String, dynamic> json) =>
      _$BankDataBankDataFromJson(json);

  Map<String, dynamic> toJson() => _$BankDataBankDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserData {
  UserData({
    this.id,
    this.phone,
    this.keyAccount,
    this.fullName,
    this.email,
    this.referralCode,
    this.system,
    this.systemData,
    this.avatar,
  });

  final int? id;
  final String? phone;

  @JsonKey(name: 'key_account')
  final String? keyAccount;

  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? email;

  @JsonKey(name: 'referral_code')
  final String? referralCode;
  final num? system;

  @JsonKey(name: 'system_data')
  final SystemData? systemData;
  final String? avatar;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class SystemData {
  SystemData({
    this.id,
    this.title,
    this.code,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? title;
  final String? code;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  factory SystemData.fromJson(Map<String, dynamic> json) =>
      _$SystemDataFromJson(json);

  Map<String, dynamic> toJson() => _$SystemDataToJson(this);
}
