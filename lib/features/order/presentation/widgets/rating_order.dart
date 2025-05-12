import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/spacing.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/spacing_extension.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/utilities/assets.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/utilities/loading.dart';
import 'package:BGP_Retail/core/widgets/base/scaffold.dart';
import 'package:BGP_Retail/core/widgets/buttons/extra_button.dart';
import 'package:BGP_Retail/core/widgets/cache_image_network_widget.dart';
import 'package:BGP_Retail/core/widgets/textfield/validate_textfield.dart';
import 'package:BGP_Retail/core/widgets/toast/overlay_custom.dart';
import 'package:BGP_Retail/features/order/data/bloc/rating_order_cubit.dart';
import 'package:BGP_Retail/features/order/data/bloc/ratting_order_state.dart';
import 'package:BGP_Retail/features/order/data/models/order_detail_model.dart';

@RoutePage(name: "RattingOrder")
class RatingOrder extends StatefulWidget {
  const RatingOrder({
    super.key,
    required this.order,
  });
  final OrderDetailModel order;

  @override
  State<RatingOrder> createState() => _RatingOrderState();
}

class _RatingOrderState extends State<RatingOrder> {
  @override
  void initState() {
    super.initState();
    bloc.initData(widget.order);
  }

  @override
  void didUpdateWidget(covariant RatingOrder oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  final bloc = getIt.get<RattingOrderCubit>();
  final navigator = getIt.get<AppNavigator>();
  final duration = const Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toUtc().toString();

    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<RattingOrderCubit, RattingOrderState>(
        bloc: bloc,
        listener: (context, state) {
          if (state.status == CubitStatus.loading) {
            showLoading();
          } else {
            EasyLoading.dismiss();
          }
          if (state.status == CubitStatus.sendSuccess) {
            showOverlayToast(
              title: "Cảm ơn bạn đã đánh giá sản phẩm",
              iconPreffix: Assets.icon(assetName: "ic_ratting.svg"),
            );
          }
        },
        child: BaseScaffold(
          resizeToAvoidBottomInset: false,
          paddingTop: false,
          backgroundImage: true,
          // paddingTopAppBar: true,
          body: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SizedBox(
                    width: 38,
                    height: 38,
                    child: BlocBuilder<RattingOrderCubit, RattingOrderState>(
                      bloc: bloc,
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
                ),
                16.height,
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: AppColors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          12.height,
                          const Text(
                            "Đánh giá sản phẩm",
                            style: AppTypography.h5,
                          ),
                          12.height,
                          const Text(
                            "Những đánh giá của bạn sẽ giúp chúng tôi hoàn thiện sản phẩm ngày một tốt hơn.",
                          ),
                          24.height,
                          const Divider(),
                          12.height,
                          BlocBuilder<RattingOrderCubit, RattingOrderState>(
                            builder: (context, state) {
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final item = state.order?.orderItems?[index];

                                  return RattingItem(
                                    onTap: () {},
                                    item: item,
                                    bloc: bloc,
                                    now: now,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Divider(),
                                ),
                                itemCount: state.order?.orderItems?.length ?? 0,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // bottomNavigationBar: Container(
          //   width: double.infinity,
          //   color: AppColors.white,
          //   padding: const EdgeInsets.all(16),
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       // if (widget.rating == null)
          //       Row(
          //         children: [
          //           Expanded(
          //             child: ExtraButton(
          //               largeButton: true,
          //               title: 'Huỷ bỏ',
          //               padding: const EdgeInsets.symmetric(
          //                 horizontal: 16,
          //                 vertical: 16,
          //               ),
          //               onTap: () {},
          //             ),
          //           ),
          //           16.width,
          //           Expanded(
          //             child: ExtraButton(
          //               largeButton: true,
          //               title: 'Gửi',
          //               borderColor: AppColors.main,
          //               color: AppColors.white,
          //               bgColor: AppColors.main,
          //               padding: const EdgeInsets.symmetric(
          //                 horizontal: 16,
          //                 vertical: 16,
          //               ),
          //               onTap: () {
          //                 // bloc.createFormulaRatingTm(
          //                 //   widget.order!,
          //                 //   _comment,
          //                 //   _userRating,
          //                 // );
          //               },
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}

class RattingItem extends StatelessWidget {
  const RattingItem({
    required this.onTap,
    required this.item,
    required this.bloc,
    required this.now,
  });

  final OrderItem? item;
  final RattingOrderCubit bloc;
  final String now;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final retailPrice = item?.units?[0].retailPrice ?? 0;
    final quantity = item?.units?[0].quantity ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onTap,
              child: CacheNetworkImageV2(
                url: item?.image?.src ?? "",
                width: 80,
                height: 80,
              ),
            ),
            8.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item?.productName ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.p5,
                  ),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item?.units?[0].unitName ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: s14w400.copyWith(
                          color: AppColors.grey_1,
                        ),
                      ),
                      Text(
                        " (${formatCurrency(retailPrice)})",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: s14w400.copyWith(
                          color: AppColors.grey_1,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "x${quantity.toInt()}",
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
        12.height,
        // if (widget.rating == null)
        ...[
          Row(
            children: [
              if (item?.ratting == null)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Text(
                    "Chất lượng sản phẩm",
                    style: AppTypography.p5,
                  ),
                ),
              RatingBar(
                // ignoreGestures: (item?.isUpdate ?? true),
                initialRating: item?.ratting?.star ?? 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: const Icon(
                    Icons.star_rounded,
                    color: AppColors.yellow_1,
                  ),
                  half: const Icon(
                    Icons.star_half,
                    color: AppColors.yellow_1,
                  ),
                  empty: const Icon(
                    Icons.star_rounded,
                    color: AppColors.border_4,
                  ),
                ),
                itemSize: 30,
                onRatingUpdate: (rating) {
                  bloc.changeRatting(
                    rating: rating,
                    item?.productId,
                  );
                },
              ),
              if (item?.ratting != null)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                  ),
                  child: Text(
                    convertDateFormatTime(
                      item!.ratting!.userCreated ?? now,
                    ),
                    style: s14w500.copyWith(
                      color: AppColors.border_2,
                    ),
                  ),
                ),
            ],
          ),
          12.height,
          if (item?.ratting == null) ...[
            const Text(
              "Nội dung đánh giá",
              style: AppTypography.p5,
            ),
            8.height,
            ValidateTextField(
              key: GlobalKey(),
              // initialValue:
              //     item?.isUpdate == true ? item?.ratting?.comment : null,
              margin: EdgeInsets.zero,
              backgroundColor: AppColors.white,
              hintText: 'Chia sẻ cảm nhận của bạn tại đây',
              hintStyle: AppTypography.p6.copyWith(
                color: AppColors.grey_1,
              ),
              maxLines: 4,
              onChanged: (value) {
                bloc.changeRatting(
                  item?.productId,
                  note: value,
                );
              },
              validator: (value) {
                return null;
              },
            ),
          ] else ...[
            Text(
              (item?.ratting?.comment != null && item?.ratting?.comment != "")
                  ? item?.ratting?.comment ?? ""
                  : "Chưa có đánh giá",
              style: s14w400,
              maxLines: 5,
            ),
          ],
        ],

        if (item?.ratting?.images?.isNotEmpty == true)
          Container(
            margin: const EdgeInsets.only(top: 16),
            height: 64,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => CacheNetworkImageV2(
                url: item?.ratting?.images?[index].src,
                width: 64,
                height: 64,
              ),
              separatorBuilder: (context, index) => 8.width,
              itemCount: item?.ratting?.images?.length ?? 0,
            ),
          )
        else if (item?.files?.isNotEmpty == true)
          Container(
            margin: const EdgeInsets.only(top: 16),
            height: 64,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Image.file(
                      File(item?.files?[index] ?? ""),
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () =>
                            bloc.removeImage(index, item?.productId ?? 0),
                        child: const Icon(
                          Icons.cancel,
                          color: AppColors.red_1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              separatorBuilder: (context, index) => 8.width,
              itemCount: item?.files?.length ?? 0,
            ),
          )
        else if (item?.ratting == null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Text(
                "Thêm ảnh/video đính kèm (${item?.files?.length ?? 0}/5)",
                style: s14w700,
              ),
              4.height,
              const Text(
                "Dung lượng tệp tải lên tối đa 15MB",
                style: s14w400,
              ),
              16.height,
              GestureDetector(
                onTap: () => bloc.pickImage(
                  item?.productId ?? 0,
                ),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.blue_2,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.main,
                    ),
                  ),
                  child: const Icon(
                    Icons.add_circle_outline,
                    size: 20,
                    color: AppColors.main,
                  ),
                ),
              ),
            ],
          )
        else
          const SizedBox.shrink(),
        16.height,
        Visibility(
          visible: item?.ratting == null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ExtraButton(
                largeButton: true,
                title: 'Gửi đánh giá',
                borderColor: AppColors.main,
                color: AppColors.white,
                bgColor: AppColors.main,
                padding: Spacing.a8,
                onTap: () {
                  bloc.createOrderRating(item?.productId);
                },
              ),
            ],
          ),
        ),
        // else if (item?.isUpdate == false && item?.ratting != null)
        //   Align(
        //     alignment: Alignment.centerRight,
        //     child: ExtraButton(
        //       largeButton: true,
        //       title: 'Chỉnh sửa đánh giá',
        //       borderColor: AppColors.main,
        //       color: AppColors.main,
        //       padding: Spacing.a8,
        //       onTap: () {
        //         bloc.changeEditOrderItem(
        //           id: item?.productId ?? 0,
        //           isEdit: true,
        //         );
        //       },
        //     ),
        //   )

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     ExtraButton(
        //       largeButton: true,
        //       title: 'Huỷ bỏ',
        //       padding: Spacing.a8,
        //       onTap: () {
        //         bloc.changeEditOrderItem(
        //           id: item?.productId ?? 0,
        //           isEdit: false,
        //         );
        //       },
        //     ),
        //     8.width,
        //     ExtraButton(
        //       largeButton: true,
        //       title: 'Lưu chỉnh sửa',
        //       borderColor: AppColors.main,
        //       color: AppColors.white,
        //       bgColor: AppColors.main,
        //       padding: Spacing.a8,
        //       onTap: () {},
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
