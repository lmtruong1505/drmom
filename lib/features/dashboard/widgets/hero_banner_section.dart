import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:flutter/material.dart';

class HeroBannerSection extends StatelessWidget {
  const HeroBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brand_main, AppColors.brand_tan],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brand_main.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_outlined,
                      color: AppColors.orange_subtle,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'CHƯƠNG TRÌNH ĐẶC BIỆT',
                      style: AppTypography.p7.copyWith(
                        color: AppColors.orange_subtle,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    'Tư vấn sức khỏe miễn phí cho mẹ bầu',
                    style: AppTypography.p4.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Đặt lịch ngay hôm nay, nhận quà tặng trị giá 500k',
                  style: AppTypography.p7.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Đăng ký ngay',
                        style: AppTypography.p6.copyWith(
                          color: AppColors.brand_main,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: AppColors.brand_main,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
