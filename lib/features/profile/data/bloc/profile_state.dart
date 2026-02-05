import 'dart:io';

import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/authentication/data/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/features/booth/data/models/asbc_both_v2_model.dart';
import 'package:bpg_retail/features/cart/data/models/qr_order_detail_model.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isEdit,
    @Default(null) UserModel? userEdit,
    @Default('') String otp,
    @Default(0) int countTime,
    @Default(0) int sendOtpCount,
    @Default(3) int isOTPVerify,
    @Default(false) bool isDisable,
    @Default(1) int step,
    @Default(null) File? image,
    @Default('') String password,
    @Default('') String oldPassword,
    @Default('') String confirmPassword,
    @Default(false) bool showPassword,
    @Default(false) bool showOldPassword,
    @Default(false) bool showConfirmPassword,
    @Default(false) bool isLoading,
    @Default(0) int tabIndex,
    @Default(null) AbbcBothV2Model? company,
    @Default(null) AddressModel? address,
    CubitStatus? status,
  }) = _ProfileState;
}
