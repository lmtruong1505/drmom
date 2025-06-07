import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/features/profile/data/bloc/user_profile_cubit.dart';
import 'package:bpg_retail/features/profile/presentation/children_screens/widgets/profiles/build_edit_profile.dart';
import 'package:bpg_retail/features/profile/presentation/children_screens/widgets/profiles/build_preview_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage(name: "ProfileInfoPage")
class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({super.key, this.isEdit = false});

  final bool? isEdit;

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  final bloc = getIt.get<UserProfileCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        if (bloc.isEdit) {
          return EditProfileView(bloc: bloc);
        }
        return UserProfileView(bloc: bloc);
      },
    );
  }
}
