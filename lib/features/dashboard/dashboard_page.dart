import 'package:auto_route/auto_route.dart';
import 'package:drmom/core/extension/init_ext.dart';
import 'package:drmom/features/dashboard/widgets/community_section.dart';
import 'package:drmom/features/dashboard/widgets/featured_posts_section.dart';
import 'package:drmom/features/dashboard/widgets/header_section.dart';
import 'package:drmom/features/dashboard/widgets/hero_banner_section.dart';
import 'package:drmom/features/dashboard/widgets/quick_menu_section.dart';
import 'package:drmom/features/dashboard/widgets/services_shop_section.dart';
import 'package:drmom/features/dashboard/widgets/trending_topics_section.dart';
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
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const HeaderSection(),
            const HeroBannerSection(),
            8.height,
            const QuickMenuSection(),
            16.height,
            const TrendingTopicsSection(),
            16.height,
            const FeaturedPostsSection(),
            24.height,
            const CommunitySection(),
            24.height,
            const ServicesShopSection(),
            40.height,
          ],
        ),
      ),
    );
  }
}
