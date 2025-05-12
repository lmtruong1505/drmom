import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/app/data/bloc/app_cubit.dart';
import 'package:BGP_Retail/app/data/bloc/app_state.dart';
import 'package:BGP_Retail/core/base/base_state.dart';
import 'package:BGP_Retail/core/configs/firebase_analytics_config.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/spacing.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/utilities/assets.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/widgets/appbar_back_button.dart';
import 'package:BGP_Retail/core/widgets/base/base_loading.dart';
import 'package:BGP_Retail/core/widgets/base/scaffold.dart';
import 'package:BGP_Retail/core/widgets/common/base_check_box.dart';
import 'package:flutter/material.dart';
import 'package:BGP_Retail/features/profile/data/bloc/notification_bloc.dart';
import 'package:BGP_Retail/features/profile/data/bloc/notification_state.dart';
import 'package:BGP_Retail/features/profile/data/models/notification_model.dart';
import 'package:BGP_Retail/features/profile/presentation/children_screens/presentation/notification/widget.dart/notification_select_all.dart';

@RoutePage(name: "NotificationPage")
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState
    extends BaseState<NotificationPage, NotificationCubit> {
  List<NotificationModel> notifyList = [];

  final _scrollCtrl = ScrollController();

  Widget _notificationItem(
    NotificationModel item,
    int index,
    bool showCheckBox,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showCheckBox) ...[
                Opacity(
                  opacity: item.status == true ? 1 : 0.1,
                  child: BaseCheckbox(
                    value: item.isChecked ?? false,
                    onChanged: (value) {
                      if (item.status == true) {
                        bloc.onCheckedItem(item.id ?? 0);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: InkWell(
                  onTap: () async {
                    bloc.markAsSeen(item.id, item.key);
                    final routeNoti = item.getRoute();
                    // appCubit.setCustomId(item.customId!);
                    final result = await navigator.push(routeNoti);
                    if (result is bool) {
                      bloc.updateReadedNoti([item.id ?? 0]);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Badge(
                        backgroundColor: item.isFailed == true
                            ? AppColors.red_1
                            : AppColors.accent_1,
                        isLabelVisible: item.status == false,
                        child: Assets.icon(
                          assetName: item.isFailed == true
                              ? "ic_noti_return.svg"
                              : "ic_noti_sucess.svg",
                          width: 40,
                          height: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: Spacing.v4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title ?? '',
                                      style: AppTypography.p4.copyWith(
                                        fontWeight: AppTypography.medium,
                                      ),
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  PopupMenuButton<PopupMenuItem>(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    iconSize: 18.0,
                                    position: PopupMenuPosition.over,
                                    offset: const Offset(-10, 20),
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          height: 30,
                                          onTap: () {
                                            _showDialogDelete(item);
                                          },
                                          child: Text(
                                            'Xoá bỏ',
                                            style: AppTypography.p5.copyWith(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ];
                                    },
                                    child: Container(
                                      height: 36,
                                      width: 48,
                                      alignment: Alignment.topRight,
                                      child: const Icon(
                                        Icons.more_vert,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                item.content ?? '',
                                style: AppTypography.p6,
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                convertDateFormatTime(
                                  item.createdAt ?? '',
                                ),
                                style: AppTypography.p5.copyWith(
                                  color: AppColors.grey_1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  FutureOr<dynamic> _showDialogDelete(NotificationModel item) {
    return navigator.showSuccessDialog(
      title: 'Xác nhận xoá',
      mainTitle: 'Xác nhận',
      extraTitle: 'Hủy',
      content: 'Bạn chắc chắn muốn xoá thông báo này?',
      hasButtonBack: true,
      icon: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Assets.icon(assetName: 'ic_warning.svg'),
      ),
      accept: () {
        bloc.deleteOne(item.id, item.key);
        navigator.back();
      },
      extraAccept: () {
        navigator.back();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _scrollCtrl.addListener(() {
      final maxScroll = _scrollCtrl.position.maxScrollExtent;
      final currentScroll = _scrollCtrl.position.pixels;

      final isEndPage = currentScroll >= (maxScroll * 0.9);
      if (isEndPage && bloc.isMore && !bloc.state.isLoading) {
        bloc.onLoadMoreNoti();
      }
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listener: (context, state) {
        if (state.isLoggedIn) {
          bloc.getListNotiFromAPI();
        }
      },
      child: RefreshIndicator(
        color: AppColors.main,
        onRefresh: () async {
          bloc.getListNotiFromAPI();
        },
        child: BaseScaffold(
          body: Container(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                AppBarBackButton(),
                const SizedBox(height: 16),
                const Text(
                  'Thông báo',
                  style: AppTypography.h4,
                ),
                // const SizedBox(height: 16),
                // SearchHeader(bloc: bloc),
                NotificationSelectAll(bloc: bloc),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<NotificationCubit, NotificationState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const BaseLoading();
                      }
                      if (state.notificationType == "SYSTEM") {
                        return const SizedBox.shrink();
                      }
                      final notifyListDB = state.notifyListDB;

                      if (notifyListDB.isEmpty) {
                        return const Align(
                          alignment: Alignment.center,
                          child: Text("Không có dữ liệu"),
                        );
                      }

                      return SingleChildScrollView(
                        controller: _scrollCtrl,
                        child: Column(
                          children: [
                            ListView.separated(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = notifyListDB[index];
                                return _notificationItem(
                                  item,
                                  index,
                                  state.isDeleteMany,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 16);
                              },
                              itemCount: notifyListDB.length,
                            ),
                            if (state.status == CubitStatus.loading)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
