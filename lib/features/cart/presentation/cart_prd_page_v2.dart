import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/base/cubit_state.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/extension/spacing_extension.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/utilities/debouncer.dart';
import 'package:BGP_Retail/core/utilities/dialog_utils.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base_container.dart';
import 'package:BGP_Retail/core/widgets/buttons/btn_icon.dart';
import 'package:BGP_Retail/core/widgets/buttons/main_button.dart';
import 'package:BGP_Retail/core/widgets/cache_image_network_widget.dart';
import 'package:BGP_Retail/core/widgets/common/base_check_box.dart';
import 'package:BGP_Retail/features/cart/data/bloc/cart_bloc_V2.dart';
import 'package:BGP_Retail/features/home/data/model/product_model_v2.dart';
import 'package:BGP_Retail/gen/assets.gen.dart';

@RoutePage()
class CartPrdPageV2 extends StatefulWidget {
  const CartPrdPageV2({super.key});

  @override
  State<CartPrdPageV2> createState() => _CartPrdPageV2State();
}

class _CartPrdPageV2State extends State<CartPrdPageV2> {
  @override
  void initState() {
    super.initState();
    // bloc.getCart();
    // ..getCartV2();
  }

  final bloc = getIt.get<CartV2Bloc>();
  final navigator = getIt.get<AppNavigator>();
  final _debouce = Debouncer();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Giỏ hàng",
      isImageBg: false,
      body: BlocConsumer<CartV2Bloc, CubitState>(
        listener: (context, state) {
          if (state.status == CubitStatus.loadMore) {
            EasyLoading.show();
          } else if (state.status == CubitStatus.loaded ||
              state.status == CubitStatus.success) {
            EasyLoading.dismiss();
          } else if (state.status == CubitStatus.error) {
            EasyLoading.dismiss();
            DialogUtils.showErrorDialog(
              context,
              content: 'Đã có lỗi xảy ra',
            );
          }
        },
        bloc: bloc,
        builder: (context, state) {
          if (bloc.warehouseProduct.isEmpty &&
              state.status != CubitStatus.loadMore) {
            return Center(
              child: const Text(
                'Chưa có sản phẩm được thêm vào giỏ hàng',
                style: s14w400,
                textAlign: TextAlign.center,
              ).padding(16.pading),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => bloc.getCart(),
            child: Padding(
              padding: 8.pading,
              child: ListView.separated(
                itemBuilder: (context, categoryIndex) {
                  final warehousePrd = bloc.warehouseProduct[categoryIndex];
                  final canSelect = bloc.indexSelected == -1 ||
                      bloc.indexSelected == categoryIndex;
                  return Visibility(
                    visible: warehousePrd.items?.isNotEmpty == true,
                    child: BaseContainer(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              BaseCheckbox(
                                value: warehousePrd.isSelect ?? false,
                                onChanged: (value) {
                                  if (canSelect) {
                                    bloc.onSelectWarehouse(warehousePrd);
                                  } else {
                                    _dissableSelectDialog(context);
                                  }
                                },
                              ),
                              16.width,
                              BaseContainer(
                                padding: 4.pading,
                                color: AppColors.red_1,
                                child: Text(
                                  'Shop',
                                  style: s12w500.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              8.width,
                              Text(
                                warehousePrd.shopName ?? '',
                                style: s14w500,
                              ),
                              8.width,
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: AppColors.grey79,
                              ),
                            ],
                          ).padding(16.padingHor + 16.padingTop),
                          if (warehousePrd.items?.isNotEmpty == true)
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final prd = warehousePrd.items![index];
                                return _item(prd, canSelect);
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: warehousePrd.items?.length ?? 0,
                            ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => 16.height,
                itemCount: bloc.warehouseProduct.length,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartV2Bloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          final isIOS = Platform.isIOS;
          return Visibility(
            visible: bloc.totalPrdsSelect > 0,
            child: Container(
              padding: 16.pading + (isIOS ? 8.padingBottom : 0.pading),
              child: Row(
                children: [
                  Visibility(
                    // visible: false,
                    child: GestureDetector(
                      onTap: () {
                        DialogUtils.showConfirmDialog(
                          context,
                          description:
                              "Bạn có muốn xoá tất cả sản phẩm được chọn?",
                          ontap: () {
                            bloc.deletePrds();
                          },
                        );
                      },
                      child: Text(
                        'Xoá đã chọn(${bloc.totalPrdsSelect})',
                        style: s14w500.copyWith(color: AppColors.red_1),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Tổng tiền',
                            style: s14w400,
                          ),
                          Text(
                            formatCurrency(bloc.totalPrice),
                            style: s16w500.copyWith(color: AppColors.main),
                          ),
                        ],
                      ),
                      8.width,
                      MainButton(
                        radius: 8,
                        title: 'Mua(${bloc.totalPrdsSelect})',
                        onTap: () {
                          final prdsSeclect = bloc.warehouseProduct
                              .expand((e) => e.items!)
                              .where((element) => element.isSelect == true)
                              .toList();
                          navigator.push(
                            AsbcCartBuyV2(
                              products: prdsSeclect,
                              option: null,
                              isCart: true,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  FutureOr<dynamic> _dissableSelectDialog(BuildContext context) {
    return DialogUtils.showConfirmDialog(
      doubleBtn: false,
      context,
      rightTitle: 'Đóng',
      title: 'Không thể đặt mua!',
      description: "Chỉ đặt mua sản phẩm trong cùng một shop. Vui lòng thử lại",
    );
  }

  Widget _item(ProductModelV2 cart, bool canSelect) {
    print('SlidableBuild=======');
    final variant = cart.variant?.firstOrNull;
    return Slidable(
      key: Key(cart.id.toString()),
      endActionPane: ActionPane(
        extentRatio: 1 / 2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 1,
            flex: 3,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            onPressed: (context) {
              DialogUtils.showConfirmDialog(
                context,
                description: "Bạn có muốn xoá sản phẩm này?",
                ontap: () => bloc.deletePrds(deletePrds: [cart]),
              );
            },
            backgroundColor: AppColors.red_1,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Xóa',
          ),
        ],
      ),
      child: Container(
        padding: 16.pading,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Row(
                      children: [
                        BaseCheckbox(
                          value: cart.isSelect ?? false,
                          radius: 4,
                          onChanged: (value) {
                            if (canSelect) {
                              bloc.onSelectPrd(cart);
                            } else {
                              _dissableSelectDialog(context);
                            }
                          },
                        ),
                        8.width,
                        Stack(
                          children: [
                            CacheNetworkImageV2(
                              url: cart.variant?.firstOrNull?.image ?? '',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              borderRadius: 8,
                            ),
                            Visibility(
                              visible: cart.cashback != null,
                              child: Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.main.withOpacity(0.8),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                    ),
                                  ),
                                  padding: 4.pading,
                                  child: Row(
                                    children: [
                                      Assets.icons.icMoneyTransfer.svg(
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      4.width,
                                      Text(
                                        '${cart.cashback ?? 0}%',
                                        style: s12w700.copyWith(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      (variant?.title ?? '') * 2,
                      style: s14w400,
                      maxLines: 2,
                    ),
                    Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: List.generate(
                        variant?.option?.length ?? 0,
                        (index) {
                          final option = variant?.option?[index];
                          return Chip(
                            padding: 4.padingHor,
                            side: BorderSide.none,
                            backgroundColor: AppColors.greyEE,
                            shape: RoundedRectangleBorder(
                              borderRadius: 20.radius,
                            ),
                            label: Text(
                              option?.title ?? '',
                              style: s12w400,
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          formatCurrency(
                            variant?.priceSell,
                          ),
                          style: s16w500.copyWith(
                            color: AppColors.main,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            BtnIcon(
                              borderColor: AppColors.greyA7,
                              radius: 4,
                              onTap: () {
                                if ((cart.quantity ?? 0) > 1) {
                                  bloc.onMinus(cart);
                                } else {
                                  DialogUtils.showConfirmDialog(
                                    context,
                                    description:
                                        "Bạn có muốn xoá sản phẩm này?",
                                    ontap: () =>
                                        bloc.deletePrds(deletePrds: [cart]),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: AppColors.grey79,
                              ),
                              size: const Size(30, 30),
                            ),
                            SizedBox(
                              width: 40,
                              child: TextFormField(
                                key: UniqueKey(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: s14w400,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                                initialValue: '${cart.quantity}',
                                onChanged: (value) {
                                  _debouce.run(
                                    () {
                                      final parseQuantity =
                                          num.tryParse(value) ?? 1;
                                      final updateQuantity =
                                          parseQuantity > 0 ? parseQuantity : 1;
                                      bloc.onInput(cart, updateQuantity);
                                    },
                                  );
                                },
                              ),
                            ),
                            BtnIcon(
                              borderColor: AppColors.greyA7,
                              radius: 4,
                              onTap: () {
                                bloc.onAdd(cart);
                              },
                              icon: const Icon(
                                Icons.add,
                                color: AppColors.grey79,
                              ),
                              size: const Size(30, 30),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ).expanded(),
              ],
            ).expanded(),
          ],
        ),
      ),
    );
  }
}
