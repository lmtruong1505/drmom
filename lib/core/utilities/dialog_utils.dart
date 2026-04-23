import 'dart:async';
import 'dart:math';

import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:drmom/core/extension/init_ext.dart';
import 'package:drmom/core/utilities/assets.dart';
import 'package:drmom/core/utilities/screens.dart';
import 'package:flutter/material.dart';

import '../widgets/widget.dart';

class DialogUtils {
  const DialogUtils._();

  static FutureOr showSuccessDialog(
    BuildContext context, {
    required String content,
    String? title,
    VoidCallback? accept,
    VoidCallback? extraAccept,
    String? mainTitle,
    String? extraTitle,
    bool hasButton = true,
    bool hasButtonBack = true,
    Widget? icon,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            width: max(widthDevice(context) - 32, 343),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 80,
                  child: icon ??
                      Assets.icon(
                        assetName: 'ic_success_new.svg',
                      ),
                ),
                const SizedBox(height: 12),
                Text(title ?? 'Thông báo', style: AppTypography.h3),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: AppTypography.p6.copyWith(color: AppColors.blackish),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                hasButton
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (hasButtonBack)
                            Expanded(
                              child: ExtraButton(
                                title: extraTitle ?? 'Quay lại',
                                onTap: () {
                                  extraAccept != null
                                      ? extraAccept.call()
                                      : Navigator.of(context).pop();
                                },
                                borderColor: AppColors.border_4,
                                largeButton: false,
                                icon: null,
                              ),
                            ),
                          if (hasButtonBack) const SizedBox(width: 12),
                          Expanded(
                            child: MainButton(
                              title: mainTitle ?? 'Xác nhận',
                              onTap: () {
                                accept?.call();
                              },
                              largeButton: false,
                              icon: null,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }

  static FutureOr showErrorDialog(
    BuildContext context, {
    required String content,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            width: max(widthDevice(context) - 32, 343),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.white,
                  child: Assets.icon(assetName: 'ic_error.svg'),
                ),
                const SizedBox(height: 24),
                 Text('Thông báo', style: AppTypography.h3),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: AppTypography.p6.copyWith(color: AppColors.blackish),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  child: MainButton(
                    title: 'Đóng',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static FutureOr showWarningDialog(
    BuildContext context, {
    required String content,
    String? mainTitle,
    VoidCallback? mainTap,
    bool isDouble = false,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            width: max(widthDevice(context) - 32, 343),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.white,
                  child: Assets.icon(assetName: 'ic_warning.svg'),
                ),
                const SizedBox(height: 24),
                 Text('Thông báo', style: AppTypography.h3),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: AppTypography.p6.copyWith(color: AppColors.blackish),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    if (isDouble)
                      Expanded(
                        child: ExtraButton(
                          largeButton: false,
                          title: 'Huỷ bỏ',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                    if (isDouble) const SizedBox(width: 10),
                    Expanded(
                      child: MainButton(
                        largeButton: false,
                        title: isDouble ? mainTitle ?? "Đồng ý" : 'Quay lại',
                        onTap: () {
                          mainTap?.call();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static FutureOr showLoadingDialog(
    BuildContext context, {
    required String message,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            width: max(widthDevice(context) - 32, 343),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BaseLoading(),
                const SizedBox(height: 24),
                 Text('Thông báo', style: AppTypography.h3),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: AppTypography.p6.copyWith(
                    color: AppColors.grey_1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static FutureOr showConfirmDialog(
    BuildContext context, {
    required String description,
    String? title,
    String? rightTitle,
    String? leftTitle,
    bool? doubleBtn = true,
    VoidCallback? ontap,
    bool barrierDismissible = true,
  }) {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            width: max(widthDevice(context) - 32, 343),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icon(assetName: "ic_warning_v2.svg"),
                Text(title ?? 'Thông báo', style: AppTypography.h3),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: AppTypography.p4.copyWith(color: AppColors.blackish),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (doubleBtn == true)
                      Row(
                        children: [
                          Expanded(
                            child: ExtraButton(
                              radius: 30,
                              title: leftTitle ?? "Huỷ",
                              onTap: () => Navigator.pop(context),
                              borderColor: AppColors.border_4,
                              largeButton: true,
                              icon: null,
                            ),
                          ),
                          const SizedBox(width: sp16),
                        ],
                      ).expanded(),
                    Expanded(
                      child: MainButton(
                        radius: 30,
                        title: rightTitle ?? "Đồng ý",
                        onTap: () {
                          Navigator.pop(context);
                          ontap?.call();
                        },
                        largeButton: true,
                        icon: null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
