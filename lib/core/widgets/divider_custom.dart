import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/spacing.dart';
import 'package:flutter/material.dart';

Widget DividerCustom({
  Color? color = AppColors.border_tertiary,
  bool isVertival = false,
  double space = 0,
}) {
  return !isVertival
      ? Divider(height: space, thickness: 1, color: color)
      : VerticalDivider(width: space, thickness: 1, color: color);
}

Widget get dottedDivider {
  return Row(
    children: List.generate(
      150 ~/ 2,
      (index) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: sp12),
          color: index % 2 == 0 ? Colors.transparent : AppColors.grey30,
          height: 1,
        ),
      ),
    ),
  );
}
