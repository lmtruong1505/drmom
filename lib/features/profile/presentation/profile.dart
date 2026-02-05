import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/base/base_state.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/features/profile/data/bloc/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/features/profile/presentation/children_screens/tabs/profile_info.dart';
import 'package:bpg_retail/gen/assets.gen.dart';

import '../../../core/widgets/base/base_screen.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage, ProfileCubit>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc..checkOpenShop(),
      child: BaseScreen(
        title: 'Quản lý cá nhân',
        isBottom: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Assets.images.bgScreen.image(
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: context.width,
              height: context.height,
              child: _bodyView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          24.height,
          ProfileInfoTab(bloc: bloc),
        ],
      ),
    );
  }
}
