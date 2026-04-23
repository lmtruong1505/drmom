import 'package:auto_route/auto_route.dart';
import 'package:drmom/app/routes/router.gr.dart';
import "package:drmom/core/configs/app_style/init_app_style.dart";
import 'package:drmom/core/extension/init_ext.dart';
import 'package:drmom/core/extension/spacing_extension.dart';
import 'package:drmom/core/injection/injection.dart';
import 'package:drmom/core/navigation/navigator.dart';
import 'package:drmom/core/utilities/debouncer.dart';
import 'package:drmom/core/widgets/buttons/main_button.dart';
import 'package:drmom/core/widgets/common/title_required.dart';
import 'package:drmom/core/widgets/textfield/validate_textfield.dart';
import 'package:drmom/features/authentication/data/bloc/authentication_cubit.dart';
import 'package:drmom/features/authentication/data/bloc/authentication_state.dart';
import 'package:drmom/features/authentication/presentation/widget/header_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final debouncer = Debouncer();
  final referralCodeCtrl = TextEditingController();
  final bloc = getIt<AuthenticationCubit>();
  final navigator = getIt<AppNavigator>();

  @override
  void initState() {
    super.initState();
    bloc.clearFormRegister();
  }

  @override
  void dispose() {
    referralCodeCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final regexPassword = RegExp(
    r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#\][:()"`;+\-|_?,.</\\>=$%}{^&*~]).{8,}$',
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
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
                  const SizedBox(height: 32),
                  _formView(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formView() {
    return Form(
      key: bloc.formKey,
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ValidateTextField(
                  label: 'Họ và tên',
                  initialValue: state.fullname,
                  hintText: 'Nguyễn Văn A',
                  hintStyle: AppTypography.p6.copyWith(
                    color: const Color(0xFF98A2B3),
                  ),
                  leadingIcon: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF98A2B3),
                    size: 20,
                  ),
                  onChanged: bloc.onChangeFullname,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ValidateTextField(
                  label: 'Email',
                  initialValue: state.email,
                  hintText: 'email@example.com',
                  hintStyle: AppTypography.p6.copyWith(
                    color: const Color(0xFF98A2B3),
                  ),
                  leadingIcon: const Icon(
                    Icons.email_outlined,
                    color: Color(0xFF98A2B3),
                    size: 20,
                  ),
                  onChanged: bloc.onChangeEmail,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Vui lòng nhập email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ValidateTextField(
                  label: 'Số điện thoại',
                  initialValue: state.phoneNumber,
                  hintText: '0123456789',
                  hintStyle: AppTypography.p6.copyWith(
                    color: const Color(0xFF98A2B3),
                  ),
                  leadingIcon: const Icon(
                    Icons.phone_outlined,
                    color: Color(0xFF98A2B3),
                    size: 20,
                  ),
                  onChanged: bloc.onChangePhoneNumber,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ValidateTextField(
                  label: 'Mật khẩu',
                  initialValue: state.password,
                  hintText: '********',
                  hintStyle: AppTypography.p6.copyWith(
                    color: const Color(0xFF98A2B3),
                  ),
                  leadingIcon: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFF98A2B3),
                    size: 20,
                  ),
                  obscureText: !state.showPassword,
                  onChanged: bloc.onChangePassword,
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
                      return 'Vui lòng nhập mật khẩu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ValidateTextField(
                  label: 'Xác nhận mật khẩu',
                  initialValue: state.confirmPassword,
                  hintText: '********',
                  hintStyle: AppTypography.p6.copyWith(
                    color: const Color(0xFF98A2B3),
                  ),
                  leadingIcon: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFF98A2B3),
                    size: 20,
                  ),
                  obscureText: !state.showConfirmPassword,
                  onChanged: bloc.onChangeConfirmPassword,
                  suffixIcon: GestureDetector(
                    onTap: bloc.onShowConfirmPassword,
                    child: Icon(
                      !state.showConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF98A2B3),
                      size: 20,
                    ),
                  ),
                  validator: (value) {
                    return bloc.validateConfirmPassword();
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: MainButton(
                    backgroundColor: AppColors.main,
                    title: 'Đăng nhập',
                    onTap: () => bloc.onRegisterAsbc(),
                    radius: 12,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Đã có tài khoản? ',
                      style: AppTypography.p6.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigator.replace(const LoginRoute());
                      },
                      child: Text(
                        'Đăng nhập',
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
          );
        },
      ),
    );
  }
}
