import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/utilities/image_utils.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base_container.dart';
import 'package:BGP_Retail/core/widgets/buttons/extra_button.dart';
import 'package:BGP_Retail/core/widgets/buttons/main_button.dart';
import 'package:BGP_Retail/core/widgets/cach_avatar_image.dart';
import 'package:BGP_Retail/core/widgets/cache_image_network_widget.dart';
import 'package:BGP_Retail/core/widgets/dashed_line_widget.dart';
import 'package:BGP_Retail/features/cart/data/models/qr_order_detail_model.dart';
import 'package:BGP_Retail/features/order/data/bloc/order_detail_cubit.dart';
import 'package:BGP_Retail/features/order/data/bloc/order_detail_state.dart';
import 'package:BGP_Retail/features/profile/presentation/children_screens/deposit_withdrawal_screen.dart';
import 'package:BGP_Retail/features/wallet/data/cubits/wallet_cubit.dart';
import 'package:BGP_Retail/gen/assets.gen.dart';

@RoutePage()
class ConfirmPaymentPage extends StatefulWidget {
  const ConfirmPaymentPage({
    super.key,
    // required this.bloc,
    // required this.totalPrice,
    required this.order,
    required this.bloc,
  });
  // final AsbcCartBuyCubit bloc;
  // final num totalPrice;
  final QrOrderDetailModel order;
  final OrderDetailCubit bloc;
  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  final navigator = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    // final bloc = widget.bloc;
    final order = widget.order;
    final bloc = widget.bloc;
    final walletBloc = context.read<WalletCubit>();
    return BlocConsumer<OrderDetailCubit, OrderDetailState>(
      listener: (context, state) {
        if (state.status == CubitStatus.sendSuccess) {
          walletBloc.getWallets();
          // navigator.pop();
        }
        // if (state.status == CubitStatus.sendSuccess) {
        //   _showOrderSuccess(context);
        //   bloc.orderDetail(widget.code ?? "");
        // } else if (state.status == CubitStatus.sendFaild) {
        //   EasyLoading.dismiss();
        //   DialogUtils.showErrorDialog(
        //     context,
        //     content: 'Thanh toán không thành công. Đã có lỗi xảy ra',
        //   );
        // } else if (state.status == CubitStatus.loading) {
        //   EasyLoading.show();
        // }
        // EasyLoading.dismiss();
      },
      bloc: bloc,
      builder: (context, state) {
        final isBanking = bloc.paymentMothod == PaymentMethodEnum.banking;
        final qrCode = bloc.orderQrCode;

        walletBloc.setWallet(bloc.walletSelectId ?? 0);
        final totalPrice =
            (order.total ?? 0) + (order.orderDlo?.transportFee ?? 0);
        final isActive = totalPrice <= (walletBloc.wallet.balance ?? 0);
        return BaseScreen(
          title: "Xác nhận thanh toán",
          body: SingleChildScrollView(
            child: Padding(
              padding: 16.pading,
              child: Column(
                children: [
                  BaseContainer(
                    padding: 16.pading,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Tổng số tiền",
                          style: s18w400,
                        ),
                        4.height,
                        Text(
                          formatCurrency(totalPrice),
                          style: s30w700.copyWith(color: AppColors.main),
                        ),
                        const Divider(
                          height: 1,
                        ).padding(16.padingVer),
                        Row(
                          children: [
                            const Text(
                              "Phương thức thanh toán",
                              style: s14w400,
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                navigator.push(
                                  PayymentMethodRoute(
                                    totalPrice: totalPrice,
                                    onChange: (p0, p1) {
                                      bloc.setPaymentMethod(p0, p1);
                                    },
                                    paymentSelect: bloc.paymentMothod,
                                    walletType: bloc.walletSelectId,
                                    bank: bloc.asbcBank,
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  const Text("Thay đổi", style: s14w400),
                                  4.width,
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        8.height,
                        BaseContainer(
                          borderColor: (isActive || isBanking)
                              ? AppColors.main
                              : AppColors.red,
                          padding: 16.pading,
                          child: isBanking ? _bankingItem() : _walletItem(),
                        ),
                      ],
                    ),
                  ),
                  // if (isBanking)
                  if (isBanking)
                    Column(
                      children: [
                        16.height,
                        const Text(
                          "Vui lòng chuyển khoản với thông tin dưới đây để tiếp tục đặt đơn.",
                          style: s14w400,
                        ),
                        16.height,
                        BaseContainer(
                          padding: 16.pading,
                          child: Row(
                            children: [
                              Assets.icons.icBanking.svg(),
                              const DashedLineWidget(
                                axis: Axis.vertical,
                                length: 70,
                              ).padding(16.padingHor),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    bloc.orderQrCode?.bankCode ?? "",
                                    style: s16w700,
                                  ),
                                  4.height,
                                  Text(
                                    bloc.orderQrCode?.userBankName ?? "",
                                    style: s12w400,
                                    maxLines: 2,
                                  ),
                                ],
                              ).expanded(),
                            ],
                          ),
                        ),
                        16.height,
                        BaseContainer(
                          padding: 16.pading,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              BaseContainer(
                                margin: 16.pading,
                                padding: 16.pading,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    borderRadius: 16.radius,
                                    child: CacheNetworkImageV2(
                                      borderRadius: 16,
                                      height: double.infinity,
                                      url: qrCode?.qrLink,
                                      showLoad: true,
                                    ),
                                  ),
                                ),
                              ),
                              8.height,
                              const Text(
                                "Nội dung chuyển khoản:",
                                style: s14w500,
                              ),
                              4.height,
                              Text(
                                bloc.orderQrCode?.content ?? '',
                                style: s12w400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: 16.pading,
            child: isBanking
                ? Row(
                    children: [
                      ExtraButton(
                        borderColor: AppColors.main,
                        color: AppColors.main,
                        icon: const Icon(
                          Icons.save,
                          color: AppColors.main,
                        ),
                        title: "Lưu mã QR",
                        onTap: () {
                          ImageUtils.saveImage(qrCode?.qrLink, context);
                        },
                      ),
                      16.width,
                      MainButton(
                        title: "Hoàn tất",
                        onTap: () {
                          bloc.confirmPayment();
                          // bloc.updateStatusOrder();
                          // _pinCodeConfirm(context, bloc);
                        },
                      ).expanded(),
                    ],
                  )
                : MainButton(
                    isDisable: !isActive,
                    title: "Thanh toán",
                    onTap: () {
                      // bloc.updateStatusOrder();
                      _pinCodeConfirm(context, bloc);
                    },
                  ),
          ),
        );
      },
    );
  }

  Future<dynamic> _pinCodeConfirm(BuildContext context, OrderDetailCubit bloc) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => PinCodeButtomSheet((value) {
        if (value == true) {
          bloc.confirmPayment();
        }
      }),
    );
  }

  Widget _bankingItem() {
    return Row(
      children: [
        Assets.icons.icBanking.svg(),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Chuyển khoản ngân hàng",
              style: s14w500,
            ),
            4.height,
            Text.rich(
              TextSpan(
                text: widget.bloc.orderQrCode?.bankName,
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
                    text: widget.bloc.orderQrCode?.bankAccount,
                    style: s12w400,
                  ),
                ],
              ),
            ),
          ],
        ).expanded(),
      ],
    );
  }

  Widget _walletItem() {
    final walletBloc = context.read<WalletCubit>();
    walletBloc.setWallet(widget.order.paymentMethod?.id);
    final wallet = walletBloc.wallet;
    return Row(
      children: [
        wallet.logo ?? const SizedBox.shrink(),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              wallet.title,
              style: s14w500,
            ),
            4.height,
            Text.rich(
              TextSpan(
                text: "Số dư: ",
                style: s12w400,
                children: [
                  TextSpan(
                    text: formatCurrency(wallet.balance),
                    style: s12w400,
                  ),
                ],
              ),
            ),
          ],
        ).expanded(),
      ],
    );
  }
}
