import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/core/base/cubit_state.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/widgets/base/base_loading.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base_container.dart';
import 'package:BGP_Retail/core/widgets/empty_widget.dart';
import 'package:BGP_Retail/core/widgets/textfield/validate_textfield.dart';
import 'package:BGP_Retail/features/profile/data/bloc/deposit_withdraw_cubit.dart';
import 'package:BGP_Retail/features/profile/data/bloc/deposit_withdraw_state.dart';
import 'package:flutter/material.dart';
import 'package:BGP_Retail/features/profile/presentation/children_screens/payment_history_screen.dart';
import 'package:BGP_Retail/features/profile/presentation/children_screens/tabs/profile_info.dart';
import 'package:BGP_Retail/features/wallet/data/cubits/wallet_cubit.dart';
import 'package:BGP_Retail/gen/assets.gen.dart';

@RoutePage()
class DepositHistoryScreen extends StatefulWidget {
  const DepositHistoryScreen({
    super.key,
  });

  @override
  State<DepositHistoryScreen> createState() => _DepositHistoryScreenState();
}

class _DepositHistoryScreenState extends State<DepositHistoryScreen> {
  @override
  void initState() {
    super.initState();
    bloc.getHistoryDeposit();
    _ctrl = TextEditingController();
    _scrollCtrl = ScrollController();
  }

  late TextEditingController _ctrl;
  late ScrollController _scrollCtrl;
  final bloc = getIt.get<DepositWithdrawCubit>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Nạp/ rút tiền",
      body: RefreshIndicator(
        onRefresh: () async => bloc.onRefresh(),
        child: Container(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TotalMoneyCard(),
              16.height,
              const Text(
                "Lịch sử lệnh nạp/ rút tiền",
                style: s16w500,
              ),
              16.height,
              ValidateTextField(
                initialValue: "",
                controller: _ctrl,
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
                hintText: 'Tìm mã, số tiền, ngân hàng',
                hintStyle: AppTypography.p6.copyWith(
                  color: AppColors.grey_1,
                ),
                maxLines: 1,
                onChanged: bloc.onSearch,
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
              16.height,
              BlocBuilder<DepositWithdrawCubit, DepositWithdrawState>(
                bloc: bloc,
                builder: (context, state) {
                  return SizedBox(
                    height: 45,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final filter = bloc.listFilter[index];
                        final isSelect = state.index == filter.value;
                        final title = filter.title;
                        return FilterItem(
                          isSelect: isSelect,
                          titile: title,
                          onTap: () => bloc.onFilter(filter.value),
                        );
                      },
                      separatorBuilder: (context, index) => 8.width,
                      itemCount: bloc.listFilter.length,
                    ),
                  );
                },
              ),
              16.height,
              Expanded(
                child: BlocBuilder<DepositWithdrawCubit, DepositWithdrawState>(
                  bloc: bloc,
                  builder: (context, state) {
                    if (state.isLoading == true) {
                      return const BaseLoading();
                    }
                    if (state.listHistory?.isEmpty == true) {
                      return const EmptyWidget(
                        title: 'Chưa có lịch sử nạp/rút tiền',
                      );
                    }
                    return ListView.separated(
                      controller: _scrollCtrl,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final detail = state.listHistory?[index];
                        final isWithdraw = detail?.requestType == 2;
                        final status = detail?.status;
                        return BaseContainer(
                          padding: 16.pading,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BaseContainer(
                                padding: 4.pading,
                                borderRadius: 30,
                                borderColor: textColor(status),
                                color: backroundColor(status),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: 2.padingHor,
                                      decoration: BoxDecoration(
                                        color: textColor(status),
                                        borderRadius: 8.radius,
                                      ),
                                    ),
                                    4.width,
                                    Text(
                                      withdrawStatus(status),
                                      style: s12w500.copyWith(
                                        color: textColor(status),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              8.height,
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  isWithdraw
                                      ? Assets.icons.icMoney.svg(
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.main,
                                            BlendMode.srcIn,
                                          ),
                                          width: 40,
                                        )
                                      : Assets.icons.icMoney2.svg(
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.blue31,
                                            BlendMode.srcIn,
                                          ),
                                          width: 40,
                                        ),
                                  8.width,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              isWithdraw
                                                  ? "Rút tiền"
                                                  : "Nạp tiền",
                                              style: s16w500,
                                            ),
                                            Text(
                                              "${isWithdraw ? "-" : "+"} ${formatCurrency(
                                                detail?.amount ?? 0,
                                              )}",
                                              style: s16w500,
                                            ),
                                          ],
                                        ),
                                        4.height,
                                        Row(
                                          children: [
                                            Text(
                                              detail?.userData?.referralCode ??
                                                  "_",
                                              style: s12w400,
                                            ),
                                            Container(
                                              width: 4,
                                              height: 4,
                                              margin: 4.pading,
                                              decoration: BoxDecoration(
                                                color: AppColors.grey79,
                                                borderRadius: 8.radius,
                                              ),
                                            ),
                                            Text(
                                              convertDateFormatTime(
                                                detail?.userData?.systemData
                                                        ?.createdAt ??
                                                    "",
                                              ),
                                              style: s12w400,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => 8.height,
                      itemCount: state.listHistory?.length ?? 0,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String withdrawStatus(num? status) {
    switch (status) {
      case 1:
        return "CHỜ DUYỆT";
      case 2:
        return "ĐANG XỬ LÝ";
      case 3:
        return "HOÀN THÀNH";
      case 4:
        return "TỪ CHỐI";
      default:
        return "CHỜ DUYỆT";
    }
  }

  Color backroundColor(num? status) {
    switch (status) {
      case 1:
        return AppColors.yellowFF;
      case 2:
        return AppColors.blue_2;
      case 3:
        return AppColors.green_2;
      case 4:
        return AppColors.red_2;
      default:
        return AppColors.yellowFF;
    }
  }

  Color textColor(num? status) {
    switch (status) {
      case 1:
        return AppColors.yellowD2;
      case 2:
        return AppColors.blue31;
      case 3:
        return AppColors.green_1;
      case 4:
        return AppColors.red_1;
      default:
        return AppColors.yellowD2;
    }
  }
}

class TotalMoneyCard extends StatefulWidget {
  const TotalMoneyCard({
    super.key,
  });

  @override
  State<TotalMoneyCard> createState() => _TotalMoneyCardState();
}

class _TotalMoneyCardState extends State<TotalMoneyCard> {
  final walletCubit = WalletCubit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, CubitState>(
      bloc: walletCubit..getWallets(),
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              height: 142,
              padding: 24.pading,
              decoration: BoxDecoration(
                borderRadius: 16.radius,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF24C6DC),
                    Color(0xFF514A9D),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Tổng tiền có thể rút",
                      style: s14w400.copyWith(color: AppColors.white),
                    ),
                  ),
                  8.height,
                  Center(
                    child: Text(
                      formatCurrency(walletCubit.getWallet(0)?.balance ?? 0),
                      style: s20w700.copyWith(color: AppColors.white),
                    ),
                  ),
                  8.height,
                ],
              ),
            ),
            DepositWithdrawTab(),
          ],
        );
      },
    );
  }
}
