import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/spacing.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/core/utilities/assets.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/dialog_utils.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/utilities/screens.dart';
import 'package:bpg_retail/core/widgets/appbar_back_button.dart';
import 'package:bpg_retail/core/widgets/base/base_loading.dart';
import 'package:bpg_retail/core/widgets/base/scaffold.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/buttons/main_button.dart';
import 'package:bpg_retail/core/widgets/cache_image_network_widget.dart';
import 'package:bpg_retail/core/widgets/image_default.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/widgets/row_item.dart';
import 'package:bpg_retail/core/widgets/toast/overlay_custom.dart';
import 'package:bpg_retail/features/cart/data/bloc/cart_cubit_v2.dart';
import 'package:bpg_retail/features/cart/data/bloc/cart_qr_buy_cubit.dart';
import 'package:bpg_retail/features/cart/data/bloc/cart_qr_buy_state.dart';
import 'package:bpg_retail/features/cart/data/bloc/cart_state_v2.dart';
import 'package:bpg_retail/features/cart/data/models/delivery_model.dart';
import 'package:bpg_retail/features/cart/data/models/payment_success_model.dart';
import 'package:bpg_retail/features/cart/data/models/qr_order_detail_model.dart';
import 'package:bpg_retail/features/cart/presentation/asbc_cart_buy_v2.dart';
import 'package:bpg_retail/features/profile/presentation/children_screens/deposit_withdrawal_screen.dart';

@RoutePage()
class CartQRBuyPage extends StatefulWidget {
  const CartQRBuyPage({super.key, required this.code});

  final String? code;

  @override
  State<CartQRBuyPage> createState() => _CartQRBuyPageState();
}

class _CartQRBuyPageState extends State<CartQRBuyPage> {
  final navigator = getIt.get<AppNavigator>();
  final preferences = getIt.get<Preferences>();
  final bloc = getIt.get<CartQrBuyCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widthDevice(context) / 2 - 16 * 3;
    return BlocProvider<CartQrBuyCubit>(
      create: (context) => bloc
        ..getOrderDetail(widget.code ?? "")
        ..getWallets(),
      child: BlocConsumer<CartQrBuyCubit, CartQrBuyState>(
        listener: (context, state) {
          if (state.status == CubitStatus.sendSuccess) {
            final payment = state.paymentDetail?.customerTrans;
            _showPayment(context, payment, state.paymentDetail?.code, state);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const BaseLoading();
          }
          final orderDetail = state.detail;
          final total = orderDetail?.orderItems?.fold(
                0,
                (num pre, element) =>
                    pre + (element.quantity ?? 0) * (element.price ?? 0),
              ) ??
              0;
          return BaseScaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerAppbar(),
                _detailOrder(width, orderDetail),
              ],
            ),
            bottomNavigationBar: _bottomBar(context, state, total),
          );
        },
      ),
    );
  }

  Future<dynamic> _showPayment(
    BuildContext context,
    Trans? payment,
    String? code,
    CartQrBuyState state,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 80,
                  child: Assets.icon(
                    assetName: 'ic_success_new.svg',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Giao dịch thành công",
                  style: AppTypography.h3,
                ),
                const SizedBox(height: 12),
                Text(formatCurrency(payment?.amount ?? 0), style: s24w700),
                24.height,
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text:
                            'Chúc mừng! Bạn đã thanh toán thành công cho đơn hàng #',
                        style: s12w400,
                      ),
                      TextSpan(
                        text: state.paymentDetail?.code ?? "",
                        style: s12w400,
                      ),
                      const TextSpan(
                        text: " bằng ví mua hàng",
                        style: s12w400,
                      ),
                    ],
                  ),
                ),
                16.height,
                const BaseRowItem(
                  title: "Ví giao dịch:",
                  subtitle: "Ví mua hàng",
                ),
                BaseRowItem(
                  title: "Mã giao dịch:",
                  subtitle: payment?.referenceOrderCode ?? "",
                ),
                BaseRowItem(
                  title: "Thời gian giao dịch:",
                  subtitle: convertDateFormatTime(
                    payment?.createdAt ?? "",
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ExtraButton(
                        radius: 30,
                        title: "Quét mã khác",
                        onTap: () {
                          navigator.popUntilRoot();
                        },
                        borderColor: AppColors.border_4,
                        largeButton: false,
                        icon: null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MainButton(
                        radius: 30,
                        title: "Chi tiết đơn hàng",
                        onTap: () {
                          navigator.popUntilRoot();
                          navigator.push(
                            OrderDetailRoute(code: code),
                          );
                        },
                        largeButton: false,
                        icon: null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bottomBar(BuildContext context, CartQrBuyState state, num total) {
    if (state.detail?.statusData?.code != "ĐH" &&
        state.detail?.statusData?.code != "HT") {
      return Container(
        width: double.infinity,
        color: AppColors.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ExtraButton(
                radius: 30,
                largeButton: false,
                title: 'Quay lại',
                color: AppColors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                onTap: () {
                  // _showPayment(context, payment, state)
                  navigator.back();
                },
              ),
            ),
            16.width,
            Expanded(
              child: ExtraButtonV2(
                borderRadius: 30,
                largeButton: false,
                title: 'Xác nhận',
                borderColor: AppColors.main,
                color: AppColors.white,
                bgColor: AppColors.main,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                // isDissemble: !state.canOrder,
                onTap: () {
                  // final isLogin = context.watch<AppCubit>().state.isLoggedIn;
                  // if (isLogin) {
                  final index = state.paymentIndex;
                  final balance = state.wallets?[index].balance ?? 0;
                  if (total > balance) {
                    showOverlayToast(
                      title: "Số dư trong tài khoản khônng đủ để thanh toán",
                      iconColor: AppColors.red_1,
                    );
                    return;
                  } else {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => PinCodeButtomSheet(
                        (value) {
                          if (value == true) {
                            DialogUtils.showConfirmDialog(
                              context,
                              title: "Xác nhận giao dịch",
                              description:
                                  "Bạn chắc chắn muốn thực hiện thanh toán cho đơn hàng này?",
                              ontap: bloc.createOrder,
                              rightTitle: "Xác nhận",
                            );
                          }
                        },
                      ),
                    );
                  }
                  // } else {
                  //   navigator.push(const LoginRoute());
                  // }
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Column _headerAppbar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppBarBackButtonV2(),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 24,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: AppColors.main,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Thanh toán đơn hàng",
                style: AppTypography.h4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailOrder(
    double width,
    QrOrderDetailModel? orderDetail,
  ) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentMethod(bloc: bloc, width: width),
              const Text(
                "Chi tiết đơn hàng",
                style: s16w500,
              ),
              8.height,
              Container(
                padding: Spacing.a16,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: getColorStatusBackground(
                    orderDetail?.statusData?.code ?? "",
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1.2,
                    color: getColorStatus(
                      orderDetail?.statusData?.code ?? "",
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Text("Mã đơn: ", style: s14w500),
                            Text(
                              orderDetail?.code ?? "",
                              style: AppTypography.h6,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          orderDetail?.statusData?.title ?? '',
                          style: AppTypography.p5.copyWith(
                            color: getColorStatus(
                              orderDetail?.statusData?.code ?? "",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              16.height,
              BoothSelectWidget(orderDetail),
              16.height,
              OrderWidget(orderDetail),
              16.height,
              NoteItem(orderDetail),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({
    super.key,
    required this.bloc,
    required this.width,
  });

  final CartQrBuyCubit bloc;
  final double width;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartQrBuyCubit, CartQrBuyState>(
      builder: (context, state) {
        if (state.wallets?.isEmpty == true) {
          return const SizedBox.shrink();
        }
        final totalPayment = state.detail?.orderItems?.fold(
              0,
              (num pre, element) =>
                  pre + (element.price ?? 0) * (element.quantity ?? 0),
            ) ??
            0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hình thức thanh toán",
                  style: s16w500,
                ),
                // GestureDetector(
                //   onTap: () {},
                //   child: Text(
                //     "Xem tất cả",
                //     style: s14w500.copyWith(
                //       color: AppColors.main,
                //     ),
                //   ),
                // ),
              ],
            ),
            8.height,
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final wallet = state.wallets?[index];
                  final isSelect = state.paymentIndex == index;
                  final isDissable = totalPayment > (wallet?.balance ?? 0);
                  return GestureDetector(
                    onTap: () {
                      if (!isDissable) {
                        bloc.selectPaymentMethod(index);
                      }
                    },
                    child: BaseContainer(
                      color: isDissable
                          ? AppColors.white
                          : isSelect
                              ? AppColors.purple_1.withOpacity(0.1)
                              : AppColors.white,
                      borderColor: isDissable
                          ? AppColors.white
                          : isSelect
                              ? AppColors.purple_1
                              : AppColors.white,
                      // width: width,
                      child: Row(
                        children: [
                          12.width,
                          isDissable
                              ? Assets.icon(
                                  assetName: "ic_wallet_dissable.svg",
                                  width: 24,
                                  height: 24,
                                )
                              : isSelect
                                  ? Assets.icon(
                                      assetName: "ic_wallet_select.svg",
                                      width: 24,
                                      height: 24,
                                    )
                                  : Assets.icon(
                                      assetName: "ic_wallet_active.svg",
                                      width: 24,
                                      height: 24,
                                    ),
                          8.width,
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                wallet?.title ?? "",
                                style: s12w500.copyWith(
                                  color: isDissable
                                      ? AppColors.grey_1
                                      : AppColors.black,
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Số dư: ',
                                      style: s12w400.copyWith(
                                        color: isDissable
                                            ? AppColors.grey_1
                                            : AppColors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: formatCurrency(
                                        wallet?.balance ?? 0,
                                      ),
                                      style: s12w400.copyWith(
                                        color: isDissable
                                            ? AppColors.grey_1
                                            : AppColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          24.width,
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => 8.width,
                itemCount: state.wallets?.length ?? 0,
              ),
            ),
          ],
        );
      },
    );
  }
}

class NoteItem extends StatelessWidget {
  const NoteItem(this.detail);
  final QrOrderDetailModel? detail;
  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      padding: 16.pading,
      child: Column(
        children: [
          const BaseRowItem(
            title: "Ghi chú",
            subtitle: "Giao hàng vào giờ hành chính",
          ),
          8.height,
          BaseRowItem(
            title: "Thời gian tạo đơn",
            subtitle: convertDateFormatTime(
              detail?.createdAt ?? "",
            ),
          ),
          8.height,
          BaseRowItem(
            title: "Thời gian cập nhật",
            subtitle: convertDateFormatTime(
              detail?.updatedAt ?? "",
            ),
          ),
        ],
      ),
    );
  }
}

class DeliverySelectWidget extends StatelessWidget {
  DeliverySelectWidget({
    super.key,
    required this.quantity,
    required this.totalPrice,
    required this.weight,
  });

  final navigator = getIt.get<AppNavigator>();
  final num quantity;
  final double totalPrice;
  final num weight;
  final bloc = getIt.get<CartCubitV2>();
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubitV2, CartStateV2>(
      builder: (context, state) {
        final estimateTime = convertDateYYYYMMDD(
          now.add(
            Duration(
              days: convertHoursToDays(state.deliverySelected?.time ?? ""),
            ),
          ),
        );
        return Container(
          padding: Spacing.a16,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1.2,
              color: AppColors.border_1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hình thức vận chuyển (Nhấn để chọn)', style: s14w400),
              const SizedBox(height: 8),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  final res = await navigator.push(
                    DeliverySelectV2Route(
                      senderAddress: state.boothSelected!.fullAddress ?? "",
                    ),
                  );
                  if (res is DeliveryTypeModel) {
                    bloc.setDelivery(res);
                  }
                },
                child: (state.deliverySelected?.deliveryShipping ==
                        DeliveryShipping.pickUp)
                    ? Row(
                        children: [
                          Image.asset(
                            "assets/images/img_store.png",
                            width: 48,
                            height: 48,
                          ),
                          16.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Nhận tại cửa hàng",
                                  style: s14w500,
                                ),
                                Text(
                                  state.boothSelected?.fullAddress ?? ",",
                                  style: s12w400,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              (state.deliverySelected?.deliveryShipping ==
                                      DeliveryShipping.viettelPost)
                                  ? Image.asset(
                                      "assets/images/img_viettel_post.png",
                                      width: 48,
                                      height: 48,
                                    )
                                  : Image.asset(
                                      "assets/images/img_ghtk.png",
                                      width: 48,
                                      height: 48,
                                    ),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.deliverySelected?.type ?? "",
                                    style: s14w500,
                                  ),
                                  Text(
                                    'Thời gian dự kiến $estimateTime',
                                    style: s12w400.copyWith(
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Text(
                          //   formatCurrency(state.deliverySelected?.price ?? 0),
                          //   style: s14w400.copyWith(
                          //     color: AppColors.main,
                          //   ),
                          // ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BoothSelectWidget extends StatelessWidget {
  const BoothSelectWidget(this.detail);

  final QrOrderDetailModel? detail;

  @override
  Widget build(BuildContext context) {
    final warehouse = detail?.companyData?.warehouseData;
    return Container(
      padding: Spacing.a16,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.2,
          color: AppColors.border_1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Nhà bán hàng", style: s14w500),
          8.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Assets.icon(
                assetName: 'ic_order_shop.svg',
                width: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 4,
                      children: [
                        Text(
                          detail?.companyData?.title ?? "",
                          style: AppTypography.p5,
                        ),
                        Row(
                          children: [
                            Text(
                              warehouse?.phone ?? '',
                              style: AppTypography.p6.copyWith(
                                color: AppColors.grey_1,
                              ),
                            ),
                            const Icon(
                              Icons.phone,
                              size: 20,
                              color: AppColors.main,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        Text(
                          warehouse?.addressFull ?? '...',
                          style: AppTypography.p6,
                        ),
                        // Text(
                        //   "${formatNumber(state.boothSelected!.distance!, 2)}km",
                        //   style: AppTypography.p6.copyWith(
                        //     color: AppColors.main,
                        //   ),
                        // ),
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
  }
}

class OrderWidget extends StatelessWidget {
  const OrderWidget(this.detail, {super.key});

  final QrOrderDetailModel? detail;

  @override
  Widget build(BuildContext context) {
    final total = detail?.orderItems?.fold(
      0,
      (num pre, element) =>
          pre + ((element.quantity ?? 0) * (element.price ?? 0)),
    );
    return Container(
      padding: Spacing.a16,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.2,
          color: AppColors.border_1,
        ),
      ),
      child: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = detail?.orderItems?[index];
              final productPrice = (item?.quantity ?? 0) * (item?.price ?? 0);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // navagator
                          //     .push(ProductDetailPageV2(id: item.productId ?? 0));
                        },
                        child: CacheNetworkImageV2(
                          url: item?.variantData?.image,
                          width: 80,
                          height: 80,
                          errorWidget: const ImageLogoLgDefault(
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item?.variantData?.title ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.p5,
                            ),
                            16.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Text(
                                //   item.unitName ?? "",
                                //   maxLines: 2,
                                //   overflow: TextOverflow.ellipsis,
                                //   style: AppTypography.p6.copyWith(
                                //     color: AppColors.grey_1,
                                //   ),
                                // ),
                                Text(
                                  "x${item?.quantity?.toInt()}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.p6.copyWith(
                                    color: AppColors.grey_1,
                                  ),
                                ),
                              ],
                            ),
                            8.height,
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                formatCurrency(productPrice),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.p6.copyWith(
                                  color: AppColors.grey_1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (index != (detail?.orderItems?.length ?? 0) - 1) ...[
                    const SizedBox(height: 8),
                    const Divider(
                      color: AppColors.border_1,
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              );
            },
            separatorBuilder: (context, index) => 8.height,
            itemCount: detail?.orderItems?.length ?? 0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              color: AppColors.border_1,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Phí vận chuyển ",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.p6.copyWith(
                      color: AppColors.grey_1,
                    ),
                  ),
                  Text(
                    formatCurrency(0),
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.p5,
                  ),
                ],
              ),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tổng tiền hàng ",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.p6.copyWith(
                      color: AppColors.grey_1,
                    ),
                  ),
                  Text(
                    formatCurrency(total ?? 0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.p5,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(
                  color: AppColors.border_1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tổng tiền thanh toán:",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.p6.copyWith(
                      color: AppColors.grey_1,
                    ),
                  ),
                  Text(
                    formatCurrency(total ?? 0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: s14w700.copyWith(color: AppColors.main),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void copyToClipboard(String text) {
  showOverlayToast(title: "Đã sao chép");
  Clipboard.setData(ClipboardData(text: text));
}

Color getColorStatus(String statusCode) {
  if (statusCode == "CXN") {
    return AppColors.yellowF0;
  }

  if (statusCode == "ĐXL") {
    return AppColors.yellowF0;
  }

  if (statusCode == "HT") {
    return AppColors.green_1;
  }
  if (statusCode == "ĐH") {
    return AppColors.red_1;
  }

  if (statusCode == "ĐG") {
    return AppColors.green_1;
  }

  if (statusCode == "ĐGH") {
    return AppColors.blue31;
  }
  if (statusCode == "CLH") {
    return AppColors.yellowF0;
  }
  return AppColors.yellowF0;
}

Color getColorStatusBackground(String statusCode) {
  if (statusCode == "CXN") {
    return AppColors.yellow_2;
  }
  if (statusCode == "ĐXL") {
    return AppColors.yellow_2;
  }
  if (statusCode == "HT") {
    return AppColors.green_2;
  }
  if (statusCode == "ĐH") {
    return AppColors.red_2;
  }
  if (statusCode == "ĐGH") {
    return AppColors.accent_3;
  }
  if (statusCode == "CLH") {
    return AppColors.yellow_2;
  }

  return AppColors.yellow_2;
}
