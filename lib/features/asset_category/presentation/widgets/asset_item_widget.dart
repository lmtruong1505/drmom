import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import "package:bpg_retail/core/configs/app_style/init_app_style.dart";
import 'package:bpg_retail/core/core.dart' hide AppColors;
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/base_progress_bar.dart';
import 'package:bpg_retail/core/widgets/chip_custom.dart';
import 'package:flutter/material.dart';

class AssetItemWidget extends StatelessWidget {
  const AssetItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      margin: 8.padingVer + 8.padingHor,
      padding: const EdgeInsets.all(12),
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Asset Image
              BaseContainer(
                width: 80,
                height: 80,
                borderRadius: 8,
                color: AppColors.grey20, // Placeholder color
                // TODO: Replace with actual image when API ready
                child: const Icon(Icons.image, color: AppColors.text_tertiary),
              ),
              12.width,
              // Asset Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "BDNKQKTC2025",
                          style: AppTypography.p5.copyWith(
                            color: AppColors.text_tertiary,
                          ),
                        ),
                        // Status Badge
                        chipCustomBadge(
                          color: AppColors.blue50,
                          title: "Đang sử dụng",
                          titleStyle: AppTypography.p7.copyWith(
                            color: AppColors.blue50,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    4.height,
                    Text(
                      "Bộ đặt nội khí quản đèn LED",
                      style: AppTypography.p4.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.text_primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.height,
                    Text(
                      "22.494.000 đ (8 năm, từ 01/01/2025)",
                      style: AppTypography.p6.copyWith(
                        color: AppColors.text_tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          // Progress Bar
          const BaseProgressBar(value: 19),
          8.height,
          // Depreciation Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Đã hao mòn: 4.012.234 đ",
                style: AppTypography.p6.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              Text(
                "Còn 19.682.250 đ",
                style: AppTypography.p6.copyWith(
                  color: AppColors.text_primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          12.height,
          // Footer
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.layers_outlined,
                  size: 16,
                  color: AppColors.text_tertiary,
                ),
                6.width,
                Text(
                  "Đi kèm 4 tài sản",
                  style: AppTypography.p6.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
              ],
            ),
          ),
          12.height,
          const Divider(height: 1, color: AppColors.border_tertiary),
        ],
      ),
    );
  }
}
