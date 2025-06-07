import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/widgets/base/base_screen.dart';
import 'package:bpg_retail/features/card/presentation/components/tab_my_card.dart';
import 'package:bpg_retail/features/profile/presentation/children_screens/deposit_history_screen.dart';

@RoutePage()
class MyCardPage extends StatefulWidget {
  const MyCardPage({super.key});

  @override
  State<MyCardPage> createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      title: 'Quản lý thẻ',
      isBottom: true,
      body: SingleChildScrollView(
        child: TabMyCard(),
      ),
    );
  }
}
