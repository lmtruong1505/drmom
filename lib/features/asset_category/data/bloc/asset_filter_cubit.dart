import 'package:flutter_bloc/flutter_bloc.dart';

import 'asset_filter_state.dart';

class AssetFilterCubit extends Cubit<AssetFilterState> {
  AssetFilterCubit() : super(const AssetFilterState());

  void selectDepartment(String? value) {
    emit(state.copyWith(selectedDepartment: value));
  }

  void selectStatus(String status) {
    emit(state.copyWith(selectedStatus: status));
  }

  void selectDeviceType(String? value) {
    emit(state.copyWith(selectedDeviceType: value));
  }

  void updateSearchKeyword(String keyword) {
    emit(state.copyWith(searchKeyword: keyword));
  }

  void clearFilter() {
    emit(const AssetFilterState());
  }
}
