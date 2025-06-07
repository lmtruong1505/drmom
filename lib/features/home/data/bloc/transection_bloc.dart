import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/features/authentication/data/models/user_model_v3.dart';
import 'package:bpg_retail/features/booth/data/models/transection_model.dart';
import 'package:bpg_retail/features/home/data/model/warehouse_model.dart';
import 'package:bpg_retail/features/home/data/repositories/warehouse_repository.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/home/data/repositories/transection_repository.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TransactionBloc extends Cubit<CubitState> {
  TransactionBloc() : super(CubitState());
  final share = getIt.get<Preferences>();
  final _warehouseRepo = WarehouseRepository();

  final TransectionRepository _repo = TransectionRepository();
  List<TransectionModel> list = [];
  List<DatePeriod>? listDatePeriod;
  DatePeriod? datePeriodSelect;

  MetaData? metaData;
  List<TransectionModel> get listCustom => list
      .where(
        (e) =>
            filterSelect?.value == null ||
            e.transactionType == filterSelect?.value,
      )
      .toList();

  num get totalHIRE => list
      .where(
        (e) =>
            (filterSelect?.value == null ||
                e.transactionType == filterSelect?.value) &&
            e.transactionType == 'HIRE',
      )
      .fold(0, (pre, element) => pre + (element.totalQuantity ?? 0));

  num get totalBalance => list
      .where(
        (e) => (filterSelect?.value == null ||
            e.transactionType == filterSelect?.value),
      )
      .fold(0, (pre, element) => pre + (element.hireCharges ?? 0));
  num get totalDEHIRE => list
      .where(
        (e) =>
            (filterSelect?.value == null ||
                e.transactionType == filterSelect?.value) &&
            e.transactionType == 'DEHIRE',
      )
      .fold(0, (pre, element) => pre + (element.totalQuantity ?? 0));

  PickerDateRange? range;
  DateTime? selectedEndDate;
  List<WarehouseModel> listWarehouse = [];
  int _page = 1;
  final preferences = getIt.get<Preferences>();

  final listFilter = [
    FilterModel(name: 'all_po_type'),
    FilterModel(name: 'hire', value: 'HIRE'),
    FilterModel(name: 'dehire', value: 'DEHIRE'),
  ];
  FilterModel? filterSelect;

  WarehouseModel? warehouse;
  void getListWarehouse({
    String? search,
    bool? isMore,
  }) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final id = share.currentUser.id ?? 0;
    isMore == true ? _page++ : _page = 1;
    final res = await _warehouseRepo.getWarehouses(search, _page, id);
    if (res.code == 200) {
      listWarehouse = res.data ?? [];
      warehouse = listWarehouse.firstOrNull;
      getTransaction();
    }
    emit(state.copyWith(status: CubitStatus.success));
  }

  void selectWareHouse(WarehouseModel? value) {
    warehouse = value;
    getTransaction();
    // emit(state.copyWith(status: CubitStatus.success));
  }

  void getTransaction() async {
    emit(state.copyWith(status: CubitStatus.loading));
    final start = datePeriodSelect?.openingDate.toText(fomat: 'yyyy-MM-dd');
    final end =
        (selectedEndDate ?? datePeriodSelect?.closingDate ?? DateTime.now())
            .toText(fomat: 'yyyy-MM-dd');
    final id = share.currentUser.id ?? 0;

    final res = await _repo.getTransaction(
      start: start,
      end: end,
      userId: id,
      warehouseId: warehouse?.id ?? 0,
    );
    if (res.data != null) {
      list = res.data ?? [];
      metaData = res.extra;
    }

    emit(state.copyWith(status: CubitStatus.success));
  }

  void initData() {
    final now = DateTime.now();
    final userDatePeriod = preferences.getUserDataV3.datePeriod;
    final start = now.firstDayOfMonth;
    range = PickerDateRange(start, now);
    filterSelect = listFilter.firstOrNull;
    listDatePeriod = [
      ...[DatePeriod(openingDate: start)],
      ...?userDatePeriod,
    ];
    datePeriodSelect = listDatePeriod?.firstOrNull;
    selectedEndDate = datePeriodSelect?.closingDate;
  }

  void selectDateRange(PickerDateRange p0) {
    range = p0;
    getTransaction();
    // emit(state.copyWith(status: CubitStatus.update));
  }

  void selectEndDate(DateTime p0) {
    selectedEndDate = p0;
    // range = PickerDateRange(range?.startDate, p0);
    getTransaction();
    // emit(state.copyWith(status: CubitStatus.update));
  }

  void filterWarehouse(FilterModel? p0) {
    filterSelect = p0;
    getTransaction();
    // emit(state.copyWith(status: CubitStatus.update));
  }

  void filterDatePeriod(DatePeriod? p0) {
    datePeriodSelect = p0;
    selectedEndDate = p0?.closingDate;
    getTransaction();
    // emit(state.copyWith(status: CubitStatus.update));
  }
}

class FilterModel {
  final String name;
  final String? value;

  FilterModel({
    required this.name,
    this.value,
  });
}
