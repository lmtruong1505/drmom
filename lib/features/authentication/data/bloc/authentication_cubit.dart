import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:BGP_Retail/app/data/bloc/app_cubit.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/base/base_cubit.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/preferences/preferences.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/utilities/loading.dart';
import 'package:BGP_Retail/core/widgets/toast/overlay_custom.dart';
import 'package:BGP_Retail/features/authentication/data/models/remember_account.dart';
import 'package:BGP_Retail/features/authentication/data/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/features/wallet/data/cubits/wallet_cubit.dart';

import 'authentication_state.dart';

@Injectable()
class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(this._authenticationRepository)
      : super(const AuthenticationState()) {
    if (preferences.rememberAccount != null) {
      onChangePhoneNumber(preferences.rememberAccount!.phoneNumber!);
      onChangePassword(preferences.rememberAccount!.password!);
    }
    onRememberAccount(preferences.rememberAccount != null);
  }

  final AuthenticationRepository _authenticationRepository;
  final navigator = getIt.get<AppNavigator>();
  final preferences = getIt.get<Preferences>();
  final appCubit = getIt.get<AppCubit>();
  final formKey = GlobalKey<FormState>();
  Timer? _timer;
  int countTime = 120;

  // @override
  // void initState() {
  //   if (preferences.rememberAccount != null) {
  //     onChangePhoneNumber(preferences.rememberAccount!.phoneNumber!);
  //     onChangePassword(preferences.rememberAccount!.password!);
  //   }
  //   onRememberAccount(preferences.rememberAccount != null);

  //   super.initState();
  // }

  void onChangeEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void onChangeUserRefferalCode(String code) {
    emit(state.copyWith(userReferralCode: code, message: null));
    verifyReferralCode();
  }

  void onChangeTypeOTP(ForgotPasswordType type) {
    emit(state.copyWith(type: type));
  }

  void checkHasAGift(bool? hasAGift) {
    emit(state.copyWith(toPromotionScreen: hasAGift ?? false));
  }

  void onChangeFullname(String fullname) {
    emit(state.copyWith(fullname: fullname));
  }

  // void onChangeReferralCode(String? code) {
  //   // emit(state.copyWith(referralCode: code));
  // }

  void onChangePhoneNumber(String phoneNumber) {
    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  void onChangePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void onChangeConfirmPassword(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  void onShowPassword() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void onShowConfirmPassword() {
    emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
  }

  void onChangeOTP(String otp) {
    emit(state.copyWith(otp: otp));
  }

  void onRemember() {
    emit(state.copyWith(isRemember: !state.isRemember));
  }

  void onRememberAccount(bool isRemember) {
    emit(state.copyWith(isRemember: isRemember));
  }

  String? validateConfirmPassword() {
    if (state.confirmPassword.isEmpty || state.password.isEmpty) {
      return null;
    }
    if (state.confirmPassword != state.password) {
      return "Mật khẩu không khớp";
    }
    return null;
  }

  void clearFormRegister() {
    emit(
      state.copyWith(
        phoneNumber: '',
        password: '',
        confirmPassword: '',
        email: '',
        fullname: '',
        otp: '',
        showPassword: false,
        showConfirmPassword: false,
      ),
    );
  }

  List mapProfile(List? profiles) {
    profiles = profiles ?? [];
    final List defaultProfiles = [
      {
        "field": "sex",
        "value": "",
      },
      {
        "field": "date_of_birth",
        "value": "",
      },
    ];

    for (final defaultProfile in defaultProfiles) {
      final bool isProfileExist = profiles.any(
        (profile) => profile["field"] == defaultProfile["field"],
      );

      if (!isProfileExist) {
        profiles.add(defaultProfile);
      }
    }

    return profiles;
  }

  FutureOr onLoginAsbc(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (state.isRemember) {
      preferences.saveRememberAccount(
        RememberAccount(
          phoneNumber: state.phoneNumber,
          password: state.password,
        ),
      );
    } else {
      preferences.removeRememberAccount();
    }

    try {
      showLoading();
      final res = await _authenticationRepository.login(
        state.phoneNumber,
        state.password,
      );
      EasyLoading.dismiss();
      if (res.code == 200) {
        navigator.showSuccessSnackBar(
          'Đăng nhập thành công',
          duration: const Duration(seconds: 2),
        );

        final user = res.data['data']['user'];

        final loginData = {
          'phone_number': user['phone_number'],
          'access_token': res.data['data']['access_token'],
          'user': {
            'id': user['id'],
            // 'point': user['reward_points'],
            'phone_number': user['phone_number'],
            'fullname': user['full_name'],
            'account_code': user['referral_code'],
            // 'system_data': user['system_data'],
          },
        };
        preferences.saveAccessToken(res.data['data']['access_token'] ?? '');
        preferences.saveCurrentUser(jsonEncode(loginData));
        getUserData(user['id']);
        appCubit.onAppInitialized();
      } else {
        navigator.showAppTopSnackBar(
          res.message ?? "Tài khoản hoặc mật khẩu không chính xác",
          type: 'error',
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  FutureOr onRegisterAsbc() async {
    if (!formKey.currentState!.validate()) return;
    try {
      showLoading();
      final res = await _authenticationRepository.register(
        fullName: state.fullname,
        password: state.password,
        phoneNumber: state.phoneNumber,
        referralCode: state.userReferralCode,
      );
      EasyLoading.dismiss();
      if (res.code == 200) {
        navigator.showSuccessDialog(
          title: 'Đăng ký thành công',
          mainTitle: 'Đến màn OTP',
          content:
              'Chào mừng bạn đến với chúng tôi. Nhập mã OTP để xác nhận tài khoản.',
          hasButtonBack: false,
          accept: () {
            emit(state.copyWith(countTime: 0));
            navigator.pop();
            navigator.push(
              VerifyOtpPage(
                fullName: state.fullname,
                phoneNumber: state.phoneNumber,
                password: state.password,
                referralCode: state.userReferralCode ?? '',
              ),
            );
          },
        );
      } else {
        navigator.showAppTopSnackBar(
          res.message ?? 'Có lỗi xảy ra!',
          type: 'error',
        );
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  // void onVerification() {
  //   if (!formKey.currentState!.validate()) return;

  //   navigator.push(
  //     OtpVerificationPage(
  //       email: state.email,
  //       password: state.password,
  //       fullname: state.fullname,
  //       phoneNumber: state.phoneNumber,
  //       referralCode: state.referralCode?.accountCode,
  //       userReferralCode: state.userReferralCode,
  //     ),
  //   );
  // }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
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

  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  Future<void> sendOTP() async {
    if (state.countTime < 1) {
      try {
        showLoading();
        final res = await _authenticationRepository.sendOTPPhone(
          state.phoneNumber,
        );
        EasyLoading.dismiss();
        res.fold(
          (l) {
            navigator.showAppTopSnackBar(
              l["message"] ?? 'Có lỗi xảy ra!',
              type: 'error',
            );
          },
          (r) {
            int sendOtpCount = state.sendOtpCount;
            sendOtpCount++;
            emit(state.copyWith(sendOtpCount: sendOtpCount));
            startTimer();

            if (state.countTime < 1) {
              emit(state.copyWith(countTime: 0));
            }
          },
        );
      } catch (e) {
        EasyLoading.dismiss();
      }
    }
  }

  void setDisable(bool isDisable) {
    emit(state.copyWith(isDisable: isDisable));
  }

  // void setDisableV2(bool isDisable) {
  //   emit(state.copyWith(isDisableV2: isDisable));
  // }

  Future<void> verifyOtp() async {
    if (!formKey.currentState!.validate()) return;

    try {
      showLoading();

      final res = await _authenticationRepository.verifyOTPPhone(
        otp: state.otp,
        fullName: state.fullname,
        phoneNumber: state.phoneNumber,
        password: state.password,
        referralCode: state.userReferralCode ?? '',
      );
      EasyLoading.dismiss();
      if (res.code == 200) {
        emit(state.copyWith(step: 2, countTime: 0));
        navigator.showSuccessDialog(
          title: 'Đăng ký thành công',
          mainTitle: 'Đóng',
          content: 'Chào mừng bạn đến với chúng tôi.',
          hasButtonBack: false,
          accept: () {
            emit(state.copyWith(countTime: 0));
            navigator.popUntilRoot(useRootNavigator: true);
            navigator.push(LoginPage(hasAGift: false));
          },
        );
      } else {
        navigator.showAppTopSnackBar(
          res.message ?? 'Mã xác nhận không chính xá',
          type: 'error',
        );
      }
      // res.fold(
      //   (l) {
      //     navigator.showAppTopSnackBar(
      //       "Mã xác nhận không chính xác",
      //       type: 'error',
      //     );
      //   },
      //   (r) {
      //     emit(state.copyWith(step: 2, countTime: 0));
      //     navigator.showSuccessDialog(
      //       title: 'Đăng ký thành công',
      //       mainTitle: 'Đóng',
      //       content:
      //           'Chào mừng bạn đến với chúng tôi. Nhập mã OTP để xác nhận tài khoản.',
      //       hasButtonBack: false,
      //       accept: () {
      //         emit(state.copyWith(countTime: 0));
      //         navigator.popUntilRoot(useRootNavigator: true);
      //         navigator.push(LoginPage(hasAGift: false));
      //       },
      //     );
      //   },
      // );
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Future<void> verifyOtpForgot() async {
    if (!formKey.currentState!.validate()) return;

    try {
      showLoading();

      final res = await _authenticationRepository.verifyForgot(
        otp: state.otp,
        sessionKey: state.sessionKey,
      );
      EasyLoading.dismiss();
      res.fold(
        (l) {
          navigator.showAppTopSnackBar(
            "Mã xác nhận không chính xác",
            type: 'error',
          );
        },
        (r) {
          emit(state.copyWith(step: 3, countTime: 0));
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Future<void> changePassForgot() async {
    if (!formKey.currentState!.validate()) return;

    try {
      showLoading();

      final res = await _authenticationRepository.changePassForgot(
        sessionKey: state.sessionKey,
        password: state.password,
      );
      EasyLoading.dismiss();
      res.fold(
        (l) {
          navigator.showAppTopSnackBar(
            l['message'] ?? "Cập nhật mật khẩu mới không thành công.",
            type: 'error',
          );
        },
        (r) {
          navigator.showSuccessDialog(
            title: 'Thông báo',
            mainTitle: 'Đóng',
            content: 'Cập nhật mật khẩu mới thành công.',
            hasButtonBack: false,
            accept: () {
              navigator.popUntilRoot(useRootNavigator: true);
              navigator.push(LoginPage(hasAGift: false));
            },
          );
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Future<void> forgotPassword() async {
    if (!formKey.currentState!.validate()) return;

    try {
      showLoading();

      final res = await _authenticationRepository.forgotPassword(
        state.phoneNumber,
      );
      EasyLoading.dismiss();

      res.fold(
        (l) {
          navigator.showAppTopSnackBar(
            "Số điện thoại chưa được tạo",
            type: 'error',
          );
        },
        (r) {
          startTimer();
          emit(
            state.copyWith(
              step: 2,
              sessionKey: r['data']['session_key'],
            ),
          );
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  static Future<bool> requestPermissionPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showOverlayToast(title: "Dịch vụ định vị đã bị vô hiệu hóa.");
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showOverlayToast(title: "Quyền vị trí bị từ chối ");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showOverlayToast(
        title:
            "Quyền vị trí bị từ chối vĩnh viễn, chúng tôi không thể yêu cầu quyền",
      );
      return false;
    }
    return true;
  }

  void onChangeToken(String token) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _authenticationRepository.sendRequestChangeToken(
      token,
      state.otp,
    );
    if (res.code == 200) {
      emit(
        state.copyWith(status: CubitStatus.success, message: res.message),
      );
    } else {
      emit(state.copyWith(status: CubitStatus.loaded, message: res.message));
    }
  }

  Future<void> verifyReferralCode() async {
    try {
      showLoading();
      final res = await _authenticationRepository
          .verifyReferralCode(state.userReferralCode ?? "");
      EasyLoading.dismiss();
      if (res.code == 200) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            message: null,
            referralCode: res.data,
          ),
        );
      } else {
        emit(state.copyWith(status: CubitStatus.loaded, message: res.message));
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  void getUserData(int id) async {
    try {
      final res = await _authenticationRepository.getUserData(id);
      if (res.code == 200) {
        await preferences.saveUserData(jsonEncode(res.data));
        navigator.replaceAll([const RootRoute()]);
      }
    } catch (e) {
      EasyLoading.dismiss();
      navigator.replaceAll([const RootRoute()]);
    }
  }

  void setWarningMessage() {
    emit(state.copyWith(message: 'Không thể nhập mã của chính mình!'));
  }

  useDifferAccount() {
    emit(
      state.copyWith(
        password: '',
        phoneNumber: '',
        useRememberAccount: false,
      ),
    );
  }

  void logOut() async {
    try {
      final res = await _authenticationRepository.logOut();
      appCubit.onForceLogout();

      if (res.code == 200) {
        print('=====logOut');
      }
    } catch (e) {
      EasyLoading.dismiss();
      navigator.replaceAll([const RootRoute()]);
    }
  }
}
