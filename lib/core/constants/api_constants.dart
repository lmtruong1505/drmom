import 'package:injectable/injectable.dart';
import 'package:drmom/core/env/env.dart';

@injectable
class Api {
  static String env = EnvironmentConfig.ENV;
  static String domain = "https://dr-mom-be.too.onl";

  static String baseURL = "https://api.thachlonghai.co";
  static String baseURLV2 = domain;

  static String provinceASBC = '$baseURLV2/api/v1/locations/provinces';
  static String districtASBC = '$baseURLV2/api/v1/locations/districts';
  static String wardsASBC = '$baseURLV2/api/v1/locations/wards';

  static String verifySoftToken = '$baseURLV2/account/api/verify-soft-token/';
  static String verifyBankAccout =
      '$baseURLV2/account/api/verify-bank-account/';

  //auth v2
  static String loginV2 = '$baseURLV2/account/api/login';
  static String sendOtpPhoneV2 = '$baseURLV2/account/api/resend-otp-v2';
  static String verifyOtpPhoneV2 = '$baseURLV2/account/api/verify-v2';
  static String forgotPasswordV2 = '$baseURLV2/account/api/forgot_password/';
  static String verifyForgotV2 = '$baseURLV2/account/api/verify_forgot/';
  static String resetPasswordV2 = '$baseURLV2/account/api/resetpassword/';
  static String disableAccount = '$baseURLV2/account/api/update-status-account';
  static String changePassword = '$baseURLV2/account/api/change-password/';

  static String checkversion = 'v1/auth/version';

  // sskdt
  static String login = '$baseURLV2/api/v1/auth/login';
  static String register = '$baseURLV2/api/v1/auth/register';
  static String verifyOtpPhone = '$baseURLV2/api/v1/auth/patient-register';
  static String logOut = '$baseURLV2/api/v1/auth/logout';
  static String hashtag = '$baseURLV2/api/v1/hashtag';
  static String newsPost = '$baseURLV2/api/v1/news-post';
  static String posts = '$baseURLV2/api/v1/posts';
}

