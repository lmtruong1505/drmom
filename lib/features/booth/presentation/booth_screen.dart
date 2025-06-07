import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/app/data/bloc/app_cubit.dart';
import 'package:bpg_retail/app/data/bloc/app_state.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/spacing.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/widgets/address_selection/models/address_selection_model.dart';
import 'package:bpg_retail/core/widgets/base/base_loading.dart';
import 'package:bpg_retail/core/widgets/base/base_screen.dart';
import 'package:bpg_retail/core/widgets/buttons/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/widgets/empty_widget.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:bpg_retail/features/booth/data/bloc/asbc_both_cubit.dart';
import 'package:bpg_retail/features/booth/data/bloc/asbc_both_state.dart';
import 'package:bpg_retail/features/booth/data/models/asbc_both_model.dart';
import 'package:bpg_retail/features/cart/presentation/widgets/cart_select_address.dart';
import 'package:bpg_retail/features/profile/data/models/address_asbc_model.dart';
import 'package:bpg_retail/gen/assets.gen.dart';

@RoutePage()
class BoothScreen extends StatefulWidget {
  const BoothScreen({super.key});

  @override
  State<BoothScreen> createState() => _BoothPageStateV2();
}

class _BoothPageStateV2 extends State<BoothScreen> {
  // late ScrollController _scrollController;
  // late ScrollController _scrollControllerV2;
  late TextEditingController _controller;
  AddressSelectionModel addressSelectionModel = const AddressSelectionModel();

  FilterButtonModel filterSelected =
      const FilterButtonModel(title: "Tất cả", value: null);

  final filterList = <FilterButtonModel>[
    const FilterButtonModel(title: "Tất cả", value: null),
    const FilterButtonModel(title: "Nổi bật", value: 0),
    const FilterButtonModel(title: "Mới", value: 1),
    const FilterButtonModel(title: "Đã xem", value: 2),
  ];

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
    // bloc.getListHospital();
    // WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     print('didChangeAppLifecycleState resumed');
  //     bloc.getASBCListAddress();
  //   }
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   print('didChangeDependencies resumed');
  //   bloc.getASBCListAddress();
  //   // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   //   if (ModalRoute.of(context)?.isCurrent ?? false) {
  //   //     bloc.getASBCListAddress();
  //   //   }
  //   // });
  // }

  final bloc = getIt.get<AsbcBothCubit>();
  final appCubit = getIt.get<AppCubit>();
  final navigator = getIt.get<AppNavigator>();

  @override
  void dispose() {
    _controller.dispose();
    // WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AsbcBothCubit, AsbcBothState>(
      bloc: bloc,
      builder: (context, state) {
        return BaseScreen(
          title: "Danh sách gian hàng",
          body: Column(
            children: [
              Padding(
                padding: 16.pading,
                child: ValidateTextField(
                  margin: EdgeInsets.zero,
                  backgroundColor: AppColors.white,
                  hintText: 'Tìm kiếm gian hàng',
                  hintStyle: AppTypography.p6.copyWith(
                    color: AppColors.grey_1,
                  ),
                  maxLines: 1,
                  onChanged: bloc.onSearch,
                  validator: (value) {},
                ),
              ),
              GestureDetector(
                onTap: () => _selectAddress(state),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.white,
                  ),
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.addressSelected != null
                              ? (state.addressSelected?.addressFull ?? "")
                              : 'Vị trí của bạn',
                          style: s14w400,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      16.width,
                      Assets.icons.icBlackArrowDown.svg(),
                    ],
                  ),
                ),
              ).padding(16.padingHor),
              (state.isLoading)
                  ? const BaseLoading()
                  : Expanded(
                      child: state.listBoths?.isEmpty == true
                          ? const EmptyWidget(
                              title: 'Chưa có gian hàng',
                            )
                          : ListView.separated(
                              padding: 16.pading,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = state.listBoths?[index];
                                return SizedBox.shrink();
                                // return _shopItem(item, true);
                              },
                              separatorBuilder: (context, index) => 8.height,
                              itemCount: state.listBoths?.length ?? 0,
                            ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _shopItem(AsbcBothModel? shop, bool isFavorite) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: Spacing.a16,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1.2,
                color: AppColors.accent_3,
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
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: 1.2,
                          color: AppColors.border_1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Assets.images.icOrderShopSvg.svg(
                          fit: BoxFit.none,
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
                            children: [
                              Text(
                                shop?.title ?? "",
                                style: AppTypography.p5,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              4.width,
                              Assets.icons.icSuccess2.svg(
                                width: 14,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.main,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            shop?.warehouseData?.addressFull ?? '...',
                            style: AppTypography.p6.copyWith(
                              color: AppColors.grey_1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // BlocBuilder<AppCubit, AppState>(
                    //   builder: (context, appState) {
                    //     if (appState.isLoggedIn == false) {
                    //       return const SizedBox.shrink();
                    //     }
                    //     return GestureDetector(
                    //       onTap: () {},
                    //       child: Container(
                    //         width: 37,
                    //         height: 37,
                    //         decoration: BoxDecoration(
                    //           color: isFavorite
                    //               ? AppColors.red_2
                    //               : AppColors.blue_2,
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         child: Center(
                    //           child: Icon(
                    //             isFavorite
                    //                 ? Icons.favorite
                    //                 : Icons.favorite_border,
                    //             color: isFavorite
                    //                 ? AppColors.red_1
                    //                 : AppColors.blue_1,
                    //             size: 18,
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _lineItem(
                      shop?.warehouseData?.phone ?? '...',
                    ),
                    _line(),
                    _lineItem(
                      shop?.diff != null
                          ? "${formatNumberV2(shop?.diff ?? 0)}km"
                          : '...',
                    ),
                    _line(),
                    _lineItem(
                      "${shop?.products ?? 0} sản phẩm",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding _line() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 1.2,
        height: 20,
        color: AppColors.grey_2,
      ),
    );
  }

  Expanded _lineItem(String text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTypography.p6,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _selectAddress(AsbcBothState state) async {
    if (appCubit.state.isLoggedIn) {
      final result = await navigator.showBottomSheet(
        child: SelectAddress(
          selected: state.addressSelected,
          listAddress: state.listAddress,
        ),
        backgroundColor: Colors.transparent,
        enableDrag: true,
      );
      if (result != null && result is AsbcAddressModel) {
        bloc.setAddressSelected(result);
      }
      // else if (result is bool) {
      //   bloc.getASBCListAddress();
      // }
    } else {
      navigator.push(LoginPage());
    }
  }
}
