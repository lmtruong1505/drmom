import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/env/env.dart';

@injectable
class Api {
  static String env = EnvironmentConfig.ENV;
  // static String env = "prod";
  // static String domain = EnvironmentConfig.BASE_URL;
  static String domain = "http://167.99.78.85:8000";

  static String baseURL = "https://api.thachlonghai.co";
  static String baseURLV2 = domain;

  static String account = 'micro-account-$env';
  static String product = 'micro-product-$env';
  static String order = 'micro-order-$env';
  static String noti = 'micro-notification-$env';

  static String categoryV2 = 'v2/category/api/in';
  static String productV2 = 'v2/product/api';
  static String orderV2 = 'v2/order/api';

  //card
  static String cards = '$baseURLV2/api/v1/cards/';
  static String myCards = '$baseURLV2/api/v1/cards/me';
  static String cardOrder = '$baseURLV2/api/v1/cards/orders/';
  static String confirmPayment = '$baseURLV2/api/v1/orders/confirm-payment/';
  static String createOnlineOrder = '$baseURLV2/order/api/create-order-v2/';
  static String uploadOnlineOrder = '$baseURLV2/order/api/confirm-payment-online/';
  static String banners = '$baseURLV2/banner/api/banner';
  static String updateStatusOrder = '$baseURLV2/order/api/update-status-order';

  //wallet
  static String wallets = '$baseURLV2/api/v1/wallets/profitable/';
  static String withdraw = '$baseURLV2/api/v1/wallets/confirm-consumer/';
  static String transactions = '$baseURLV2/api/v1/wallets/transactions';
  static String updateWallets = '$baseURLV2/api/v1/wallets/take-profit/';
  static String confirmCashback = '$baseURLV2/api/v1/wallets/consumer-confirmation';

  // static String objectAccount = '$baseURL/$account/object_account/api';
  // static String accountURL = '$baseURL/$account/account/api';
  static String subdivisions = '$baseURL/$account/subdivisions/api';
  static String productURL = '$baseURL/$product/v2/product/api';
  static String categoryURL = '$baseURL/$product/v2/category/api';
  static String orderURL = '$baseURL/$order/v2/order/api';
  // static String helpDeskURL = '$baseURL/$account/helpdesk/api';
  static String notiURL = '$baseURL/$noti/notifications_v2/notification';

  // authentication

  // static String login = '$objectAccount/login';
  // static String register = '$objectAccount/register';
  // static String sendEmailOTP = '$objectAccount/send_email_otp';
  // static String verifyOTP = '$objectAccount/verify_otp';
  // static String updatePhoneNumber = '$objectAccount/update_phone_number';
  // static String updateProfile = '$objectAccount/update_profile';
  // static String bankInfor = '$accountURL/list_bank';

  static String district = '$subdivisions/district';

  static String provinceASBC = '$baseURLV2/api/v1/locations/provinces/';
  static String districtASBC = '$baseURLV2/api/v1/locations/districts/';
  static String wardsASBC = '$baseURLV2/api/v1/locations/wards/';
  static String opendShop = '$baseURLV2/api/v1/shops/request-open-shop/';
  static String checkOpendShop = '$baseURLV2/api/v1/shops/my-shop/';
  static String generateQR = '$baseURLV2/api/v1/wallets/vietqr/generate-qr/';
  static String getBankASBC = '$baseURLV2/order/api/bank-owner/';
  static String historyWithdraws = '$baseURLV2/api/v1/wallets/request-withdraws/';
  static String listBank = '$baseURLV2/account/api/banks';
  static String listMyBank = '$baseURLV2/account/api/bank-accounts';
  static String createBankAccount = '$baseURLV2/account/api/create-bank-account/';
  static String requestChangeSoftToken = '$baseURLV2/account/api/change-soft-token/';
  static String verifySoftToken = '$baseURLV2/account/api/verify-soft-token/';
  static String verifyReferralCode = '$baseURLV2/account/api/check-referral-code/';
  static String verifyBankAccout = '$baseURLV2/account/api/verify-bank-account/';
  static String checkToken = '$baseURLV2/account/api/check-soft-token/';
  static String requestWithdraw = '$baseURLV2/api/v1/wallets/request-withdraws/';
  static String aSBCAddress = '$baseURLV2/account/api/address-manager/';
  static String getAsbcShopList = '$baseURLV2/api/v1/shops/shops/';
  static String getAsbcShop = '$baseURLV2/api/v1/shops/shop-detail/';
  static String bothCategory = '$baseURLV2/api/v1/shops/category-company';

  static String myReferrer = '$baseURLV2/account/api/my-referrer/';
  static String updateReferrer = '$baseURLV2/account/api/update-referral-code/';

  //auth v2
  static String loginV2 = '$baseURLV2/account/api/login';
  static String asbcProfile = '$baseURLV2/account/api/profile/';
  static String registerV2 = '$baseURLV2/account/api/register-v2';
  static String sendOtpPhoneV2 = '$baseURLV2/account/api/resend-otp-v2';
  static String verifyOtpPhoneV2 = '$baseURLV2/account/api/verify-v2';
  static String forgotPasswordV2 = '$baseURLV2/account/api/forgot_password/';
  static String verifyForgotV2 = '$baseURLV2/account/api/verify_forgot/';
  static String resetPasswordV2 = '$baseURLV2/account/api/resetpassword/';
  static String disableAccount = '$baseURLV2/account/api/update-status-account';
  static String myGroup = '$baseURLV2/account/api/my-group';
  static String changePassword = '$baseURLV2/account/api/change-password/';
  static String viettelPost = 'https://api.kafa.pro/order/api/getlistservice/';

  // product
  // static String formulaEcommerceList = '$productURL/formula_ecommerce_list';
  // static String categoryEcommerceList = '$categoryURL/category_ecommerce_list';
  // static String formulaRatingTm = '$productURL/get_formula_rating_tm';
  // static String createFormulaRatingTm = '$productURL/create_formula_rating_tm';

  // shop
  // static String shopList = '$objectAccount/shop_list';

  // order
  static String orderList = '$orderURL/tmdt_order_list';
  static String orderCreate = '$orderURL/tmdt_order_create';
  static String orderConfirm = '$orderURL/tmdt_order_confirm';
  static String orderDetail = '$orderURL/tmdt_order_detail';
  static String productPurchased = '$productURL/in/list_purchased_product';

  // helpDesk
  // static String createQuestionTmdt = '$helpDeskURL/create_question_tmdt';
  // static String getAllGroup = '$helpDeskURL/get_all_group';
  // static String listQuestion = '$helpDeskURL/list_question_tmdt';

//newApi
  static String categories = '$categoryURL/in/category';

  //PRODUCT NEW
  static String products = '$productURL/tm_list_products';
  static String rating = '$productURL/product_rating';
  static String getRating = '$productURL/product_rating_list';
  static String productDetail = '$productURL/in/product_tmdt';
  static String topRatingProduct = '$productURL/product_top_sale';
  static String promotion = '$productURL/list_promotion_tmdt';
  static String updatePromotion = '$productURL/update_status_promotion_tmdt';
  // static String getReferallCode = '$objectAccount/get_nearest_grocery_store';
  static String getFirstPurchaseGift = '$productURL/check_first_order';
  static String promotionDetail = '$productURL/promotion_account_detail';

  //PRODUCT ASBC
  static String productsV2 = '$baseURLV2/product/api/product';
  static String productsByCate = '$baseURLV2/product/api/product-option-category';
  static String categoryAsbc = '$baseURLV2/product/api/product-category';
  static String favorite = '$baseURLV2/product/api/product-favorite';
  static String addToCartV2 = '$baseURLV2/order/api/add-item-cart';

  //ORDER ASBC
  static String ordersV2 = '$baseURLV2/order/api/order';
  static String ordersV1 = '$baseURLV2/api/v1/orders';
  static String ordersCountV2 = '$baseURLV2/order/api/count-order';
  static String ordersReasonV2 = '$baseURLV2/order/api/reason';
  static String ordersCancelV2 = '$baseURLV2/order/api/cancel-order';
  static String qrOrderDetail = '$baseURLV2/api/v1/orders';
  static String carts = '$baseURLV2/order/api/cart-view';
  static String deleteCarts = '$baseURLV2/order/api/delete-item-cart';
  static String updatePrd = '$baseURLV2/order/api/update-quantity-item-cart';

  //ORDER NEW
  static String addToCart = '$orderURL/shopping-cart/update_shopping_cart/';
  static String getCarts = '$orderURL/shopping-cart/list_shopping_cart/';
  static String deleteOrderProduct = '$orderURL/shopping-cart/delete_shopping_cart/';
  static String getOrders = '$orderURL/list_order_tmdt/';

  static String updateOrderProduct = '$orderURL/shopping-cart/update_shopping_cart/';

  static String orderCreateV2 = '$orderURL/new_order_tmdt/';
  static String orderDetailV2 = '$orderURL/order_tmdt_detail/';
  static String updateOrderV2 = '$orderURL/update_status_order_tmdt/';
  static String getTotalOrder = '$orderURL/list_order_status_tmdt/';
  // static String getRating = '$productURL/product_rating/';
  // static String createRating = '$productURL/product_rating/';
  static String seenNoti = '$notiURL/seen';
  static String deleteNoti = '$notiURL/delete';
  static String updateDeviceToken = '$baseURL/$noti/notifications_v2/token/create_or_update_token';
  static String getAddressGoogleMap = 'https://maps.googleapis.com/maps/api/geocode/json';
  static String checkversion = 'v1/auth/version';

  // sskdt
  static String login = '$baseURLV2/api/v1/auth/login';
  static String register = '$baseURLV2/api/v1/auth/register';
  static String verifyOtpPhone = '$baseURLV2/api/v1/auth/patient-register';
  static String healthcare = '$baseURLV2/api/v1/healthcare-entity';
  static String getTransaction(int id) => '$baseURLV2/api/v1/user/$id/transaction_v2';
  static String transactionDetail = '$baseURLV2/api/v1/transaction';
  static String getReports(int id) => '$baseURLV2/api/v1/user/$id/report';
  static String getWarehouses = '$baseURLV2/api/v1/warehouse';
  static String getUser = '$baseURLV2/api/v1/auth/profile';
  static String logOut = '$baseURLV2/api/v1/auth/logout';
}
