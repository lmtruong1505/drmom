import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:drmom/core/widgets/base_container.dart';
import 'package:drmom/core/widgets/feature_service_card.dart';
import 'package:flutter/material.dart';

class ServicesShopSection extends StatelessWidget {
  const ServicesShopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              FeatureServiceCard(
                title: 'Dịch vụ',
                description: 'Chăm sóc chuyên nghiệp',
                buttonText: 'Khám phá',
                backgroundColor: AppColors.brand_main,
                icon: Icons.business_center,
                onTap: () {
                  // TODO: Navigate to Services
                },
              ),
              const SizedBox(width: 16),
              FeatureServiceCard(
                title: 'Shop',
                description: 'Sản phẩm chất lượng',
                buttonText: 'Mua sắm',
                backgroundColor: AppColors.brand_dark,
                icon: Icons.shopping_bag,
                onTap: () {
                  // TODO: Navigate to Shop
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          BaseContainer(
            padding: const EdgeInsets.all(24),
            color: AppColors.white,
            borderRadius: 24,
            borderColor: AppColors.brand_main.withOpacity(0.3),
            child: Column(
              children: [
                BaseContainer(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.yellow_subtle,
                  isCircle: true,
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.brand_main,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Đặt lịch tư vấn miễn phí',
                  style: AppTypography.p5.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Gặp gỡ chuyên gia ngay hôm nay để được tư vấn về sức khỏe mẹ và bé',
                  textAlign: TextAlign.center,
                  style: AppTypography.p6.copyWith(
                    color: AppColors.text_secondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                BaseContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: AppColors.brand_dark,
                  borderRadius: 100,
                  onTap: () {
                    // TODO: Handle consultation booking
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đặt lịch ngay',
                        style: AppTypography.p5.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 20,
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
