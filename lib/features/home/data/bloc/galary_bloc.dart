import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';

class GalaryBloc extends Cubit<CubitState> {
  GalaryBloc() : super(CubitState());
  int? selectPage;
  bool seeMore = true;
  onChangeSeeMore() {
    seeMore = !seeMore;
    emit(state.copyWith(status: CubitStatus.update));
  }

  onChangePage(int value) {
    selectPage = value;
    emit(state.copyWith(status: CubitStatus.update));
  }
}
