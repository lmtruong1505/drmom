import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/core/base/cubit_state.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/preferences/preferences.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/widgets/buttons/main_button.dart';
import 'package:BGP_Retail/core/widgets/buttons/tab_button.dart';
import 'package:BGP_Retail/core/widgets/textfield/validate_textfield.dart';
import 'package:BGP_Retail/core/widgets/toast/toast.dart';
import 'package:BGP_Retail/features/profile/data/bloc/confirm_account_opt_cubit.dart';
import 'package:BGP_Retail/features/profile/presentation/children_screens/payment_detail_sreen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ConfirmOtpBankAccount extends StatefulWidget {
  const ConfirmOtpBankAccount({super.key, this.onTap});
  final void Function(bool value)? onTap;

  @override
  State<ConfirmOtpBankAccount> createState() => _ConfirmOtpBankAccountState();
}

class _ConfirmOtpBankAccountState extends State<ConfirmOtpBankAccount>
    with SingleTickerProviderStateMixin {
  late TabController tabCtrl;
  final bloc = getIt.get<ConfirmAccountOtpCubit>();

  final phoneKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConfirmAccountOtpCubit>(
      create: (context) => bloc,
      child: BlocConsumer<ConfirmAccountOtpCubit, CubitState>(
        listener: (context, state) {
          if (state.status == CubitStatus.sendSuccess) {
            // widget.onTap?.call(true);
            Toast.showToast('Tạo tài khoản thành công', context);
            nav.pop(result: true);
          } else if (state.status == CubitStatus.sendFaild) {
            // Toast.showToast('Mã OTP không đúng', context);
          }
        },
        builder: (context, state) {
          return Container(
            padding: 16.pading,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    18.width,
                    const Text(
                      "Xác thực thông tin thanh toán",
                      style: s16w700,
                    ),
                    GestureDetector(
                      onTap: () => nav.pop(),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                16.height,
                IndexedStack(
                  children: [
                    PhoneView(bloc: bloc),
                    EmailView(bloc: bloc),
                  ],
                )
                // TabBarView(
                //   physics: const NeverScrollableScrollPhysics(),
                //   controller: tabCtrl,
                //   children: [

                //   ],
                // ).expanded(),
                // if (bloc.tabIndex == 0)
                //   _buildPhoneView(context)
                // else
                //   _buidlEmailView(context),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EmailView extends StatefulWidget {
  const EmailView({super.key, required this.bloc});
  final ConfirmAccountOtpCubit bloc;

  @override
  State<EmailView> createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  final otpEmail = TextEditingController();
  final emailCtrl = TextEditingController();
  final preference = getIt.get<Preferences>();

  @override
  Widget build(BuildContext context) {
    final email = null;
    final bloc = widget.bloc;
    return BlocBuilder<ConfirmAccountOtpCubit, CubitState>(
      builder: (context, state) {
        return Column(
          children: [
            Visibility(
              visible: email != null,
              child: Column(
                children: [
                  Text(
                    "Mã xác thực được gửi đến email ${email ?? ""}",
                    style: s14w400,
                  ),
                  const Text(
                    "Vui lòng nhập mã OTP để xác thực.",
                    style: s14w400,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: email == null,
              child: const Text(
                "Bạn chưa có email ,vui lòng cập nhật email để xác nhận",
                style: s14w400,
                textAlign: TextAlign.center,
              ),
            ),
            // Visibility(
            //   visible: bloc.isEmailCount,
            //   child: Column(
            //     children: [
            //       8.height,
            //       Text(
            //         formatMinute(bloc.countTime),
            //         style: s14w700.copyWith(color: AppColors.blue31),
            //       ),
            //     ],
            //   ),
            // ),

            8.height,
            MainButton(
              isDisable: email == null || bloc.isEmailCount,
              title: !bloc.isEmailCount
                  ? "Gửi OTP"
                  : (bloc.countTime > 0)
                      ? formatMinute(bloc.countTime)
                      : "Gửi lại OTP",
              onTap: () {
                bloc.startTimer(isPhone: false);
              },
              largeButton: false,
            ),
            // 8.height,
            // ValidateTextField(
            //   suffixIcon: !bloc.isEmailCount
            //       ? GestureDetector(
            //           onTap: () {
            //             bloc.startTimer(isPhone: false);
            //           },
            //           child: Text(
            //             "Gửi OTP",
            //             style: s14w700.copyWith(color: AppColors.blue31),
            //           ),
            //         )
            //       : bloc.countTime > 0
            //           ? Text(
            //               "${formatMinute(bloc.countTime)} s",
            //               style: s14w700.copyWith(color: AppColors.blue31),
            //             )
            //           : GestureDetector(
            //               onTap: () => bloc.startTimer(isPhone: false),
            //               child: Text(
            //                 "Gửi lại OTP",
            //                 style: s14w700.copyWith(color: AppColors.blue31),
            //               ),
            //             ),
            //   controller: emailCtrl,
            //   hintText: "Nhập Email của bạn",
            //   validator: (p0) {
            //     if (p0?.isEmpty == true) {
            //       return 'Hãy nhập Email';
            //     } else if (!p0.isEmail()) {
            //       return "Email không đúng định dạng";
            //     }
            //     return null;
            //   },
            // ),
            const SizedBox(height: 8),
            const Text("Mã OTP", style: s14w500),
            8.height,
            PinCodeTextField(
              controller: otpEmail,
              appContext: context,
              length: 6,
              keyboardType: TextInputType.number,
              cursorColor: Colors.transparent,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                borderWidth: 1,
                fieldHeight: 45,
                fieldWidth: 45,
                // inactiveColor: (otpPhone.text.length > 1)
                //     ? AppColors.red_1
                //     : AppColors.border_2,
                // activeColor:
                //     bloc.tabIndex == 0 ? AppColors.red_1 : AppColors.border_2,
              ),
              errorTextSpace: 20,
              errorTextMargin: const EdgeInsets.only(left: 0),
              textStyle: AppTypography.h4,
              validator: (value) {
                if (value!.isEmpty) {
                  bloc.setDisable(true);
                  return 'Bạn cần hoàn thiện trường này';
                } else if (value.length < 6) {
                  bloc.setDisable(true);
                  return 'Bạn cần nhập đủ 6 số mã code';
                }
                //  else if (state.isOTPVerify == 0) {
                //   bloc.setDisable(true);
                //   return 'Mã OTP không đúng hoặc đã hết hạn';
                // }
                bloc.setDisable(false);
                return null;
              },
              onCompleted: (value) {
                if (value.length < 6 || !emailCtrl.text.isEmail()) {
                  bloc.setDisable(true);
                } else {
                  bloc.setDisable(false);
                }
              },
            ),
            // const Spacer(),
            16.height,
            Container(
              width: double.infinity,
              child: MainButton(
                isDisable: bloc.isDisable,
                largeButton: true,
                onTap: () {
                  bloc.verifyBankAccout(otpEmail.text, otpEmail.text);
                },
                title: "Xác thực",
              ),
            ),
          ],
        );
      },
    );
  }
}

class PhoneView extends StatefulWidget {
  const PhoneView({super.key, required this.bloc});
  final ConfirmAccountOtpCubit bloc;

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  final otpPhone = TextEditingController();
  final phoneCtrl = TextEditingController();
  final preference = getIt.get<Preferences>();
  @override
  Widget build(BuildContext context) {
    final phone = preference.getUserData.phone;
    final bloc = widget.bloc;
    return BlocBuilder<ConfirmAccountOtpCubit, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        print(state.status);
        return Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Visibility(
              visible: phone != null,
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Mã xác thực được gửi đến zalo SĐT ",
                      style: s14w400.copyWith(color: AppColors.black),
                      children: [
                        TextSpan(
                          text: phone ?? "",
                          style: s14w500.copyWith(color: AppColors.blue31),
                        )
                      ],
                    ),
                  ),
                  // Text(
                  //   "Mã xác thực được gửi đến SĐT ${phone ?? ""}",
                  //   style: s14w400,
                  // ),
                  const Text(
                    "Vui lòng nhập mã OTP để xác thực.",
                    style: s14w400,
                  ),
                ],
              ),
            ),
            // Visibility(
            //   visible: bloc.isPhoneCount,
            //   child: Column(
            //     children: [
            //       8.height,
            //       Text(
            //         formatMinute(bloc.countTime),
            //         style: s14w700.copyWith(color: AppColors.blue31),
            //       ),
            //     ],
            //   ),
            // ),
            // Visibility(
            //   visible: phone == null,
            //   child: const Text(
            //     "Bạn chưa có sđt ,vui lòng cập nhật sđt để xác nhận",
            //     style: s14w400,
            //     textAlign: TextAlign.center,
            //   ),
            // ),

            // 8.height,
            // (bloc.countTime > 0)
            //     ? Text(formatMinute(bloc.countTime))
            //     : MainButton(
            //         isDisable: phone == null || bloc.isPhoneCount,
            //         title: "Gửi lại OTP",
            //         onTap: () {
            //           bloc.startTimer(isPhone: true);
            //         },
            //         largeButton: false,
            //       ),

            // const Text(
            //   "Số điện thoại Zalo",
            //   style: s14w500,
            // ),
            // 8.height,
            // ValidateTextField(
            //   controller: phoneCtrl,
            //   onChanged: (p0) {
            //     bloc.setSendOTP(true);
            //   },
            //   suffixIcon: !bloc.isPhoneCount
            //       ? GestureDetector(
            //           onTap: () {
            //             bloc.startTimer();
            //           },
            //           child: Text(
            //             "Gửi OTP",
            //             style: s14w700.copyWith(color: AppColors.blue31),
            //           ),
            //         )
            //       : bloc.countTime > 0
            //           ? Text(
            //               "${formatMinute(bloc.countTime)} s",
            //               style: s14w700.copyWith(color: AppColors.blue31),
            //             )
            //           : GestureDetector(
            //               onTap: bloc.startTimer,
            //               child: Text(
            //                 "Gửi lại OTP",
            //                 style: s14w700.copyWith(color: AppColors.blue31),
            //               ),
            //             ),
            //   hintText: "Nhập số điên thoại Zalo của bạn",
            //   validator: (p0) {
            //     if (p0?.isEmpty == true) {
            //       return 'Hãy nhập số điện thoại';
            //     } else if (!p0.isPhoneNumber()) {
            //       return "Số điện thoại không đúng định dạng";
            //     }

            //     return null;
            //   },
            // ),

            16.height,
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Mã OTP", style: s14w500),
            ),
            8.height,
            const SizedBox(height: 8),
            PinCodeTextField(
              controller: otpPhone,
              appContext: context,
              length: 6,
              keyboardType: TextInputType.number,
              cursorColor: Colors.transparent,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                borderWidth: 1,
                fieldHeight: 45,
                fieldWidth: 45,
                // inactiveColor: state.isOTPVerify == 0
                //     ? AppColors.red_1
                //     : AppColors.border_2,
                // activeColor: state.isOTPVerify == 0
                //     ? AppColors.red_1
                //     : AppColors.border_2,
              ),
              errorTextSpace: 20,
              errorTextMargin: const EdgeInsets.only(left: 0),
              textStyle: AppTypography.h4,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Bạn cần hoàn thiện trường này';
                } else if (value.length < 6) {
                  return 'Bạn cần nhập đủ 6 số mã code';
                }
                //  else if (state.isOTPVerify == 0) {
                //   bloc.setDisable(true);
                //   return 'Mã OTP không đúng hoặc đã hết hạn';
                // }
                return null;
              },
              onChanged: (value) {
                bloc.setDisable(true);
              },
              onCompleted: (value) {
                if (value.length < 6) {
                  bloc.setDisable(true);
                } else {
                  bloc.setDisable(false);
                  bloc.verifyBankAccout(phone ?? '', otpPhone.text);
                }
              },
            ),
            Visibility(
              visible: state.status == CubitStatus.sendFaild,
              child: Text(
                "Mã OTP không đúng",
                style: s16w500.copyWith(color: AppColors.red_1),
              ),
            )
            // const Spacer(),
            // 16.height,
            // Container(
            //   width: double.infinity,
            //   child: MainButton(
            //     isDisable: bloc.isDisable,
            //     largeButton: true,
            //     onTap: () {},
            //     title: "Xác thực",
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
