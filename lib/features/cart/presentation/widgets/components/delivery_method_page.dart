import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/core/base/cubit_state.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/utilities/dialog_utils.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/utilities/funtion.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base_container.dart';
import 'package:BGP_Retail/core/widgets/buttons/extra_button.dart';
import 'package:BGP_Retail/core/widgets/buttons/main_button.dart';
import 'package:BGP_Retail/features/cart/data/bloc/asbc_cart_buy_cubit.dart';
import 'package:BGP_Retail/features/cart/data/models/ghtk_model.dart';
import 'package:BGP_Retail/features/cart/presentation/asbc_cart_buy_v2.dart';
import 'package:BGP_Retail/gen/assets.gen.dart';

@RoutePage()
class DeliveryMethodPage extends StatelessWidget {
  const DeliveryMethodPage({super.key, required this.bloc});
  final AsbcCartBuyCubit bloc;

  @override
  Widget build(BuildContext context) {
    // final walletBloc = context.read<WalletCubit>();
    final navigator = getIt.get<AppNavigator>();
    return BaseScreen(
      title: "Hình thức vận chuyển",
      body: BlocBuilder<AsbcCartBuyCubit, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          final wareHouse = bloc.products?.firstOrNull?.companyData;

          final senderLat = wareHouse?.address?.lat ?? 0;
          final senderLong = wareHouse?.address?.long ?? 0;
          final receiverLat = bloc.addressSelected?.addressData?.lat ?? 0;
          final receiverLong = bloc.addressSelected?.addressData?.long ?? 0;
          final distance = calculateDistance(
            senderLat,
            senderLong,
            receiverLat,
            receiverLong,
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Bạn có thể lựa chọn một trong các hình thức vận chuyển sau đây:",
                  style: s14w400,
                ),
                8.height,
                GestureDetector(
                  onTap: () {
                    DialogUtils.showWarningDialog(
                      context,
                      isDouble: true,
                      content:
                          'Kho nhà cung cấp  tại địa chỉ ${wareHouse?.title} cách bạn ${distance.toStringAsFixed(2)}km, bạn vui lòng tự di chuyển đến lấy hàng tại kho trước 7 ngày. Thông tin kho sẽ được gửi sau khi đơn hàng thanh toán thành công. Bạn xác nhận chọn hình thức nhận hàng này?',
                      mainTap: () {
                        navigator.pop();
                        bloc.pickDeliveryMethod(DeliveryMethodEnum.pickUp);
                      },
                    );
                  },
                  child: BaseContainer(
                    borderColor:
                        bloc.deliveryTypePick == DeliveryMethodEnum.pickUp
                            ? AppColors.main
                            : null,
                    padding: 16.pading,
                    child: Row(
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
                                  style:
                                      s14w500.copyWith(color: AppColors.main),
                                ),
                              ],
                            ),
                            4.height,
                            Text(
                              bloc.products?.firstOrNull?.companyData?.address
                                      ?.addressFull ??
                                  "",
                              maxLines: 2,
                              style: s12w400,
                            ),
                          ],
                        ).expanded(),
                      ],
                    ),
                  ),
                ),
                8.height,
                walletList(),
              ],
            ).padding(16.pading),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: 16.padingHor + 16.padingTop,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ExtraButton(
                  title: "Quay lại",
                  onTap: () {
                    navigator.pop();
                  },
                  largeButton: true,
                ).expanded(),
                16.width,
                MainButton(
                  title: "Chọn",
                  onTap: () {
                    navigator.pop(result: true);
                  },
                  largeButton: true,
                ).expanded(),
              ],
            ),
            if (Platform.isIOS)
              SizedBox(height: MediaQuery.of(context).padding.bottom / 2),
          ],
        ),
      ),
    );
  }

  Widget walletList() {
    return Visibility(
      visible: bloc.viettelPostDelivery.isNotEmpty,
      child: BaseContainer(
        padding: 16.pading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Assets.images.imgViettelPost.image(width: 48, height: 48),
                8.width,
                const Text(
                  "Viettel Post",
                  style: s14w500,
                )
              ],
            ),
            const Divider(
              height: 1,
            ).padding(16.padingVer),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final listDelivery = bloc.viettelPostDelivery;
                return _deliveryItem(listDelivery[index]);
              },
              separatorBuilder: (context, index) {
                return 8.height;
              },
              itemCount: bloc.viettelPostDelivery.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget _deliveryItem(ViettelPostModel delivery) {
    final now = DateTime.now();
    final deliveryTime = convertHoursToDays(delivery.thoiGian);
    final firtsDate = now.add(Duration(days: deliveryTime));
    final secondDate = now.add(Duration(days: deliveryTime + 1));
    return GestureDetector(
      onTap: () {
        bloc.pickDeliveryMethod(DeliveryMethodEnum.ship, delivery: delivery);
      },
      child: BaseContainer(
        borderColor: bloc.deliveryTypePick == DeliveryMethodEnum.ship &&
                delivery.tenDichvu == bloc.deliveryPick?.tenDichvu
            ? AppColors.main
            : null,
        padding: 16.pading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  delivery.tenDichvu ?? "",
                  style: s14w500,
                ),
                16.width,
                Text(
                  formatCurrency(delivery.giaCuoc ?? 0),
                  style: s14w400.copyWith(color: AppColors.main),
                )
              ],
            ),
            4.height,
            Text(
              "Nhận hàng vào ${convertDateYYYYMMDD(firtsDate)} - ${convertDateYYYYMMDD(secondDate)} ",
              style: s12w400,
            )
            // Text.rich(
            //     TextSpan(text: "Nhận hàng vào", style:, children: [
            //   TextSpan(
            //     text: "18 Tháng 9 - 20 Tháng 9",
            //     style: s12w400,
            //   )
            // ]))
          ],
        ),
      ),
    );
  }
}
