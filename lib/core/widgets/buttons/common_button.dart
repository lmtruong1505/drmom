import 'package:flutter/material.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/spacing.dart';
import 'package:BGP_Retail/core/constants/typography.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final Color? buttonColor;
  final Color? titleColor;
  final VoidCallback? onTap;
  final double radius;
  final EdgeInsets? padding;

  const CommonButton({
    super.key,
    required this.title,
    this.buttonColor,
    this.titleColor,
    this.radius = 8,
    this.padding,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: padding ?? Spacing.a16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: buttonColor ?? AppColors.main,
        ),
        child: Center(
          child: Text(
            title,
            style: AppTypography.h6.copyWith(
              color: titleColor ?? AppColors.white,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
