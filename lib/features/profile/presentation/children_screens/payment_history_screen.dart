import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/widgets/base/base_loading.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base_container.dart';
import 'package:BGP_Retail/core/widgets/buttons/filter_button.dart';
import 'package:BGP_Retail/core/widgets/empty_widget.dart';
import 'package:BGP_Retail/core/widgets/textfield/validate_textfield.dart';
import 'package:BGP_Retail/features/profile/data/bloc/payment_history_cubit.dart';
import 'package:BGP_Retail/features/profile/data/bloc/payment_history_state.dart';
import 'package:BGP_Retail/features/profile/data/models/payment_model.dart';
import 'package:BGP_Retail/features/profile/data/repositories/payment_repository.dart';

import '../../../../gen/assets.gen.dart';

@RoutePage()
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    cubit.onRefresh();
    _scroll.onMore(() => cubit.onLoadMore());
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  final cubit = getIt.get<PaymentHistoryCubit>();
  final nav = getIt.get<AppNavigator>();
  final _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentHistoryCubit, PaymentHistoryState>(
      bloc: cubit,
      builder: (context, state) {
        return BaseScreen(
          title: "Lịch sử giao dịch",
          body: RefreshIndicator(
            onRefresh: () async {
              cubit.onRefresh();
            },
            child: Container(
              padding: 16.padingHor,
              child: Column(
                children: [
                  8.height,
                  _headerSearch(state),
                  8.height,
                  state.isLoading
                      ? const BaseLoading()
                      : cubit.list.isEmpty
                          ? const EmptyWidget(
                              title: 'Chưa có lịch sử giao dịch',
                            )
                          : SingleChildScrollView(
                              controller: _scroll,
                              child: Scrollbar(
                                thumbVisibility: true,
                                child: Column(
                                  children: [
                                    ListView.separated(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final payment = cubit.list[index];
                                        return _paymentItem(payment);
                                      },
                                      separatorBuilder: (context, index) =>
                                          16.height,
                                      itemCount: cubit.list.length,
                                    ),
                                    if (cubit.isMore &&
                                        state.stauts == CubitStatus.loaded)
                                      const BaseLoading(),
                                  ],
                                ),
                              ),
                            ).expanded(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _headerSearch(PaymentHistoryState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ValidateTextField(
                initialValue: "",
                // border: true,
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
                hintText: 'Tìm kiếm giao dịch',
                hintStyle: AppTypography.p6.copyWith(
                  color: AppColors.grey_1,
                ),
                maxLines: 1,
                onChanged: cubit.onSearch,
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
            8.width,
            GestureDetector(
              onTap: () async {
                final result = await nav.push(
                  PaymentFilterScreen(
                    end: cubit.to,
                    start: cubit.from,
                    type: cubit.type,
                    wallet: cubit.wallet,
                  ),
                );
                if (result is FilterArgModel) {
                  cubit.setFilter(result);
                }
              },
              child: Badge.count(
                isLabelVisible: cubit.total > 0,
                count: cubit.total,
                child: BaseContainer(
                  borderColor:
                      cubit.total > 0 ? AppColors.main : AppColors.greyA7,
                  width: 50,
                  height: 50,
                  child: Center(
                    child: Assets.icons.icFilter.svg(
                      colorFilter: const ColorFilter.mode(
                        AppColors.greyA7,
                        BlendMode.srcIn,
                      ),
                      width: 14,
                      height: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // 16.height,
        // SizedBox(
        //   height: 45,
        //   child: ListView.separated(
        //     shrinkWrap: true,
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (context, index) {
        //       final transaction = cubit.transactionType[index];
        //       final isSelect = state.indexTransaction == transaction.value;
        //       final title = transaction.title;
        //       return FilterItem(
        //         isSelect: isSelect,
        //         titile: title,
        //         onTap: () => cubit.onFilterTransaction(transaction.value),
        //       );
        //     },
        //     separatorBuilder: (context, index) => 8.width,
        //     itemCount: cubit.transactionType.length,
        //   ),
        // )
      ],
    );
  }

  Widget _paymentItem(PaymentModel? payment) {
    final price = payment?.amount ?? 0;
    final isNotWithdraw = payment?.transType != 3;
    return GestureDetector(
      onTap: () => nav.push(PaymentDetailScreen(code: payment?.code)),
      child: BaseContainer(
        padding: 16.pading,
        child: Row(
          children: [
            walletIcon(payment?.walletData?.type ?? 0),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment?.content ?? "",
                  style: s14w500,
                  maxLines: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(convertDateFormatTime(payment?.createdAt ?? ' ')),
                    4.width,
                    Text(
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      "${!isNotWithdraw ? '-' : (price > 0) ? '+' : ''}${formatCurrency(price)}",
                      overflow: TextOverflow.ellipsis,
                      style: s16w700.copyWith(
                        color: (price > 0 && isNotWithdraw)
                            ? AppColors.main
                            : AppColors.red_1,
                      ),
                    ).expanded(),
                  ],
                ),
              ],
            ).expanded(),
          ],
        ),
      ),
    );
  }

  Widget walletIcon(num type) {
    switch (type) {
      case 1:
        return Assets.icons.icWalletActive.svg();

      case 2:
        return Assets.icons.icWalletGift.svg();

      case 3:
        return Assets.icons.icWalletCrashback.svg();

      case 4:
        return Assets.icons.icWalletSelect.svg();

      default:
        return Assets.icons.icWalletActive.svg();
    }
  }
}

class FilterItem extends StatelessWidget {
  const FilterItem({
    super.key,
    required this.isSelect,
    required this.titile,
    required this.onTap,
  });
  final bool isSelect;
  final String titile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BaseContainer(
        color: isSelect ? AppColors.main : AppColors.white,
        padding: 12.pading,
        child: Text(
          titile,
          style: s14w500.copyWith(
            color: isSelect ? AppColors.white : AppColors.greyA7,
          ),
        ),
      ),
    );
  }
}
