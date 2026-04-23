import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.width,
    this.height = 48,
    this.borderRadius = 12,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? (isSecondary ? AppColors.white : AppColors.primary);
    final finalTextColor = textColor ?? (isSecondary ? AppColors.primary : AppColors.white);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: finalTextColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: isSecondary ? BorderSide(color: AppColors.primary) : BorderSide.none,
          ),
          disabledBackgroundColor: AppColors.bg_disable,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(finalTextColor),
                ),
              )
            : Text(
                title,
                style: AppTypography.p4.copyWith(
                  fontWeight: FontWeight.w600,
                  color: finalTextColor,
                ),
              ),
      ),
    );
  }
}
