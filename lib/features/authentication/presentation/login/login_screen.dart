import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:drmom/core/widgets/common/app_button.dart';
import 'package:drmom/core/widgets/common/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Logo placeholder
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: AppColors.white, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Dr.\nMOM',
                      textAlign: TextAlign.center,
                      style: AppTypography.h1.copyWith(
                        color: AppColors.primary,
                        height: 1.1,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              
              // Login Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppShadows.soft,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đăng nhập',
                        style: AppTypography.h3.copyWith(
                          color: AppColors.text_primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        label: 'Tài khoản',
                        hintText: 'Nhập số điện thoại hoặc email',
                        controller: _accountController,
                        prefixIcon: const Icon(Icons.email_outlined, size: 20),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tài khoản';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'Mật khẩu',
                        hintText: '********',
                        isPassword: true,
                        controller: _passwordController,
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        title: 'Đăng nhập',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // TODO: Implement login logic
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'Chưa có tài khoản? ',
                            style: AppTypography.p6.copyWith(color: AppColors.text_secondary),
                            children: [
                              TextSpan(
                                text: 'Đăng ký ngay',
                                style: AppTypography.p6.copyWith(
                                  color: AppColors.blue60,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  // TODO: Navigate to register
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Bằng việc đăng nhập, bạn đồng ý với điều khoản sử dụng',
                  textAlign: TextAlign.center,
                  style: AppTypography.p7.copyWith(
                    color: AppColors.text_tertiary,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
