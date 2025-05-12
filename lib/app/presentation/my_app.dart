import 'package:auto_route/auto_route.dart';
import 'package:BGP_Retail/app/data/bloc/app_cubit.dart';
import 'package:BGP_Retail/app/data/bloc/app_state.dart';
import 'package:BGP_Retail/app/routes/router.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/base/base_state.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/features/root_page.dart/root_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../features/card/data/cubits/card_bloc.dart';
import '../../features/cart/data/bloc/cart_bloc.dart';
import '../../features/wallet/data/cubits/wallet_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends BaseState<MyApp, AppCubit>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    EasyLoading.init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Hủy đăng ký
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getData();
      });
    } else if (state == AppLifecycleState.paused) {}
  }

  void getData() {
    context.read<WalletCubit>().getWallets();
    context.read<CardBloc>().getMyCard();
  }

  final appRouter = getIt.get<AppRouter>();

  @override
  Widget buildPage(BuildContext context) {
    return OverlaySupport(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WalletCubit(),
          ),
          BlocProvider(
            create: (context) => CardBloc(),
          ),
          BlocProvider(
            create: (context) => CartBloc()..getCart(),
          ),
        ],
        child: MaterialApp.router(
          builder: EasyLoading.init(
            builder: (context, child) {
              final mediaQueryData = MediaQuery.of(context);
              final scale = mediaQueryData.textScaler
                  .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: scale,
                ),
                child: child!,
              );
            },
          ),
          routerDelegate: appRouter.delegate(
            // initialRoutes: [const HomePage()],
            deepLinkBuilder: (_) => DeepLink(_mapRouteToPageRouteInfo()),
            // navigatorObservers: () => [AppNavigatorObserver()],
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('vi', 'VN'),
          ],
          routeInformationParser: appRouter.defaultRouteParser(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }

  List<PageRouteInfo> _mapRouteToPageRouteInfo() {
    // final token = preferences.accessToken;
    // if (token == null || token.isEmpty) {
    //   return [LoginPage()];
    // } else {
    //   return [const RootRoute()];
    // }
    return [LoginPage()];
  }
}
