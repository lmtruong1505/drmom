import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/features/profile/data/models/referall_model.dart';

part 'authentication_state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    @Default('') String phoneNumber,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default('') String email,
    @Default('') String fullname,
    @Default('') String otp,
    String? userReferralCode,
    ReferallModel? referralCode,
    @Default(false) bool showPassword,
    @Default(false) bool showConfirmPassword,
    @Default(false) bool isRemember,
    @Default(0) int countTime,
    @Default(0) int sendOtpCount,
    @Default(3) int isOTPVerify,
    @Default(true) bool isDisable,
    @Default(false) bool isDisableV2,
    @Default(1) int step,
    @Default(false) bool toPromotionScreen,
    @Default(true) bool useRememberAccount,
    @Default('') String sessionKey,
    @Default(ForgotPasswordType.email) ForgotPasswordType type,
    @Default(CubitStatus.init) CubitStatus status,
    @Default("") String? message,
  }) = _AuthenticationState;
}
