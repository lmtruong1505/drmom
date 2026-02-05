import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/cart/data/models/payment_success_model.dart';
import 'package:bpg_retail/features/cart/data/models/qr_order_detail_model.dart';
import 'package:bpg_retail/features/cart/data/models/wallet_model.dart';

part 'cart_qr_buy_state.freezed.dart';

@freezed
abstract class CartQrBuyState with _$CartQrBuyState {
  const factory CartQrBuyState({
    @Default(false) bool isLoading,
    @Default(null) QrOrderDetailModel? detail,
    @Default(0) int paymentIndex,
    @Default([]) List<WalletModel>? wallets,
    @Default(CubitStatus.init) status,
    @Default(null) PaymentSuccessModel? paymentDetail,
  }) = _CartQrBuyState;
}
