import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/utilities/loading.dart';
import 'package:BGP_Retail/core/widgets/toast/overlay_custom.dart';
import 'package:BGP_Retail/features/profile/data/bloc/register_store_state.dart';
import 'package:BGP_Retail/features/profile/data/models/address_model.dart';
import 'package:BGP_Retail/features/profile/data/repositories/address_repository.dart';

@Injectable()
class RegisterStoreCubit extends Cubit<RegisterStoreState> {
  RegisterStoreCubit(this._addressRepository)
      : super(const RegisterStoreState());

  final AddressRepository _addressRepository;
  final navigator = getIt.get<AppNavigator>();

  void onChangeAddress(Map<String, dynamic> address) {
    Map<String, dynamic> addressJson;
    if (state.address == null) {
      addressJson = AddressModel(
        isDefault: false,
        locations: [],
        fullname: '',
        phoneNumber: '',
      ).toJson();
      addressJson['address'] = address;
    } else {
      addressJson = state.address!.toJson();
      addressJson['address'] = address;
    }
    emit(state.copyWith(address: AddressModel.fromJson(addressJson)));
    if (address['text'] != null) {
      getLatLngFromAddress(address['text']);
    }
  }

  Future<void> getLatLngFromAddress(String address) async {
    final addressJson = state.address!.toJson();
    addressJson["address"]['locations'] = [0.0, 0.0];
    emit(state.copyWith(isLoadingAddress: true));

    try {
      final List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        addressJson["address"]['locations'] = [
          locations.first.latitude,
          locations.first.longitude,
        ];
        emit(
          state.copyWith(
            address: AddressModel.fromJson(addressJson),
            isLoadingAddress: false,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      emit(state.copyWith(isLoadingAddress: false));
    }
  }

  Future createGroceryAddress({
    required String? manager,
    required String? phone,
    required String? title,
    required String? tax,
  }) async {
    try {
      if (state.isLoading == false) {
        showLoading();
        final address = state.address?.address;
        final res = await _addressRepository.createGroceryAddress(
          province: address?["province"]["id"],
          district: address?["district"]["id"],
          ward: address?["ward"]["id"],
          address: address?["address"],
          lat: address?["locations"]?[0] ?? 0,
          long: address?["locations"]?[1] ?? 0,
          manager: manager,
          phone: phone,
          title: title,
          tax: tax,
        );
        EasyLoading.dismiss();
        if (res.code == 200) {
          showOverlayToast(title: "Thêm mới địa chỉ thành công");
          navigator.back(result: true);
        } else {
          showOverlayToast(title: "Đã có lỗi xảy ra", iconColor: AppColors.red);
        }
      }
    } catch (e) {
      showOverlayToast(title: "Đã có lỗi xảy ra");
      EasyLoading.dismiss();
    }
  }
}
