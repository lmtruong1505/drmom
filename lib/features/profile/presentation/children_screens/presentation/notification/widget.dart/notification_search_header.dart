import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/widgets/buttons/extra_button.dart';
import 'package:BGP_Retail/core/widgets/textfield/validate_textfield.dart';
import 'package:BGP_Retail/features/profile/data/bloc/notification_bloc.dart';
import 'package:BGP_Retail/features/profile/data/bloc/notification_state.dart';

class SearchHeader extends StatelessWidget {
  SearchHeader({
    super.key,
    required this.bloc,
  });

  final NotificationCubit bloc;
  final List<Map<String, dynamic>> itemsFilter = [
    {"label": "Đơn hàng", "value": "TM_ORDER"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ValidateTextField(
                  margin: EdgeInsets.zero,
                  backgroundColor: AppColors.white,
                  hintText: 'Tìm kiếm thông báo',
                  hintStyle: AppTypography.p6.copyWith(
                    color: AppColors.grey_1,
                  ),
                  maxLines: 1,
                  onChanged: (value) {
                    bloc.onSearch(value);
                  },
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 15,
                    bottom: 14,
                  ),
                  leadingIcon: const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.search,
                      size: 20,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                return Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ExtraButton(
                    onTap: bloc.onFilter,
                    borderColor:
                        state.isFilter ? AppColors.main : AppColors.border_2,
                    padding: EdgeInsets.zero,
                    largeButton: false,
                    icon: Icon(
                      Icons.filter_list,
                      size: 20,
                      color: state.isFilter ? AppColors.main : AppColors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            Map<String, dynamic>? selected;

            if (state.notificationType.isNotEmpty) {
              selected = itemsFilter.firstWhere(
                (e) => e['value'] == state.notificationType,
              );
            }

            return state.isFilter
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Text(
                            selected != null
                                ? selected["label"]
                                : "Loại thông báo",
                            style: selected != null
                                ? AppTypography.p5.copyWith(
                                    color: AppColors.blackish,
                                  )
                                : AppTypography.p6.copyWith(
                                    color: AppColors.grey_1,
                                  ),
                          ),
                          items: itemsFilter.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item["label"] ?? '',
                                style: AppTypography.p5.copyWith(
                                  color: AppColors.blackish,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (Map<String, dynamic>? item) {
                            bloc.onNotificationType(item!['value']);
                          },
                          iconStyleData: IconStyleData(
                            icon: selected != null
                                ? GestureDetector(
                                    onTap: () {
                                      bloc.onNotificationType("");
                                    },
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 20,
                                    ),
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
                            openMenuIcon: const Icon(
                              Icons.keyboard_arrow_up_rounded,
                            ),
                            iconSize: 24,
                          ),
                          buttonStyleData: ButtonStyleData(
                            height: 45,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.border_2,
                                width: 1.2,
                              ),
                            ),
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 1,
                            ),
                            width: double.infinity,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 36,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            offset: const Offset(0, -2),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
