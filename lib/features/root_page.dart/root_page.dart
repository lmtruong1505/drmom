import 'package:auto_route/auto_route.dart';
import 'package:drmom/core/widgets/base_container.dart';
import 'package:drmom/features/asset_category/presentation/asset_category_page.dart';
import 'package:drmom/features/dashboard/dashboard_page.dart';
import 'package:drmom/features/profile/presentation/personal_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drmom/app/data/bloc/app_state.dart';
import 'package:drmom/core/base/index_cubit.dart';
import "package:drmom/core/configs/app_style/init_app_style.dart";
import "package:drmom/core/configs/app_style/init_app_style.dart";
import 'package:drmom/core/extension/init_ext.dart';
import 'package:drmom/core/injection/injection.dart';
import 'package:drmom/core/utilities/assets.dart';

import '../../app/data/bloc/app_cubit.dart';
import '../../core/base/cubit_state.dart';
import '../../core/utilities/enum.dart';

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
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
      ],
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state.isLoggedIn) {}
        },
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: _btnNav(),
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const DashboardPage(),
                AssetCategoryPage(),
                Container(
                  color: AppColors.bg_6,
                  child:  Center(
                    child: Text(
                      'Tính năng này đang được phát triển',
                      style: AppTypography.p3,
                    ),
                  ),
                ),
                Container(
                  color: AppColors.bg_6,
                  child:  Center(
                    child: Text(
                      'Tính năng này đang được phát triển',
                      style: AppTypography.p3,
                    ),
                  ),
                ),
                const PersonalInfoPage(),
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
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(label: 'Home', icon: Icons.home_outlined, index: 0, activeIcon: Icons.home),
                  _navItem(label: 'Sức khỏe', icon: Icons.favorite_outline, index: 1, activeIcon: Icons.favorite),
                  _navItem(label: 'Cộng đồng', icon: Icons.groups_outlined, index: 2, activeIcon: Icons.groups),
                  _navItem(label: 'Dịch vụ', icon: Icons.business_center_outlined, index: 3, activeIcon: Icons.business_center),
                  _navItem(label: 'Shop', icon: Icons.shopping_bag_outlined, index: 4, activeIcon: Icons.shopping_bag),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _navItem({
    required String label,
    required IconData icon,
    required int index,
    required IconData activeIcon,
  }) {
    final isActive = indexCubit.state == index;
    final color = isActive ? const Color(0xFFC67C4E) : const Color(0xFF98A2B3);

    return InkWell(
      onTap: () => indexCubit.set(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.p8.copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
