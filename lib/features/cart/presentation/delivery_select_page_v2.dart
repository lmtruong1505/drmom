import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/spacing.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/extension/string_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/screens.dart';
import 'package:bpg_retail/core/widgets/appbar_back_button.dart';
import 'package:bpg_retail/core/widgets/base/base_loading.dart';
import 'package:bpg_retail/core/widgets/base/scaffold.dart';
import 'package:bpg_retail/core/widgets/two_button_box.dart';
import 'package:bpg_retail/features/cart/data/bloc/cart_cubit_v2.dart';
import 'package:bpg_retail/features/cart/data/bloc/cart_state_v2.dart';
import 'package:bpg_retail/features/cart/data/models/delivery_model.dart';

import 'package:bpg_retail/features/cart/data/models/ghtk_model.dart';

@RoutePage(name: "DeliverySelectPageV2")
class DeliverySelectV2Page extends StatefulWidget {
  const DeliverySelectV2Page(this.senderAddress);

  final String senderAddress;

  @override
  State<DeliverySelectV2Page> createState() => _DeliverySelectV2PageState();
}

class _DeliverySelectV2PageState extends State<DeliverySelectV2Page> {
  final _cubit = getIt.get<CartCubitV2>();
  final navigator = getIt.get<AppNavigator>();
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubitV2, CartStateV2>(
      builder: (context, state) {
        final isSelectGHTK =
            DeliveryShipping.ghtk == state.deliverySelected?.deliveryShipping;
        final isSelectPickUp =
            DeliveryShipping.pickUp == state.deliverySelected?.deliveryShipping;
        return BaseScaffold(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
            height: heightDevice(context),
            width: widthDevice(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarBackButton(),
                  40.height,
                  const Text("Hình thức vận chuyển", style: s18w700),
                  16.height,
                  const Text(
                    "Bạn có thể lựa chọn một trong các hình thức vận chuyển của Long Hải sau đây:",
                    style: s14w400,
                  ),
                  8.height,
                  _buildContainer(
                    widget: GestureDetector(
                      onTap: () {
                        _cubit.onSelectDelivery(
                          DeliveryTypeModel(
                            deliveryShipping: DeliveryShipping.pickUp,
                            address: widget.senderAddress,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          if (isSelectPickUp)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                              ),
                              child: Container(
                                width: 4,
                                height: 50,
                                color: AppColors.main,
                              ),
                            ),
                          Image.asset(
                            "assets/images/img_store.png",
                            width: 48,
                            height: 48,
                          ),
                          8.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Nhận tại cửa hàng",
                                  style: s14w500,
                                ),
                                Text(
                                  widget.senderAddress,
                                  style: s12w400,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  16.height,
                  _buildViettelPost(state),
                  16.height,
                  // _buildGHTK(state, isSelectGHTK),
                ],
              ),
            ),
          ),
          bottomNavigationBar: TwoButtonBox(
            rightTitle: 'Xác nhận',
            leftTitle: 'Huỷ bỏ',
            leftOnTap: () {
              // widget.onSelected?.call(_cubit.state.itemSelected);
              navigator.pop();
            },
            rightOnTap: () {
              // widget.onSelected?.call(_cubit.state.deliverySelect);
              navigator.pop(result: _cubit.state.deliverySelected);
            },
          ),
        );
      },
    );
  }

  // Container _buildGHTK(CartStateV2 state, bool isSelectGHTK) {
  //   return Container(
  //     child: state.isLoading
  //         ? const BaseLoading()
  //         : Container(
  //             child: state.ghtk == null
  //                 ? const SizedBox.shrink()
  //                 : _buildContainer(
  //                     widget: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Column(
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Image.asset(
  //                                   "assets/images/img_ghtk.png",
  //                                   width: 48,
  //                                   height: 48,
  //                                 ),
  //                                 8.width,
  //                                 const Text(
  //                                   "Giao hàng tiết kiệm",
  //                                   style: s14w500,
  //                                 ),
  //                               ],
  //                             ),
  //                             InkWell(
  //                               onTap: () {
  //                                 _cubit.onSelectDelivery(
  //                                   DeliveryTypeModel(
  //                                     deliveryShipping: DeliveryShipping.ghtk,
  //                                     type: "Giao hàng tiết kiệm",
  //                                     price: state.ghtk?.moneyTotal,
  //                                     time: "48 giờ",
  //                                   ),
  //                                 );
  //                               },
  //                               child: Column(
  //                                 children: [
  //                                   const Divider(),
  //                                   Row(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.end,
  //                                     children: [
  //                                       if (isSelectGHTK)
  //                                         Padding(
  //                                           padding:
  //                                               const EdgeInsets.only(right: 8),
  //                                           child: Container(
  //                                             width: 4,
  //                                             height: 50,
  //                                             color: AppColors.main,
  //                                           ),
  //                                         ),
  //                                       Column(
  //                                         crossAxisAlignment:
  //                                             CrossAxisAlignment.start,
  //                                         children: [
  //                                           RichText(
  //                                             text: TextSpan(
  //                                               children: [
  //                                                 TextSpan(
  //                                                   text: "Phí giao hàng ",
  //                                                   style: s14w500.copyWith(
  //                                                     color: AppColors.black,
  //                                                   ),
  //                                                 ),
  //                                                 TextSpan(
  //                                                   text: formatCurrency(
  //                                                     state.ghtk?.moneyTotal
  //                                                             ?.toDouble() ??
  //                                                         0,
  //                                                   ),
  //                                                   style: s14w400.copyWith(
  //                                                     color: AppColors.main,
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                           gapHeight(sp8),
  //                                           Text(
  //                                             'Thời gian dự kiến ${convertDateYYYYMMDD(now.add(const Duration(days: 4)))}',
  //                                             style: s12w400.copyWith(
  //                                               color: AppColors.black,
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //           ),
  //   );
  // }

  Container _buildViettelPost(CartStateV2 state) {
    return Container(
      child: state.isLoading
          ? const BaseLoading()
          : state.lstviettelPost.isEmpty
              ? const SizedBox.shrink()
              : _buildContainer(
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/img_viettel_post.png",
                                width: 48,
                                height: 48,
                              ),
                              8.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Viettel Post",
                                    style: s14w400,
                                  ),
                                  8.height,
                                  Text(
                                    "Chương trình : (Miễn phí vận chuyển)",
                                    style:
                                        s12w500.copyWith(color: AppColors.bg_3),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final item = state.lstviettelPost[index];
                              final isSelected = (item.tenDichvu ==
                                  state.deliverySelected?.type);
                              final datetime = now.add(
                                Duration(
                                  days: convertHoursToDays(
                                    item.thoiGian ?? "",
                                  ),
                                ),
                              );
                              return _viettelPostItem(
                                item,
                                isSelected,
                                datetime,
                              );
                            },
                            separatorBuilder: (context, index) => 16.height,
                            itemCount: state.lstviettelPost.length,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  InkWell _viettelPostItem(
    ViettelPostModel item,
    bool isSelected,
    DateTime datetime,
  ) {
    return InkWell(
      onTap: () {
        _cubit.onSelectDelivery(
          DeliveryTypeModel(
            deliveryShipping: DeliveryShipping.viettelPost,
            type: item.tenDichvu,
            price: item.giaCuoc,
            time: item.thoiGian,
            code: item.maDvChinh,
          ),
        );
      },
      child: Column(
        children: [
          const Divider(),
          // 16.verticalSpacing,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    width: 4,
                    height: 50,
                    color: AppColors.main,
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${item.tenDichvu}  ",
                          style: s14w500.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        TextSpan(
                          text: formatCurrency(
                            item.giaCuoc?.toDouble() ?? 0,
                          ),
                          style: s14w400.copyWith(
                            color: AppColors.main,
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapHeight(sp8),
                  Text(
                    'Thời gian dự kiến ${convertDateYYYYMMDD(datetime)}',
                    style: s12w400.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContainer({required Widget widget}) {
    return Container(
      padding: Spacing.a16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
        border: Border.all(color: AppColors.bg_3),
      ),
      child: widget,
    );
  }
}

int convertHoursToDays(String? input) {
  if (input.nullOrEmpty) {
    return 0;
  }
  final hours = int.tryParse(input!.split(' ')[0]) ?? 0;
  final days = (hours / 24).round();
  return days;
}
