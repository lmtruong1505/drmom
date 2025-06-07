import 'package:bpg_retail/features/profile/data/models/address_asbc_model.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_state.freezed.dart';

@freezed
class AddressState with _$AddressState {
  const factory AddressState({
    @Default([]) List<AddressModel> addressList,
    @Default([]) List<AsbcAddressModel> addressAsbcList,
    @Default(null) AddressModel? address,
    @Default(null) AddressModel? addressEdit,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingAddress,
  }) = _AddressState;
}
