import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/utilities/localization_helper.dart';
import 'package:bpg_retail/features/booth/data/models/transection_detail_model.dart';
import 'package:bpg_retail/features/home/data/bloc/transection_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gen/assets.gen.dart';

@RoutePage()
class TransectionDetailPage extends StatefulWidget {
  const TransectionDetailPage({
    super.key,
    required this.id,
    required this.price,
  });
  final int? id;
  final num? price;
  @override
  State<TransectionDetailPage> createState() => _TransectionDetailPageState();
}

class _TransectionDetailPageState extends State<TransectionDetailPage> {
  final navigator = getIt<AppNavigator>();
  final bloc = TransactionDetailBloc();
  late ScrollController scroll;
  @override
  void initState() {
    scroll = ScrollController();
    super.initState();
    bloc.initData(widget.id);
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: BaseAppBar(
          centerTitle: true,
          title: trans.translate('po_detail'),
        ),
        body: BlocBuilder<TransactionDetailBloc, CubitState>(
          builder: (context, state) {
            if (state.status == CubitStatus.loading) return const BaseLoading();
            final detail = bloc.detail;

            return RefreshIndicator(
              onRefresh: () async {
                bloc.getDetail();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trans.translate('from'),
                              style: s16w500.copyWith(color: AppColors.main),
                            ),
                            16.height,
                            Text(
                              detail?.warehouseFrom?.name ?? '',
                              style: s16w400,
                            ),
                          ],
                        ).expanded(),
                        Assets.icons.icLineArrow.svg(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              trans.translate('to'),
                              style: s16w500.copyWith(color: AppColors.green_3),
                            ),
                            16.height,
                            Text(
                              detail?.warehouseTo?.name ?? '',
                              style: s16w400,
                            ),
                          ],
                        ).expanded(),
                      ],
                    ),
                    const Divider().padding(16.padingVer),
                    BaseRowItem(
                      title: trans.translate('dn_number'),
                      subtitle: detail?.transactionCode ?? '',
                      titleStyle: s14w400.copyWith(color: AppColors.grey79),
                      subStyle: s14w400.copyWith(color: AppColors.black),
                    ),
                    12.height,
                    BaseRowItem(
                      title: trans.translate('po_date'),
                      subtitle: '${detail?.startDate.toTextDefaulft}',
                      titleStyle: s14w400.copyWith(color: AppColors.grey79),
                      subStyle: s14w400.copyWith(color: AppColors.black),
                    ),
                    12.height,
                    BaseRowItem(
                      title: 'Hire/charges',
                      subtitle: formatCurrency(widget.price),
                      titleStyle: s14w400.copyWith(color: AppColors.grey79),
                      subStyle: s14w400.copyWith(color: AppColors.black),
                    ),
                    const Divider().padding(16.padingVer),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final prd = detail?.transactionItems?[index];
                        final imgsLengt =
                            (prd?.product?.images?.length ?? 0) > 4
                                ? 4
                                : prd?.product?.images?.length ?? 0;
                        return ProductItem(
                          prd: prd,
                          imgsLengt: imgsLengt,
                          scroll: scroll,
                        );
                      },
                      separatorBuilder: (context, index) => 16.height,
                      itemCount: detail?.transactionItems?.length ?? 0,
                    ),
                  ],
                ),
              ),
            );
          },
        ).padding(16.pading),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.prd,
    required this.imgsLengt,
    this.scroll,
  });

  final TransactionItem? prd;
  final int imgsLengt;
  final ScrollController? scroll;

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CacheNetworkImageV2(
              url: prd?.product?.images?.firstOrNull?.image ?? '',
              width: 56,
              height: 56,
              borderRadius: 8,
              fit: BoxFit.contain,
            ),
            8.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prd?.product?.productName ?? '',
                  style: s14w400,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      prd?.product?.productCode ?? '',
                      style: s14w400.copyWith(
                        color: AppColors.grey79,
                      ),
                    ),
                    const Spacer(),
                    RichText(
                      text: TextSpan(
                        text: formatCurrency(prd?.money),
                        style: s14w400.copyWith(
                          color: AppColors.main,
                        ),
                        children: [
                          TextSpan(
                            text: ' / ${trans.translate('day')}',
                            style: AppTypography.p6.copyWith(
                              color: AppColors.grey79,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ).expanded(),
          ],
        ),
        8.height,
        RichText(
          text: TextSpan(
            text: '${trans.translate('quantity')} : ',
            style: s14w400.copyWith(color: AppColors.grey79),
            children: [
              TextSpan(
                text: formatNumberV2(prd?.quantity),
                style: AppTypography.p6.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),
        12.height,
        Text(
          trans.translate('pallet_status'),
          style: s14w400.copyWith(color: AppColors.grey79),
        ),
        12.height,
        BaseContainer(
          borderColor: AppColors.grey79,
          padding: 8.pading,
          color: AppColors.border_1,
          height: 112,
          width: double.infinity,
          child: Scrollbar(
            controller: scroll,
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              controller: scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Text(
                prd?.product?.description ?? '',
                style: s16w400,
              ),
            ),
          ),
        ),
        12.height,
        SizedBox(
          height: 80,
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context.router
                      .push(GalleryRoute(items: prd!, initialIndex: index));
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CacheNetworkImageV2(
                      fit: BoxFit.contain,
                      url: prd?.product?.images?[0].image ?? '',
                      width: 80,
                      height: 80,
                      borderRadius: 8,
                    ),
                    Visibility(
                      visible: index >= 3,
                      child: Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: 8.radius,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5,
                              sigmaY: 5,
                            ),
                            child: BaseContainer(
                              color: AppColors.black.withOpacity(0.3),
                              child: Center(
                                child: Text(
                                  "+${(prd?.product?.images?.length ?? 0) - 3}",
                                  style: s16w700.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => 8.width,
            itemCount: imgsLengt,
          ),
        ),
      ],
    );
  }
}
