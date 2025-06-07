import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/profile/data/models/bank_model.dart';
import 'package:bpg_retail/features/profile/data/models/deposit_history_model.dart';
import 'package:bpg_retail/features/profile/data/models/deposit_qr_code_model.dart';

part 'deposit_withdraw_state.freezed.dart';

@freezed
class DepositWithdrawState with _$DepositWithdrawState {
  const factory DepositWithdrawState({
    @Default(null) final int? index,
    @Default(false) final bool? isLoading,
    @Default(false) final bool isDefault,
    @Default(CubitStatus.init) final CubitStatus? status,
    @Default(null) final DepositQrCodeModel? deposit,
    @Default([]) final List<DepositHistoryModel>? listHistory,
    @Default([]) final List<BankModel>? listBank,
    @Default([]) final List<MyBankModel>? listMyBank,
    @Default(null) final BankModel? bankSelect,
    @Default(null) final MyBankModel? myBankSelect,
    @Default("") final String? message,
    @Default("") final String? token,
  }) = _DepositWithdrawState;
}
