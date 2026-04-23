import 'package:auto_route/auto_route.dart';
import 'package:drmom/app/routes/router.gr.dart';
import "package:drmom/core/configs/app_style/init_app_style.dart";
import 'package:drmom/core/extension/init_ext.dart';
import 'package:drmom/core/injection/injection.dart';
import 'package:drmom/core/navigation/navigator.dart';
import 'package:drmom/core/utilities/localization_helper.dart';
import 'package:drmom/core/widgets/buttons/main_button.dart';
import 'package:drmom/core/widgets/textfield/validate_textfield.dart';
import 'package:drmom/features/authentication/data/bloc/authentication_cubit.dart';
import 'package:drmom/features/authentication/data/bloc/authentication_state.dart';
import 'package:drmom/features/authentication/presentation/widget/header_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    passworkCtrl = TextEditingController();
  }

  final bloc = getIt.get<AuthenticationCubit>();
  final navigator = getIt.get<AppNavigator>();
  late TextEditingController passworkCtrl;

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const HeaderAuthForm(isPaddingTop: 0),
                _formView(trans),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _formView(AppLocalizations trans) {
    return Form(
      key: bloc.formKey,
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        bloc: bloc,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              48.height,
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Đăng nhập',
                      style: AppTypography.h3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ValidateTextField(
                      label: 'Tài khoản',
                      initialValue: state.phoneNumber,
                      margin: EdgeInsets.zero,
                      hintText: 'Nhập số điện thoại hoặc email',
                      hintStyle: AppTypography.p6.copyWith(
                        color: const Color(0xFF98A2B3),
                      ),
                      leadingIcon: const Icon(
                        Icons.mail_outline,
                        color: Color(0xFF98A2B3),
                        size: 20,
                      ),
                      maxLines: 1,
                      onChanged: bloc.onChangePhoneNumber,
                    ),
                    const SizedBox(height: 16),
                    ValidateTextField(
                      label: 'Mật khẩu',
                      initialValue: state.password,
                      margin: EdgeInsets.zero,
                      hintText: '********',
                      hintStyle: AppTypography.p6.copyWith(
                        color: const Color(0xFF98A2B3),
                      ),
                      leadingIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF98A2B3),
                        size: 20,
                      ),
                      maxLines: 1,
                      onChanged: bloc.onChangePassword,
                      obscureText: !state.showPassword,
                      suffixIcon: GestureDetector(
                        onTap: bloc.onShowPassword,
                        child: Icon(
                          !state.showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF98A2B3),
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return trans.translate('pw_not_valid');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: MainButton(
                        backgroundColor: AppColors.main,
                        title: trans.translate('log_in'),
                        onTap: () => bloc.onLogin(context),
                        largeButton: true,
                        radius: 12,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa có tài khoản? ',
                          style: AppTypography.p6.copyWith(
                            color: AppColors.text_secondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            navigator.push(const RegisterRoute());
                          },
                          child: Text(
                            'Đăng ký ngay',
                            style: AppTypography.p6.copyWith(
                              color: AppColors.blue60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Bằng việc đăng nhập, bạn đồng ý với điều khoản sử dụng',
                    textAlign: TextAlign.center,
                    style: AppTypography.p7.copyWith(
                      color: AppColors.text_tertiary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
