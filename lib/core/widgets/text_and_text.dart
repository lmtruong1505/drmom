import 'package:flutter/material.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';

import '../configs/app_style/init_app_style.dart';
import '../configs/app_style/init_app_style.dart';

Widget TextAndText({
  required String title,
  required String subtitle,
  TextAlign textAlign = TextAlign.right,
  TextStyle? style,
  CrossAxisAlignment? crossAxisAlignment,
  Key? key,
  Widget? icon,
  bool isExpanded = true,
}) {
  return Row(
    crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: AppTypography.p6.copyWith(
          color: AppColors.grey_79,
        ),
      ),
      8.width,
      isExpanded
          ? Text(
              subtitle,
              style: style ?? AppTypography.p6,
              textAlign: textAlign,
            ).expanded()
          : Text(
              subtitle,
              style: style ?? AppTypography.p6,
              textAlign: textAlign,
            ).flexible(),
      if (icon != null) icon,
    ],
  );
}
