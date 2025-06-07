import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/cache_image_network_widget.dart';
import 'package:bpg_retail/features/card/data/models/card_model.dart';

import 'bts_checkout_card.dart';

class CardItem extends StatelessWidget {
  final CardModel model;
  final int? index;
  const CardItem({
    super.key,
    required this.model,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final size = context.width / 100;
    final double percent = model.price.validator > 0
        ? model.priceCurrent.validator / model.price.validator
        : 1;
    final cashback = ((model.cashback.validator * model.price.validator) / 100);
    final datimeFuture = DateTime.now().add(
      Duration(days: (100 / (model.cashback ?? 1)).toInt()),
    );
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 210,
            child: Stack(
              children: [
                CacheNetworkImageV2(
                  height: 210,
                  url: model.image ?? '',
                  width: double.infinity,
                  fit: BoxFit.fill,
                  borderRadius: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            model.title ?? "",
                            style: s20w700.copyWith(color: AppColors.white),
                          ),
                          if (index != null)
                            Text(
                              index.toString(),
                              style: s20w700.copyWith(color: AppColors.white),
                            ),
                        ],
                      ),
                      12.height,
                      Center(
                        child: Text(
                          formatNumberWithSpaces(model.code ?? ""),
                          style: s20w700.copyWith(color: AppColors.white),
                        ),
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${model.cashback}% Cashback",
                            style: s16w500.copyWith(color: AppColors.white),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "HẠN \nDÙNG",
                                style: s12w500.copyWith(
                                  color: AppColors.white,
                                  fontSize: 8,
                                ),
                              ),
                              4.width,
                              Text(
                                convertStringToYYMM(datimeFuture),
                                style: s16w500.copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trị giá",
                            style: s12w500.copyWith(color: AppColors.white),
                          ),
                          Text(
                            "Quà tặng",
                            style: s12w500.copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                      4.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatCurrency(model.price ?? 0),
                            style: s14w500.copyWith(color: AppColors.white),
                          ),
                          Text(
                            "${formatCurrency((model.price ?? 0) * (model.cashback ?? 0) / 100)} /ngày",
                            style: s14w500.copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          8.height,
          // Text(
          //   model.title ?? '',
          //   style: s14w500,
          // ),
          // 4.height,

          Visibility(
            visible: model.isMyCard == true,
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.7,
                  child: CacheNetworkImageV2(
                    url: model.image ?? '',
                    height: 46,
                    width: context.width,
                    fit: BoxFit.cover,
                    borderRadius: 8,
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lãi tích luỹ',
                              style: s12w500.copyWith(color: AppColors.white),
                            ),
                            Text(
                              '${model.priceCurrent == null ? '' : '${model.priceCurrent.toPrice()} /'} ${model.price.toPrice(type: ' đ')}',
                              style: s12w500.copyWith(color: AppColors.white),
                            ),
                          ],
                        ),
                        if (model.cashback != null &&
                            model.isMyCard != true) ...[
                          4.height,
                          Row(
                            children: [
                              Text(
                                'Cashback ${model.cashback ?? 0}',
                                style: s14w400.copyWith(color: AppColors.white),
                              ),
                              const Spacer(),
                              Text(
                                '${(cashback / (24 * 60 * 60)).toPrice(type: 'VNĐ')}/Giây',
                                style: s14w400.copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                        ],
                        if (model.priceCurrent != null &&
                            model.isMyCard == true) ...[
                          4.height,
                          Container(
                            height: 14,
                            width: context.width - 50,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: AppColors.greyEE,
                              borderRadius: 16.radius,
                            ),
                            child: LinearProgressIndicator(
                              color: AppColors.main,
                              value: percent,
                              borderRadius: 16.radius,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (model.isMyCard != true) ...[
            8.height,
            Container(
              width: double.infinity,
              child: ExtraButton(
                bgColor: AppColors.main.withOpacity(0.2),
                borderColor: AppColors.main,
                color: AppColors.main,
                onTap: () {
                  context.bottomSheet(
                    BtsCheckoutCard(model: model),
                  );
                },
                largeButton: true,
                title: 'Mua ngay',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
