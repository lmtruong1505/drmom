import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/base/base_state.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/spacing.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/spacing_extension.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/utilities/assets.dart';
import 'package:BGP_Retail/core/widgets/base/base_loading.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/features/booth/data/bloc/asbc_both_cubit.dart';
import 'package:BGP_Retail/features/profile/data/bloc/address_cubit.dart';
import 'package:BGP_Retail/features/profile/data/bloc/address_state.dart';
import 'package:BGP_Retail/features/profile/data/models/address_asbc_model.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AddressManagerPage extends StatefulWidget {
  const AddressManagerPage({super.key});

  @override
  State<AddressManagerPage> createState() => _AddressManagerPageState();
}

class _AddressManagerPageState extends State<AddressManagerPage> {
  final bloc = getIt.get<AddressCubit>();

  final navigator = getIt.get<AppNavigator>();
  @override
  void initState() {
    super.initState();
    bloc.getASBCListAddress();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.main,
      onRefresh: bloc.getASBCListAddress,
      child: BaseScreen(
        onTap: () {
          navigator.pop(result: true);
        },
        title: 'Quản lý địa chỉ',
        body: Container(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddAddressItem(
                navigator: navigator,
                cubit: bloc,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: BlocBuilder<AddressCubit, AddressState>(
                    bloc: bloc,
                    builder: (context, state) {
                      return state.isLoading
                          ? const BaseLoading()
                          : Column(
                              children: [
                                ListView.separated(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      8.height,
                                  itemCount: state.addressAsbcList.length,
                                  itemBuilder: (context, index) {
                                    final address =
                                        state.addressAsbcList[index];
                                    return _addressItem(address);
                                  },
                                ),
                                16.height,
                              ],
                            );
                    },
                  ),
                ),
              ),

              // BlocBuilder<AddressCubit, AddressState>(
              //   builder: (context, state) {
              //     return Visibility(
              //       visible: state.addressList.length >= 10,
              //       child: Padding(
              //         padding: const EdgeInsets.only(bottom: 20),
              //         child: Text(
              //           "Tối đa tạo được 10 địa chỉ",
              //           style: s14w500.copyWith(color: AppColors.red_1),
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addressItem(AsbcAddressModel address) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final result =
            await navigator.push(CreateAddressRoute(address: address));
        if (result == true) {
          bloc.getASBCListAddress();
        }
      },
      child: Container(
        padding: Spacing.a16,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1.2,
            color: AppColors.accent_3,
          ),
        ),
        child: BlocBuilder<AddressCubit, AddressState>(
          bloc: bloc,
          builder: (context, state) {
            return Column(
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
                              address.fullname!.isEmpty
                                  ? bloc.currentUser.fullname ?? ''
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
                            address.phone!.isEmpty
                                ? bloc.currentUser.phoneNumber ?? ''
                                : address.phone ?? '',
                            style: s14w400.copyWith(color: AppColors.grey_1),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: address.isDefault == true,
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
                          style: AppTypography.p5.copyWith(
                            color: AppColors.blue_1,
                          ),
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
                  address.addressFull ?? '',
                  style: AppTypography.p6,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AddAddressItem extends StatelessWidget {
  const AddAddressItem({
    super.key,
    required this.navigator,
    required this.cubit,
  });

  final AppNavigator navigator;
  final AddressCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      bloc: cubit,
      builder: (context, state) {
        return Visibility(
          visible: state.addressList.length < 10,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final result = await navigator.push(CreateAddressRoute());
              if (result == true) {
                cubit.getASBCListAddress();
                // getIt.get<AsbcBothCubit>().getListHospital();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              child: Container(
                height: 113,
                padding: Spacing.h16,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      offset: Offset(0.0, 3.0),
                      blurRadius: 10,
                      spreadRadius: -1.0,
                      color: Color.fromARGB(
                        160,
                        149,
                        179,
                        197,
                      ),
                    ),
                  ],
                  border: Border.all(
                    width: 1.2,
                    color: AppColors.main,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Thêm địa chỉ để xác định địa điểm nhận hàng của bạn",
                            style: AppTypography.p7.copyWith(
                              color: AppColors.grey_1,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Thêm địa chỉ",
                            style: AppTypography.p5.copyWith(
                              color: AppColors.main,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    Assets.icon(assetName: 'ic_address_manager.svg'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
