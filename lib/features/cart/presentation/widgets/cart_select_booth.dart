import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/spacing.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/extension/string_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/assets.dart';
import 'package:bpg_retail/core/utilities/debouncer.dart';
import 'package:bpg_retail/core/utilities/screens.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:bpg_retail/features/booth/data/models/booth_model.dart';
import 'package:bpg_retail/features/cart/data/bloc/cart_cubit_v2.dart';

class CartSelectBooth extends StatefulWidget {
  const CartSelectBooth({super.key, this.selectedBooth, this.booths});

  final BoothModel? selectedBooth;
  final List<BoothModel>? booths;

  @override
  State<CartSelectBooth> createState() => _CartSelectBoothState();
}

class _CartSelectBoothState extends State<CartSelectBooth> {
  BoothModel? selectedBooth;
  List<BoothModel>? booths;
  late Debouncer _debouncer;

  List<BoothModel> sortBooth(List<BoothModel>? addressList) {
    final List<BoothModel> newBoothList = [...addressList ?? []];

    newBoothList.sort((BoothModel a, BoothModel b) {
      if (widget.selectedBooth == null) {
        return 0;
      }
      return a.id != widget.selectedBooth?.id &&
              b.id == widget.selectedBooth?.id
          ? 1
          : 0;
    });

    return newBoothList;
  }

  @override
  void initState() {
    // if (appCubit.state.booths.isEmpty) {
    //   bloc.shopList(isEmpty: true);
    // }
    // bloc.shopList(isEmpty: true);
    _debouncer = Debouncer();
    super.initState();
    selectedBooth = widget.selectedBooth;
    booths = widget.booths;
  }

  @override
  void dispose() {
    super.dispose();
    _debouncer.dispose();
  }

  @override
  void didUpdateWidget(covariant CartSelectBooth oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  final cartBloc = getIt.get<CartCubitV2>();
  final navigator = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: double.infinity,
          color: AppColors.white,
          height: heightDevice(context) - 60,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewInsets.bottom > 00
                ? AppBar().preferredSize.height
                : 24,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Thay đổi gian hàng",
                    style: AppTypography.h5,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ValidateTextField(
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.white,
                hintText: 'Tìm kiếm gian hàng',
                hintStyle: AppTypography.p6.copyWith(
                  color: AppColors.grey_1,
                ),
                maxLines: 1,
                onChanged: (value) {
                  _debouncer.run(() async {
                    selectedBooth = null;
                    // booths = await cartBloc.getShopList(keyword: value);

                    setState(() {});
                  });
                },
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 15,
                  bottom: 14,
                ),
                leadingIcon: const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.search,
                    size: 20,
                    color: AppColors.black,
                  ),
                ),
                // suffixIcon: const Padding(
                //   padding: EdgeInsets.only(left: 6),
                //   child: Icon(
                //     Icons.mic_none,
                //     size: 20,
                //     color: AppColors.black,
                //   ),
                // ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: booths?.isEmpty == true
                    ? const Center(
                        child: Text("Chưa có gian hàng"),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => 12.height,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: booths?.length ?? 0,
                        itemBuilder: (context, index) {
                          final items = sortBooth(booths);
                          return _groceryItem(
                            items,
                            index,
                            () => setState(() {
                              selectedBooth = items[index];
                            }),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ExtraButton(
                      largeButton: false,
                      title: 'Huỷ bỏ',
                      onTap: () {
                        navigator.pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ExtraButtonV2(
                      isDissemble: selectedBooth == null,
                      largeButton: false,
                      title: 'Xác nhận',
                      color: AppColors.white,
                      bgColor: AppColors.main,
                      borderColor: AppColors.main,
                      onTap: () {
                        final result = BoothSelectModel(
                          selected: selectedBooth,
                          booths: booths,
                        );
                        navigator.pop(result: result);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _groceryItem(
    List<BoothModel> items,
    int index,
    VoidCallback ontap,
  ) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: Spacing.a16,
        width: double.infinity,
        decoration: BoxDecoration(
          color: (selectedBooth != null
                  ? selectedBooth!.id == items[index].id
                  : widget.selectedBooth != null
                      ? widget.selectedBooth!.id == items[index].id
                      : false)
              ? AppColors.blue_2
              : AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1.2,
            color: (selectedBooth != null
                    ? selectedBooth!.id == items[index].id
                    : widget.selectedBooth != null
                        ? widget.selectedBooth!.id == items[index].id
                        : false)
                ? AppColors.blue_1
                : AppColors.border_1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 1.2,
                      color: AppColors.border_1,
                    ),
                    image: DecorationImage(
                      image: items[index].avatar != null
                          ? NetworkImage(
                              items[index].avatar ??
                                  'https://counter-form.com/pgd/assets/img/product_img/noimg.jpg',
                            )
                          : const AssetImage(
                              'assets/images/ic_order_shop.png',
                            ) as ImageProvider,
                      fit: items[index].avatar != null
                          ? BoxFit.cover
                          : BoxFit.none,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        children: [
                          Text(
                            items[index].fullname,
                            style: AppTypography.p5,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Assets.icon(
                            assetName: 'ic_success_2.svg',
                            width: 14,
                            colorFilter: const ColorFilter.mode(
                              AppColors.main,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            " ${items[index].phoneNumber ?? '...'}",
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
                            TextSpan(
                              text:
                                  items[index].fullAddress.nullOrEmpty == false
                                      ? items[index].fullAddress ?? ""
                                      : 'Chưa có địa chỉ',
                              style: AppTypography.p6.copyWith(
                                color: AppColors.blackish,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "  ${(items[index].distance ?? 0).toStringAsFixed(2)} km",
                              style: AppTypography.p6.copyWith(
                                color: AppColors.main,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Wrap(
                      //   children: [
                      //     Text(
                      //       items[index]
                      //                   .fullAddress
                      //                   .nullOrEmpty ==
                      //               false
                      //           ? items[index]
                      //                   .fullAddress ??
                      //               ""
                      //           : 'Chưa có địa chỉ',
                      //       style:
                      //           AppTypography.p6.copyWith(
                      //         color: AppColors.grey_1,
                      //       ),
                      //       maxLines: 2,
                      //       overflow:
                      //           TextOverflow.ellipsis,
                      //     ),
                      //     Text(
                      //       (items[index].distance ?? 0)
                      //           .toStringAsFixed(2),
                      //       style:
                      //           AppTypography.p6.copyWith(
                      //         color: AppColors.grey_1,
                      //       ),
                      //       maxLines: 2,
                      //       overflow:
                      //           TextOverflow.ellipsis,
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 16),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Text(
            //         items[index].phoneNumber == null
            //             ? items[index].username
            //             : items[index].phoneNumber ??
            //                 '...',
            //         textAlign: TextAlign.center,
            //         style: AppTypography.p6,
            //       ),
            //     ),
            //     Container(
            //       width: 1.2,
            //       height: 20,
            //       color: AppColors.grey_2,
            //     ),
            //     Expanded(
            //       child: Text(
            //         items[index].distance != null
            //             ? "${formatNumber(items[index].distance ?? 0, 2)}km"
            //             : '...',
            //         textAlign: TextAlign.center,
            //         style: AppTypography.p6,
            //       ),
            //     ),
            //     Container(
            //       width: 1.2,
            //       height: 20,
            //       color: AppColors.grey_2,
            //     ),
            //     const Expanded(
            //       child: Text(
            //         "${1} sản phẩm",
            //         textAlign: TextAlign.center,
            //         style: AppTypography.p6,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class BoothSelectModel {
  final BoothModel? selected;
  final List<BoothModel>? booths;

  BoothSelectModel({required this.selected, required this.booths});
}
