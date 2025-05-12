import 'package:auto_route/auto_route.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/preferences/preferences.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/utilities/debouncer.dart';
import 'package:BGP_Retail/core/utilities/dialog_utils.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/widgets/base/base_loading.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base_container.dart';
import 'package:BGP_Retail/core/widgets/buttons/main_button.dart';
import 'package:BGP_Retail/core/widgets/cache_image_network_widget.dart';
import 'package:BGP_Retail/core/widgets/empty_widget.dart';
import 'package:BGP_Retail/core/widgets/textfield/validate_textfield.dart';
import 'package:BGP_Retail/features/profile/data/bloc/my_group_cubit.dart';
import 'package:BGP_Retail/features/profile/data/bloc/my_group_state.dart';
import 'package:flutter/material.dart';
import 'package:BGP_Retail/features/profile/presentation/children_screens/tabs/profile_info.dart';
import '../../../../gen/assets.gen.dart';
import 'package:BGP_Retail/features/profile/data/models/my_group_model.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart' as route;

@RoutePage()
class MyGroupScreen extends StatefulWidget {
  final MyGroupModel? member;
  const MyGroupScreen({this.member, super.key});
  @override
  State<MyGroupScreen> createState() => _MyGroupScreenState();
}

class _MyGroupScreenState extends State<MyGroupScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _ctrl;
  final bloc = getIt.get<MyGroupCubit>();
  final preferences = getIt.get<Preferences>();
  final navigator = getIt.get<AppNavigator>();

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc
      ..getListMember(member: widget.member)
      ..getMyReferrer(member: widget.member);
    _ctrl = TextEditingController();
    _scrollCtrl.onMore(() => bloc.onLoadMore(widget.member));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyGroupCubit>(
      create: (context) => bloc,
      child: BlocBuilder<MyGroupCubit, MyGroupState>(
        builder: (context, state) {
          return (state.isLoading)
              ? const BaseLoading()
              : BaseScreen(
                  isImageBg: false,
                  title: "Đội nhóm của tôi",
                  body: NestedScrollView(
                    controller: _scrollCtrl,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverPadding(
                          padding: 16.padingHor + 16.padingTop,
                          sliver: SliverToBoxAdapter(
                            child: _referenceInfor(
                              widget.member,
                              state.total ?? 0,
                            ),
                          ),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: SliverHeaderGroup(bloc: bloc),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: SliverHeaderSearch(
                            bloc: bloc,
                            controller: _ctrl,
                            member: widget.member,
                          ),
                        ),
                      ];
                    },
                    body: state.listGroup?.isEmpty == true
                        ? const EmptyWidget(
                            title: 'Chưa có thành viên',
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: 16.pading,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final member = state.listGroup?[index];
                                    return InkWell(
                                      onTap: () {
                                        navigator.push(
                                          route.MyGroupScreen(
                                            member: member,
                                          ),
                                        );
                                      },
                                      child: menuItem(member),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      8.height,
                                  itemCount: state.listGroup?.length ?? 0,
                                ),
                                if (bloc.isMore &&
                                    state.status == CubitStatus.loaded)
                                  const BaseLoading().padding(16.padingVer),
                              ],
                            ),
                          ),
                  ),
                );
        },
      ),
    );
  }

  Widget menuItem(MyGroupModel? member) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: 8.radius),
      margin: EdgeInsets.zero,
      child: BaseContainer(
        padding: 16.pading,
        borderRadius: 8,
        color: AppColors.white,
        child: Row(
          children: [
            CacheNetworkImageV2(
              borderRadius: 48,
              url: member?.avatar ?? "",
            ),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  member?.fullName ?? "",
                  style: s16w500,
                ),
                8.height,
                Row(
                  children: [
                    Text(
                      member?.phone ?? "",
                      style: s12w400.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                    DotsIndicator(
                      dotsCount: 1,
                      decorator: const DotsDecorator(
                        color: AppColors.greyA7,
                      ),
                    ),
                    Text(
                      'Từ ${convertDateFormat(
                        member?.referralAt ?? "",
                      )}',
                      style: s12w400.copyWith(
                        color: AppColors.greyA7,
                      ),
                    ),
                  ],
                ),
              ],
            ).expanded(),
            Text(
              '${member?.numberChildren ?? '0'} người',
              style: s12w500.copyWith(
                color: AppColors.greyAA,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _referenceInfor(MyGroupModel? member, int? count) {
    final user = preferences.currentUser.user;
    return Container(
      padding: 24.pading,
      decoration: BoxDecoration(
        borderRadius: 16.radius,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF24C6DC),
            Color(0xFF514A9D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              member != null
                  ? CacheNetworkImageV2(
                      url: member.avatar,
                      borderRadius: 30,
                    )
                  : const AppAvatar(),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            member?.fullName ?? user?.fullname ?? '',
                            style: s14w500.copyWith(color: AppColors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.groups, color: Colors.white, size: 16),
                        4.width,
                        Text(
                          "Đội nhóm",
                          style: s12w400.copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                    4.height,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            member?.phone ?? user?.phoneNumber ?? '',
                            style: s12w400.copyWith(color: AppColors.white),
                          ),
                        ),
                        Text(
                          "${count ?? 0} người",
                          style: s12w500.copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          RichText(
            text: TextSpan(
              text: 'Hoa hồng tích lũy: ',
              style: s12w400.copyWith(color: AppColors.white),
              children: [
                TextSpan(
                  text: formatCurrency(bloc.total),
                  style: s14w700.copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
          8.height,
          Material(
            color: AppColors.blue_1.withOpacity(.2),
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                preferences.currentUser.user?.accountCode.copy;
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Mã giới thiệu: ',
                    style: s12w400.copyWith(color: AppColors.white),
                    children: [
                      TextSpan(
                        text: '${member?.phone ?? user?.accountCode ?? ''} ',
                        style: s12w400.copyWith(color: AppColors.white),
                      ),
                      const WidgetSpan(
                        child: Icon(
                          Icons.copy_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReferalCodeDialog extends StatefulWidget {
  const ReferalCodeDialog({super.key, required this.bloc});
  final MyGroupCubit bloc;

  @override
  State<ReferalCodeDialog> createState() => _ReferalCodeDialogState();
}

class _ReferalCodeDialogState extends State<ReferalCodeDialog> {
  late TextEditingController _referralCtrl;
  final debouncer = Debouncer();
  final navigator = getIt.get<AppNavigator>();
  final userPhone = getIt.get<Preferences>().getUserData.phone;

  @override
  void initState() {
    super.initState();
    _referralCtrl = TextEditingController();
    widget.bloc.clearRefference();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    return BlocConsumer<MyGroupCubit, MyGroupState>(
      bloc: bloc,
      builder: (context, state) {
        final isActive = bloc.message == null && bloc.refference != null;
        return SingleChildScrollView(
          child: Container(
            padding: 24.padingVer + 16.padingHor,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Assets.icons.icRefference.svg(),
                    20.height,
                    const Text(
                      "Nhập mã giới thiệu",
                      style: s20w700,
                    ),
                    12.height,
                    const Text(
                      "Nhập mã giới thiệu của bạn bè, người thân tại đây để tích hoa hồng cho họ",
                      style: s14w400,
                      textAlign: TextAlign.center,
                    ),
                    12.height,
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Mã giới thiệu",
                          style: s14w500,
                        ),
                        4.width,
                        GestureDetector(
                          onTap: () async {
                            final result = await navigator
                                .push(QRCodeScreen(isScanUser: true));
                            if (result is String) {
                              _referralCtrl.text = result.removeAllNonNumeber();
                              verifyPhone(_referralCtrl.text);
                            }
                          },
                          child: const Icon(
                            Icons.qr_code,
                            size: 18,
                            color: AppColors.blue31,
                          ),
                        ),
                      ],
                    ),
                    12.height,
                    ValidateTextField(
                      suffixIcon: isActive
                          ? const Icon(
                              Icons.check,
                              color: AppColors.green65,
                            )
                          : _referralCtrl.text.isEmpty
                              ? null
                              : const Icon(
                                  Icons.error,
                                  color: AppColors.red,
                                ),
                      controller: _referralCtrl,
                      hintText: "Nhập mã giới thiệu",
                      radius: 12,
                      onChanged: (p0) {
                        debouncer.run(
                          () {
                            _referralCtrl.text =
                                _referralCtrl.text.removeAllNonNumeber();
                            verifyPhone(_referralCtrl.text);
                          },
                        );
                      },
                    ),
                    Visibility(
                      visible: isActive,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: 4.padingTop,
                          child: Text(
                            "Mã hợp lệ cho ${bloc.refference?.accountName} (${bloc.refference?.accountCode})",
                            style: s14w500.copyWith(
                              color: AppColors.green65,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: bloc.message != null,
                      child: Padding(
                        padding: 4.padingTop,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            bloc.message ?? '',
                            style: s14w500.copyWith(
                              color: AppColors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    12.height,
                    Container(
                      width: double.infinity,
                      child: MainButton(
                        isDisable: !isActive,
                        largeButton: true,
                        title: "Xác nhận",
                        onTap: () {
                          bloc.updateReferralCode(_referralCtrl.text);
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: navigator.pop,
                    child: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.status == CubitStatus.sendSuccess) {
          print("=====listener2");
          navigator.pop(result: true);
        } else if (state.status == CubitStatus.sendFaild) {
          print("====listener1");
          navigator.pop();
        }
      },
    );
  }

  verifyPhone(String phone) {
    if (phone == userPhone) {
      widget.bloc.setWarningMessage();
    } else {
      widget.bloc.verifyReferralCode(phone);
    }
  }
}

class SliverHeaderGroup extends SliverPersistentHeaderDelegate {
  SliverHeaderGroup({required this.bloc});
  final MyGroupCubit bloc;
  final navigator = getIt.get<AppNavigator>();
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.bg_6,
      padding: 16.padingHor + 8.padingTop,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Người giới thiệu (cấp trên)",
            style: s16w500,
          ),
          8.height,
          if (bloc.refferenceInfor != null)
            _referalItem()
          else
            _buildEmptyReferal(context),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 135;

  @override
  double get minExtent => 135;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  Widget _referalItem() {
    final refferenceInfor = bloc.refferenceInfor;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: 8.radius),
      margin: EdgeInsets.zero,
      child: BaseContainer(
        padding: 16.pading,
        child: Row(
          children: [
            CacheNetworkImageV2(
              url: refferenceInfor?.avatar,
              borderRadius: 30,
            ),
            8.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        refferenceInfor?.fullName ?? "_",
                        style: s14w500,
                      ),
                      // Text(
                      //   "Đội nhóm",
                      //   style: s12w400.copyWith(
                      //     color: AppColors.greyA7,
                      //   ),
                      // ),
                    ],
                  ),
                  8.height,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: convertDateFormat(
                              refferenceInfor?.referralAt ?? "",
                            ),
                            style: s12w400.copyWith(
                              color: AppColors.grey79,
                            ),
                            children: [
                              const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.circle,
                                    color: AppColors.main,
                                    size: 4,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: refferenceInfor?.phone ?? "",
                                style: s12w400.copyWith(
                                  color: AppColors.main,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Text(
                      //   '40 người',
                      //   style: s12w500.copyWith(color: AppColors.black),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyReferal(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: 8.radius),
      margin: EdgeInsets.zero,
      child: BaseContainer(
        padding: 16.pading,
        color: AppColors.white,
        child: Row(
          children: [
            BaseContainer(
              width: 48,
              height: 48,
              color: AppColors.accent_7,
              borderRadius: 30,
              child: Center(
                child: Assets.icons.icUser.svg(width: 30, height: 30),
              ),
            ),
            8.width,
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chưa có thông tin",
                    style: s14w400.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  MainButton(
                    onTap: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: ReferalCodeDialog(bloc: bloc),
                          );
                        },
                      );
                      if (result == true) {
                        DialogUtils.showSuccessDialog(
                          context,
                          content:
                              "Cập nhật thông tin người giới thiệu thành công",
                          hasButtonBack: false,
                          accept: () => navigator.pop(),
                        );
                        bloc.getMyReferrer();
                      }
                    },
                    radius: 8,
                    largeButton: false,
                    title: "Nhập mã",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SliverHeaderSearch extends SliverPersistentHeaderDelegate {
  SliverHeaderSearch({
    required this.bloc,
    required this.controller,
    this.member,
  });
  final MyGroupCubit bloc;
  final TextEditingController? controller;
  final MyGroupModel? member;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return BlocBuilder<MyGroupCubit, MyGroupState>(
      builder: (context, state) {
        return Container(
          padding: 16.padingHor + 8.padingVer,
          color: AppColors.bg_6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thành viên cấp dưới (${state.total ?? 0})",
                style: s16w500,
              ),
              8.height,
              ValidateTextField(
                initialValue: "",
                controller: controller,
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
                hintText: 'Tìm theo tên, số điện thoại',
                hintStyle: AppTypography.p6.copyWith(
                  color: AppColors.grey_1,
                ),
                maxLines: 1,
                onChanged: (value) => bloc.onSearch(value, member),
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
            ],
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => 98;

  @override
  double get minExtent => 98;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
