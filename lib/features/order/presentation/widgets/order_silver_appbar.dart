import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/spacing.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/widgets/buttons/filter_button.dart';
import 'package:bpg_retail/features/order/data/bloc/total_order_cubit.dart';
import 'package:bpg_retail/features/order/data/bloc/total_order_state.dart';
import 'package:bpg_retail/features/order/data/models/order_count_asbc_model.dart';
import 'package:bpg_retail/features/order/data/models/total_order_model.dart';
import 'package:bpg_retail/gen/assets.gen.dart';

class OrderSilverAppBar extends SliverPersistentHeaderDelegate {
  // final double paddingTop;
  final double expandedHeight;
  final List<FilterButtonModel> filterList;
  final Function(FilterButtonModel) onTap;

  OrderSilverAppBar({
    required this.expandedHeight,
    // required this.paddingTop,
    required this.filterList,
    required this.onTap,
  });
  final bloc = getIt.get<TotalOrderCubit>();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return BlocProvider(
      create: (context) => bloc..getTotalOrder(),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 0,
              // bottom: 20,
              left: 20,
              right: 20,
            ),
            child: Container(
              padding: Spacing.a4,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(Assets.images.backgroundGradient.path),
                  fit: BoxFit.cover,
                ),
              ),
              child: BlocBuilder<TotalOrderCubit, TotalOrderState>(
                builder: (context, state) {
                  final total = state.totalOrder;

                  return GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    childAspectRatio: 1.5,
                    children: List.generate(
                      filterList.length,
                      (index) {
                        final order = filterList[index];
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onTap(order),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (order.icon != null) ...[
                                        order.icon!,
                                        const SizedBox(height: 8),
                                      ],
                                      Text(
                                        order.title,
                                        style: AppTypography.p6.copyWith(
                                          color: AppColors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (total != null && total.isNotEmpty)
                                  Positioned(
                                    top: 10,
                                    right: 20,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      width: 20,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        findCountByCode(
                                          total,
                                          order.value ?? "",
                                        ).toString(),
                                        style: AppTypography.p8.copyWith(
                                          color: AppColors.accent_8,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  int quantity(String status, TotalOrderModel total) {
    switch (status) {
      case "CLH":
        return (total.pickUp ?? 0).toInt();
      case "APPROVED":
        return (total.approved ?? 0).toInt();
      case "SHIPPING":
        return (total.shipping ?? 0).toInt();
      case "DELIVERED":
        return (total.delivered ?? 0).toInt();
      case "DONE":
        return (total.done ?? 0).toInt();
      case "RETURN":
        return (total.totalOrderReturn ?? 0).toInt();
      case "CANCEL":
        return (total.cancel ?? 0).toInt();
      default:
        return 0;
    }
  }

  num findCountByCode(List<OrderCountAsbcModel>? items, String code) {
    try {
      if (items?.isEmpty == true) {
        return 0;
      }
      final item = items?.firstWhere(
        (element) => element.code == code,
        orElse: () => const OrderCountAsbcModel(),
      );

      return item?.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
