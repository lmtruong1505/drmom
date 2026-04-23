import "package:drmom/core/configs/app_style/init_app_style.dart";
import 'package:drmom/core/core.dart';
import 'package:drmom/core/extension/spacing_extension.dart';
import 'package:drmom/core/widgets/base_container.dart';
import 'package:drmom/core/widgets/textfield/validate_textfield.dart';
import 'package:flutter/material.dart';

class AssetFilterWidget extends StatelessWidget {
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onSearchChanged;

  const AssetFilterWidget({super.key, this.onFilterTap, this.onSearchChanged});

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
              onChanged: (value) {
                onSearchChanged?.call(value);
              },
            ),
          ),
          12.width,
          InkWell(
            onTap: onFilterTap,
            child: BaseContainer(
              width: 48,
              height: 48,
              isCircle: true,
              color: AppColors.grey_e2.withOpacity(0.5),
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
