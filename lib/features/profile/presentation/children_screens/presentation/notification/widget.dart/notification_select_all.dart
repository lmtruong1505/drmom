import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/spacing.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/utilities/assets.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/utilities/loading.dart';
import 'package:BGP_Retail/core/widgets/buttons/filter_button.dart';
import 'package:BGP_Retail/core/widgets/common/base_check_box.dart';
import 'package:BGP_Retail/features/profile/data/bloc/notification_bloc.dart';
import 'package:BGP_Retail/features/profile/data/bloc/notification_state.dart';

class NotificationSelectAll extends StatelessWidget {
  NotificationSelectAll({
    super.key,
    required this.bloc,
  });

  final NotificationCubit bloc;
  final navigator = getIt.get<AppNavigator>();

  final filterList = <FilterButtonModel>[
    const FilterButtonModel(title: "Tất cả", value: null),
    const FilterButtonModel(title: "Chưa đọc", value: 0),
    const FilterButtonModel(title: "Đã đọc", value: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state.notificationType == "SYSTEM") {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            FilterButton(
              listFilter: filterList,
              selectFilter:
                  filterList.firstWhere((e) => e.value == state.filter),
              handleSelectFilter: (selected) {
                bloc.onChangeFilter(selected.value);
              },
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: Spacing.a16,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1.2,
                  color: AppColors.accent_3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BlocBuilder<NotificationCubit, NotificationState>(
                      builder: (context, state) {
                        return state.isDeleteMany
                            ? Row(
                                children: [
                                  GestureDetector(
                                    onTap: _showDialog,
                                    child: Text(
                                      "Xóa ngay",
                                      style: AppTypography.h6.copyWith(
                                        color: bloc.listNotiSelected.isNotEmpty
                                            ? AppColors.red_1
                                            : AppColors.red_1.withOpacity(0.4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  InkWell(
                                    onTap: () => bloc.onChecked(false),
                                    child: const Text(
                                      "Hủy bỏ",
                                      style: AppTypography.h6,
                                    ),
                                  ),
                                ],
                              )
                            : GestureDetector(
                                onTap: bloc.openDeleteMany,
                                child: const Text(
                                  "Xóa hàng loạt",
                                  style: AppTypography.h6,
                                ),
                              );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        bloc.markAsSeenAll();
                      },
                      child: Text(
                        "Đánh dấu đã đọc (${state.totalUnread})",
                        style: AppTypography.h6.copyWith(
                          color: AppColors.main,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state.isDeleteMany) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: Spacing.a16,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1.2,
                    color: AppColors.accent_3,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BaseCheckbox(
                      value: state.isChecked,
                      onChanged: bloc.onChecked,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        bloc.onChecked(!state.isChecked);
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 1,
                          ),
                          Text(
                            ' Chọn tất cả thông báo đã đọc',
                            style: AppTypography.p4.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
      listener: (BuildContext context, NotificationState state) {
        if (state.status == CubitStatus.loading) {
          showLoading();
        } else {
          EasyLoading.dismiss();
        }
      },
    );
  }

  FutureOr _showDialog() {
    if (bloc.listNotiSelected.isEmpty) return null;

    return navigator.showSuccessDialog(
      title: 'Xác nhận xoá',
      mainTitle: 'Xác nhận',
      extraTitle: 'Hủy',
      content: 'Bạn chắc chắn muốn xoá các thông báo đã chọn?',
      hasButtonBack: true,
      icon: Padding(
        padding: const EdgeInsets.only(
          top: 16,
        ),
        child: Assets.icon(
          assetName: 'ic_warning.svg',
        ),
      ),
      accept: () {
        bloc.deleteMany();
        navigator.back();
      },
      extraAccept: () {
        navigator.back();
      },
    );
  }
}
