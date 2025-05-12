import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/base/base_state.dart';
import 'package:BGP_Retail/core/configs/firebase_analytics_config.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/spacing.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/widgets/appbar_back_button.dart';
import 'package:BGP_Retail/core/widgets/base/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:BGP_Retail/core/widgets/textfield/validate_textfield.dart';
import 'package:BGP_Retail/features/home/data/model/product_model.dart';
import 'package:BGP_Retail/features/profile/data/bloc/favorite_cubit.dart';
import 'package:BGP_Retail/features/profile/data/bloc/favorite_state.dart';

@RoutePage(name: "FavoritePage")
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends BaseState<FavoritePage, FavoriteCubit>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<UnitModel> sortUnitPrice(List<UnitModel>? unitPrice) {
    final List<UnitModel> newUnitPrice = [...(unitPrice ?? [])];

    newUnitPrice.sort((UnitModel a, UnitModel b) {
      return (a.retailPrice ?? 0) > (b.retailPrice ?? 0) ? -1 : 1;
    });

    return newUnitPrice;
  }

  Widget buildListProduct() {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        final products = state.products;
        return products.isEmpty
            ? const Align(
                alignment: Alignment.center,
                child: Text("Không có dữ liệu"),
              )
            : Column(
                children: List.generate(products.length, (index) {
                  final product = products[index];

                  final unitPrice = sortUnitPrice(product.units).first;

                  String priceText = "";
                  if (product.units!.length > 1) {
                    final UnitModel unitPriceList =
                        sortUnitPrice(product.units).last;
                    priceText =
                        "${formatCurrency(unitPriceList.retailPrice ?? 0)} - ${formatCurrency(unitPrice.retailPrice ?? 0)}";
                  } else {
                    priceText = formatCurrency(unitPrice.retailPrice ?? 0);
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        onLongPress: () {},
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
                          child: Row(
                            children: [
                              Container(
                                width: 108,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 1.2,
                                    color: AppColors.border_1,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      product.images?[0].src ??
                                          'https://counter-form.com/pgd/assets/img/product_img/noimg.jpg',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 70,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        priceText,
                                        style: AppTypography.h6.copyWith(
                                          color: AppColors.main,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  bloc.removeProductFavorite(product);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.red_2,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      width: 1.2,
                                      color: AppColors.red_2,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.favorite,
                                      color: AppColors.red_1,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: products.length - 1 == index ? 32 : 16),
                    ],
                  );
                }),
              );
      },
    );
  }

  double? distanceLatLong(double? endLatitude, double? endLongitude) {
    final bool isOk = preferences.locations.length == 2;
    final double? startLatitude = isOk ? preferences.locations[0] : null;
    final double? startLongitude = isOk ? preferences.locations[1] : null;

    if (startLatitude != null &&
        startLongitude != null &&
        endLatitude != null &&
        endLongitude != null) {
      final double distanceInMeters = Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      return distanceInMeters / 1000;
    }
    return null;
  }

  Widget buildListBooth() {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        return state.booths.isEmpty
            ? const Align(
                alignment: Alignment.center,
                child: Text("Không có dữ liệu"),
              )
            : Column(
                children: List.generate(state.booths.length, (index) {
                  final booth = state.booths[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // navigator.push(
                          //   BoothDetailPage(booth: booth),
                          // );
                        },
                        onLongPress: () {},
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
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        width: 1.2,
                                        color: AppColors.border_1,
                                      ),
                                      image: DecorationImage(
                                        image: booth.avatar != null
                                            ? NetworkImage(
                                                booth.avatar ?? '',
                                              )
                                            : const AssetImage(
                                                'assets/images/store_avatar.png',
                                              ) as ImageProvider,
                                        fit: booth.avatar != null
                                            ? BoxFit.cover
                                            : BoxFit.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booth.fullname,
                                          style: AppTypography.p5,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          booth.address ?? '...',
                                          style: AppTypography.p6.copyWith(
                                            color: AppColors.grey_1,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  BlocBuilder<FavoriteCubit, FavoriteState>(
                                    builder: (context, state) {
                                      return GestureDetector(
                                        onTap: () {
                                          bloc.removeBoothFavorite(
                                            booth,
                                          );
                                        },
                                        child: Container(
                                          width: 37,
                                          height: 37,
                                          decoration: BoxDecoration(
                                            color: AppColors.red_2,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.favorite,
                                              color: AppColors.red_1,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      booth.phoneNumber ?? booth.username,
                                      textAlign: TextAlign.center,
                                      style: AppTypography.p6,
                                    ),
                                  ),
                                  Container(
                                    width: 1.2,
                                    height: 20,
                                    color: AppColors.grey_2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      booth.distance != null
                                          ? "${formatNumber(booth.distance ?? 0, 2)}km"
                                          : '...',
                                      textAlign: TextAlign.center,
                                      style: AppTypography.p6,
                                    ),
                                  ),
                                  Container(
                                    width: 1.2,
                                    height: 20,
                                    color: AppColors.grey_2,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${booth.totalProduct ?? '0'} sản phẩm",
                                      textAlign: TextAlign.center,
                                      style: AppTypography.p6,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: state.booths.length - 1 == index ? 32 : 16,
                      ),
                    ],
                  );
                }),
              );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      bloc.onChangeTab(_tabController.index);
    });
    bloc.setFavorites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.main,
      onRefresh: () async {},
      child: BaseScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 56),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarBackButton(),
                  const SizedBox(height: 16),
                  const Text(
                    'Yêu thích',
                    style: AppTypography.h4,
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, state) {
                      return Stack(
                        children: [
                          Positioned(
                            top: 46,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 2,
                                    color: AppColors.grey_2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TabBar(
                            controller: _tabController,
                            indicatorColor: AppColors.main,
                            onTap: (p0) {
                              bloc.setFavorites();
                            },
                            tabs: [
                              Tab(
                                icon: Text(
                                  "Gian hàng",
                                  style: AppTypography.h6.copyWith(
                                    color: state.tabActive == 0
                                        ? AppColors.main
                                        : AppColors.blackish,
                                  ),
                                ),
                              ),
                              Tab(
                                icon: Text(
                                  "Sản phẩm",
                                  style: AppTypography.h6.copyWith(
                                    color: state.tabActive == 1
                                        ? AppColors.main
                                        : AppColors.blackish,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  BlocBuilder<FavoriteCubit, FavoriteState>(
                                    builder: (context, state) {
                                      return ValidateTextField(
                                        initialValue: state.keyword,
                                        margin: EdgeInsets.zero,
                                        backgroundColor: AppColors.white,
                                        hintText: 'Tìm kiếm gian hàng',
                                        hintStyle: AppTypography.p6.copyWith(
                                          color: AppColors.grey_1,
                                        ),
                                        maxLines: 1,
                                        onChanged: (value) {
                                          bloc.handleSearchBooth(value);
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
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: buildListBooth(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(
                                      0,
                                      2,
                                    ),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: BlocBuilder<FavoriteCubit, FavoriteState>(
                                builder: (context, state) {
                                  return ValidateTextField(
                                    initialValue: state.keyword,
                                    margin: EdgeInsets.zero,
                                    backgroundColor: AppColors.white,
                                    hintText: 'Tìm kiếm sản phẩm',
                                    hintStyle: AppTypography.p6.copyWith(
                                      color: AppColors.grey_1,
                                    ),
                                    maxLines: 1,
                                    onChanged: (value) {
                                      bloc.handleSearchProduct(value);
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
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: buildListProduct(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
