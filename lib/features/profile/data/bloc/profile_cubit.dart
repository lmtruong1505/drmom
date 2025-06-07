import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/base/base_cubit.dart';
import 'package:bpg_retail/core/utilities/assets.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/utilities/loading.dart';
import 'package:bpg_retail/core/widgets/buttons/filter_button.dart';
import 'package:bpg_retail/core/widgets/identity_card_widget.dart';
import 'package:bpg_retail/features/authentication/data/models/profile_model.dart';
import 'package:bpg_retail/features/authentication/data/models/user_model.dart';
import 'package:bpg_retail/features/authentication/data/models/user_model_v2.dart';
import 'package:bpg_retail/features/authentication/data/repositories/authentication_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';

import 'profile_state.dart';

@Injectable()
class ProfileCubit extends BaseCubit<ProfileState> {
  ProfileCubit(this._authenticationRepository) : super(const ProfileState());

  final AuthenticationRepository _authenticationRepository;

  final formKey = GlobalKey<FormState>();
  Timer? _timer;
  int countTime = 120;

  String? backUrl;
  String? frontUrl;
  String? image;

  // UserModel get currentUser {
  //   return preferences.currentUser.user ?? UserModel();
  // }

  UserModelV2 get userData {
    return preferences.getUserData;
  }

  // ProfileModel? get avatar {
  //   return currentUser.profiles?.firstWhere(
  //     (e) => e.field == 'avatar',
  //     orElse: () => ProfileModel(),
  //   );
  // }

  List<FilterButtonModel> genders = [
    const FilterButtonModel(title: "Nam", value: 1),
    const FilterButtonModel(title: "Nữ", value: 2),
    const FilterButtonModel(title: "Khác", value: 3)
  ];

  @override
  void initState() {
    EasyLoading.dismiss();
    // emit(
    //   state.copyWith(
    //     userEdit: currentUser,
    //   ),
    // );

    super.initState();
  }

  void mounted(bool isEdit) {
    emit(state.copyWith(isEdit: isEdit));
  }

  void handleBack() {
    if (state.isEdit) {
      onCancelEdit();
    } else {
      navigator.back();
    }
  }

  void setTab(int val) {
    emit(
      state.copyWith(
        tabIndex: val,
      ),
    );
  }

  void onChangeEdit() {
    // emit(state.copyWith(userEdit: currentUser, image: null));
    emit(state.copyWith(isEdit: true));
  }

  void onCancelEdit() {
    // emit(state.copyWith(userEdit: currentUser));
    emit(state.copyWith(isEdit: false));
  }

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void onChangeProfile(String field, dynamic value) {
    final Map<String, dynamic> userJson = state.userEdit?.toJson() ?? {};

    if (userJson.containsKey(field)) {
      userJson[field] = value;
    }

    if (userJson['profiles'] != null && userJson['profiles'] is List) {
      final profileList = userJson['profiles'].map((e) => e.toJson()).toList();
      for (var i = 0; i < profileList.length; i++) {
        if (profileList[i]['field'] == field) {
          profileList[i]['value'] = value;
        }
      }
      userJson['profiles'] = profileList;
    }

    // emit(state.copyWith(userEdit: UserModel.fromJson(userJson)));
  }

  // void onSaveEdit() async {
  //   if (!formKey.currentState!.validate()) return;

  //   if (state.isLoading == false) {
  //     final currentUserJson = preferences.currentUser.toJson();

  //     final Map<String, dynamic> userJson = state.userEdit?.toJson() ?? {};

  //     if (userJson['profiles'] != null && userJson['profiles'] is List) {
  //       final profileList = userJson['profiles'].map((e) {
  //         return ProfileModel.fromJson(e!.toJson());
  //       }).toList();
  //       userJson['profiles'] = profileList;
  //     }

  //     try {
  //       setLoading(true);
  //       showLoading();
  //       final newUserJson = {...userJson};
  //       newUserJson['profiles'] = jsonEncode(newUserJson['profiles']);
  //       // newUserJson.removeWhere((key, value) => value == "" || value == null);
  //       final FormData formData = FormData.fromMap(newUserJson);

  //       if (state.image != null) {
  //         final MultipartFile image = await MultipartFile.fromFile(
  //           state.image!.path,
  //         );
  //         formData.files.add(MapEntry("image", image));
  //       }

  //       setLoading(true);
  //       EasyLoading.dismiss();
  //       final res = await _authenticationRepository.updateProfile(
  //         state.userEdit!.id!,
  //         formData,
  //       );
  //       EasyLoading.dismiss();
  //       setLoading(false);
  //       res.fold(
  //         (l) {
  //           navigator.showErrorSnackBar(
  //             l["message"] ?? 'Có lỗi xảy ra!',
  //             duration: const Duration(seconds: 1),
  //           );
  //         },
  //         (r) {
  //           final profiles = r['data']['profiles'];
  //           navigator.showSuccessSnackBar(
  //             'Cập nhật thành công',
  //             duration: const Duration(seconds: 1),
  //           );
  //           emit(state.copyWith(isEdit: false));
  //           userJson["profiles"] = profiles;
  //           currentUserJson["user"] = userJson;
  //           preferences.saveCurrentUser(jsonEncode(currentUserJson));
  //           if (profiles != null && profiles is List) {
  //             String? avatar;
  //             for (var i = 0; i < profiles.length; i++) {
  //               if (profiles[i]['field'] == 'avatar') {
  //                 avatar = profiles[i]['value'];
  //               }
  //             }
  //             if (avatar != null) {
  //               appCubit.onChangeAvatar(avatar);
  //             }
  //           }
  //         },
  //       );
  //     } catch (e) {
  //       EasyLoading.dismiss();
  //       setLoading(false);
  //     }
  //   }
  // }

  void startTimer() {
    emit(state.copyWith(countTime: countTime));
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (state.countTime == 0) {
          _timer!.cancel();
        } else {
          int time = state.countTime;
          time--;
          emit(state.copyWith(countTime: time));
        }
      },
    );
  }

  void onChangeOTP(String otp) {
    emit(state.copyWith(otp: otp));
  }

  void setStep(int step) {
    emit(state.copyWith(step: step, isDisable: false));
    onClose();
  }

  void setDisable(bool isDisable) {
    emit(state.copyWith(isDisable: isDisable));
  }

  // Future<void> sendOTPChangePhone({bool? isResent = false}) async {
  //   if (isResent == false && !formKey.currentState!.validate()) return;

  //   if (state.isLoading == false) {
  //     try {
  //       setLoading(true);
  //       showLoading();
  //       final res = await _authenticationRepository.sendOTPSubject(
  //         false,
  //         state.userEdit?.email,
  //         "Bạn có một yêu cầu thay đổi số điện thoại",
  //         "Đây là mã OTP xác nhận việc thay đổi số điện thoại của bạn",
  //         state.userEdit?.phoneNumber,
  //         state.userEdit?.id,
  //         0,
  //       );
  //       EasyLoading.dismiss();
  //       setLoading(false);

  //       emit(state.copyWith(otp: ''));

  //       res.fold(
  //         (l) {
  //           navigator.showAppTopSnackBar(
  //             l["message"] ?? 'Có lỗi xảy ra!',
  //             type: 'error',
  //           );
  //         },
  //         (r) {
  //           onChangeOTP('');
  //           int sendOtpCount = state.sendOtpCount;
  //           sendOtpCount++;
  //           emit(state.copyWith(sendOtpCount: sendOtpCount));

  //           startTimer();
  //           if (state.countTime < 1) {
  //             emit(state.copyWith(countTime: 0));
  //           }
  //           emit(state.copyWith(step: 2, isDisable: true));
  //         },
  //       );
  //     } catch (e) {
  //       EasyLoading.dismiss();
  //       setLoading(false);
  //     }
  //   }
  // }

  // Future<void> updatePhoneNumber() async {
  //   if (state.isLoading == false) {
  //     try {
  //       setLoading(true);
  //       showLoading();
  //       final res = await _authenticationRepository.updatePhoneNumber(
  //         state.otp,
  //         state.userEdit?.phoneNumber ?? "",
  //         state.userEdit?.id ?? 0,
  //       );
  //       EasyLoading.dismiss();
  //       setLoading(false);
  //       res.fold(
  //         (l) {
  //           navigator.showAppTopSnackBar(
  //             l["message"] ?? 'Có lỗi xảy ra!',
  //             type: 'error',
  //           );
  //         },
  //         (r) async {
  //           onClose();
  //           final currentUserJson = preferences.currentUser.toJson();
  //           currentUserJson["user"] = state.userEdit!.toJson();
  //           await preferences.saveCurrentUser(jsonEncode(currentUserJson));
  //           navigator.showSuccessDialog(
  //             title: 'Thay đổi thành công',
  //             mainTitle: 'Đóng',
  //             content: 'Số điện thoại đã được thay đổi thành công',
  //             hasButtonBack: false,
  //             accept: () {
  //               navigator.popUntilRoot(useRootNavigator: true);
  //               navigator.pushAll([
  //                 const ProfilePage(),
  //                 ProfileInfoPage(isEdit: true),
  //               ]);
  //             },
  //           );
  //         },
  //       );
  //     } catch (e) {
  //       EasyLoading.dismiss();
  //       setLoading(false);
  //     }
  //   }
  // }

  Future pickImage() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        // allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        final File imageTemporary = File(result.files.single.path!);
        emit(state.copyWith(image: imageTemporary));
      }
    } catch (e) {}
  }

  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void onShowPassword() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void onShowOldPassword() {
    emit(state.copyWith(showOldPassword: !state.showOldPassword));
  }

  void onShowConfirmPassword() {
    emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
  }

  void onChangePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void onChangeOldPassword(String oldPassword) {
    emit(state.copyWith(oldPassword: oldPassword));
  }

  void onChangeConfirmPassword(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  String? validateConfirmPassword() {
    if (state.password.isNotEmpty && state.password == state.oldPassword) {
      return "Mật khẩu mới phải khác mật khẩu cũ";
    }
    if (state.confirmPassword.isEmpty || state.password.isEmpty) {
      return null;
    }
    if (state.confirmPassword != state.password) {
      return "Mật khẩu không khớp";
    }
    return null;
  }

  void updatePassword() async {
    if (!formKey.currentState!.validate()) return;

    if (state.isLoading == false) {
      try {
        setLoading(true);
        showLoading();
        final res = await _authenticationRepository.changePassword(
          state.oldPassword,
          state.password,
        );
        EasyLoading.dismiss();
        setLoading(false);
        res.fold(
          (l) {
            navigator.showErrorSnackBar(l["message"] ?? 'Có lỗi xảy ra!');
          },
          (r) async {
            navigator.showSuccessDialog(
              title: 'Thay đổi thành công',
              mainTitle: 'Đóng',
              content: 'Thay đổi mật khẩu thành công',
              hasButtonBack: false,
              accept: () {
                navigator.popUntilRoot(useRootNavigator: true);
                navigator.push(const ProfilePage());
              },
            );
          },
        );
      } catch (e) {
        EasyLoading.dismiss();
        setLoading(false);
      }
    }
  }

  void onDisabledAccount() {
    navigator.showSuccessDialog(
      title: 'Thông báo',
      mainTitle: 'Xác nhận',
      extraTitle: 'Hủy',
      content: 'Bạn xác nhận vô hiệu hóa tài khoản này',
      hasButtonBack: true,
      icon: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Assets.icon(assetName: 'ic_warning.svg'),
      ),
      accept: () async {
        navigator.back();
        final res = await _authenticationRepository.deactive(1);
        if (res.code == 200) {
          try {
            showLoading();
            navigator.showSuccessSnackBar(
              'Vô hiệu hóa tài khoản thành công',
              duration: const Duration(seconds: 3),
            );

            // getIt.get<CartCubitV2>().clearCartCubit();
            // appCubit.onForceLogout(isMessage: false);
            EasyLoading.dismiss();
            navigator.replaceAll([const RootRoute()]);
          } catch (e) {
            EasyLoading.dismiss();
          }
        } else {
          navigator.showErrorSnackBar(
            res.message ?? "Đã có lỗi xảy ra",
            duration: const Duration(seconds: 2),
          );
        }
      },
      extraAccept: () {
        navigator.back();
      },
    );
  }

  void checkOpenShop() async {
    try {
      emit(state.copyWith(isLoading: true));
      final res = await _authenticationRepository.checkOpenShop();
      if (res.data != null) {
        emit(state.copyWith(company: res.data, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> pickImageIdentity(
    ImageIdentityTypeEnum type,
    String? image,
  ) async {
    emit(state.copyWith(isLoading: true));
    if (image != null) {
      setUrl(type, null);
      setUrl(type, image);
      emit(state.copyWith(isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void setUrl(ImageIdentityTypeEnum type, String? url) {
    emit(state.copyWith(isLoading: true));
    if (type == ImageIdentityTypeEnum.front) {
      frontUrl = url;
    } else if (type == ImageIdentityTypeEnum.back) {
      backUrl = url;
    } else {
      image = url;
    }
    emit(state.copyWith(isLoading: false));
  }

  // void onAsbcUpdate({
  //   String? name,
  //   String? birthday,
  //   int? gender,
  //   String? identified,
  //   String? dateProvided,
  //   String? placeProvided,
  // }) async {
  //   if (!formKey.currentState!.validate()) return;

  //   if (state.isLoading == false) {
  //     try {
  //       showLoading();

  //       final address = state.address?.address;

  //       final data = {
  //         "full_name": name,
  //         "birthday": birthday,
  //         "gender": gender,
  //         "identified": identified,
  //         "date_provided": dateProvided,
  //         "place_provided": placeProvided,
  //         "address": {
  //           "province": address["province"]["id"],
  //           "district": address["province"]["id"],
  //           "ward": address["ward"]["id"],
  //           "title": address["address"],
  //           "lat": address["locations"][0],
  //           "long": address["locations"][1],
  //         },
  //       };
  //       data.removeWhere((key, value) => value == "");
  //       final FormData formData = FormData.fromMap(data);

  //       if (frontUrl != null) {
  //         final image = await MultipartFile.fromFile(frontUrl ?? "");
  //         formData.files.add(MapEntry("image_front", image));
  //       }

  //       if (backUrl != null) {
  //         final image = await MultipartFile.fromFile(backUrl ?? "");
  //         formData.files.add(MapEntry("image_back", image));
  //       }
  //       final id = preferences.currentUser.user?.id ?? 0;

  //       final res = await _authenticationRepository.onAsbcUpdate(formData, id);
  //       EasyLoading.dismiss();
  //       if (res.code == 200) {
  //         navigator.showSuccessSnackBar(
  //           'Cập nhật thành công',
  //           duration: const Duration(seconds: 1),
  //         );
  //         preferences.saveUserData(jsonEncode(res.data));
  //         emit(state.copyWith(isEdit: false));
  //       }
  //     } catch (e) {
  //       print(e);
  //       EasyLoading.dismiss();
  //     }
  //   }
  // }

  void onChangeAddress(Map<String, dynamic> address) {
    emit(state.copyWith(isLoading: true));
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

    emit(
      state.copyWith(
        address: AddressModel.fromJson(addressJson),
        isLoading: false,
      ),
    );
    if (address['text'] != null && address['locations'] == null) {
      getLatLngFromAddress(address['text']);
    }
  }

  Future<void> getLatLngFromAddress(String address) async {
    emit(state.copyWith(isLoading: true));
    final addressJson = state.address!.toJson();
    addressJson["address"]['locations'] = [0.0, 0.0];

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
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      emit(state.copyWith(isLoading: false));
    }
  }

  void onRefesh() {
    emit(state.copyWith(status: CubitStatus.loading));
    emit(state.copyWith(status: CubitStatus.update));
  }
}
