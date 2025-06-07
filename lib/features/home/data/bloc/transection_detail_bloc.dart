import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/features/booth/data/models/transection_detail_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/home/data/repositories/transection_repository.dart';

class TransactionDetailBloc extends Cubit<CubitState> {
  TransactionDetailBloc() : super(CubitState());
  final share = getIt.get<Preferences>();

  final TransectionRepository _repo = TransectionRepository();
  TransectionDetailModel? detail;
  int? id;

  void getDetail() async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _repo.getDetailTransaction(id ?? 0);
    if (res.data != null) {
      detail = res.data;
    }
    emit(state.copyWith(status: CubitStatus.success));
  }

  void initData(int? value) {
    id = value;
    getDetail();
  }
}
