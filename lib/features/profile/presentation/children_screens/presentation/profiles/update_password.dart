import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/core/base/base_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/widgets/base/base_screen.dart';
import 'package:bpg_retail/core/widgets/base/scaffold.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/common/title_required.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:bpg_retail/features/profile/data/bloc/profile_cubit.dart';
import 'package:bpg_retail/features/profile/data/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage(name: "ChangePasswordPage")
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState
    extends BaseState<ChangePasswordPage, ProfileCubit> {
  @override
  Widget buildPage(BuildContext context) {
    return BaseScreen(
      title: 'Đổi mật khẩu',
      body: Container(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Form(
          key: bloc.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 40),
              // SizedBox(
              //   width: 38,
              //   height: 38,
              //   child: InkWell(
              //     onTap: bloc.handleBack,
              //     child: Container(
              //       decoration: BoxDecoration(
              //         color: const Color(0xFF000000).withOpacity(0.4),
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       child: const Center(
              //         child: Icon(
              //           Icons.arrow_back_rounded,
              //           color: Colors.white,
              //           size: 22,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),
              requiredTitle("Mật khẩu cũ"),
              const SizedBox(height: 8),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return ValidateTextField(
                    initialValue: "",
                    margin: EdgeInsets.zero,
                    backgroundColor: AppColors.white,
                    hintText: 'Nhập mật khẩu',
                    hintStyle: AppTypography.p6.copyWith(
                      color: AppColors.grey_1,
                    ),
                    maxLines: 1,
                    onChanged: bloc.onChangeOldPassword,
                    obscureText: !state.showOldPassword,
                    suffixIcon: GestureDetector(
                      onTap: bloc.onShowOldPassword,
                      child: Icon(
                        !state.showOldPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.grey_1,
                        size: 20,
                      ),
                    ),
                    validator: (value) {
                      final RegExp regex = RegExp(
                        r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#\][:()"`;+\-|_?,.</\\>=$%}{^&*~]).{8,}$',
                      );
                      if (value?.isEmpty ?? false) {
                        return 'Hãy nhập mật khẩu';
                      }
                      if (!regex.hasMatch(value ?? '')) {
                        return "Mật khẩu phải chứa ít nhất một số\nMột ký tự đặc biệt và phải có ít nhất 8 ký tự";
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              requiredTitle("Mật khẩu"),
              const SizedBox(height: 8),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return ValidateTextField(
                    initialValue: "",
                    margin: EdgeInsets.zero,
                    backgroundColor: AppColors.white,
                    hintText: 'Nhập mật khẩu',
                    hintStyle: AppTypography.p6.copyWith(
                      color: AppColors.grey_1,
                    ),
                    maxLines: 1,
                    onChanged: bloc.onChangePassword,
                    obscureText: !state.showPassword,
                    suffixIcon: GestureDetector(
                      onTap: bloc.onShowPassword,
                      child: Icon(
                        !state.showPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.grey_1,
                        size: 20,
                      ),
                    ),
                    validator: (value) {
                      final RegExp regex = RegExp(
                        r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#\][:()"`;+\-|_?,.</\\>=$%}{^&*~]).{8,}$',
                      );
                      if (value?.isEmpty ?? false) {
                        return 'Hãy nhập mật khẩu';
                      }
                      if (!regex.hasMatch(value ?? '')) {
                        return "Mật khẩu phải chứa ít nhất một số\nMột ký tự đặc biệt và phải có ít nhất 8 ký tự";
                      }
                      return bloc.validateConfirmPassword();
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              requiredTitle('Xác nhận mật khẩu'),
              const SizedBox(height: 8),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return ValidateTextField(
                    initialValue: "",
                    margin: EdgeInsets.zero,
                    backgroundColor: AppColors.white,
                    hintText: 'Nhập mật khẩu',
                    hintStyle:
                        AppTypography.p6.copyWith(color: AppColors.grey_1),
                    maxLines: 1,
                    onChanged: bloc.onChangeConfirmPassword,
                    obscureText: !state.showConfirmPassword,
                    suffixIcon: GestureDetector(
                      onTap: bloc.onShowConfirmPassword,
                      child: Icon(
                        !state.showConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.grey_1,
                        size: 20,
                      ),
                    ),
                    validator: (value) {
                      final RegExp regex = RegExp(
                        r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#\][:()"`;+\-|_?,.</\\>=$%}{^&*~]).{8,}$',
                      );
                      if (value?.isEmpty ?? false) {
                        return 'Hãy nhập mật khẩu';
                      }
                      if (!regex.hasMatch(value ?? '')) {
                        return "Mật khẩu phải chứa ít nhất một số\nMột ký tự đặc biệt và phải có ít nhất 8 ký tự";
                      }
                      return bloc.validateConfirmPassword();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ExtraButton(
                largeButton: false,
                title: 'Huỷ bỏ',
                onTap: () => navigator.back(),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return ExtraButton(
                    isLoading: state.isLoading,
                    largeButton: false,
                    title: 'Lưu lại',
                    color: AppColors.white,
                    bgColor: AppColors.main,
                    borderColor: AppColors.main,
                    onTap: bloc.updatePassword,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
