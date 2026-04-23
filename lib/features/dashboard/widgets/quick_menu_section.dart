import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:flutter/material.dart';

class QuickMenuSection extends StatelessWidget {
  const QuickMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'label': 'Sức khỏe', 'icon': Icons.favorite_outline_rounded, 'color': AppColors.red_subtle},
      {'label': 'Đạo và đời', 'icon': Icons.menu_book_outlined, 'color': AppColors.yellow_subtle},
      {'label': 'Cộng đồng', 'icon': Icons.groups_outlined, 'color': AppColors.green_subtle},
      {'label': 'Dịch vụ', 'icon': Icons.business_center_outlined, 'color': AppColors.blue_subtle},
      {'label': 'Shop', 'icon': Icons.shopping_bag_outlined, 'color': AppColors.pink_subtle},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: menuItems.map((item) {
          return Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: item['color'],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  item['icon'],
                  color: (item['color'] as Color).withRed(100).withGreen(100).withBlue(100),
                  size: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['label'],
                style: AppTypography.p7.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: AppColors.text_primary,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
