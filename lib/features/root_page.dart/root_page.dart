import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/features/home/presentation/home_page.dart';
import 'package:bpg_retail/features/profile/presentation/profile_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/app/data/bloc/app_state.dart';
import 'package:bpg_retail/core/base/index_cubit.dart';
import 'package:bpg_retail/core/check_version/check_vesion.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/utilities/assets.dart';
import 'package:bpg_retail/features/authentication/presentation/login/login.dart';
import 'package:bpg_retail/features/card/presentation/card_page.dart';
import 'package:bpg_retail/features/cart/data/bloc/cart_bloc_V2.dart';
import 'package:bpg_retail/features/home/presentation/home_page.dart';
import 'package:bpg_retail/features/order/presentation/order.dart';
import 'package:bpg_retail/features/profile/presentation/profile.dart';
import 'package:bpg_retail/features/qr/presentation/qr_view.dart';

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

    // initializeData();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    // _priceUpdateTimer?.cancel();
    super.dispose();
  }

  void initializeData() {
    // CheckVersion.checkAndPush(context);
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
            if (state.status == CubitStatus.success) {
              // _startUpdatePrice();
            }
          },
        ),
        BlocListener<WalletCubit, CubitState>(
          listener: (context, state) {},
        ),
        BlocListener<CartBloc, CubitState>(
          listener: (context, state) {},
        ),
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
                const HomePage(),
                Container(
                  color: AppColors.bg_6,
                  child: const Center(
                    child: const Text(
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
        return Card(
          elevation: 5,
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _iconBtn(
                    icon: 'ic_home',
                    index: 0,
                    title: 'Trang chủ',
                  ),
                  _iconBtn(
                    icon: 'ic_group',
                    index: 1,
                    title: 'Cộng đồng',
                  ),
                  // _qrBtn(),
                  _iconBtn(
                    icon: 'ic_noti',
                    index: 2,
                    title: 'Thông báo',
                  ),
                  _iconBtn(
                    icon: 'ic_user',
                    index: 3,
                    title: 'Tài khoản',
                  ),
                ],
              ),
              10.height,
            ],
          ),
        );
      },
    );
  }

  Widget _iconBtn({
    required String icon,
    required String title,
    required int index,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          indexCubit.set(index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            4.height,
            SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: Assets.icon(
                  assetName: "${icon}_active.svg",
                  width: 21,
                  height: 21,
                  colorFilter: ColorFilter.mode(
                    index == indexCubit.state
                        ? AppColors.main
                        : AppColors.grey79,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Text(
              title,
              style: s12w400.copyWith(
                color: index == indexCubit.state
                    ? AppColors.main
                    : AppColors.grey79,
              ),
            ),
            10.height,
          ],
        ),
      ),
    );
  }

  Widget _qrBtn() {
    return Expanded(
      child: InkWell(
        onTap: () {
          indexCubit.set(2);
        },
        child: Column(
          children: [
            4.height,
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 50,
                height: 50,
                margin: 10.padingHor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.greyE2, width: 2),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 21,
                    backgroundColor: AppColors.main,
                    child: Assets.icon(
                      assetName: "ic_qrcode.svg",
                      width: 21,
                      height: 21,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "Scan&Pay",
              style: s12w400.copyWith(
                color:
                    2 == indexCubit.state ? AppColors.main : AppColors.grey79,
              ),
            ),
            10.height,
          ],
        ),
      ),
    );
  }
}
