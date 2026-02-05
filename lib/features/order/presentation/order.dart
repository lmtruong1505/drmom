import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/spacing.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/widgets/base/base_loading.dart';
import 'package:bpg_retail/core/widgets/base/base_screen.dart';
import 'package:bpg_retail/core/widgets/base/scaffold.dart';
import 'package:bpg_retail/core/widgets/buttons/filter_button.dart';
import 'package:bpg_retail/core/widgets/cache_image_network_widget.dart';
import 'package:bpg_retail/core/widgets/empty_widget.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/features/cart/presentation/cart_qr_buy%20.dart';
import 'package:bpg_retail/features/order/data/bloc/order_cubit_v2.dart';
import 'package:bpg_retail/features/order/data/bloc/order_state_v2.dart';
import 'package:bpg_retail/features/order/data/models/order_asbc_model.dart';
import 'package:bpg_retail/features/order/data/models/order_model.dart';
import 'package:bpg_retail/features/order/presentation/widgets/order_silver_appbar.dart';
import 'package:bpg_retail/gen/assets.gen.dart';

@RoutePage()
class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final bloc = getIt.get<OrderCubitV2>();
  final navigator = getIt.get<AppNavigator>();
  late ScrollController _screenController;
  late ScrollController _listOrderController;
  late ScrollController _listFilterController;
  late TextEditingController keywordSearch;

  List<FilterButtonModel> filterList = [
    const FilterButtonModel(title: "Tất cả", value: null),
    const FilterButtonModel(
      title: "Chờ thanh toán",
      value: "CTT",
      icon: Icon(
        Icons.rotate_left_rounded,
        color: AppColors.white,
        size: 28,
      ),
    ),
    const FilterButtonModel(
      title: "Chờ xác nhận",
      value: "CXN",
      icon: Icon(
        Icons.rotate_left_rounded,
        color: AppColors.white,
        size: 28,
      ),
    ),
    const FilterButtonModel(
      title: "Chờ lấy hàng",
      value: "CLH",
      icon: Icon(
        Icons.rotate_left_rounded,
        color: AppColors.white,
        size: 28,
      ),
    ),
    const FilterButtonModel(
      title: "Đang giao hàng",
      value: "ĐGH",
      icon: Icon(
        Icons.local_shipping_outlined,
        color: AppColors.white,
        size: 28,
      ),
    ),
    const FilterButtonModel(
      title: "Đã giao hàng",
      value: "ĐG",
      icon: Icon(
        Icons.assignment_turned_in_outlined,
        color: AppColors.white,
        size: 28,
      ),
    ),
    const FilterButtonModel(
      title: "Hoàn thành",
      value: "HT",
      icon: Icon(
        Icons.done_all_rounded,
        color: AppColors.white,
        size: 28,
      ),
    ),
    const FilterButtonModel(
      title: "Hoàn hàng",
      value: "HH",
      icon: Icon(
        Icons.swap_vert_rounded,
        color: AppColors.white,
        size: 28,
      ),
    ),
    const FilterButtonModel(
      title: "Đã hủy",
      value: "ĐH",
      icon: Icon(
        Icons.cancel_outlined,
        color: AppColors.white,
        size: 28,
      ),
    ),
    const FilterButtonModel(
      title: "Khiếu nại",
      value: "KN",
      icon: Icon(
        Icons.cancel_outlined,
        color: AppColors.white,
        size: 28,
      ),
    ),
  ];

  @override
  void initState() {
    _screenController = ScrollController();
    _listOrderController = ScrollController();
    _listFilterController = ScrollController();
    keywordSearch = TextEditingController();
    super.initState();
    _screenController.addListener(() {
      if (_screenController.position.atEdge) {
        bloc.onShowBG(_screenController.position.pixels < 120);
      }
    });

    _listOrderController.onMore(() => bloc.onLoadMore());
  }

  @override
  void dispose() {
    _screenController.dispose();
    _listOrderController.dispose();
    _listFilterController.dispose();
    keywordSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc
        ..getOrders()
        ..getTotalOrders(),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<OrderCubitV2, OrderStateV2>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.bg_6,
            body: CustomScrollView(
              controller: _listOrderController,
              slivers: [
                SliverPersistentHeader(
                  delegate: OrderSilverAppBar(
                    expandedHeight: 270,
                    filterList:
                        filterList.where((e) => e.value != null).toList(),
                    onTap: (selected) {
                      bloc.onFilter(selected);
                      final index = filterList.indexOf(selected);
                      final widthDevice = context.width;
                      _listFilterController.animateTo(
                        (index) * widthDevice / 4,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  pinned: false,
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: OrderHeaderSearch(
                    bloc: bloc,
                    keywordSearch: keywordSearch,
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: OrderHeaderFilter(
                    filterList: filterList,
                    bloc: bloc,
                    listFilterController: _listFilterController,
                  ),
                ),
                SliverToBoxAdapter(
                  child: 16.height,
                ),
                if (state.isLoading)
                  const SliverToBoxAdapter(
                    // hasScrollBody: false,
                    child: BaseLoading(),
                  )
                else ...[
                  if (state.orders?.isEmpty == true)
                    const SliverToBoxAdapter(
                      child: EmptyWidget(title: 'Chưa có đơn hàng'),
                    )
                  else ...[
                    SliverList.separated(
                      itemBuilder: (context, index) {
                        final item = state.orders?[index];
                        return _groceryItem(item, index);
                      },
                      separatorBuilder: (context, index) => 16.height,
                      itemCount: state.orders?.length ?? 0,
                    ),
                    SliverToBoxAdapter(
                      child: Visibility(
                        visible:
                            state.status == CubitStatus.loaded && bloc.isMore,
                        child: const BaseLoading().padding(16.padingVer),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _groceryItem(OrderAsbcModel? item, int index) {
    final firstOrder = item?.orderitems?.firstOrNull;
    return Padding(
      padding: 20.padingHor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              final result = await navigator
                  .push(OrderDetailRoute(order: item, code: item?.code ?? ""));
              if (result == true) {
                bloc
                  ..getOrders()
                  ..getTotalOrders();
              }
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1.2,
                  color: AppColors.main,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: Spacing.a16,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: AppColors.border_4,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Assets.icons.icOrderShop
                                      .svg(width: 24, height: 24),
                                  8.width,
                                  Flexible(
                                    child: Text(
                                      item?.companyData?.title ?? '',
                                      style: AppTypography.p5,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  4.width,
                                  Assets.icons.icSuccess2.svg(
                                    width: 14,
                                    height: 14,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.main,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            16.width,
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  item?.statusOrderData?.title ?? '',
                                  style: AppTypography.p5.copyWith(
                                    color: getColorStatus(
                                      item?.statusOrderData?.code ?? "",
                                    ),
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "#${item?.code ?? '_'}",
                              style: s14w500.copyWith(color: AppColors.blue31),
                            ),
                            Text(
                              convertDateFormatTime(item?.createdAt ?? ''),
                              style: s14w500.copyWith(color: AppColors.greyA7),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: Spacing.a16,
                    child: Row(
                      children: [
                        CacheNetworkImageV2(
                          url: firstOrder?.variantData?.image,
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  firstOrder?.variantData?.title ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: s14w500,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                      children: [
                        Text(
                          "${item?.orderitems?.length ?? 0} sản phẩm",
                          style: AppTypography.p5.copyWith(
                            color: AppColors.grey_1,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatCurrency(item?.paymentData?.total ?? 0),
                          style: AppTypography.h5.copyWith(
                            color: AppColors.blue31,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderHeaderSearch extends SliverPersistentHeaderDelegate {
  final OrderCubitV2 bloc;
  final TextEditingController? keywordSearch;
  OrderHeaderSearch({
    required this.keywordSearch,
    required this.bloc,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return BlocBuilder<OrderCubitV2, OrderStateV2>(
      builder: (context, state) => _buildSearchBar(state),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Container _buildSearchBar(OrderStateV2 state) {
    return Container(
      color: AppColors.bg_6,
      child: Container(
        margin: 16.pading,
        decoration: BoxDecoration(
          color: AppColors.white,
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
        child: ValidateTextField(
          controller: keywordSearch,
          border: false,
          margin: EdgeInsets.zero,
          backgroundColor: AppColors.white,
          hintText: 'Tìm kiếm đơn hàng',
          hintStyle: AppTypography.p6.copyWith(
            color: AppColors.grey_1,
          ),
          maxLines: 1,
          onChanged: bloc.onSearch,
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
        ),
      ),
    );
  }
}

class OrderHeaderFilter extends SliverPersistentHeaderDelegate {
  final ScrollController listFilterController;
  final List<FilterButtonModel> filterList;
  final OrderCubitV2 bloc;

  OrderHeaderFilter({
    required this.listFilterController,
    required this.filterList,
    required this.bloc,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return BlocBuilder<OrderCubitV2, OrderStateV2>(
      bloc: bloc,
      builder: (context, state) => BlocBuilder<OrderCubitV2, OrderStateV2>(
        builder: (context, state) {
          return _buildFilterSection(state);
        },
      ),
    );
  }

  @override
  double get maxExtent => 42;

  @override
  double get minExtent => 42;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  Widget _buildFilterSection(OrderStateV2 state) {
    return Container(
      color: AppColors.bg_6,
      child: Center(
        child: Padding(
          padding: 20.padingLeft,
          child: FilterButton(
            scrollController: listFilterController,
            listFilter: filterList,
            selectFilter: state.filter,
            defaultColor: AppColors.white,
            handleSelectFilter: (selected) {
              bloc.onFilter(selected);
            },
          ),
        ),
      ),
    );
  }
}
