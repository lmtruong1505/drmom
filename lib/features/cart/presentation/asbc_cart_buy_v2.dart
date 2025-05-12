import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/base/cubit_state.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/extension/string_extension.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/preferences/preferences.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/utilities/funtion.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base_container.dart';
import 'package:BGP_Retail/core/widgets/buttons/main_button.dart';
import 'package:BGP_Retail/core/widgets/cache_image_network_widget.dart';
import 'package:BGP_Retail/core/widgets/row_item.dart';
import 'package:BGP_Retail/core/widgets/textfield/validate_textfield.dart';
import 'package:BGP_Retail/features/cart/data/bloc/asbc_cart_buy_cubit.dart';
import 'package:BGP_Retail/features/cart/data/models/ghtk_model.dart';
import 'package:BGP_Retail/features/cart/presentation/widgets/components/select_address_bottom_sheet.dart';
import 'package:BGP_Retail/features/home/data/model/product_model_v2.dart';
import 'package:BGP_Retail/features/profile/data/models/address_asbc_model.dart';
import 'package:BGP_Retail/features/wallet/data/cubits/wallet_cubit.dart';

import '../../../gen/assets.gen.dart';

@RoutePage()
class AsbcCartBuyV2 extends StatefulWidget {
  const AsbcCartBuyV2({
    super.key,
    required this.products,
    required this.option,
    this.isCart = false,
  });
  final List<ProductModelV2> products;
  final List<OptionData>? option;
  final bool? isCart;

  @override
  State<AsbcCartBuyV2> createState() => _AsbcCartBuyV2State();
}

class _AsbcCartBuyV2State extends State<AsbcCartBuyV2> {
  @override
  void initState() {
    super.initState();
    bloc.initProductV2(widget.products, widget.isCart);
  }

  final bloc = getIt.get<AsbcCartBuyCubit>();
  final navigator = getIt.get<AppNavigator>();
  final preferences = getIt.get<Preferences>();

  // num get total => widget.products.fold(
  //       0,
  //       (pre, element) =>
  //           pre +
  //           (element.variant?.firstOrNull?.priceSell ?? 0) *
  //               (element.quantity ?? 0),
  //     );
  @override
  Widget build(BuildContext context) {
    final products = widget.products;

    return BlocConsumer<AsbcCartBuyCubit, CubitState>(
      bloc: bloc
        ..getASBCListAddress()
        ..setShopAddress(
          products.firstOrNull?.companyData?.address?.addressFull,
        )
        ..getBankASBC(),
      listener: (context, state) {},
      builder: (context, state) {
        return BaseScreen(
          title: "Đặt đơn mới",
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _selectUserAddress(context),
                16.height,
                productInfor(products),
                16.height,
                _paymentMethod(),
              ],
            ).padding(16.pading),
          ),
          bottomNavigationBar: _bottomNavigationBar(context),
        );
      },
    );
  }

  Widget _paymentMethod() {
    final isNotSeclect = bloc.methodSelected == null;
    final isBanking = bloc.methodSelected == PaymentMethodEnum.banking;

    return BaseContainer(
      padding: 16.pading,
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Phương thức thanh toán",
                style: s14w500,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => onSelectPayment(),
                child: Row(
                  children: [
                    const Text(
                      "Xem tất cả",
                      style: s12w400,
                    ),
                    4.width,
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          8.height,
          BaseContainer(
            borderColor: isNotSeclect ? AppColors.red_1 : AppColors.main,
            padding: 16.pading,
            child: isNotSeclect
                ? _notSelectMethod(
                    icon: Assets.images.imCreditCard.svg(),
                    onTap: () => onSelectPayment(),
                    title: 'Bấm để chọn hình thức thanh toán',
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Assets.icons.icWalletActive.svg(),
                      8.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            isBanking
                                ? "Chuyển khoản ngân hàng"
                                : bloc.walletSelected?.title ?? "",
                            style: s14w500,
                          ),
                          4.height,
                          isBanking
                              ? Text.rich(
                                  maxLines: 1,
                                  TextSpan(
                                    text: bloc.asbcBank?.code,
                                    style: s12w400,
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding: 4.pading,
                                          child: const Icon(
                                            Icons.circle,
                                            size: 6,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: bloc.asbcBank?.accountNumber,
                                        style: s14w500,
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  "Số dư: ${formatCurrency(bloc.walletSelected?.balance ?? 0)}",
                                  maxLines: 2,
                                  style: s12w400,
                                ),
                        ],
                      ).expanded(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _notSelectMethod({
    required Widget icon,
    required Function() onTap,
    required String title,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          icon,
          8.width,
          Expanded(
            child: Text(title, style: s12w400.copyWith(color: AppColors.black)),
          ),
          8.width,
          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
          ),
        ],
      ),
    );
  }

  Container _bottomNavigationBar(BuildContext context) {
    final isPickUp = bloc.deliveryTypeSelected == DeliveryMethodEnum.pickUp;
    final isBanking = bloc.methodSelected == PaymentMethodEnum.banking;
    final deliveryPrice = bloc.deliveryMethodSelected?.giaCuoc ?? 0;
    final totalPrice = bloc.totalPrice + (isPickUp ? 0 : deliveryPrice);
    final isAddressValid = bloc.addressSelected != null;
    final isPaymentValid = bloc.methodSelected != null;
    final isDeliveryValid = bloc.deliveryTypeSelected != null;
    final paddingBottom = Platform.isAndroid ? 16 : 0;
    return Container(
      padding: 16.padingHor + 16.padingTop + paddingBottom.padingBottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text.rich(
                TextSpan(
                  text: "Tổng thanh toán ",
                  style: s14w400,
                  children: [
                    TextSpan(
                      text: formatCurrency(totalPrice),
                      style: s16w700.copyWith(color: AppColors.main),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              MainButton(
                isDisable:
                    !isAddressValid || !isPaymentValid || !isDeliveryValid,
                title: "Đặt hàng",
                onTap: () {
                  if (isAddressValid && isDeliveryValid && isPaymentValid) {
                    bloc.createOrder();
                  }
                  // navigator.push(
                  //   ConfirmPaymentRoute(bloc: bloc, totalPrice: totalPrice),
                  // );
                },
                largeButton: true,
              ),
            ],
          ),
          if (Platform.isIOS)
            SizedBox(height: MediaQuery.of(context).padding.bottom / 2),
        ],
      ),
    );
  }

  Widget productInfor(List<ProductModelV2> products) {
    final delivery = bloc.deliveryMethodSelected;
    final isNotSelect = bloc.deliveryTypeSelected == null;

    final isPickUp = bloc.deliveryTypeSelected == DeliveryMethodEnum.pickUp;

    final product = products.firstOrNull;
    return BaseContainer(
      padding: 16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Assets.icons.icOrderShop.svg(),
              16.width,
              Column(
                children: [
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: product?.companyData?.title ?? "",
                          style: s14w700,
                          children: [
                            WidgetSpan(child: 8.width),
                            TextSpan(
                              text: product?.companyData?.phone ?? "",
                              style: s14w400.copyWith(
                                color: AppColors.greyA7,
                              ),
                            ),
                          ],
                        ),
                      ).expanded(),
                    ],
                  ),
                  Text(
                    product?.companyData?.address?.addressFull ?? "",
                    maxLines: 2,
                  ),
                ],
              ).expanded(),
            ],
          ),
          16.height,
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final product = products[index];

              // final variant = product.variant?.firstOrNull;

              final optionSelectIds =
                  product.optionSelect?.map((e) => e.id ?? 0).toList();
              final variantSelect = product.variant?.firstOrNullWhere(
                (element) {
                  final variantIds =
                      element.options?.map((e) => e.id ?? 0).toList();
                  return areListsEqual(variantIds, optionSelectIds);
                },
              );
              final productPrice =
                  (product.quantity ?? 0) * (variantSelect?.priceSell ?? 0);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CacheNetworkImageV2(
                    width: 70,
                    height: 70,
                    url: variantSelect?.image,
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        variantSelect?.title ?? "",
                        style: s14w400,
                        maxLines: 2,
                      ),
                      8.height,
                      SizedBox(
                        height: 30,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => BaseContainer(
                            padding: 8.padingHor,
                            borderRadius: 30,
                            child: Center(
                              child: Text(
                                product.optionSelect?[index].values ?? "",
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) => 8.width,
                          itemCount: product.optionSelect?.length ?? 0,
                        ),
                      ),
                      8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatCurrency(variantSelect?.priceSell),
                          ),
                          Text(
                            "x ${formatNumberV2(product.quantity ?? 0)}",
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text.rich(
                          TextSpan(
                            text: "Tổng: ",
                            style: s14w400.copyWith(
                              color: AppColors.greyA7,
                            ),
                            children: [
                              TextSpan(
                                text: formatCurrency(productPrice),
                                style: s14w500.copyWith(
                                  color: AppColors.main,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).expanded(),
                ],
              );
            },
            separatorBuilder: (context, index) => 8.height,
            itemCount: products.length,
          ),
          const Divider(height: 1).padding(16.padingVer),
          const Text(
            "Ghi chú cho shop",
            style: s14w500,
          ),
          8.height,
          const ValidateTextField(
            radius: 8,
            hintText: "Để lại lời nhắn ...",
            maxLines: 5,
          ),
          const Divider(height: 1).padding(16.padingVer),
          Row(
            children: [
              const Text(
                "Hình thức vận chuyển",
                style: s14w500,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => onSelectDelivery(),
                child: Row(
                  children: [
                    const Text(
                      "Xem tất cả",
                      style: s12w400,
                    ),
                    4.width,
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          8.height,
          BaseContainer(
            borderColor: isNotSelect ? AppColors.red_1 : AppColors.main,
            padding: 16.pading,
            child: isNotSelect
                ? _notSelectMethod(
                    icon: Assets.images.imLogisticsDelivery.svg(),
                    onTap: () => onSelectDelivery(),
                    title: 'Bấm để chọn hình thức vận chuyển',
                  )
                : isPickUp
                    ? _pickUpItem()
                    : _deliveryItem(delivery),
          ),
          const Divider(height: 1).padding(16.padingVer),
          RowItem(
            title: "Tổng tiền hàng (1 sản phẩm)",
            subtitle: formatCurrency(bloc.totalPrice),
          ),
          8.height,
          RowItem(
            title: "Phí vận chuyển",
            subtitle: formatCurrency(
              isPickUp ? 0 : delivery?.giaCuoc,
            ),
          ),
          const Divider(height: 1).padding(16.padingVer),
          RowItem(
            title: "Tổng thanh toán",
            subtitle: formatCurrency(
                bloc.totalPrice + (isPickUp ? 0 : delivery?.giaCuoc ?? 0)),
          ),
        ],
      ),
    );
  }

  Widget _deliveryItem(ViettelPostModel? delivery) {
    final now = DateTime.now();
    final deliveryTime = convertHoursToDays(delivery?.thoiGian);
    final firtsDate = now.add(Duration(days: deliveryTime));
    final secondDate = now.add(Duration(days: deliveryTime + 1));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Assets.images.imgViettelPost.image(width: 48, height: 48),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  delivery?.tenDichvu ?? "",
                  style: s14w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ).expanded(),
                8.width,
                Text(
                  formatCurrency(delivery?.giaCuoc ?? 0),
                  style: s14w500.copyWith(color: AppColors.main),
                ),
              ],
            ),
            4.height,
            Text(
              "Nhận hàng vào ${convertDateYYYYMMDD(firtsDate)} - ${convertDateYYYYMMDD(secondDate)} ",
              maxLines: 2,
              style: s12w400,
            ),
          ],
        ).expanded(),
      ],
    );
  }

  Widget _pickUpItem() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Assets.icons.icOrderShop.svg(),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text(
                  "Lấy hàng tại kho",
                  style: s14w500,
                ),
                const Spacer(),
                Text(
                  formatCurrency(0),
                  style: s14w500.copyWith(color: AppColors.main),
                ),
              ],
            ),
            4.height,
            Text(
              widget.products.firstOrNull?.companyData?.address?.addressFull ??
                  "",
              maxLines: 2,
              style: s12w400,
            ),
          ],
        ).expanded(),
      ],
    );
  }

  Widget _selectUserAddress(BuildContext context) {
    final isNotValid = bloc.addressSelected == null;
    return GestureDetector(
      onTap: () async {
        final res =
            await context.bottomSheet(SelectAddressBottomSheet(bloc: bloc));
        if (res is AsbcAddressModel) {
          bloc.updateSelectAddress(res);
        }
      },
      child: BaseContainer(
        borderColor: (isNotValid) ? AppColors.red : null,
        padding: 16.pading,
        child: Row(
          children: [
            Assets.icons.icAddressManager.svg(width: 40),
            8.width,
            if (isNotValid)
              Text(
                'Bạn chưa tạo địa chỉ nhận hàng',
                style: s14w500.copyWith(color: AppColors.red),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          bloc.addressSelected?.fullname ?? "_",
                          style: s14w700,
                        ),
                        8.width,
                        Text(
                          bloc.addressSelected?.phone ?? "_",
                          style: s14w700.copyWith(
                            color: AppColors.greyA7,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                    4.height,
                    Text(
                      bloc.addressSelected?.addressFull ?? "",
                      style: s14w400,
                    ),
                  ],
                ),
              ),
            isNotValid
                ? const SizedBox.shrink()
                : const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ).padding(4.padingLeft),
          ],
        ),
      ),
    );
  }

  void onSelectPayment() {
    final walletBlc = context.read<WalletCubit>();
    navigator.push(
      PayymentMethodRoute(
        totalPrice: bloc.totalPrice,
        onChange: (p0, p1) {
          walletBlc.setWallet(p1);
          final walletSl = walletBlc.wallet;
          bloc.updatePaymentMethod(p0, walletSl);
        },
        paymentSelect: bloc.methodSelected,
        walletType: bloc.walletSelected?.type,
        bank: bloc.asbcBank,
      ),
    );
  }

  void onSelectDelivery() async {
    final res = await navigator.push(DeliveryMethodRoute(bloc: bloc));
    if (res == true) {
      bloc.updateDeliveryMethod(bloc.totalPrice.toInt());
    }
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
