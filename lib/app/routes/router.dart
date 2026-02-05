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
          page: VerifyOtpRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: ProfileRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: CartPrdRouteV2.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: OrderRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: BoothScreen.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: LoginRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: RegisterRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: OtpVerificationRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: ForgotPasswordRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: ProfileInfoRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        // CustomRoute(
        //   page: UpdatePhoneRoute.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        CustomRoute(
          page: AddressManagerRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: DetailAddressRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        // CustomRoute(
        //   page: CreateNewAddressRoute.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        CustomRoute(
          page: ChangePasswordRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: NotificationRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        // CustomRoute(
        //   page: FAQRoute.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        // CustomRoute(
        //   page: FAQNewRoute.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        CustomRoute(
          page: FavoriteRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        // CustomRoute(
        //   page: PurchasedRoute.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        // CustomRoute(
        //   page: PolicyRoute.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        // CustomRoute(
        //   page: PrivacyPolicyRoute.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        // CustomRoute(
        //   page: ProductDetailRoute.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        // CustomRoute(
        //   page: BoothDetailRoute.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        CustomRoute(
          page: OrderDetailRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        // CustomRoute(
        //   page: CartBuyRoute.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        // CustomRoute(
        //   page: SearchProductRoute.page,
        //   transitionsBuilder: TransitionsBuilders.noTransition,
        // ),
        // CustomRoute(
        //   page: PointRoute.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        // CustomRoute(
        //   page: DeliverySelectRoute.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        // CustomRoute(
        //   page: ProductDetailRouteV2.page,
        //   transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        // ),
        CustomRoute(
          page: DeliverySelectV2Route.page,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          page: RatingOrder.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: AddressFullScreenV2.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        // CustomRoute(
        //   page: PromotionScreen.page,
        //   transitionsBuilder: TransitionsBuilders.noTransition,
        // ),
        // CustomRoute(
        //   page: PromotionDetailScreen.page,
        //   transitionsBuilder: TransitionsBuilders.noTransition,
        // ),
        CustomRoute(
          page: QrCodeScreen.page,
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
