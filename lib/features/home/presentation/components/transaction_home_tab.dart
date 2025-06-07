import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/utilities/localization_helper.dart';
import 'package:bpg_retail/features/booth/data/models/transection_model.dart';
import 'package:bpg_retail/features/home/data/bloc/transection_bloc.dart';
import 'package:bpg_retail/features/home/presentation/components/balance_table_widget.dart';
import 'package:bpg_retail/features/home/presentation/components/filter_transection_widget.dart';
import 'package:bpg_retail/features/home/presentation/home_page.dart';
import 'package:bpg_retail/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransectionHomeTab extends StatefulWidget {
  const TransectionHomeTab({super.key, required this.bloc});

  final TransactionBloc bloc;

  @override
  State<TransectionHomeTab> createState() => _TransectionHomeTabState();
}

class _TransectionHomeTabState extends State<TransectionHomeTab> {
  final navigator = getIt<AppNavigator>();

  final searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    final trans = AppLocalizations.of(context);
    return BlocBuilder<TransactionBloc, CubitState>(
      builder: (context, state) {
        return Column(
          children: [
            12.height,
            FilterTransactionWidget(bloc: bloc),
            RefreshIndicator(
              onRefresh: () async {
                bloc.getTransaction();
              },
              child: SingleChildScrollView(
                child: state.status == CubitStatus.loading
                    ? const BaseLoading()
                    : Column(
                        children: [
                          TotalBalanceWidget(bloc: bloc),
                          8.height,
                          BalanceTable(bloc: bloc),
                          TitleDivider(
                            title: trans.translate('po_list'),
                          ),
                          widget.bloc.listCustom.isEmpty
                              ? EmptyWidget(
                                  title: trans.translate('empty_warehouse'),
                                )
                              : ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final transection =
                                        widget.bloc.listCustom[index];
                                    return _transectionItem(transection);
                                  },
                                  separatorBuilder: (context, index) =>
                                      12.height,
                                  itemCount: widget.bloc.listCustom.length,
                                ),
                        ],
                      ),
              ),
            ).expanded(),
          ],
        );
      },
    );
  }

  Widget _transectionItem(TransectionModel transection) {
    final trans = AppLocalizations.of(context);
    final isHire = transection.transactionType == 'DEHIRE';
    return GestureDetector(
      onTap: () {
        navigator.push(
          TransectionDetailRoute(
            id: transection.id,
            price: transection.hireCharges,
          ),
        );
      },
      child: BaseContainer(
        padding: 16.pading,
        borderColor: AppColors.grey79,
        child: Column(
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text:
                        '${transection.startDate.toTextDefaulft} - ${transection.endDate.toTextDefaulft}',
                    style: s12w400.copyWith(
                      color: AppColors.black,
                    ),
                    children: [
                      TextSpan(
                        text:
                            ' (${transection.totalDay} ${trans.translate('days')})',
                        style: s12w400.copyWith(
                          color: AppColors.grey79,
                        ),
                      ),
                    ],
                  ),
                ).expanded(),
                Text(
                  transection.transactionCode ?? '',
                  style: s12w400,
                ),
              ],
            ),
            12.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconTransection(transection.transactionType),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      transection.warehouseFromData ?? '',
                      style: s12w400,
                    ),
                    4.width,
                    Assets.icons.icLineArrow.svg(),
                    4.width,
                    Text(
                      transection.warehouseToData ?? '',
                      style: s12w400.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            12.height,
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text:
                        '${trans.translate('stock')}: ${formatNumberV2((transection.stockInTime ?? 0) - (transection.totalQuantity ?? 0))}',
                    style: s12w400.copyWith(
                      color: AppColors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '${transection.totalQuantity}',
                        style: s12w400.copyWith(
                          color: isHire ? AppColors.redC7 : AppColors.green_3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  formatCurrency(transection.hireCharges),
                  style: s14w400.copyWith(
                    color: isHire ? AppColors.redC7 : AppColors.green_3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget iconTransection(String? value) {
    return Row(
      children: [
        value == 'HIRE'
            ? Assets.icons.icCircleArrowUpLeft.svg()
            : Assets.icons.icCircleArrowUpRight.svg(),
        8.width,
        Text(
          value ?? '',
          style: s12w400,
        ),
      ],
    );
  }
}

class TotalBalanceWidget extends StatelessWidget {
  const TotalBalanceWidget({
    super.key,
    required this.bloc,
  });
  final TransactionBloc bloc;

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);
    return BaseContainer(
      borderColor: AppColors.grey79,
      color: AppColors.bg_6,
      padding: 16.pading,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: trans.translate('sub_total'),
                  style: s10w400.copyWith(
                    color: AppColors.greyAA,
                    fontSize: 10,
                  ),
                  children: [
                    TextSpan(
                      text: ' ${formatNumberV2(bloc.totalBalance)}',
                      style: s12w400.copyWith(
                        color: AppColors.grey79,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Vat @ 8%',
                  style: s10w400.copyWith(
                    color: AppColors.greyAA,
                    fontSize: 10,
                  ),
                  children: [
                    TextSpan(
                      text: ' ${formatNumberV2(bloc.totalBalance * 0.08)}',
                      style: s12w400.copyWith(
                        color: AppColors.grey79,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                trans.translate('total'),
                style: s10w400.copyWith(
                  color: AppColors.greyAA,
                  fontSize: 10,
                ),
              ),
              Text(
                formatNumberV2(bloc.totalBalance + bloc.totalBalance * 0.08),
                style: s14w400.copyWith(
                  color: AppColors.main,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DateRangWidget extends StatelessWidget {
  const DateRangWidget({
    super.key,
    required this.start,
    required this.end,
  });

  final String start;
  final String end;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$start - $end',
      style: s14w400.copyWith(
        color: AppColors.grey79,
      ),
    );
  }
}
