import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:flutter/material.dart';

class AssetListsWidget extends StatefulWidget {
  const AssetListsWidget({super.key});

  @override
  State<AssetListsWidget> createState() => _AssetListsWidgetState();
}

class _AssetListsWidgetState extends State<AssetListsWidget> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAssetQuantitySection(),
        24.height,
        _buildDepreciationRateSection(),
        24.height,
        _buildAssetStatusSection(),
      ],
    );
  }

  Widget _buildAssetQuantitySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "Số lượng tài sản",
            style: AppTypography.h3.copyWith(color: const Color(0xFF201B51)),
          ), // Dark Blue Title
          16.height,
          // Custom Tab Bar
          Row(
            children: [
              _buildTabItem(0, "Theo khoa phòng"),
              _buildTabItem(1, "Theo loại tài sản"),
            ],
          ),
          const Divider(height: 1, color: AppColors.grey_2),
          16.height,
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Khoa/Phòng",
                style: AppTypography.p5.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "Tổng nguyên giá",
                style: AppTypography.p5.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.grey_2),
          // List Items
          _buildListItem("Khoa Dược"),
          _buildListItem("Khoa Nhi"),
          _buildListItem("Khoa Sản"),
          _buildListItem("Khoa Cấp cứu"),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.black : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style:
                isSelected
                    ? AppTypography.p5.copyWith(fontWeight: FontWeight.bold)
                    : AppTypography.p5.copyWith(color: AppColors.grey79),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.p5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("1.234", style: AppTypography.p5),
              Text(
                "123.456.789 đ",
                style: AppTypography.p5.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "Còn lại 123.456 đ",
                style: AppTypography.p7.copyWith(color: AppColors.grey79),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepreciationRateSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "Tỷ lệ hao mòn tài sản",
            style: AppTypography.h3.copyWith(color: const Color(0xFF201B51)),
          ),
          24.height,
          _buildProgressBar("Hao mòn 0-30%", AppColors.green_1, 0.85),
          _buildProgressBar("Hao mòn 31-60%", AppColors.blue_1, 0.85),
          _buildProgressBar("Hao mòn 61-80%", AppColors.accent_5, 0.85),
          _buildProgressBar("Hao mòn 81-100%", AppColors.red, 0.85),
        ],
      ),
    );
  }

  Widget _buildAssetStatusSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "Tỷ lệ trạng thái tài sản",
            style: AppTypography.h3.copyWith(color: const Color(0xFF201B51)),
          ),
          24.height,
          _buildProgressBar("Chưa nhập", const Color(0xFF7E52FF), 0.85),
          _buildProgressBar("Nhàn rỗi", const Color(0xFF7E52FF), 0.85),
          _buildProgressBar("Đang sử dụng", const Color(0xFF7E52FF), 0.85),
          _buildProgressBar("Đang sửa chữa", const Color(0xFF7E52FF), 0.85),
          _buildProgressBar("Đang bảo dưỡng", const Color(0xFF7E52FF), 0.85),
          _buildProgressBar("Chờ thanh lý", const Color(0xFF7E52FF), 0.85),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, Color color, double percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTypography.p5.copyWith(
                  color: const Color(0xFF6B6B80),
                ),
              ), // Grey-purple text
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("3.456", style: AppTypography.h5), // Or 567
                  // Badge 85%
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey_2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${(percent * 100).toInt()}%",
                      style: AppTypography.p8.copyWith(color: AppColors.grey_1),
                    ),
                  ),
                ],
              ),
            ],
          ),
          8.height,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: AppColors.grey_2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 12, // Thicker bar
            ),
          ),
        ],
      ),
    );
  }
}
