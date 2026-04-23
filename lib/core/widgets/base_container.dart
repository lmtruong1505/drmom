import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import "package:drmom/core/configs/app_style/init_app_style.dart";

class BaseContainer extends StatelessWidget {
  const BaseContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.border,
    this.margin,
    this.boxShadow,
    this.isCircle = false,
    this.isDotted = false,
    this.dashPattern,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.inkWell = false,
    this.alignment,
    this.gradient,
    this.image,
    this.constraints,
    this.clipBehavior,
    this.splashColor,
    this.highlightColor,
  });

  final Widget? child;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final bool isCircle;
  final bool isDotted;
  final List<double>? dashPattern;

  /// Gestures
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final bool inkWell;
  final Color? splashColor;
  final Color? highlightColor;

  /// Alignment & Decoration
  final AlignmentGeometry? alignment;
  final Gradient? gradient;
  final DecorationImage? image;
  final BoxConstraints? constraints;
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        isCircle ? null : BorderRadius.circular(borderRadius ?? 8);

    final decoration = BoxDecoration(
      color: color,
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: effectiveBorderRadius,
      border:
          border ??
          (borderColor != null
              ? Border.all(color: borderColor!, width: borderWidth ?? 1)
              : null),
      boxShadow: boxShadow,
      gradient: gradient,
      image: image,
    );

    Widget current = child ?? const SizedBox.shrink();

    if (padding != null) {
      current = Padding(padding: padding!, child: current);
    }

    if (onTap != null || onLongPress != null || onDoubleTap != null) {
      if (inkWell) {
        current = InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
          borderRadius: effectiveBorderRadius,
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: current,
        );
      } else {
        current = GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
          behavior: HitTestBehavior.opaque,
          child: current,
        );
      }
    }

    if (isDotted) {
      current = DottedBorder(
        padding: EdgeInsets.zero,
        borderType: isCircle ? BorderType.Circle : BorderType.RRect,
        radius: Radius.circular(borderRadius ?? 8),
        color: borderColor ?? AppColors.black,
        strokeWidth: borderWidth ?? 1,
        dashPattern: dashPattern ?? [6, 3],
        child: Container(
          width: width,
          height: height,
          alignment: alignment,
          decoration: decoration.copyWith(
            border: null,
            boxShadow: null,
          ), // Move shadow/border to wrapper if needed, but Dotted handles border
          constraints: constraints,
          clipBehavior: clipBehavior ?? Clip.none,
          child: current,
        ),
      );

      // Wrap dotted with margin and shadow if necessary
      if (margin != null || boxShadow != null) {
        current = Container(
          margin: margin,
          decoration: BoxDecoration(
            boxShadow: boxShadow,
            borderRadius: effectiveBorderRadius,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          ),
          child: current,
        );
      }
      return current;
    }

    return Container(
      margin: margin,
      width: width,
      height: height,
      padding: EdgeInsets.zero, // Padding handled by child wrap
      alignment: alignment,
      constraints: constraints,
      clipBehavior: clipBehavior ?? Clip.none,
      decoration: decoration,
      child: current,
    );
  }
}
