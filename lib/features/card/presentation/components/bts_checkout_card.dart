import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/base/index_cubit.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/utilities/image_utils.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/buttons/main_button.dart';
import 'package:bpg_retail/core/widgets/cache_image_network_widget.dart';
import 'package:bpg_retail/core/widgets/toast/overlay_custom.dart';
import 'package:bpg_retail/core/widgets/toast/toast.dart';
import 'package:bpg_retail/core/widgets/toast/toast_position.dart';
import 'package:bpg_retail/features/card/data/models/card_model.dart';
import 'package:bpg_retail/gen/assets.gen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/text_and_text.dart';
import '../../data/cubits/create_card_order_bloc.dart';

class BtsCheckoutCard extends StatefulWidget {
  final CardModel model;
  const BtsCheckoutCard({
    super.key,
    required this.model,
  });

  @override
  State<BtsCheckoutCard> createState() => _BtsCheckoutCardState();
}

class _BtsCheckoutCardState extends State<BtsCheckoutCard>
    with AutomaticKeepAliveClientMixin {
  final indexBloc = IndexCubit();
  final bloc = CreateCardOrderBloc();
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    indexBloc.set(1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCardOrderBloc, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        if (state.status == CubitStatus.success) {
          _pageController.nextPage(
            duration: 300.milliseconds,
            curve: Curves.linear,
          );
        }
        if (state.status == CubitStatus.success ||
            state.status == CubitStatus.error) {
          Toast.showToast(
            state.message,
            context,
            toastPosition: ToastPosition.BOTTOM,
            toastBorderRadius: 8.0,
            // backgroundColor: AppColors.white,
            // textStyle: s14w400.copyWith(
            //   color: state.status == CubitStatus.success
            //       ? AppColors.green_3
            //       : AppColors.red,
            // ),
            // border: Border.all(
            //   color: state.status == CubitStatus.success
            //       ? AppColors.green_3
            //       : AppColors.red,
            // ),
            trailing: state.status == CubitStatus.success
                ? const Icon(
                    Icons.check,
                    color: AppColors.white,
                  )
                : const Icon(
                    Icons.error_outline,
                    color: AppColors.white,
                  ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: 16.radiusTop,
          ),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _tabCheckout(),
              _tabBankData(),
            ],
          ),
        );
      },
    );
  }

  Widget _tabBankData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NavigationToolbar(
          middle: const Text(
            'Tạo đơn hàng thành công',
            style: s18w700,
          ),
          trailing: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.close,
              color: AppColors.grey79,
            ),
          ),
        ).size(height: 50),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chuyển khoản với thông tin dưới đây để hoàn tất đơn hàng!',
              style: s12w400,
              textAlign: TextAlign.center,
            ),
            16.height,
            Center(
              child: ImageNetWork(
                path: bloc.cardOrder?.bankData?.logo ?? '',
                height: 40,
              ),
            ),
            8.height,
            Center(
              child: Text(
                bloc.cardOrder?.bankData?.name ?? '',
                style: s12w400,
                textAlign: TextAlign.center,
              ),
            ),
            15.height,
            Center(
              child: Container(
                width: 240,
                height: 240,
                padding: 16.pading,
                decoration: BoxDecoration(
                  borderRadius: 18.radius,
                  border: Border.all(color: AppColors.main),
                ),
                child: ImageNetWork(
                  path: bloc.cardOrder?.bankData?.qr ?? '',
                  width: 240,
                  height: 240,
                ),
              ),
            ),
            15.height,
            InkWell(
              onTap: () => (bloc.cardOrder?.bankData?.accountNumber ?? '').copy,
              child: TextAndText(
                title: 'Số tài khoản:',
                crossAxisAlignment: CrossAxisAlignment.center,
                subtitle: bloc.cardOrder?.bankData?.accountNumber ?? '',
                textAlign: TextAlign.left,
                style: s16w700,
                isExpanded: false,
                icon: const Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: AppColors.main,
                ).padding(4.padingLeft),
              ),
            ),
            8.height,
            Text(
              'Chủ tài khoản:',
              style: s14w400.copyWith(
                color: AppColors.grey79,
              ),
            ),
            InkWell(
              onTap: () => (bloc.cardOrder?.bankData?.accountName ?? '').copy,
              child: Row(
                children: [
                  Text(
                    bloc.cardOrder?.bankData?.accountName ?? '',
                    style: s14w700,
                  ).flexible(),
                  const Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: AppColors.main,
                  ).padding(4.padingLeft),
                ],
              ),
            ),
            8.height,
            InkWell(
              onTap: () => (bloc.cardOrder?.bankData?.amount?.round() ?? '')
                  .toString()
                  .copy,
              child: TextAndText(
                crossAxisAlignment: CrossAxisAlignment.center,
                title: 'Số tiền:',
                subtitle:
                    bloc.cardOrder?.bankData?.amount.toPrice(type: ' VNĐ') ??
                        "",
                textAlign: TextAlign.left,
                style: s18w700.copyWith(
                  color: AppColors.main,
                ),
                isExpanded: false,
                icon: const Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: AppColors.main,
                ).padding(4.padingLeft),
              ),
            ),
            8.height,
            Text(
              'Nội dung chuyển khoản:',
              style: s14w400.copyWith(
                color: AppColors.grey79,
              ),
            ),
            InkWell(
              onTap: () => (bloc.cardOrder?.bankData?.addInfo ?? '').copy,
              child: Row(
                children: [
                  Text(
                    bloc.cardOrder?.bankData?.addInfo ?? '',
                    style: s14w700,
                  ).flexible(),
                  const Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: AppColors.main,
                  ).padding(4.padingLeft),
                ],
              ),
            ),
          ],
        ).size(width: context.width).expanded(),
        Row(
          children: [
            ExtraButton(
              borderColor: AppColors.main,
              bgColor: AppColors.main.withOpacity(0.1),
              onTap: () async {
                final res = await ImageUtils.saveImage(
                  bloc.cardOrder?.bankData?.qr,
                  context,
                );
                // final res = await getIt<BaseDio>()
                //     .download(bloc.cardOrder?.bankData?.qr ?? "");
                // print(res);
                if (res == true) {
                  Toast.showToast("Tải ảnh thành công", context);
                }
              },
              largeButton: false,
              title: 'Lưu mã QR',
              icon: const Icon(
                Icons.file_present_outlined,
                color: AppColors.main,
                size: 20,
              ),
              textStyle: s14w500.copyWith(
                color: AppColors.main,
              ),
              radius: 99,
            ),
            16.width,
            MainButton(
              onTap: () {
                context.router.popUntilRoot();
              },
              largeButton: false,
              title: 'Quay về trang chủ',
              radius: 99,
            ).expanded(),
          ],
        ),
        context.padding.bottom.height,
      ],
    ).padding(16.padingHor);
  }

  Widget _tabSuccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NavigationToolbar(
          // middle: const Text(
          //   'Tạo đơn hàng thành công',
          //   style: s18w700,
          // ),
          trailing: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.close,
              color: AppColors.grey79,
            ),
          ),
        ).size(height: 50),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.icons.icSuccess2.svg(),
            // const Text(
            //   'Chuyển khoản với thông tin dưới đây để hoàn tất đơn hàng!',
            //   style: s12w400,
            //   textAlign: TextAlign.center,
            // ),
            16.height,
            Text(
              'Thanh toán thành công',
              textAlign: TextAlign.center,
              style: s20w700.copyWith(
                color: Colors.black,
              ),
            ),
            20.height,
            _infoCard(isSuccess: true),
          ],
        ).expanded(),
        MainButton(
          onTap: () {
            context.router.popUntilRoot();
          },
          largeButton: false,
          title: 'Quay về trang chủ',
          radius: 99,
        ),
        context.padding.bottom.height,
      ],
    ).padding(16.padingHor);
  }

  Widget _tabCheckout() {
    return SingleChildScrollView(
      padding: 16.padingHor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          NavigationToolbar(
            middle: const Text(
              'Thông tin thanh toán',
              style: s18w700,
            ),
            trailing: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.close,
                color: AppColors.grey79,
              ),
            ),
          ).size(height: 50),
          Container(
            height: 210,
            child: Stack(
              children: [
                ImageNetWork(
                  path: widget.model.image ?? '',
                  height: 210,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  radius: 16.radius,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.model.title ?? "",
                        style: s20w700.copyWith(color: AppColors.white),
                      ),
                      12.height,
                      Center(
                        child: Text(
                          formatNumberWithSpaces(widget.model.code ?? ""),
                          style: s20w700.copyWith(color: AppColors.white),
                        ),
                      ),
                      16.height,
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.model.cashback}% Cashback",
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
                                  convertStringToYYMM(
                                    widget.model.createdAt ?? DateTime.now(),
                                  ),
                                  style:
                                      s16w500.copyWith(color: AppColors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      12.height,
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Trị giá",
                              style: s12w500.copyWith(color: AppColors.white),
                            ),
                            Text(
                              "Lợi nhuận",
                              style: s12w500.copyWith(color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                      4.height,
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatCurrency(widget.model.price ?? 0),
                              style: s14w500.copyWith(color: AppColors.white),
                            ),
                            Text(
                              "${formatCurrency((widget.model.price ?? 0) * (widget.model.cashback ?? 0) / 100)} /ngày",
                              style: s14w500.copyWith(color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          16.height,
          Row(
            children: [
              const Text(
                'Tổng tiền',
                style: s14w500,
              ),
              const Spacer(),
              if (bloc.cardOrder?.code != null) ...[
                Text(
                  'Mã TT: ',
                  style: s14w500.copyWith(
                    color: AppColors.grey79,
                  ),
                ),
                Text(
                  '#${bloc.cardOrder?.code ?? ''}',
                  style: s14w500.copyWith(
                    color: AppColors.main,
                  ),
                ),
              ],
            ],
          ),
          12.height,
          Row(
            children: [
              Text(
                widget.model.price.toPrice(type: ' VNĐ'),
                style: s18w500.copyWith(
                  color: AppColors.main,
                ),
              ),
              const Spacer(),
              if (bloc.cardOrder?.isPay != null)
                Container(
                  padding: 16.padingHor + 4.padingVer,
                  decoration: BoxDecoration(
                    color: (bloc.cardOrder?.isPay != true
                            ? AppColors.red
                            : AppColors.green_3)
                        .withOpacity(0.1),
                    borderRadius: 99.radius,
                  ),
                  child: Text(
                    bloc.cardOrder?.isPay != true
                        ? 'Chưa thanh toán'
                        : 'Đã thanh toán',
                    style: s14w400.copyWith(
                      color: bloc.cardOrder?.isPay != true
                          ? AppColors.red
                          : AppColors.green_3,
                    ),
                  ),
                ),
            ],
          ),
          const Divider(
            height: 30,
            color: AppColors.greyD9,
          ),
          _infoCard(),
          16.height,
          MainButton(
            isLoad: bloc.state.status == CubitStatus.loading,
            onTap: () {
              // ImageUtils.saveImage("url", context);
              bloc.create(
                cardId: widget.model.id!,
                qty: widget.model.qty ?? 1,
              );
            },
            largeButton: false,
            title: 'Thanh toán',
            radius: 99,
          ),
          context.padding.bottom.height,
        ],
      ),
    );
  }

  Container _infoCard({
    bool isSuccess = false,
  }) {
    return Container(
      padding: 16.pading,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyD9),
        borderRadius: 16.radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isSuccess) ...[
            Text(
              (indexBloc.state * widget.model.price.validator)
                  .toPrice(type: 'VNĐ'),
              textAlign: TextAlign.center,
              style: s20w700.copyWith(color: AppColors.main),
            ),
            16.height,
          ],
          const Text(
            'Thông tin tài khoản',
            style: s14w500,
          ),
          8.height,
          TextAndText(
            title: 'Ngân hàng:',
            subtitle: widget.model.bank?.name ?? '',
          ),
          8.height,
          TextAndText(
            title: 'Số tài khoản:',
            subtitle: widget.model.bank?.accountNumber ?? '',
          ),
          8.height,
          TextAndText(
            title: 'Chủ tài khoản: ',
            subtitle: widget.model.bank?.accountName ?? '',
          ),
          8.height,
          if (isSuccess)
            TextAndText(
              title: 'Ngày thanh toán: ',
              subtitle:
                  bloc.cardOrder?.createdAt.toText(fomat: 'HH:mm dd/MM/yyyy') ??
                      "",
            ),
          // if (!isSuccess)
          //   Row(
          //     children: [
          //       Text(
          //         'Mã QR',
          //         style: s14w400.copyWith(
          //           color: AppColors.grey79,
          //         ),
          //       ),
          //       const Spacer(),
          //       InkWell(
          //         onTap: () async {
          //           final res = await getIt<BaseDio>()
          //               .download(widget.model.bank?.logo ?? "");
          //           if (res != null) {
          //             Toast.showToast(
          //               "Tải ảnh thành công $res",
          //               context,
          //             );
          //           }
          //         },
          //         child: Row(
          //           children: [
          //             Text(
          //               'Tải về',
          //               style: s14w400.copyWith(
          //                 color: AppColors.main,
          //               ),
          //               textAlign: TextAlign.right,
          //             ),
          //             8.width,
          //             Assets.icons.icQrCode.svg(
          //               color: AppColors.grey79,
          //               height: 24,
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          const Divider(
            height: 30,
            color: AppColors.greyD9,
          ),
          const Text(
            'Sản phẩm',
            style: s14w500,
          ),
          8.height,
          TextAndText(
            title: 'Tên sản phẩm:',
            subtitle: widget.model.title ?? "",
          ),
          8.height,
          TextAndText(
            title: 'Tỷ lệ sinh lời:',
            subtitle: "${widget.model.cashback.toPrice(type: '%')}/ Ngày",
          ),
          if (!isSuccess) 8.height,
          if (!isSuccess)
            Row(
              children: [
                Text(
                  'Số lượng:',
                  style: s14w400.copyWith(
                    color: AppColors.grey79,
                  ),
                ),
                const Spacer(),
                ExtraButton(
                  onTap: () {
                    if (indexBloc.state > 1) {
                      indexBloc.set(indexBloc.state - 1);
                    }
                  },
                  largeButton: false,
                  padding: 0.pading,
                  borderColor: AppColors.greyD9,
                  icon: const Icon(
                    Icons.remove,
                    color: AppColors.grey79,
                  ),
                ).size(width: 35, height: 35),
                8.width,
                BlocConsumer<IndexCubit, int>(
                  bloc: indexBloc,
                  listener: (context, state) {
                    widget.model.qty = state;
                  },
                  builder: (context, state) {
                    return Text(
                      '$state',
                      style: s14w400.copyWith(
                        color: AppColors.main,
                      ),
                      textAlign: TextAlign.center,
                    ).size(width: 40);
                  },
                ),
                8.width,
                ExtraButton(
                  onTap: () {
                    indexBloc.set(indexBloc.state + 1);
                  },
                  largeButton: false,
                  padding: 0.pading,
                  borderColor: AppColors.greyD9,
                  icon: const Icon(
                    Icons.add,
                    color: AppColors.grey79,
                  ),
                ).size(width: 35, height: 35),
              ],
            ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
// checkSallaryPer()async{
//   final status = await Permission.photos.request();
//   switch (status) {
//     case status?.isGranted:
      
//       break;
//     default:
//   }
// }
