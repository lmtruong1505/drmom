import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/features/dashboard/widgets/dashboard_header.dart';
import 'package:bpg_retail/features/dashboard/widgets/hospital_filter.dart';
import 'package:bpg_retail/features/dashboard/widgets/overview_cards.dart';
import 'package:bpg_retail/features/dashboard/widgets/depreciation_chart.dart';
import 'package:bpg_retail/features/dashboard/widgets/liquidation_chart.dart';
import 'package:bpg_retail/features/dashboard/widgets/asset_lists.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple_1,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const DashboardHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color:
                      AppColors
                          .bg_6, // Using grey background to make white cards pop
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      const HospitalFilter(),
                      24.height,
                      const OverviewCards(),
                      24.height,
                      const DepreciationChartWidget(),
                      24.height,
                      const LiquidationChartWidget(),
                      24.height,
                      const AssetListsWidget(),
                      80.height, // Bottom padding for scroll
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
