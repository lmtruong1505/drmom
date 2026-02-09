import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/base/appbar.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/features/asset_category/presentation/widgets/asset_filter_widget.dart';

import 'package:bpg_retail/features/asset_category/presentation/widgets/asset_item_widget.dart';
import 'package:flutter/material.dart';

class AssetCategoryPage extends StatelessWidget {
  const AssetCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Connect with Bloc state to toggle this
    bool hasData = true;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: BaseAppBar(
        title: "Danh mục tài sản (999)",
        centerTitle: false,
        hasLeading: false,
        textStyle: AppTypography.h3.copyWith(color: AppColors.black),
        trailingIcons: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                // TODO: Handle create new asset
              },
              child: const Icon(Icons.add, color: AppColors.black),
            ),
          ),
        ],
      ),
      body: hasData ? _buildListState() : _buildEmptyState(),
    );
  }

  Widget _buildListState() {
    return Column(
      children: [
        const AssetFilterWidget(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: 10, // Mock 10 items
            separatorBuilder: (context, index) => 8.height,
            itemBuilder: (context, index) {
              return const AssetItemWidget();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BaseContainer(
            width: 80,
            height: 80,
            isCircle: true,
            color: AppColors.grey80.withOpacity(0.5),
            child: Center(
              child: BaseContainer(
                width: 48,
                height: 48,
                isCircle: true,
                color: AppColors.black,
                child: const Center(
                  child: Icon(
                    Icons.description_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          16.height,
          Text(
            "Không có tài sản",
            style: AppTypography.h3.copyWith(color: AppColors.black),
          ),
          8.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Không có dữ liệu khả dụng liên quan đến chức năng bạn truy cập",
              textAlign: TextAlign.center,
              style: AppTypography.p5.copyWith(color: AppColors.grey80),
            ),
          ),
          24.height,
          BaseContainer(
            // onTap: () {
            //   // TODO: Handle create new asset
            // },
            isDotted: true,
            borderColor: AppColors.grey80,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            borderRadius: 24,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Tạo mới tài sản",
                  style: AppTypography.p5.copyWith(
                    color: AppColors.grey80,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                8.width,
                const Icon(Icons.add, color: AppColors.grey80, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
