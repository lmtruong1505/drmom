import 'package:flutter/material.dart';

import '../configs/app_style/init_app_style.dart';
import 'buttons/extra_button.dart';
import 'buttons/main_button.dart';

class TwoButtonBox extends StatelessWidget {
  final String? leftTitle;
  final String? rightTitle;
  final VoidCallback? leftOnTap;
  final VoidCallback? rightOnTap;
  final bool isDisable;
  final BorderRadiusGeometry? borderRadius;

  const TwoButtonBox({
    super.key,
    this.leftTitle = '',
    this.rightTitle = '',
    this.leftOnTap,
    this.rightOnTap,
    this.borderRadius,
    this.isDisable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: AppColors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            spreadRadius: 1,
            blurRadius: 15,
            offset: Offset(0, 0.3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: ExtraButton(
              title: leftTitle ?? 'Từ chối',
              onTap: () {
                leftOnTap == null ? Navigator.pop(context) : leftOnTap?.call();
              },
              borderColor: AppColors.border_4,
              largeButton: true,
              icon: null,
            ),
          ),
          const SizedBox(width: sp16),
          Expanded(
            flex: 1,
            child: MainButton(
              title: rightTitle ?? 'Phê duyệt',
              onTap: () {
                isDisable ? rightOnTap?.call() : null;
              },
              largeButton: true,
              icon: null,
            ),
          ),
        ],
      ),
    );
  }
}
