import 'package:auto_route/auto_route.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/base/base_state.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/extension/spacing_extension.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/widgets/buttons/extra_button.dart';
import 'package:BGP_Retail/core/widgets/buttons/main_button.dart';
import 'package:BGP_Retail/core/widgets/common/base_check_box.dart';
import 'package:BGP_Retail/core/widgets/common/title_required.dart';
import 'package:BGP_Retail/core/widgets/textfield/validate_textfield.dart';
import 'package:BGP_Retail/features/authentication/data/bloc/authentication_cubit.dart';
import 'package:BGP_Retail/features/authentication/data/bloc/authentication_state.dart';
import 'package:BGP_Retail/features/authentication/presentation/widget/header_auth.dart';
import 'package:BGP_Retail/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/banner_asbc.dart';

@RoutePage(name: "LoginPage")
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.hasAGift});
  final bool? hasAGift;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    passworkCtrl = TextEditingController();
    // bloc.checkHasAGift(widget.hasAGift);
  }

  final bloc = getIt.get<AuthenticationCubit>();
  final navigator = getIt.get<AppNavigator>();
  late TextEditingController passworkCtrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderAuthForm(),
            _formView(),
          ],
        ).padding(16.padingHor),
      ),
    );
  }

  Widget _formView() {
    return Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: bloc.formKey,
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        bloc: bloc,
        builder: (context, state) {
          final useRememberAccount = state.useRememberAccount &&
              state.phoneNumber != '' &&
              state.password != '';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              32.height,
              useRememberAccount
                  ? _useRememberAccount(state)
                  : _useDifferAccount(state),
              16.height,
              requiredTitle('Mật khẩu'),
              4.height,
              ValidateTextField(
                initialValue: state.password,
                // controller: passworkCtrl,
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
                  if (value?.isEmpty ?? false) {
                    return 'Hãy nhập mật khẩu';
                  }
                  return null;
                },
              ),
              16.height,
              Row(
                children: [
                  BaseCheckbox(
                    value: state.isRemember,
                    radius: 4,
                    onChanged: (bool? value) =>
                        bloc.onRememberAccount(value ?? false),
                  ),
                  4.width,
                  GestureDetector(
                    onTap: () => bloc.onRememberAccount(!state.isRemember),
                    child: Text(
                      'Ghi nhớ tài khoản',
                      style: AppTypography.p4.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // GestureDetector(
                  //   onTap: () => navigator.push(const ForgotPasswordPage()),
                  //   child:
                  //       const Text('Quên mật khẩu?', style: AppTypography.p4),
                  // ),
                ],
              ),
              24.height,
              SizedBox(
                height: 45,
                width: double.infinity,
                child: MainButton(
                  title: 'Đăng nhập',
                  onTap: () => bloc.onLoginAsbc(context),
                  largeButton: true,
                ),
              ),
              24.height,
              // useRememberAccount ? loginWithDifferAccount() : _createAccount(),
              loginWithDifferAccount()
            ],
          );
        },
      ),
    );
  }

  Row _createAccount() {
    return Row(
      children: [
        const Text(
          'Bạn chưa có tài khoản? ',
          style: AppTypography.p6,
        ),
        GestureDetector(
          onTap: () => navigator.replace(const RegisterPage()),
          child: Text(
            'Đăng ký ngay',
            style: AppTypography.p5.copyWith(
              color: AppColors.main,
            ),
          ),
        ),
      ],
    );
  }

  Column loginWithDifferAccount() {
    return Column(
      children: [
        Row(
          children: [
            const Divider().expanded(),
            Text(
              'hoặc',
              style: s14w400.copyWith(color: AppColors.grey97),
            ).padding(8.padingHor),
            const Divider().expanded(),
          ],
        ),
        16.height,
        SizedBox(
          width: double.infinity,
          child: ExtraButton(
            color: AppColors.grey5B,
            bgColor: AppColors.border_1,
            borderColor: AppColors.border_1,
            title: 'Đăng nhập với tài khoản khác',
            onTap: () => bloc.useDifferAccount(),
          ),
        ),
      ],
    );
  }

  Column _useDifferAccount(AuthenticationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Chào mừng bạn",
          textAlign: TextAlign.center,
          style: s24w700,
        ),
        4.height,
        Text(
          "Vui lòng đăng nhập để sử dụng dịch vụ!",
          textAlign: TextAlign.center,
          style: s14w400.copyWith(color: AppColors.grey80),
        ),
        24.height,
        requiredTitle('Số điện thoại'),
        4.height,
        ValidateTextFieldV2(
          initialValue: state.phoneNumber,
          margin: EdgeInsets.zero,
          backgroundColor: AppColors.white,
          hintText: 'Nhập số điện thoại',
          hintStyle: AppTypography.p6.copyWith(
            color: AppColors.grey_1,
          ),
          maxLines: 1,
          onChanged: bloc.onChangePhoneNumber,
          validator: (value) {
            final RegExp regex = RegExp(r'^0\d{9,11}$');
            if (value?.isEmpty ?? false) {
              return 'Hãy nhập số điện thoại';
            }
            if (!regex.hasMatch(value ?? '')) {
              return "Số điện thoại không đúng định dạng";
            }
            return null;
          },
        ),
      ],
    );
  }

  Column _useRememberAccount(AuthenticationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Xin chào",
          textAlign: TextAlign.center,
          style: s16w500.copyWith(color: AppColors.grey80),
        ),
        4.height,
        Text(
          state.phoneNumber,
          style: s24w700,
        ),
        24.height,
      ],
    );
  }
}
