import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/features/profile/data/models/address_model.dart';
part 'register_store_state.freezed.dart';

@freezed
class RegisterStoreState with _$RegisterStoreState {
  const factory RegisterStoreState({
    @Default([]) List<AddressModel> addressList,
    @Default(null) AddressModel? address,
    @Default(null) AddressModel? addressEdit,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingAddress,
  }) = _RegisterStoreState;
}
