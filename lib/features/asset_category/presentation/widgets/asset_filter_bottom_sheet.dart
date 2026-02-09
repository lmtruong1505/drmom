import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/buttons/common_button.dart';
import 'package:bpg_retail/core/widgets/chip_custom.dart';
import 'package:bpg_retail/core/widgets/dropdown_button.dart';
import 'package:flutter/material.dart';

class AssetFilterBottomSheet extends StatefulWidget {
  const AssetFilterBottomSheet({super.key});

  @override
  State<AssetFilterBottomSheet> createState() => _AssetFilterBottomSheetState();
}

class _AssetFilterBottomSheetState extends State<AssetFilterBottomSheet> {
  String? _selectedDepartment;
  String _selectedStatus = 'Tất cả'; // Default selected
  String? _selectedDeviceType;

  final List<String> _statuses = [
    'Tất cả',
    'Chưa nhập',
    'Nhận rồi',
    'Đang sử dụng',
    'Đang sửa chữa',
    'Đang bảo dưỡng',
    'Chờ thanh lý',
    'Đã thanh lý',
  ];

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      borderRadius: 16,
      color: AppColors.white,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: BaseContainer(
              margin: 8.padingVer,
              width: 40,
              height: 4,
              color: AppColors.grey_2,
              borderRadius: 2,
              child: Container(),
            ),
          ),
          Padding(
            padding: 16.padingHor,
            child: Text(
              "Bộ lọc",
              style: AppTypography.h3.copyWith(color: AppColors.black),
            ),
          ),
          16.height,
          const Divider(height: 1, color: AppColors.border_2),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: 16.pading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Khoa phòng
                  _buildSectionTitle("Khoa phòng"),
                  8.height,
                  CustomDropdownButton(
                    value: _selectedDepartment,
                    hintText: "Toàn viện",
                    items: [
                      DropdownButtonModel(label: "Toàn viện", value: "all"),
                      DropdownButtonModel(label: "Khoa Nội", value: "noi"),
                      DropdownButtonModel(label: "Khoa Ngoại", value: "ngoai"),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDepartment = value?.value;
                      });
                    },
                  ),
                  16.height,

                  // Trạng thái tài sản
                  _buildSectionTitle("Trạng thái tài sản"),
                  8.height,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _statuses.map((status) {
                          final isSelected = _selectedStatus == status;
                          return ChipCustomBadge(
                            title: status,
                            color:
                                isSelected
                                    ? AppColors.main
                                    : AppColors
                                        .grey79, // Use Brand for selected, Grey for unselected
                            onTap: () {
                              setState(() {
                                _selectedStatus = status;
                              });
                            },
                            // We need a way to style unselected distinctively if ChipCustomBadge prevents custom styling
                            // ChipCustomBadge uses color.withOpacity(0.1) for bg.
                            // If unselected is Grey79, bg is light grey.
                            // If selected is Brand, bg is light green.
                            // This matches requirements reasonably well.
                          );
                        }).toList(),
                  ),
                  16.height,

                  // Loại thiết bị
                  _buildSectionTitle("Loại thiết bị"),
                  8.height,
                  CustomDropdownButton(
                    value: _selectedDeviceType,
                    hintText: "Công nghệ thông tin",
                    items: [
                      DropdownButtonModel(
                        label: "Công nghệ thông tin",
                        value: "it",
                      ),
                      DropdownButtonModel(label: "Y tế", value: "medical"),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDeviceType = value?.value;
                      });
                    },
                  ),
                  24.height,

                  // Xóa bộ lọc
                  CommonButton(
                    title: "Xóa bộ lọc",
                    onTap: () {
                      setState(() {
                        _selectedDepartment = null;
                        _selectedStatus = 'Tất cả';
                        _selectedDeviceType = null;
                      });
                    },
                    buttonColor: AppColors.red_1.withOpacity(0.1),
                    titleColor: AppColors.red_1,
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, color: AppColors.border_2),

          // Bottom Buttons
          Padding(
            padding: 16.pading,
            child: Row(
              children: [
                Expanded(
                  child: CommonButton(
                    title: "Hủy bỏ",
                    onTap: () {
                      Navigator.pop(context);
                    },
                    buttonColor: AppColors.bg_2, // Light grey
                    titleColor: AppColors.black,
                  ),
                ),
                12.width,
                Expanded(
                  child: CommonButton(
                    title: "Lọc danh sách",
                    onTap: () {
                      Navigator.pop(context);
                      // Return result logic can be added here
                    },
                    buttonColor: AppColors.black, // Or Dark Grey
                    titleColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.p5.copyWith(color: AppColors.grey79),
    );
  }
}
