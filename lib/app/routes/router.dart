import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
@singleton
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: RootRoute.page,
    ),
    AutoRoute(
      page: VerifyOtpRoute.page,
    ),
    AutoRoute(
      page: LoginRoute.page,
    ),
    AutoRoute(
      page: RegisterRoute.page,
    ),
    AutoRoute(
      page: OtpVerificationRoute.page,
    ),
    AutoRoute(
      page: ForgotPasswordRoute.page,
    ),
    AutoRoute(
      page: QrCodeScreen.page,
    ),
    AutoRoute(
      page: KycCameraIdentityScreen.page,
    ),
    AutoRoute(
      page: KycCameraPreview.page,
    ),
    AutoRoute(
      page: KycCameraPortraitScreen.page,
    ),
    AutoRoute(
      page: DashboardRoute.page,
    ),
  ];
}
