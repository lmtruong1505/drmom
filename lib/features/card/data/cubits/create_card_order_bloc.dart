import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/features/card/data/repositories/card_repository.dart';

import '../../../../core/base/cubit_state.dart';
import '../models/card_order_model.dart';

class CreateCardOrderBloc extends Cubit<CubitState> {
  CreateCardOrderBloc() : super(CubitState());

  final _repo = CardRepository();

  CardOrderModel? cardOrder;

  create({
    required int cardId,
    required int qty,
  }) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _repo.createOrder(cardId: cardId, qty: qty);
    final bool isOk = res.code.validator >= 200 && res.code.validator < 300;
    cardOrder = res.data;
    emit(
      state.copyWith(
        status: isOk ? CubitStatus.success : CubitStatus.error,
        message: isOk
            ? 'Tạo đơn hàng thành công'
            : res.message ?? "Tạo đơn hàng thất bại",
      ),
    );
  }
}
