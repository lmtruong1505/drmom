import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:BGP_Retail/core/base/base_cubit.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/utilities/loading.dart';
import 'package:BGP_Retail/core/widgets/toast/overlay_custom.dart';
import 'package:BGP_Retail/features/authentication/data/models/user_model.dart';
import 'package:BGP_Retail/features/cart/data/bloc/cart_cubit_v2.dart';
import 'package:BGP_Retail/features/profile/data/models/address_asbc_model.dart';
import 'package:BGP_Retail/features/profile/data/models/address_map_model.dart';
import 'package:BGP_Retail/features/profile/data/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:BGP_Retail/features/profile/data/repositories/address_repository.dart';

import 'address_state.dart';

@Injectable()
class AddressCubit extends BaseCubit<AddressState> {
  AddressCubit(this._addressRepository) : super(const AddressState());

  final AddressRepository _addressRepository;

  final formKey = GlobalKey<FormState>();

  UserModel get currentUser {
    return preferences.currentUser.user!;
  }

  final cartCubit = getIt.get<CartCubitV2>();

  List<double> onDetail(AddressModel address) {
    emit(state.copyWith(address: address));
    // if (address.address != null) {
    //   // getLatLngFromAddress(address.address['text']);
    // }
    // emit(state.copyWith(addressEdit: state.address));
    return (address.address != null && address.address.containsKey("locations"))
        ? address.address["locations"]!.cast<double>()
        : preferences.locations.isNotEmpty
            ? preferences.locations.map((e) => e as double).toList()
            : [20.937341, 106.314554];
  }

  bool get isChangeEdit {
    if (state.addressEdit == null || state.address == null) {
      return true;
    }

    final address = jsonEncode(state.address!.toJson());
    final addressEdit = jsonEncode(state.addressEdit!.toJson());

    return address != addressEdit;
  }

  void updateDefault(index) {
    int? newId;
    int? defaultId;
    if (state.addressList.isNotEmpty) {
      defaultId = state.addressList
          .firstWhere(
            (e) => e.isDefault == true,
            orElse: () => AddressModel(),
          )
          .id;
    }
    final List addressJson = state.addressList.map((e) => e.toJson()).toList();

    if (addressJson.isNotEmpty) {
      for (var i = 0; i < addressJson.length; i++) {
        addressJson[i]['is_default'] = i == index;
        if (i == index) {
          newId = addressJson[i]['id'];
        }
      }
    }
    emit(
      state.copyWith(
        addressList: addressJson.map((e) => AddressModel.fromJson(e)).toList(),
      ),
    );

    appCubit.setAddressList(
      addressJson.map((e) => AddressModel.fromJson(e)).toList(),
    );
    if (newId != defaultId) {
      // _addressRepository.updateStatusAddress(newId!.toString(), true);
      appCubit.setBooth([]);
    }
  }

  void onChangeFullname(String fullname) {
    Map<String, dynamic> addressJson;
    if (state.address == null) {
      addressJson = AddressModel(
        isDefault: false,
        locations: [],
        fullname: fullname,
        phoneNumber: '',
        address: null,
      ).toJson();
    } else {
      addressJson = state.address!.toJson();
      addressJson['fullname'] = fullname;
    }
    emit(state.copyWith(address: AddressModel.fromJson(addressJson)));
  }

  void onChangePhoneNumber(String phoneNumber) {
    Map<String, dynamic> addressJson;
    if (state.address == null) {
      addressJson = AddressModel(
        isDefault: false,
        locations: [],
        fullname: '',
        phoneNumber: phoneNumber,
        address: null,
      ).toJson();
    } else {
      addressJson = state.address!.toJson();
      addressJson['phone_number'] = phoneNumber;
    }
    emit(state.copyWith(address: AddressModel.fromJson(addressJson)));
  }

  void onSetAddressDefault(bool isDefault) {
    Map<String, dynamic> addressJson;
    if (state.address == null) {
      addressJson = AddressModel(
        isDefault: isDefault,
        locations: [],
        fullname: '',
        phoneNumber: '',
        address: null,
      ).toJson();
    } else {
      addressJson = state.address!.toJson();
      addressJson['is_default'] = isDefault;
    }
    emit(state.copyWith(address: AddressModel.fromJson(addressJson)));
  }

  void onSetAddress(Map<String, dynamic> addressJson) {
    Map<String, dynamic> newAddressJson = addressJson;
    if (state.address != null) {
      newAddressJson = state.address!.toJson();
      newAddressJson['address'] = addressJson['address'];
      // if (newAddressJson['text'] != null) {
      //   getLatLngFromAddress(newAddressJson['text']);
      // }
      newAddressJson['address']['locations'] =
          addressJson['address']['locations'];
    }
    final address = AddressModel.fromJson(newAddressJson);
    emit(state.copyWith(address: address));
  }

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
    if (address['text'] != null && address['locations'] == null) {
      getLatLngFromAddress(address['text']);
    }
  }

  AddressComponent? findLocation(List<AddressComponent> list, String key) {
    return list.firstWhere(
      (element) => element.types?.contains(key) == true,
      orElse: () => AddressComponent(),
    );
  }

  Future<AddressModel?> updateLatLong(List<double> latLng) async {
    try {
      // final List<Placemark> placemarks = await placemarkFromCoordinates(
      //   latLng[0],
      //   latLng[1],
      // );
      showLoading();
      Map<String, dynamic> addressJson;
      if (state.address?.address == null) {
        addressJson = AddressModel(
          isDefault: false,
          fullname: '',
          phoneNumber: '',
          address: {},
        ).toJson();
      } else {
        addressJson = state.address!.toJson();
        addressJson['fullname'] = '';
        addressJson['phone_number'] = '';
        addressJson['is_default'] = addressJson['is_default'] ?? false;
      }
      addressJson['address']['locations'] = latLng.toList();
      // addressJson['address'] = {
      //   'text': fullAddress,
      //   'ward': {'name': ward},
      //   'address': fullAddress,
      //   'district': {'name': district},
      //   'province': {'name': province},
      // };
      return AddressModel.fromJson(addressJson);
      // final latlng = "${latLng[0]},${latLng[1]}";
      // final res = await _addressRepository.getAddressFromLatLong(latlng);
      // EasyLoading.dismiss();
      // if (res.code == 200) {
      //   final googleAddress = res.data!.addressComponents;
      //   if (res.data!.addressComponents?.isNotEmpty == true) {
      //     final String ward =
      //         findLocation(googleAddress!, "route")?.longName ?? "";
      //     final String district =
      //         findLocation(googleAddress, "administrative_area_level_2")
      //                 ?.longName ??
      //             "";
      //     final province =
      //         findLocation(googleAddress, "administrative_area_level_1")
      //                 ?.longName ??
      //             "";
      //     final fullAddress = res.data?.formattedAddress;
      //     // final subAdministrativeArea = placemark.subAdministrativeArea ?? '';

      //     // final addressFinal = [
      //     //   address,
      //     //   city,
      //     //   subAdministrativeArea,
      //     //   administrativeArea,
      //     // ].where((e) => e.isNotEmpty).toList().join(", ");

      //     Map<String, dynamic> addressJson;
      //     if (state.address == null) {
      //       addressJson = AddressModel(
      //         isDefault: false,
      //         fullname: '',
      //         phoneNumber: '',
      //       ).toJson();
      //     } else {
      //       addressJson = state.address!.toJson();
      //       addressJson['fullname'] = '';
      //       addressJson['phone_number'] = '';
      //       addressJson['is_default'] = addressJson['is_default'] ?? false;
      //     }
      //     addressJson['address']['locations'] = latLng;
      //     // addressJson['address'] = {
      //     //   'text': fullAddress,
      //     //   'ward': {'name': ward},
      //     //   'address': fullAddress,
      //     //   'district': {'name': district},
      //     //   'province': {'name': province},
      //     // };
      //     return AddressModel.fromJson(addressJson);
      //   }
      //   // final Placemark placemark = placemarks.first;

      //   // final String address = placemark.street ?? '';
      //   // final String city = placemark.locality ?? '';
      //   // final administrativeArea = placemark.administrativeArea ?? '';
      //   // final subAdministrativeArea = placemark.subAdministrativeArea ?? '';

      //   // final Placemark placemark = placemarks.first;
      // }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
        EasyLoading.dismiss();
      }
    }
    return null;
  }

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
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

  // Future createAddress() async {
  //   if (!formKey.currentState!.validate()) return;
  //   try {
  //     if (state.isLoading == false) {
  //       setLoading(true);
  //       showLoading();
  //       final res = await _addressRepository.createAddress(
  //         state.address!.fullname,
  //         state.address!.phoneNumber,
  //         state.address!.isDefault ?? false,
  //         state.address!.address,
  //       );
  //       EasyLoading.dismiss();
  //       setLoading(false);

  //       res.fold(
  //         (l) {
  //           navigator.showErrorSnackBar(l["message"] ?? 'Có lỗi xảy ra!');
  //         },
  //         (r) {
  //           if (state.address!.isDefault == true) {
  //             appCubit.setBooth([]);
  //           }
  //           // cartCubit.getListAddress();
  //           showOverlayToast(title: "Thêm mới địa chỉ thành công");
  //           navigator.pop(result: true);
  //           // navigator.popUntilRoot(useRootNavigator: true);
  //           // navigator.pushAll([
  //           //   const ProfilePage(),
  //           //   const AddressManagerPage(),
  //           // ]);
  //           // navigator.showSuccessDialog(
  //           //   title: 'Thêm mới thành công',
  //           //   mainTitle: 'Chi tiết',
  //           //   extraTitle: 'Danh sách',
  //           //   content: 'Thêm mới địa chỉ thành công',
  //           //   hasButtonBack: true,
  //           //   accept: () {
  //           //     navigator.popUntilRoot(useRootNavigator: true);
  //           //     navigator.pushAll([
  //           //       const ProfilePage(),
  //           //       const AddressManagerPage(),
  //           //       DetailAddressPage(
  //           //         address: AddressModel.fromJson(r['data']),
  //           //       ),
  //           //     ]);
  //           //   },
  //           //   extraAccept: () {
  //           //     navigator.popUntilRoot(useRootNavigator: true);
  //           //     navigator.pushAll([
  //           //       const ProfilePage(),
  //           //       const AddressManagerPage(),
  //           //     ]);
  //           //   },
  //           // );
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //   }
  // }

  Future createASBCAddress() async {
    if (!formKey.currentState!.validate()) return;
    try {
      // setLoading(true);
      showLoading();
      final data = state.address;
      final res = await _addressRepository.createASBCAddress(
        fullname: data?.fullname,
        phoneNumber: data?.phoneNumber,
        isDefault: data?.isDefault ?? false,
        district: data?.address["district"]["id"],
        lat: data?.address?["locations"]?[0] ?? 0,
        long: data?.address?["locations"]?[1] ?? 0,
        province: data?.address["province"]["id"],
        title: data?.address["address"],
        ward: data?.address["ward"]["id"],
      );
      EasyLoading.dismiss();
      // setLoading(false);
      if (res.code == 200) {
        showOverlayToast(title: "Thêm mới địa chỉ thành công");
        // if (state.address!.isDefault == true) {
        //   appCubit.setBooth([]);
        // }
        navigator.pop(result: true);
      } else {
        showOverlayToast(
          title: res.message ?? "",
          status: ToastStatus.error,
        );
      }
    } catch (e) {
      showOverlayToast(
        title: e.toString(),
        status: ToastStatus.error,
      );
      EasyLoading.dismiss();
    }
  }

  Future updateASBCAddress(int id) async {
    if (!formKey.currentState!.validate()) return;
    try {
      // setLoading(true);
      showLoading();
      final data = state.address;
      final res = await _addressRepository.updateASBCAddress(
        fullname: data?.fullname,
        phoneNumber: data?.phoneNumber,
        district: data?.address["district"]["id"],
        lat: data?.address?["locations"]?[0] ?? 0,
        long: data?.address?["locations"]?[1] ?? 0,
        province: data?.address["province"]["id"],
        title: data?.address["address"],
        ward: data?.address["ward"]["id"],
        isDefault: state.address?.isDefault,
        id: id,
      );
      EasyLoading.dismiss();
      if (res.code == 200) {
        showOverlayToast(title: "Thêm mới địa chỉ thành công");

        navigator.pop(result: true);
      } else {
        showOverlayToast(
          title: res.message ?? "",
          status: ToastStatus.error,
        );
      }
    } catch (e) {
      showOverlayToast(
        title: e.toString(),
        status: ToastStatus.error,
      );
      EasyLoading.dismiss();
    }
  }

  // Future updateAddress() async {
  //   if (!formKey.currentState!.validate()) return;

  //   if (state.isLoading == false) {
  //     setLoading(true);
  //     showLoading();
  //     final res = await _addressRepository.updateAddress(
  //       state.address!.id.toString(),
  //       state.address!.fullname,
  //       state.address!.phoneNumber,
  //       state.address!.isDefault ?? false,
  //       state.address!.address,
  //     );
  //     EasyLoading.dismiss();
  //     setLoading(false);

  //     res.fold(
  //       (l) {
  //         navigator.showErrorSnackBar(l["message"] ?? 'Có lỗi xảy ra!');
  //       },
  //       (r) {
  //         cartCubit.getListAddress();
  //         final addressDefault = appCubit.state.addressList.firstWhere(
  //           (e) => e.isDefault == true,
  //           orElse: () => AddressModel(),
  //         );
  //         if (state.address!.isDefault == true &&
  //             addressDefault.id != state.address!.id) {
  //           appCubit.setBooth([]);
  //         }
  //         // navigator.popUntilRoot(useRootNavigator: true);
  //         // navigator.pushAll([
  //         //   const ProfilePage(),
  //         //   const AddressManagerPage(),
  //         // ]);
  //         showOverlayToast(title: "Cập nhật địa chỉ thành công");
  //         navigator.pop(result: true);
  //       },
  //     );
  //   }
  // }

  // Future deleteAddress() async {
  //   if (!formKey.currentState!.validate()) return;
  //   try {
  //     if (state.isLoading == false) {
  //       setLoading(true);
  //       showLoading();
  //       final res = await _addressRepository.deleteAddress(
  //         state.address!.id.toString(),
  //       );
  //       EasyLoading.dismiss();
  //       setLoading(false);

  //       res.fold(
  //         (l) {
  //           navigator.showErrorSnackBar(l["message"] ?? 'Có lỗi xảy ra!');
  //           setLoading(false);
  //         },
  //         (r) {
  //           // cartCubit.getListAddress();
  //           // navigator.popUntilRoot(useRootNavigator: true);
  //           // navigator.pushAll([
  //           //   const ProfilePage(),
  //           //   const AddressManagerPage(),
  //           // ]);
  //           navigator.pop(result: true);
  //           showOverlayToast(title: 'Xóa địa chỉ thành công');
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     setLoading(false);
  //   }
  // }

  // Future getListAddress() async {
  //   emit(state.copyWith(isLoading: true));
  //   final res = await _addressRepository.getListAddress();
  //   emit(state.copyWith(isLoading: false));

  //   res.fold((l) => {}, (r) {
  //     emit(
  //       state.copyWith(
  //         addressList: (r['data'] as List<dynamic>)
  //             .map((e) => AddressModel.fromJson(e))
  //             .toList(),
  //       ),
  //     );
  //     cartCubit.getListAddress();

  //     appCubit.setAddressList(
  //       (r['data'] as List<dynamic>)
  //           .map(
  //             (e) => AddressModel.fromJson(e),
  //           )
  //           .toList(),
  //     );
  //   });
  // }

  Future getASBCListAddress() async {
    emit(state.copyWith(isLoading: true));
    final res = await _addressRepository.getASBCListAddress();
    emit(state.copyWith(isLoading: false));
    if (res.code == 200) {
      emit(state.copyWith(addressAsbcList: res.data!));
    }

    // cartCubit.getListAddress();

    // appCubit.setAddressList(res.data);
  }

  void initAddress(AsbcAddressModel? address) {
    final Map<String, dynamic> addressJson = {
      "text": address?.addressData?.addressFull,
      'ward': {
        'id': address?.addressData?.ward?.id,
        'title': address?.addressData?.ward?.title,
        'code': address?.addressData?.ward?.code,
      },
      'district': {
        'id': address?.addressData?.district?.id,
        'title': address?.addressData?.district?.title,
        'code': address?.addressData?.district?.code,
      },
      'province': {
        'id': address?.addressData?.province?.id,
        'title': address?.addressData?.province?.title,
      },
      'locations': [address?.addressData?.lat, address?.addressData?.long],
    };

    emit(
      state.copyWith(
        address: AddressModel(
          fullname: address?.fullname,
          phoneNumber: address?.phone,
          address: addressJson,
          isDefault: address?.isDefault,
        ),
      ),
    );
  }
}
