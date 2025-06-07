import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/base/base_response.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/dialog_utils.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/widgets/toast/overlay_custom.dart';
import 'package:bpg_retail/features/cart/data/bloc/cart_qr_buy_state.dart';
import 'package:bpg_retail/features/cart/data/repositories/cart_repository.dart';

@injectable
class CartQrBuyCubit extends Cubit<CartQrBuyState> {
  CartQrBuyCubit(this.repo) : super(const CartQrBuyState());

  final CartRepository repo;

  void getOrderDetail(String code) async {
    emit(state.copyWith(isLoading: true));
    try {
      final res = await repo.getOrderDetail(code);
      if (res.code == 200) {
        emit(state.copyWith(detail: res.data, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void getWallets() async {
    try {
      final res = await repo.getWallets();
      if (res.code == 200) {
        emit(state.copyWith(wallets: res.data));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectPaymentMethod(int index) async {
    emit(state.copyWith(paymentIndex: index));
  }

  void createOrder() async {
    try {
      final id = state.detail?.id ?? 0;
      final index = state.paymentIndex;
      final wallet = state.wallets?[index].type ?? 0;
      final res = await repo.createOrder(id, wallet);
      if (res.code == 200) {
        emit(
          state.copyWith(
            status: CubitStatus.sendSuccess,
            paymentDetail: res.data,
          ),
        );
      } else {
        emit(state.copyWith(status: CubitStatus.sendFaild));
        showOverlayToast(title: res.message ?? "", iconColor: AppColors.red_1);
      }
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.sendFaild));
      showOverlayToast(title: e.toString(), iconColor: AppColors.red_1);
    }
  }
}
