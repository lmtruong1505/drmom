import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/profile/data/models/payment_detail_model.dart';
import 'package:bpg_retail/features/profile/data/models/payment_model.dart';

part 'payment_history_state.freezed.dart';

@freezed
class PaymentHistoryState with _$PaymentHistoryState {
  const factory PaymentHistoryState({
    @Default([]) List<PaymentModel>? payments,
    @Default(null) PaymentDetailModel? detail,
    @Default(false) bool isLoading,
    int? indexWallet,
    int? indexTransaction,
    CubitStatus? stauts,
  }) = _PaymentHistoryState;
}
