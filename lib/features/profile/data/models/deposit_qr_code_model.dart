import 'package:json_annotation/json_annotation.dart';

part 'deposit_qr_code_model.g.dart';

@JsonSerializable()
class DepositQrCodeModel {
  DepositQrCodeModel({
    this.bankCode,
    this.bankName,
    this.bankAccount,
    this.userBankName,
    this.amount,
    this.content,
    this.qrCode,
    this.imgId,
    this.existing,
    this.transactionId,
    this.transactionRefId,
    this.qrLink,
    this.subTerminalCode,
    this.serviceCode,
    this.orderId,
    this.terminalCode,
  });

  final String? bankCode;
  final String? bankName;
  final String? bankAccount;
  final String? userBankName;
  final String? amount;
  final String? content;
  final String? qrCode;
  final String? imgId;
  final num? existing;
  final String? transactionId;
  final String? transactionRefId;
  final String? qrLink;
  final String? terminalCode;
  final String? subTerminalCode;
  final String? serviceCode;
  final String? orderId;

  factory DepositQrCodeModel.fromJson(Map<String, dynamic> json) =>
      _$DepositQrCodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepositQrCodeModelToJson(this);
}
