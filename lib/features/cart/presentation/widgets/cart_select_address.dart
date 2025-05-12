import 'package:flutter/material.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/spacing.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/extension/spacing_extension.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/utilities/screens.dart';
import 'package:BGP_Retail/core/widgets/buttons/extra_button.dart';
import 'package:BGP_Retail/features/profile/data/models/address_asbc_model.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({super.key, this.selected, this.listAddress});

  final AsbcAddressModel? selected;
  final List<AsbcAddressModel>? listAddress;

  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  AsbcAddressModel? selectedAddress;

  List<AsbcAddressModel> sortAddress(List<AsbcAddressModel> addressList) {
    final List<AsbcAddressModel> newAddressList = [...addressList];

    newAddressList.sort((AsbcAddressModel a, AsbcAddressModel b) {
      if (a.id != widget.selected?.id && b.id == widget.selected?.id) {
        return 1;
      }
      return (b.isDefault == true ? 1 : 0) - (a.isDefault == true ? 1 : 0);
    });

    return newAddressList;
  }

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
        child: Container(
          width: double.infinity,
          color: AppColors.white,
          height: heightDevice(context) - 60,
          padding: 16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Thay đổi địa chỉ giao hàng",
                    style: AppTypography.h5,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                child: ExtraButton(
                  borderColor: AppColors.main,
                  color: AppColors.main,
                  title: "Thêm địa chỉ",
                  onTap: () async {
                    navigator.popAndPush(const AddressManagerRoute());
                  },
                  largeButton: true,
                  icon: null,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => 16.height,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.listAddress?.length ?? 0,
                  itemBuilder: (context, index) {
                    final address =
                        sortAddress(widget.listAddress ?? [])[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAddress = address;
                        });
                      },
                      child: Container(
                        padding: Spacing.a16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1.2,
                            color: (selectedAddress != null
                                    ? selectedAddress!.id == address.id
                                    : widget.selected != null
                                        ? widget.selected!.id == address.id
                                        : false)
                                ? AppColors.blue_1
                                : AppColors.border_1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    address.fullname ?? '',
                                    style: AppTypography.p5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              address.phone ?? '',
                              style: AppTypography.p6,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              address.addressFull ?? '',
                              style: AppTypography.p6,
                            ),
                            const SizedBox(height: 8),
                            Visibility(
                              visible: address.isDefault == true,
                              child: Container(
                                width: 80,
                                height: 32,
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  top: 8,
                                  bottom: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: address.isDefault == true
                                      ? (selectedAddress != null
                                              ? selectedAddress!.id ==
                                                  address.id
                                              : widget.selected != null
                                                  ? widget.selected!.id ==
                                                      address.id
                                                  : false)
                                          ? AppColors.blue_1
                                          : AppColors.blue_2
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: address.isDefault == true
                                    ? Text(
                                        "Mặc định",
                                        style: AppTypography.p5.copyWith(
                                          color: (selectedAddress != null
                                                  ? selectedAddress!.id ==
                                                      address.id
                                                  : widget.selected != null
                                                      ? widget.selected!.id ==
                                                          address.id
                                                      : false)
                                              ? AppColors.white
                                              : AppColors.blue_1,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: ExtraButton(
                      largeButton: false,
                      title: 'Xác nhận',
                      color: AppColors.white,
                      bgColor: AppColors.main,
                      borderColor: AppColors.main,
                      onTap: () {
                        navigator.pop(result: selectedAddress);
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
}
