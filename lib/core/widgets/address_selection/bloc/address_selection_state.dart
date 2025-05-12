import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_selection_state.freezed.dart';

@freezed
class AddressSelectionState with _$AddressSelectionState {
  const factory AddressSelectionState({
    @Default(1) int step,
    @Default(null) String? text,
    @Default(null) dynamic ward,
    @Default(null) String? address,
    @Default(null) dynamic district,
    @Default(null) dynamic province,
    @Default([]) List<dynamic> provinces,
    @Default([]) List<dynamic> provincesClone,
    @Default([]) List<dynamic> districts,
    @Default([]) List<dynamic> districtsClone,
    @Default([]) List<dynamic> wards,
    @Default([]) List<dynamic> wardsClone,
    @Default(false) bool isLoading,
    @Default('') String keyword,
  }) = _AddressSelectionState;
}
