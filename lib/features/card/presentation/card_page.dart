import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/widgets/base/base_screen.dart';
import 'package:bpg_retail/features/card/presentation/components/tab_card.dart';
import 'package:bpg_retail/features/card/presentation/components/tab_my_card.dart';

import '../../../core/base/index_cubit.dart';
import '../../../core/constants/colors.dart';

@RoutePage()
class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final indexBloc = IndexCubit();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      //bottomNavigationBar: const BaseBottomNavigation(),
      title: 'Quản lý thẻ',
      isBottom: false,
      body: Column(
        children: [
          // 24.height,
          Container(
            color: AppColors.bg_6,
            child: TabBar(
              indicatorColor: AppColors.main,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: 16.pading,
              labelStyle: s14w500.copyWith(color: AppColors.main),
              unselectedLabelStyle: s14w500.copyWith(color: AppColors.greyA7),
              isScrollable: false,
              controller: _tabController,
              tabs: const [
                Text('Danh sách thẻ'),
                Text('Thẻ của tôi'),
              ],
              onTap: (value) {
                _tabController.animateTo(value, duration: 200.milliseconds);
              },
            ),
          ),
          // 16.height,

          // BlocConsumer<IndexCubit, int>(
          //   bloc: indexBloc,
          //   listener: (context, state) {
          //     _tabController.animateTo(state, duration: 200.milliseconds);
          //   },
          //   builder: (context, state) {
          //     return Row(
          //       children: [
          //         TabButton(
          //           onTap: () {
          //             indexBloc.set(0);
          //           },
          //           title: 'Danh sách thẻ',
          //           isActive: state == 0,
          //         ).expanded(),
          //         16.width,
          //         TabButton(
          //           onTap: () {
          //             indexBloc.set(1);
          //           },
          //           title: 'Thẻ của tôi',
          //           isActive: state == 1,
          //         ).expanded(),
          //       ],
          //     );
          //   },
          // ).padding(16.padingHor),
          TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              TabCard(),
              TabMyCard(),
            ],
          ).expanded(),
        ],
      ),
    );
  }
}
