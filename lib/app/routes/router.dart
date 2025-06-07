import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
@singleton
class AppRouter extends $AppRouter {
  @override
  List<CustomRoute> get routes => [
        CustomRoute(
          page: CardRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: WalletRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: RootRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('VerifyOtpPage'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('ProfilePage'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('CartPageV2'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('OrderPage'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('BoothPageV2'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('LoginPage'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('RegisterPage'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('OtpVerificationPage'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('ForgotPasswordPage'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('ProfileInfoPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('UpdatePhonePage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('AddressManagerPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('DetailAddressPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('CreateNewAddressPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('ChangePasswordPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('NotificationPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('FAQPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('FAQNewPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('FavoritePage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('PurchasedPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('PolicyPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('PrivacyPolicyPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('ProductDetailPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('BoothDetailPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('OrderDetailPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('CartBuyPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('SearchProductPage'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('PointPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('DeliverySelectPage'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('ProductDetailPageV2'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('DeliverySelectPageV2'),
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: const PageInfo('RattingOrder'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('AddressFullScreenV2'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('PromotionScreen'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('PromotionDetailScreen'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: const PageInfo('QRCodeScreen'),
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: RegisterStoreRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: CartQRBuyRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: ShopRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: PaymentHistoryScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: PaymentFilterScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: PaymentDetailScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: DepositWithdrawScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: DepositHistoryScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: CreateAccountBankScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: AccountBankScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: ChangeTokenBankScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: OtpVerificationTokenRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: CreateAddressRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: AddressManagerRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: MyCardRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: BoothScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: KycCameraIdentityScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: KycCameraPreview.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: KycCameraPortraitScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: PayymentMethodRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: DeliveryMethodRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: ConfirmPaymentRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: CartPrdRouteV2.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: AsbcCartBuyV2.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: DevModeScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: ProfileV2Screen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: HomeRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: TransectionDetailRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: GalleryRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
      ];
}
