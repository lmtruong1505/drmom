import 'package:flutter/material.dart';
import 'package:drmom/core/extension/init_ext.dart';

import '../../configs/app_style/init_app_style.dart';
import '../../configs/app_style/init_app_style.dart';

Widget TabButton({
  required String title,
  bool isActive = false,
  Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: 99.radius,
        color: isActive ? AppColors.white : null,
        // border: Border.all(color: AppColors.border_3),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.p5,
      ),
    ),
  );
}
