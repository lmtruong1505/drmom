import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/colors.dart';

class BaseContainer extends StatelessWidget {
  const BaseContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.color,
    this.borderColor,
    this.margin,
    this.boxShadow,
  });

  final Widget child;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border:
            borderColor != null
                ? Border.all(color: borderColor!, width: 1)
                : null,
        color: color ?? AppColors.white,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
