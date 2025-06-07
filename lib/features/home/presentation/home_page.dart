import 'package:bpg_retail/app/data/bloc/localization_cubit.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/localization_helper.dart';
import 'package:bpg_retail/core/utilities/screens.dart';
import 'package:bpg_retail/features/authentication/data/bloc/authentication_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/features/home/data/bloc/report_home_bloc.dart';
import 'package:bpg_retail/features/home/data/bloc/transection_bloc.dart';
import 'package:bpg_retail/features/home/presentation/components/report_home_tab.dart';
import 'package:bpg_retail/features/home/presentation/components/transaction_home_tab.dart';
import 'package:bpg_retail/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:upgrader/upgrader.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final scroll = ScrollController();
  final navigator = getIt.get<AppNavigator>();
  final transectionBloc = TransactionBloc();
  final homeReportBloc = HomeReportBloc();
  final authBloc = getIt.get<AuthenticationCubit>();
  late TabController _tabController;
  final indexCubit = IndexCubit();

  @override
  void initState() {
    super.initState();
    // initFirebase();
    initializeData();
    _tabController = TabController(length: 2, vsync: this);
  }

  void initializeData() {
    transectionBloc
      ..initData()
      ..getListWarehouse();
    homeReportBloc
      ..initData()
      ..getListWarehouse();
  }

  // void initFirebase() async {
  //   final share = getIt.get<Preferences>();
  //   // await FirebaseMessageConfig().initNotification(context);
  //   // await FirebaseMessaging.instance.subscribeToTopic('ACCOUNT_${1}');
  // }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => indexCubit,
        ),
        BlocProvider(
          create: (context) => transectionBloc,
        ),
        BlocProvider(
          create: (context) => homeReportBloc,
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: false,
          title: Assets.images.logo.image(height: 41, width: 79),
          actions: [
            GestureDetector(
              onTap: () {
                // final authBloc = getIt.get<AuthenticationCubit>();
                // authBloc.logOut();
                _scaffoldKey.currentState?.openEndDrawer();
              },
              child: const Icon(
                Icons.menu,
              ),
            ),
            16.width,
          ],
        ),
        endDrawer: AppDrawer(),
        backgroundColor: AppColors.white,
        body: BlocListener<IndexCubit, int>(
          listener: (context, state) {
            _tabController.animateTo(state, duration: 300.milliseconds);
          },
          child: RefreshIndicator(
            onRefresh: () async {
              initializeData();
            },
            child: Container(
              child: Column(
                children: [
                  12.height,
                  BaseContainer(
                    padding: 2.pading,
                    borderRadius: 999,
                    color: AppColors.grey_2,
                    child: BlocConsumer<IndexCubit, int>(
                      bloc: indexCubit,
                      listener: (context, state) {
                        _tabController.animateTo(
                          state,
                          duration: 200.milliseconds,
                        );
                      },
                      builder: (context, state) {
                        return Row(
                          children: [
                            TabButton(
                              onTap: () => indexCubit.set(0),
                              title: trans.translate('transaction'),
                              isActive: state == 0,
                            ).expanded(),
                            16.width,
                            TabButton(
                              onTap: () => indexCubit.set(1),
                              title: trans.translate('report'),
                              isActive: state == 1,
                            ).expanded(),
                          ],
                        );
                      },
                    ),
                  ),
                  TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      TransectionHomeTab(bloc: transectionBloc),
                      ReportHomeTab(bloc: homeReportBloc),
                    ],
                  ).expanded(),
                ],
              ).padding(16.padingHor),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleDivider extends StatelessWidget {
  const TitleDivider({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: s12w400.copyWith(color: AppColors.greyAA),
        ),
        const Divider(
          height: 1,
          color: AppColors.greyAA,
        ).expanded(),
      ],
    ).padding(16.padingVer);
  }
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

class AppDrawer extends StatelessWidget {
  final authBloc = getIt.get<AuthenticationCubit>();
  final preferences = getIt.get<Preferences>();
  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);

    final paddingBottom = MediaQuery.of(context).viewPadding.bottom;
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    final user = preferences.currentUser;
    final profile = preferences.getUserDataV3;
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      width: widthDevice(context) * 3 / 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          paddingTop.height,
          Container(
            padding: 16.pading,
            width: double.infinity,
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trans.translate('hello'),
                  style: s14w700.copyWith(color: AppColors.grey79),
                ),
                4.height,
                Text(
                  user.fullname ?? '',
                  style: s16w700,
                ),
              ],
            ),
          ),
          16.height,
          ColumnItem(
            title: trans.translate('company_representative'),
            data: user.representative,
          ),
          ColumnItem(
            title: trans.translate('tax_code'),
            data: user.taxCode,
          ),
          ColumnItem(
            title: trans.translate('phone_number'),
            data: user.phoneNumber,
          ),
          ColumnItem(
            title: trans.translate('email'),
            data: user.email,
          ),
          ColumnItem(
            title: trans.translate('province'),
            data: profile.city?.name,
          ),
          ColumnItem(
            title: trans.translate('district'),
            data: profile.district?.name,
          ),
          ColumnItem(
            title: trans.translate('ward'),
            data: profile.ward?.name,
          ),
          ColumnItem(
            title: trans.translate('detail_address'),
            data: user.fullAddress,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const LanguageSelector(),
              16.width,
              BtnIcon(
                color: AppColors.redC7,
                icon: const Icon(
                  Icons.logout,
                  color: AppColors.white,
                  size: 20,
                ),
                size: const Size(48, 48),
                onTap: () => authBloc.logOut(),
              ),
            ],
          ).padding(paddingBottom.padingBottom + 16.padingHor),
        ],
      ),
    );
  }
}

class ColumnItem extends StatelessWidget {
  const ColumnItem({
    super.key,
    required this.title,
    required this.data,
  });
  final String title;
  final String? data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: s16w400.copyWith(color: AppColors.grey79),
        ),
        4.height,
        Text(
          data ?? 'Chưa có thông tin',
          textAlign: TextAlign.end,
          style: s16w500,
        ),
      ],
    ).padding(16.padingHor + 12.padingBottom);
  }
}

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocalizationCubit>().state;

    return PopupMenuButton<String>(
      position: PopupMenuPosition.over,
      offset: const Offset(0, -120),
      onSelected: (String languageCode) {
        context.read<LocalizationCubit>().changeLanguage(languageCode);
      },
      itemBuilder: (context) => [
        _buildMenuItem(context, "vi", '🇻🇳 Tiếng Việt'),
        _buildMenuItem(context, "en", '🇬🇧 English'),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: 8.radius,
      ),
      elevation: 4,
      child: BaseContainer(
        color: AppColors.bg_6,
        borderColor: AppColors.greyAA,
        borderRadius: 8,
        height: 48,
        padding: 16.padingHor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(locale.languageCode == 'vi' ? '🇻🇳' : '🇬🇧'),
            4.width,
            Text(locale.languageCode == 'vi' ? 'Tiếng Việt' : 'English'),
            const Icon(Icons.chevron_right_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    BuildContext context,
    String languageCode,
    String text,
  ) {
    return PopupMenuItem(
      value: languageCode,
      child: Row(
        children: [
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
