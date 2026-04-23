import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:drmom/core/widgets/base_container.dart';
import 'package:drmom/core/widgets/textfield/search_input_field.dart';
import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 32,
                fit: BoxFit.contain,
              ),
              const Stack(
                children: [
                  BaseContainer(
                    padding: EdgeInsets.all(8),
                    color: AppColors.bg_pill_grey,
                    isCircle: true,
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.text_primary,
                      size: 24,
                    ),
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: BaseContainer(
                      padding: EdgeInsets.all(4),
                      color: AppColors.carrot70,
                      isCircle: true,
                      constraints: BoxConstraints(minWidth: 10, minHeight: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RichText(
              text: TextSpan(
                text: 'Xin chào, ',
                style: AppTypography.p6.copyWith(
                  color: AppColors.text_secondary,
                ),
                children: [
                  TextSpan(
                    text: 'Mẹ Mai! 👋',
                    style: AppTypography.p6.copyWith(
                      color: AppColors.text_primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SearchInputField(hintText: 'Tìm kiếm bạn bè, bài viết...'),
        ],
      ),
    );
  }
}
