import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/app/data/bloc/app_cubit.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/utilities/loading.dart';
import 'package:bpg_retail/core/widgets/buttons/filter_button.dart';
import 'package:bpg_retail/core/widgets/identity_card_widget.dart';
import 'package:bpg_retail/features/authentication/data/models/user_model.dart';
import 'package:bpg_retail/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';

@Injectable()
class UserProfileCubit extends Cubit<CubitState> {
  UserProfileCubit(this._repo) : super(CubitState());

  final AuthenticationRepository _repo;

  bool isEdit = false;
  bool isUpdate = false;
  AddressModel? userAddress;
  String? backUrl;
  String? frontUrl;
  String? avatar;
  final formKey = GlobalKey<FormState>();

  final preferences = getIt.get<Preferences>();
  final navigator = getIt.get<AppNavigator>();

  List<FilterButtonModel> genders = [
    const FilterButtonModel(title: "Nam", value: 1),
    const FilterButtonModel(title: "Nữ", value: 2),
    const FilterButtonModel(title: "Khác", value: 3),
  ];

  UserModel get userData {
    return preferences.getUserData;
  }

  // UserModel get currentUser {
  //   return preferences.currentUser.user ?? UserModel();
  // }

  void onChangeAddress(Map<String, dynamic> address) {
    emit(state.copyWith(status: CubitStatus.loading));
    Map<String, dynamic> addressJson;
    if (userAddress == null) {
      addressJson =
          AddressModel(
            isDefault: false,
            locations: [],
            fullname: '',
            phoneNumber: '',
          ).toJson();
      addressJson['address'] = address;
    } else {
      addressJson = userAddress!.toJson();
      addressJson['address'] = address;
    }
    userAddress = AddressModel.fromJson(addressJson);
    emit(state.copyWith(status: CubitStatus.loaded));
    if (address['text'] != null && address['locations'] == null) {
      getLatLngFromAddress(address['text']);
    }
  }

  Future<void> getLatLngFromAddress(String address) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final addressJson = userAddress!.toJson();
    addressJson["address"]['locations'] = [0.0, 0.0];

    try {
      final List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        addressJson["address"]['locations'] = [
          locations.first.latitude,
          locations.first.longitude,
        ];
        userAddress = AddressModel.fromJson(addressJson);
        emit(state.copyWith(status: CubitStatus.loaded));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void onAsbcUpdate({
    String? name,
    String? birthday,
    int? gender,
    String? identified,
    String? dateProvided,
    String? placeProvided,
    String? email,
  }) async {
    if (!formKey.currentState!.validate()) return;

    if (state.status != CubitStatus.loading) {
      try {
        showLoading();

        final address = userAddress?.address;

        final data = {
          "full_name": name,
          'email': email,
          "birthday": birthday,
          "gender": gender,
          "identified": identified,
          "date_provided": dateProvided,
          "place_provided": placeProvided,
          "address": {
            "province": address["province"]["id"],
            "district": address["province"]["id"],
            "ward": address["ward"]["id"],
            "title": address["address"],
            "lat": address["locations"][0],
            "long": address["locations"][1],
          },
        };
        data.removeWhere((key, value) => value == "");
        final FormData formData = FormData.fromMap(data);
        if (avatar != null) {
          final image = await MultipartFile.fromFile(avatar ?? "");
          formData.files.add(MapEntry("avatar", image));
        }

        if (frontUrl != null) {
          final image = await MultipartFile.fromFile(frontUrl ?? "");
          formData.files.add(MapEntry("image_front", image));
        }

        if (backUrl != null) {
          final image = await MultipartFile.fromFile(backUrl ?? "");
          formData.files.add(MapEntry("image_back", image));
        }
        final id = preferences.currentUser.id ?? 0;

        final res = await _repo.onAsbcUpdate(formData, id);
        EasyLoading.dismiss();
        if (res.code == 200) {
          navigator.showSuccessSnackBar(
            'Cập nhật thành công',
            duration: const Duration(seconds: 1),
          );
          // _repo.getUserData(id);

          preferences.saveUserData(jsonEncode(res.data?.toJson()));
          isEdit = false;
          isUpdate = true;
          emit(state.copyWith(status: CubitStatus.loaded));
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        EasyLoading.dismiss();
      }
    }
  }

  final appCubit = getIt.get<AppCubit>();

  Future<void> pickImageIdentity(
    ImageIdentityTypeEnum type,
    String? image,
  ) async {
    // emit(state.copyWith(status: CubitStatus.loading));
    if (image != null) {
      setUrl(type, null);
      setUrl(type, image);
    }
    emit(state.copyWith(status: CubitStatus.loaded));
  }

  void setUrl(ImageIdentityTypeEnum type, String? url) {
    // emit(state.copyWith(status: CubitStatus.loading));
    if (type == ImageIdentityTypeEnum.front) {
      frontUrl = url;
    } else if (type == ImageIdentityTypeEnum.back) {
      backUrl = url;
    } else {
      avatar = url;
    }
    emit(state.copyWith(status: CubitStatus.loaded));
  }

  void onChangeEdit(bool edit) {
    emit(state.copyWith(status: CubitStatus.loading));
    isEdit = edit;
    emit(state.copyWith(status: CubitStatus.loaded));
  }

  void confirmDeactive() async {
    navigator.back();
    final id = preferences.currentUser.id ?? 0;
    final res = await _repo.deactive(id);
    if (res.code == 200) {
      emit(state.copyWith(status: CubitStatus.sendSuccess));
    } else {
      emit(state.copyWith(status: CubitStatus.sendFaild));
    }
  }

  void showConfirmDisableAccount() {
    emit(state.copyWith(status: CubitStatus.success));
  }

  void updateGender() {
    emit(state.copyWith(status: CubitStatus.loaded));
  }
}
