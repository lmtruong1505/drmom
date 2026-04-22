import 'package:flutter/material.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';

import '../configs/app_style/init_app_style.dart';
import '../configs/app_style/init_app_style.dart';

Row TextTitel({required String title}) {
  return Row(
    children: [
      Container(
        height: 24,
        width: 5,
        decoration: BoxDecoration(
          color: AppColors.main,
          borderRadius: 50.radius,
        ),
      ),
      8.width,
      Text(
        title,
        style: AppTypography.h4,
        overflow: TextOverflow.ellipsis,
      ).expanded(),
    ],
  );
}
