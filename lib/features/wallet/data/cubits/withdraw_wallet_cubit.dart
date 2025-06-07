import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/wallet/data/repositories/wallet_repository.dart';

import '../../../../core/base/cubit_state.dart';

class WithdrawWalletCubit extends Cubit<CubitState> {
  WithdrawWalletCubit() : super(CubitState());

  final _repo = WalletRepository();

  withdraw(
    int type, {
    required String title,
  }) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _repo.witthdraw(type);
    final bool isOk = res.code.validator >= 200 && res.code.validator < 300;
    emit(
      state.copyWith(
        status: isOk ? CubitStatus.success : CubitStatus.error,
        message: isOk ? "$title thành công" : "$title thất bại",
      ),
    );
  }
}
