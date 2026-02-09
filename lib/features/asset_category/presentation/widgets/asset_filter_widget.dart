import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/core.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:flutter/material.dart';

class AssetFilterWidget extends StatelessWidget {
  final VoidCallback? onFilterTap;

  const AssetFilterWidget({super.key, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 16.padingHor + 12.padingVer,
      child: Row(
        children: [
          Expanded(
            child: ValidateTextField(
              padding: 14.pading,
              margin: EdgeInsets.zero,
              backgroundColor: AppColors.white,
              hintText: 'Tìm kiếm',
              hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
              leadingIcon: Padding(
                padding: 6.padingRight,
                child: const Icon(Icons.search, size: 22),
              ),
              maxLines: 1,
              onChanged: (value) {},
            ),
          ),
          12.width,
          InkWell(
            onTap: onFilterTap,
            child: BaseContainer(
              width: 48,
              height: 48, // Match text field height roughly
              isCircle: true,
              color: AppColors.greyE2.withOpacity(0.5),
              child: const Center(
                child: Icon(Icons.filter_list, color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
