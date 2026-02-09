import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/features/asset_category/presentation/asset_category_page.dart';
import 'package:bpg_retail/features/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/app/data/bloc/app_state.dart';
import 'package:bpg_retail/core/base/index_cubit.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/utilities/assets.dart';
import 'package:bpg_retail/features/cart/data/bloc/cart_bloc_V2.dart';

import '../../app/data/bloc/app_cubit.dart';
import '../../core/base/cubit_state.dart';
import '../../core/utilities/enum.dart';
import '../card/data/cubits/card_bloc.dart';
import '../cart/data/bloc/cart_bloc.dart';
import '../wallet/data/cubits/wallet_cubit.dart';

@RoutePage()
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final indexCubit = IndexCubit();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initializeData() {
    context.read<WalletCubit>().getWallets();
    context.read<CardBloc>().getMyCard();
  }

  final cartBloc = getIt.get<CartV2Bloc>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<IndexCubit, int>(
          bloc: indexCubit,
          listener: (context, state) {
            _tabController.animateTo(state, duration: 300.milliseconds);
          },
        ),
        BlocListener<CardBloc, CubitState>(
          listener: (context, state) {
            if (state.status == CubitStatus.success) {}
          },
        ),
        BlocListener<WalletCubit, CubitState>(listener: (context, state) {}),
        BlocListener<CartBloc, CubitState>(listener: (context, state) {}),
      ],
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state.isLoggedIn) {
            cartBloc.getCart();
          }
        },
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: _btnNav(),
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const DashboardPage(),
                const AssetCategoryPage(),
                Container(
                  color: AppColors.bg_6,
                  child: const Center(
                    child: Text(
                      'Tính năng này đang được phát triển',
                      style: s16w500,
                    ),
                  ),
                ),
                Container(
                  color: AppColors.bg_6,
                  child: const Center(
                    child: Text(
                      'Tính năng này đang được phát triển',
                      style: s16w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _btnNav() {
    return BlocBuilder<IndexCubit, int>(
      bloc: indexCubit,
      builder: (context, state) {
        return BaseContainer(
          padding: const EdgeInsets.symmetric(vertical: 12),
          borderRadius: 0,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _iconBtn(icon: 'ic_home', index: 0),
                _iconBtn(icon: 'ic_laptop_medical', index: 1),
                _qrBtn(),
                _iconBtn(icon: 'ic_noti', index: 2),
                _iconBtn(icon: 'ic_bars', index: 3),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _iconBtn({required String icon, required int index}) {
    return InkWell(
      onTap: () {
        indexCubit.set(index);
      },
      child: SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: Assets.icon(
            assetName: "${icon}_active.svg",
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              index == indexCubit.state ? AppColors.main : AppColors.grey79,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _qrBtn() {
    return BaseContainer(
      width: 56,
      height: 56,
      isCircle: true,
      borderColor: AppColors.greyE2,
      borderWidth: 2,
      color: Colors.transparent,
      child: Center(
        child: BaseContainer(
          width: 44,
          height: 44,
          isCircle: true,
          color: AppColors.main,
          child: Center(
            child: Assets.icon(
              assetName: "ic_qrcode.svg",
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
