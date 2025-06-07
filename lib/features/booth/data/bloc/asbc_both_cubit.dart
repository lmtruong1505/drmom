import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/app/data/bloc/app_cubit.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/core/utilities/debouncer.dart';
import 'package:bpg_retail/core/widgets/buttons/filter_button.dart';
import 'package:bpg_retail/features/booth/data/bloc/asbc_both_state.dart';
import 'package:bpg_retail/features/booth/data/repositories/booth_repository.dart';
import 'package:bpg_retail/features/profile/data/models/address_asbc_model.dart';
import 'package:bpg_retail/features/profile/data/repositories/address_repository.dart';

@LazySingleton()
class AsbcBothCubit extends Cubit<AsbcBothState> {
  AsbcBothCubit(
    this._boothRepository,
    this._addressRepository,
  ) : super(const AsbcBothState()) {
    getCurrentLatLong();
  }
  final BoothRepository _boothRepository;
  final AddressRepository _addressRepository;
  final preferences = getIt.get<Preferences>();
  final appCubit = getIt.get<AppCubit>();

  String? _status;
  String? _keyword = "";
  String? _address = "";
  int _page = 1;
  bool isMore = false;
  num lat = 0;
  num long = 0;
  final _debouncer = Debouncer();

  final filters = [
    const FilterButtonModel(title: "Tất cả", value: null),
    const FilterButtonModel(title: "Hoạt động", value: "active"),
    const FilterButtonModel(title: "Tạm dừng hoạt động", value: "inactive"),
    const FilterButtonModel(title: "Chờ phê duyệt", value: "pending"),
  ];

  void getCurrentLatLong() {
    final isValid = preferences.locations.length > 1;
    if (isValid) {
      lat = preferences.locations[0];
      long = preferences.locations[1];
    }
  }

  void getListHospital() async {
    emit(state.copyWith(isLoading: true));
    try {
      final res = await _boothRepository.getListHospital(
        keyword: _keyword,
        page: _page,
      );
      if (res.code == 200) {
        emit(state.copyWith(listBoths: res.data!, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void onSearch(String keySearch) {
    _keyword = keySearch;

    _debouncer.run(() => onRefesh());
  }

  void onLoadMore() {
    _page++;
    // getListHospitals();
  }

  void onRefesh() {
    _page = 1;
    emit(state.copyWith(listAddress: []));
    // getListHospitals();
  }

  void onSelectFilter(FilterButtonModel filter) {
    emit(state.copyWith(filter: filter));
    onRefesh();
  }

  void setAddressSelected(AsbcAddressModel result) {
    emit(state.copyWith(addressSelected: result));
    // getListHospitals();
  }
}
