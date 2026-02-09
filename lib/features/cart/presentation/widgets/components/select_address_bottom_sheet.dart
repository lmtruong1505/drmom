import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/core/widgets/base/scaffold.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/buttons/main_button.dart';
import 'package:bpg_retail/features/cart/data/bloc/asbc_cart_buy_cubit.dart';
import 'package:bpg_retail/features/profile/data/models/address_asbc_model.dart';

class SelectAddressBottomSheet extends StatefulWidget {
  const SelectAddressBottomSheet({super.key, required this.bloc});
  final AsbcCartBuyCubit bloc;

  @override
  State<SelectAddressBottomSheet> createState() =>
      _SelectAddressBottomSheetState();
}

class _SelectAddressBottomSheetState extends State<SelectAddressBottomSheet> {
  final navigator = getIt.get<AppNavigator>();
  final preferences = getIt.get<Preferences>();

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: BaseScaffold(
        body: Container(
          padding: 16.pading,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text("Chọn địa chỉ nhận hàng", style: s18w700),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => navigator.back(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              32.height,
              ExtraButton(
                title: "Thêm địa chỉ",
                borderColor: AppColors.main,
                textStyle: s14w700.copyWith(color: AppColors.main),
                largeButton: true,
                color: AppColors.main,
                onTap: () async {
                  final res = await navigator.push(CreateAddressRoute());
                  if (res == true) {
                    bloc.getASBCListAddress();
                  }
                },
              ),
              16.height,
              BlocBuilder<AsbcCartBuyCubit, CubitState>(
                bloc: bloc,
                builder: (context, state) {
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final address = bloc.listAddress?[index];
                      final isSelect = address?.id == bloc.addressSelect?.id;
                      return _addressItem(address, isSelect);
                    },
                    separatorBuilder: (context, index) => 16.height,
                    itemCount: bloc.listAddress?.length ?? 0,
                  );
                },
              ).expanded(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: 16.pading,
          child: Row(
            children: [
              ExtraButton(
                onTap: () => navigator.pop(),
                largeButton: true,
                title: "Quay lại",
              ).expanded(),
              16.width,
              MainButton(
                title: "Xác nhận",
                onTap: () {
                  navigator.pop(result: bloc.addressSelect);
                },
                largeButton: true,
              ).expanded(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addressItem(AsbcAddressModel? address, bool isSelect) {
    return GestureDetector(
      onTap: () async {
        widget.bloc.selectAddress(address);
      },
      child: BaseContainer(
        padding: 16.pading,
        borderColor: isSelect ? AppColors.main : AppColors.greyA7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          address == null
                              ? preferences.getUserData.fullName ?? ''
                              : address.fullname ?? '',
                          style: s14w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          width: 1,
                          color: AppColors.grey_1,
                          height: 18,
                        ),
                      ),
                      Text(
                        address == null
                            ? preferences.getUserData.phone ?? ''
                            : address.phone ?? '',
                        style: s14w400.copyWith(color: AppColors.grey_1),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: address?.isDefault == true,
                  child: Container(
                    width: 80,
                    height: 32,
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 9,
                      bottom: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue_2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Mặc định",
                      style: AppTypography.p5.copyWith(color: AppColors.blue_1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 8),
            // Text(
            //   address.phone!.isEmpty
            //       ? bloc.currentUser.phoneNumber ?? ''
            //       : address.phone ?? '',
            //   style: AppTypography.p6,
            // ),
            const SizedBox(height: 8),
            Text(
              address!.addressFull ?? '',
              style: AppTypography.p6,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
