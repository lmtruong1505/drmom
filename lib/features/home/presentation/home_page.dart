import 'package:auto_route/auto_route.dart';
import 'package:BGP_Retail/features/home/data/bloc/doctor_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:BGP_Retail/core/core.dart';
import 'package:BGP_Retail/features/booth/data/bloc/asbc_both_cubit.dart';
import 'package:BGP_Retail/features/home/presentation/components/hospital_section.dart';
import 'package:BGP_Retail/features/home/presentation/components/doctor_section.dart';
import 'package:BGP_Retail/features/home/presentation/components/header_home_section.dart';

import '../../../core/configs/firebase_massage_config.dart';
import 'package:upgrader/upgrader.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final scroll = ScrollController();
  final navigator = getIt.get<AppNavigator>();
  final hospitalBloc = getIt.get<AsbcBothCubit>();
  final doctorBloc = DoctorBloc();

  @override
  void initState() {
    super.initState();
    initFirebase();
    initializeData();
  }

  void initializeData() {
    doctorBloc.getDoctors();
    hospitalBloc.getListHospital();
  }

  void initFirebase() async {
    final share = getIt.get<Preferences>();
    await FirebaseMessageConfig().initNotification(context);
    await FirebaseMessaging.instance
        .subscribeToTopic('ACCOUNT_${share.currentUser.user?.id}');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        initializeData();
      },
      child: Scaffold(
        backgroundColor: AppColors.bg_7,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scroll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MyUpgraderMessages extends UpgraderMessages {
  @override
  String get languageCode => 'vi';

  @override
  String message(UpgraderMessage messageKey) {
    switch (messageKey) {
      case UpgraderMessage.body:
        return 'Có một phiên bản mới của ứng dụng này. Vui lòng cập nhật!';
      case UpgraderMessage.buttonTitleUpdate:
        return 'Cập nhật';
      case UpgraderMessage.prompt:
        return 'Bạn có muốn cập nhật ngay bây giờ không?';
      case UpgraderMessage.title:
        return 'Cập nhật ứng dụng';
      case UpgraderMessage.releaseNotes:
        return 'Ghi chú phiên bản';
      default:
        return super.message(messageKey)!;
    }
  }
}
