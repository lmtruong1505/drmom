import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/features/authentication/data/models/user_model_v3.dart';
import 'package:bpg_retail/features/home/data/model/home_report_model.dart';
import 'package:bpg_retail/features/home/data/model/warehouse_model.dart';
import 'package:bpg_retail/features/home/data/repositories/report_repository.dart';
import 'package:bpg_retail/features/home/data/repositories/warehouse_repository.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomeReportBloc extends Cubit<CubitState> {
  HomeReportBloc() : super(CubitState());
  final ReportRepository _repo = ReportRepository();
  List<ReportHomeModel> list = [];
  PickerDateRange? range;
  final share = getIt.get<Preferences>();
  DateTime? selectedDate;

  final _warehouseRepo = WarehouseRepository();
  List<WarehouseModel> listWarehouse = [];
  int _page = 1;
  List<DatePeriod>? listDatePeriod;
  DatePeriod? datePeriodSelect;

  WarehouseModel? warehouse;
  // void getListWarehouse({
  //   String? search,
  //   bool? isMore,
  // }) async {
  //   emit(state.copyWith(status: CubitStatus.loading));
  //   final id = share.currentUser.id ?? 0;
  //   isMore == true ? _page++ : _page = 1;
  //   final res = await _warehouseRepo.getWarehouses(search, _page, id);
  //   if (res.code == 200) {
  //     listWarehouse = [WarehouseModel(name: 'Tất cả kho'), ...?res.data];
  //     warehouse = listWarehouse.firstOrNull;
  //     getReports();
  //   }
  //   emit(state.copyWith(status: CubitStatus.success));
  // }

  void selectWareHouse(WarehouseModel? value) {
    warehouse = value;
    getReports();
  }

  void getReports() async {
    emit(state.copyWith(status: CubitStatus.loading));
    final id = share.currentUser.id ?? 0;
    final start = datePeriodSelect?.openingDate.toText(fomat: 'yyyy-MM-dd');
    final end = (datePeriodSelect?.closingDate ?? DateTime.now())
        .toText(fomat: 'yyyy-MM-dd');
    final res = await _repo.getReports(start, end, id, warehouse?.id);
    if (res.data != null) {
      list = res.data ?? [];
    }
    emit(state.copyWith(status: CubitStatus.success));
  }

  void selectDateRange(PickerDateRange result) {
    range = result;
    getReports();
  }

  void selectDate(DateTime day) {
    selectedDate = day;

    emit(state.copyWith(status: CubitStatus.update));
  }

  void initData() {
    final now = DateTime.now();
    final userDatePeriod = share.getUserDataV3.datePeriod;
    final start = now.firstDayOfMonth;
    range = PickerDateRange(start, now);
    listDatePeriod = [
      ...[DatePeriod(openingDate: start)],
      ...?userDatePeriod,
    ];
    datePeriodSelect = listDatePeriod?.firstOrNull;

    listWarehouse = [
      WarehouseModel(name: 'Tất cả kho'),
      ...?share.getUserDataV3.warehouses,
    ];
    warehouse = listWarehouse.firstOrNull;
  }

  void filterDatePeriod(DatePeriod? p0) {
    datePeriodSelect = p0;
    getReports();
    // emit(state.copyWith(status: CubitStatus.update));
  }
}
