import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/core/utilities/debouncer.dart';
import 'package:bpg_retail/features/home/data/model/warehouse_model.dart';
import 'package:bpg_retail/features/home/data/repositories/warehouse_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/utilities/enum.dart';

class WarehouseBloc extends Cubit<CubitState> {
  WarehouseBloc() : super(CubitState());
  final _repo = WarehouseRepository();
  List<WarehouseModel> list = [];
  final share = getIt.get<Preferences>();
  int _page = 1;
  final debounce = Debouncer(delay: 500.milliseconds);

  WarehouseModel? warehouse;
  void getListWarehouse({
    String? search,
    bool? isMore,
  }) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final id = share.currentUser.id ?? 0;
    isMore == true ? _page++ : _page = 1;
    final res = await _repo.getWarehouses(search, _page, id);
    if (res.code == 200) {
      list = res.data ?? [];
    }
    emit(state.copyWith(status: CubitStatus.success));
  }

  void selectWareHouse(WarehouseModel? value) {
    warehouse = value;
    emit(state.copyWith(status: CubitStatus.success));
  }
}
