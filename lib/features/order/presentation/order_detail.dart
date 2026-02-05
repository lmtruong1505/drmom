import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bpg_retail/app/data/bloc/app_cubit.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/spacing.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/dialog_utils.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/widgets/base/base_loading.dart';
import 'package:bpg_retail/core/widgets/base/scaffold.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/widgets/buttons/main_button.dart';
import 'package:bpg_retail/core/widgets/cache_image_network_widget.dart';
import 'package:bpg_retail/features/cart/data/models/qr_order_detail_model.dart';
import 'package:bpg_retail/features/cart/presentation/cart_qr_buy%20.dart';
import 'package:bpg_retail/features/order/data/bloc/order_detail_cubit.dart';
import 'package:bpg_retail/features/order/data/bloc/order_detail_state.dart';
import 'package:bpg_retail/features/order/data/models/order_asbc_model.dart';
import 'package:bpg_retail/features/order/presentation/widgets/reason_confirm.dart';
import 'package:bpg_retail/features/wallet/data/cubits/wallet_cubit.dart';
import 'package:bpg_retail/gen/assets.gen.dart';

@RoutePage()
class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, this.order, this.code});

  final OrderAsbcModel? order;
  final String? code;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final now = DateTime.now();
  Widget buildBottomNavigation() {
    return BlocBuilder<OrderDetailCubit, OrderDetailState>(
      builder: (context, state) {
        final orderDetail = state.order;
        if (state.isLoading) {
          return const SizedBox.shrink();
        } else {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (orderDetail?.statusData?.code == "CTT") ...[
                  Row(
                    children: [
                      ExtraButton(
                        largeButton: false,
                        title: 'Hủy đơn hàng',
                        borderColor: AppColors.border_1,
                        color: AppColors.red_1,
                        onTap: () async {
                          // if (state.reason?.isNotEmpty == true) {
                          final result = await navigator.showBottomSheet(
                            child: ReasonConfirm(
                              reasons: state.reason!,
                              title: "Lý do hủy đơn hàng",
                            ),
                          );
                          if (result is DataModel) {
                            bloc.orderCancel(
                              orderType: OrderEnum.CANCEL,
                              id: orderDetail?.id ?? 0,
                              reason: result,
                            );
                          }
                          // }
                        },
                      ).expanded(),
                      const SizedBox(width: 12),
                      MainButton(
                        largeButton: false,
                        title: 'Thanh toán',
                        onTap: () async {
                          final result = await navigator.push(
                            ConfirmPaymentRoute(
                              bloc: bloc,
                              order: orderDetail!,
                            ),
                          );
                          if (result == true) {
                            bloc.orderDetail(widget.code ?? "");
                          }
                        },
                      ).expanded(),
                    ],
                  ),
                ],
                if (orderDetail?.statusData?.code == "CXN" ||
                    orderDetail?.statusData?.code == "CLH") ...[
                  Row(
                    children: [
                      ExtraButton(
                        largeButton: false,
                        title: 'Hủy đơn hàng',
                        borderColor: AppColors.border_1,
                        color: AppColors.red_1,
                        onTap: () async {
                          // if (state.reason?.isNotEmpty == true) {
                          final result = await navigator.showBottomSheet(
                            child: ReasonConfirm(
                              reasons: state.reason!,
                              title: "Lý do hủy đơn hàng",
                            ),
                          );
                          if (result is DataModel) {
                            bloc.orderCancel(
                              orderType: OrderEnum.CANCEL,
                              id: orderDetail?.id ?? 0,
                              reason: result,
                            );
                          }
                          // }
                        },
                      ).expanded(),
                    ],
                  ),
                ],
                if (orderDetail?.statusData?.code == "ĐG") ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ExtraButton(
                        largeButton: false,
                        title: 'Khiếu nại',
                        borderColor: AppColors.border_1,
                        color: AppColors.red_1,
                        onTap: () async {
                          // if (state.reason?.isNotEmpty == true) {
                          final result = await navigator.showBottomSheet(
                            child: ReasonConfirm(
                              reasons: state.listComplant!,
                              title: "Lý do khiếu nại",
                            ),
                          );
                          if (result is DataModel) {
                            bloc.orderCancel(
                              orderType: OrderEnum.COMPLAINT,
                              id: orderDetail?.id ?? 0,
                              reason: result,
                            );
                          }
                        },
                      ).expanded(),
                      16.width,
                      MainButton(
                        largeButton: false,
                        title: 'Đã nhận hàng',
                        onTap: () async {
                          bloc.updateStatusOrder(3, orderDetail?.id ?? 0);
                        },
                      ).expanded(),
                    ],
                  ),
                ],

                // if (["DELIVERED", "APPROVED", "RETURN"]
                //     .contains(orderDetail?.orderStatus)) ...[
                //   const SizedBox.shrink(),
                //   Row(
                //     children: [
                //       // Expanded(
                //       //   child: ExtraButton(
                //       //     largeButton: false,
                //       //     title: orderDetail?.reason!.isNotEmpty
                //       //         ? "Xem chi tiết lý do"
                //       //         : 'Hoàn hàng',
                //       //     borderColor: AppColors.border_1,
                //       //     color: orderDetail.reason!.isNotEmpty
                //       //         ? AppColors.blackish
                //       //         : AppColors.red_1,
                //       //     onTap: () async {
                //       //       final result = await navigator.showBottomSheet(
                //       //         child: ReasonConfirm(
                //       //           reasons: reasonReturns,
                //       //           title: "Lý do hoàn hàng",
                //       //           type: orderDetail.reason!.isNotEmpty
                //       //               ? "RETURN_VIEW"
                //       //               : 'RETURN',
                //       //           order: orderDetail,
                //       //         ),
                //       //       );
                //       //       if (result['is_confirm'] == true) {
                //       //         bloc.confirmOrder(
                //       //           order: orderDetail,
                //       //           status: statusObj["RETURN"],
                //       //           reason: result['value'],
                //       //         );
                //       //       }
                //       //     },
                //       //   ),
                //       // ),
                //       if ([
                //         "DELIVERED",
                //         "APPROVED",
                //       ].contains(orderDetail?.orderStatus)) ...[
                //         const SizedBox(width: 12),
                //         Expanded(
                //           child: ExtraButton(
                //             largeButton: false,
                //             title: 'Đã nhận hàng',
                //             color: AppColors.white,
                //             bgColor: AppColors.main,
                //             borderColor: AppColors.main,
                //             onTap: () {
                //               bloc.orderConfirm(
                //                 id: orderDetail?.orderId ?? 0,
                //                 status: "DONE",
                //               );
                //             },
                //           ),
                //         ),
                //       ],
                //     ],
                //   ),
                // ],
                // const SizedBox(height: 12),
                // SizedBox(
                //   width: double.infinity,
                //   child: ExtraButton(
                //     largeButton: false,
                //     title: 'PICKUP',
                //     borderColor: AppColors.border_1,
                //     color: AppColors.red_1,
                //     onTap: () async {
                //       // final result = await navigator.showBottomSheet(
                //       //   child: ReasonConfirm(
                //       //     reasons: reasons,
                //       //     title: "Lý do hủy đơn hàng",
                //       //   ),
                //       // );
                //       // bloc.orderConfirm(
                //       //   id: orderDetail?.orderId ?? 0,
                //       //   status: statusObj["PENDING"]['value'],
                //       // );
                //     },
                //   ),
                // ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildGrocery(QrOrderDetailModel orderDetail) {
    // if (orderDetail.companyData == null) return const SizedBox.shrink();
    return Column(
      children: [
        const SizedBox(height: 8),
        BorderContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Địa chỉ lấy hàng", style: s14w500),
              8.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Assets.icons.icOrderShop.svg(width: 40),
                  // Assets.icon(assetName: 'ic_order_shop.svg', width: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 4,
                          children: [
                            Text(
                              orderDetail.companyData?.title ?? "",
                            ),
                            Assets.icons.icSuccess2.svg(
                              width: 14,
                              colorFilter: const ColorFilter.mode(
                                AppColors.main,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              orderDetail.companyData?.warehouseData?.phone ??
                                  "",
                              style: AppTypography.p6.copyWith(
                                color: AppColors.grey_1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              // if (orderDetail.shopData?.addressShop != null)
                              TextSpan(
                                text: orderDetail.companyData?.warehouseData
                                        ?.addressFull ??
                                    "",
                                style: AppTypography.p6
                                    .copyWith(color: AppColors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAddress(QrOrderDetailModel orderDetail) {
    return Visibility(
      visible: orderDetail.orderType != 2,
      child: BorderContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Địa chỉ nhận hàng", style: s14w500),
            8.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Assets.icons.icAddressManager.svg(width: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        children: [
                          Text(
                            orderDetail.customerData?.fullName ?? '',
                            style: AppTypography.p5,
                          ),
                          Assets.icons.icSuccess2.svg(
                            width: 14,
                            colorFilter: const ColorFilter.mode(
                              AppColors.main,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            orderDetail.customerData?.phone ?? "",
                            style: AppTypography.p6.copyWith(
                              color: AppColors.grey_1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        orderDetail
                                .orderDlo?.receiverAddressData?.addressFull ??
                            '',
                        style: AppTypography.p6,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ).padding(8.padingTop),
    );
  }

  Widget buildDeliveryType(QrOrderDetailModel orderDetail) {
    final order = orderDetail.orderDlo;
    final isPickUp = order == null;
    // final deliveryTime = convertHoursToDays(order?.thoiGian);
    // final firtsDate = now.add(Duration(days: deliveryTime));
    // final secondDate = now.add(Duration(days: deliveryTime + 1));
    return BorderContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Thông tin vận chuyển",
                style: s14w500,
              ),
            ],
          ),
          8.height,
          isPickUp
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Assets.images.imgOrderShop.image(
                      width: 48,
                      height: 48,
                    ),
                    // Assets.image(
                    //   assetName: "img_order_shop.png",
                    //   width: 48,
                    //   height: 48,
                    // ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tự đến lấy hàng",
                            style: s14w500,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Assets.images.imgViettelPost.image(
                      width: 48,
                      height: 48,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.titleService ?? '',
                            style: s14w500,
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

  Widget buildPaymentType(QrOrderDetailModel orderDetail) {
    final isPaymentSuccess = orderDetail.statusData?.code != "CTT";
    final isBanking = orderDetail.paymentMethod?.title == "BANKING";
    return BorderContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Thông tin thanh toán",
                style: s14w500,
              ),
              Row(
                children: [
                  if (isPaymentSuccess)
                    Assets.icons.icShieldCheck.svg(
                      width: 20,
                      height: 20,
                    ),
                  4.width,
                  Text(
                    isPaymentSuccess ? "Đã thanh toán" : "Chưa thanh toán",
                    style: AppTypography.p5.copyWith(
                      color: isPaymentSuccess
                          ? AppColors.green_1
                          : AppColors.yellowD2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          8.height,
          Row(
            children: [
              isBanking
                  ? Assets.icons.icBanking.svg(
                      width: 48,
                      height: 48,
                    )
                  : Assets.icons.icWalletSelect.svg(
                      width: 48,
                      height: 48,
                    ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBanking
                          ? 'Chuyển khoản ngân hàng'
                          : orderDetail.paymentMethod?.walletData?.title ?? '',
                      style: s14w500,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Giao dịch: ',
                            style: s12w400,
                          ),
                          TextSpan(
                            text: orderDetail.code ?? "",
                            style: s12w400.copyWith(color: AppColors.main),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formatCurrency(orderDetail.total ?? 0),
                style: s14w500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc
      ..orderDetail(widget.code ?? "")
      ..getBankASBC();
  }

  final bloc = getIt.get<OrderDetailCubit>();
  final navigator = getIt.get<AppNavigator>();
  final appCubit = getIt.get<AppCubit>();
  final preferences = getIt.get<Preferences>();

  @override
  Widget build(BuildContext context) {
    final walletBlc = context.read<WalletCubit>();
    return BlocProvider(
      create: (context) => bloc,
      child: RefreshIndicator(
        color: AppColors.main,
        onRefresh: () async {
          bloc.orderDetail(widget.order?.code ?? widget.code ?? '');
        },
        child: BlocConsumer<OrderDetailCubit, OrderDetailState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            final status = state.order?.statusData?.code;
            if (state.status == CubitStatus.sendSuccess) {
              navigator.pop();
              _showOrderSuccess(context, widget.order?.code);
              bloc.orderDetail(widget.code ?? "");
              walletBlc.getWallets();
            } else if (state.status == CubitStatus.sendFaild) {
              EasyLoading.dismiss();
              DialogUtils.showErrorDialog(
                context,
                content: 'Thanh toán không thành công. Đã có lỗi xảy ra',
              );
            } else if (state.status == CubitStatus.success) {
              print('========$status');
              if (status == 'CXN' || status == 'CTT' || status == 'CLH') {
                bloc.getReasonCancel(OrderEnum.CANCEL);
                // bloc.getReasonCancel(OrderEnum.COMPLAINT);
              } else if (status == 'ĐG') {
                bloc.getReasonCancel(OrderEnum.COMPLAINT);
              }
            } else if (state.status == CubitStatus.update) {
              bloc.orderDetail(widget.code ?? "");
            }

            // else if (state.status == CubitStatus.loading) {
            //   EasyLoading.show();
            // } else {
            //   EasyLoading.dismiss();
            // }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const BaseLoading();
            }
            final orderDetail = state.order;
            return BaseScaffold(
              backgroundImage: true,
              body: Container(
                height: 187,
                padding: const EdgeInsets.only(
                  top: 40,
                  left: 20,
                  right: 20,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: BlocBuilder<OrderDetailCubit, OrderDetailState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: () => navigator.pop(result: state.hasUpdate),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF000000).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Chi tiết đơn hàng',
                      style: AppTypography.h4,
                    ),
                    const SizedBox(height: 16),
                    // if (orderDetail == null)
                    //   const Expanded(
                    //     child: BaseLoading(),
                    //   ),
                    if (orderDetail != null)
                      BlocBuilder<OrderDetailCubit, OrderDetailState>(
                        builder: (context, state) {
                          final orderDetail = state.order;
                          return Container(
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Mã đơn: ",
                                              style: AppTypography.h6,
                                            ),
                                            Text(
                                              orderDetail?.code ?? "",
                                              style: s14w400,
                                            ),
                                            4.width,
                                            InkWell(
                                              onTap: () {
                                                (orderDetail?.code ?? "").copy;
                                              },
                                              child: const Icon(
                                                Icons.copy,
                                                size: 14,
                                                color: AppColors.blue_1,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Text(
                                        //   convertDateFormatTime(
                                        //     orderDetail?.reasonDate ??
                                        //         orderDetail?.createdAt ??
                                        //         "",
                                        //   ),
                                        //   style: AppTypography.p6,
                                        // ),
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
                                // if ([
                                //   'CANCEL',
                                //   'RETURN',
                                // ].contains(
                                //   "orderDetail?.orderStatus",
                                // )) ...[
                                //   const SizedBox(height: 12),
                                //   // Text(
                                //   //   "Lý do ${orderDetail?.orderStatus == 'CANCEL' ? 'hủy' : 'hoàn hàng'}: ${orderDetail?.reason ?? ''}",
                                //   //   style: AppTypography.p5.copyWith(
                                //   //     color: getColorStatus(
                                //   //       orderDetail?.orderStatus ?? "",
                                //   //     ),
                                //   //   ),
                                //   // ),
                                // ],
                              ],
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 8),
                    if (orderDetail != null)
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              buildDeliveryType(orderDetail),
                              8.height,
                              buildPaymentType(orderDetail),
                              buildAddress(orderDetail),
                              8.height,
                              buildGrocery(orderDetail),
                              8.height,
                              buildListOrder(orderDetail, state),
                              16.height,
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              bottomNavigationBar: buildBottomNavigation(),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> _showOrderSuccess(BuildContext context, String? code) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: 16.pading,
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.images.imOrder.image(width: 100, height: 100),
              16.height,
              const Text(
                "Đặt hàng thành công!",
                style: s18w700,
              ),
              8.height,
              Text(
                "Chức mừng bạn đã đặt hàng thành công. Mã đơn hàng là $code",
                style: s12w400,
              ),
              24.height,
              Container(
                width: double.infinity,
                child: MainButton(
                  title: "Chi tiết đơn",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                    // navigator.pop();
                    // navigator.pop(result: true);
                  },
                ),
              ),
              16.height,
              Container(
                width: double.infinity,
                child: ExtraButton(
                  onTap: () {
                    navigator.popUntilRoot(useRootNavigator: true);
                    // navigator.popUntilRoot(useRootNavigator: true);
                  },
                  title: "Trang chủ",
                  largeButton: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildNote(OrderDetailModel orderDetail) {
  //   return BorderContainer(
  //     child: Column(
  //       children: [
  //         RowItem(
  //           title: "Ghi chú",
  //           subtitle: orderDetail.note?.isNotEmpty == true
  //               ? orderDetail.note ?? ''
  //               : "Không có dữ liệu",
  //         ),
  //         12.height,
  //         const RowItem(
  //           title: 'Hình thức thanh toán',
  //           subtitle: "COD",
  //         ),
  //         12.height,
  //         RowItem(
  //           title: 'Thời gian đặt hàng',
  //           subtitle: convertDateFormatTime(orderDetail.createdAt ?? ""),
  //         ),
  //         12.height,
  //         RowItem(
  //           title: 'Thời gian cập nhật',
  //           subtitle: convertDateFormatTime(orderDetail.updatedAt ?? ""),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildListOrder(
    QrOrderDetailModel orderDetail,
    OrderDetailState state,
  ) {
    num allPrice = 0;
    if (orderDetail.orderItems != null) {
      allPrice = orderDetail.orderItems!.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.price ?? 0) * (element.quantity ?? 0),
      );
    }

    return BorderContainer(
      child: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = orderDetail.orderItems?[index];
              final retailPrice = item?.price ?? 0;
              final quantity = item?.quantity ?? 0;
              final totalPrice = retailPrice * quantity;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: CacheNetworkImageV2(
                          url: item?.variantData?.image ?? "",
                          width: 80,
                          height: 80,
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
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (item?.variantData?.optionData?.isNotEmpty ==
                                    true)
                                  Text(
                                    item?.variantData?.optionData?[0].values ??
                                        "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: s14w400.copyWith(
                                      color: AppColors.grey_1,
                                    ),
                                  ),
                                Text(
                                  " (${formatCurrency(item?.price ?? 0)})",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      s14w400.copyWith(color: AppColors.grey_1),
                                ),
                                const Spacer(),
                                Text(
                                  "x${item?.quantity}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: s14w400,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            formatCurrency(totalPrice),
                            overflow: TextOverflow.ellipsis,
                            style: s14w500,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return (index != (orderDetail.orderItems?.length ?? 0) - 1)
                  ? const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(color: AppColors.border_1),
                        ),
                      ],
                    )
                  : const SizedBox.shrink();
            },
            itemCount: orderDetail.orderItems?.length ?? 0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: AppColors.border_1),
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng tiền hàng',
                    style: s14w400,
                  ),
                  const Spacer(),
                  Text(
                    formatCurrency(allPrice),
                    style: AppTypography.p5,
                  ),
                ],
              ),
              12.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phí vận chuyển',
                    style: s14w400,
                  ),
                  const Spacer(),
                  Text(
                    formatCurrency(orderDetail.orderDlo?.transportFee ?? 0),
                    style: AppTypography.p5,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(
                  color: AppColors.grey_1,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng thanh toán: ',
                    style: s14w400,
                  ),
                  const Spacer(),
                  Text(
                    formatCurrency(
                      allPrice + (orderDetail.orderDlo?.transportFee ?? 0),
                    ),
                    overflow: TextOverflow.ellipsis,
                    style: s14w700.copyWith(
                      color: AppColors.main,
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
}

class BorderContainer extends StatelessWidget {
  final Widget child;

  const BorderContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Spacing.a16,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.2,
          color: AppColors.grey_1,
        ),
      ),
      child: child,
    );
  }
}
