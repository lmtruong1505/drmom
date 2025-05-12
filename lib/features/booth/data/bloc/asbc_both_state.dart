import 'package:BGP_Retail/features/booth/data/models/healthy_care_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/core/widgets/buttons/filter_button.dart';
import 'package:BGP_Retail/features/booth/data/models/asbc_both_model.dart';
import 'package:BGP_Retail/features/profile/data/models/address_asbc_model.dart';

part 'asbc_both_state.freezed.dart';

@freezed
class AsbcBothState with _$AsbcBothState {
  const factory AsbcBothState({
    @Default(false) bool isLoading,
    @Default([]) List<HealthCareModel>? listBoths,
    @Default([]) List<AsbcAddressModel>? listAddress,
    @Default(null) AsbcAddressModel? addressSelected,
    @Default(null) FilterButtonModel? filter,
  }) = _AsbcBothState;
}
