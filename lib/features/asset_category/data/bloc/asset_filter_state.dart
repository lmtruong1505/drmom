import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_filter_state.freezed.dart';

@freezed
abstract class AssetFilterState with _$AssetFilterState {
  const factory AssetFilterState({
    @Default(null) String? selectedDepartment,
    @Default('Tất cả') String selectedStatus,
    @Default(null) String? selectedDeviceType,
    @Default('') String searchKeyword,
  }) = _AssetFilterState;
}
