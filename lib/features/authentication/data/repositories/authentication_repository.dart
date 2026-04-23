import 'package:dartz/dartz.dart';
import 'package:drmom/core/base/base_response.dart';
import 'package:drmom/core/configs/dio_config.dart';
import 'package:drmom/core/constants/api_constants.dart';
import 'package:drmom/features/authentication/data/models/auth_response.dart';
import 'package:drmom/features/authentication/data/models/user_model.dart';
import 'package:drmom/features/authentication/data/services/authentication_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthenticationRepository {
  AuthenticationRepository(this._authenticationService, this._baseDio);

  final AuthenticationService _authenticationService;

  final BaseDio _baseDio;

  Future<BaseResponseModel<AuthResponse>> login(
    String username,
    String password,
  ) async {
    try {
      final res = await _baseDio.post(
        Api.login,
        data: {
          "username": username,
          "password": password,
        },
      );
      
      final status = res.data['status'];
      final success = res.data['success'];
      final message = res.data['message'];
      final metadata = res.data['metadata'];
      
      AuthResponse? authData;
      if (res.data['data'] != null) {
        authData = AuthResponse.fromJson(res.data['data']);
      }
      
      return BaseResponseModel<AuthResponse>(
        status: status,
        success: success,
        message: message,
        data: authData,
        metadata: metadata,
      );
    } catch (err) {
      print('Login Error: $err');
      return BaseResponseModel(status: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  Future<BaseResponseModel> register({
    required String email,
    required String password,
    required String fullName,
    String? rePresentative,
    String? taxCode,
    required String phoneNumber,
    required String confirmPassword,
  }) async {
    try {
      final data = {
        "email": email,
        "password": password,
        "fullname": fullName,
        "confirm_password": confirmPassword,
        "representative": rePresentative,
        "tax_code": taxCode,
        "phone_number": phoneNumber,
      };
      final res = await _baseDio.post(Api.register, data: data);
      if (res.data['success'] == true) {
        return BaseResponseModel(status: 200, data: res.data);
      } else {
        return BaseResponseModel(
          status: res.data['status'],
          message: res.data['message'],
        );
      }
    } catch (err) {
      return BaseResponseModel(status: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  Future<Either<dynamic, dynamic>> sendOTPPhone(String phoneNumber) async {
    try {
      final response = await _authenticationService.sendOTPPhone(phoneNumber);
      if (response['code'] == 400) {
        return left(response);
      } else {
        return right(response);
      }
    } catch (err) {
      return left({"message": err.toString(), "code": 400});
    }
  }

  Future<BaseResponseModel> verifyOTPPhone({
    required String phoneNumber,
    required String otp,
    required String fullName,
    required String referralCode,
    required String password,
  }) async {
    try {
      final payload = {
        'phone_number': phoneNumber,
        'full_name': fullName,
        "password": password,
        "referral_code": referralCode,
        "otp_code": otp,
      };

      final response = await _baseDio.post(Api.verifyOtpPhone, data: payload);
      if (response.data['success'] == true) {
        return BaseResponseModel(status: 200, data: response.data);
      } else {
        return BaseResponseModel(
          status: response.data['status'],
          message: response.data['message'],
        );
      }
    } catch (err) {
      return BaseResponseModel(status: 400, message: err.toString());
    }
  }

  Future<Either<dynamic, dynamic>> forgotPassword(String phoneNumber) async {
    try {
      final response = await _authenticationService.forgotPassword(phoneNumber);
      if (response['code'] == 400) {
        return left(response);
      } else {
        return right(response);
      }
    } catch (err) {
      return left({"message": err.toString(), "code": 400});
    }
  }

  Future<Either<dynamic, dynamic>> verifyForgot({
    required String otp,
    required String sessionKey,
  }) async {
    try {
      final response = await _authenticationService.verifyForgot(
        otp,
        sessionKey,
      );
      if (response['code'] == 400) {
        return left(response);
      } else {
        return right(response);
      }
    } catch (err) {
      return left({"message": err.toString(), "code": 400});
    }
  }

  Future<Either<dynamic, dynamic>> changePassForgot({
    required String password,
    required String sessionKey,
  }) async {
    try {
      final response = await _authenticationService.changePassForgot(
        sessionKey,
        password,
      );
      if (response['code'] == 400) {
        return left(response);
      } else {
        return right(response);
      }
    } catch (err) {
      return left({"message": err.toString(), "code": 400});
    }
  }

  Future<Either<dynamic, dynamic>> changePassword(
    String oldPassword,
    String password,
  ) async {
    try {
      final response = await _authenticationService.changePassword(
        oldPassword,
        password,
      );
      if (response['code'] == 400) {
        return left(response);
      } else {
        return right(response);
      }
    } catch (err) {
      return left({"message": err.toString(), "code": 400});
    }
  }

  Future<BaseResponseModel> deactive(int? id) async {
    try {
      final res = await _baseDio.put('${Api.disableAccount}/$id');
      if (res.data["status"] == 200) {
        return BaseResponseModel(status: 200);
      } else {
        return BaseResponseModel(
          status: res.data["status"],
          message: res.data["message"],
        );
      }
    } catch (e) {
      return BaseResponseModel(status: 400, message: "Đã có lỗi xảy ra");
    }
  }

  Future<BaseResponseModel> sendRequestChangeToken(
    String token,
    String otp,
  ) async {
    try {
      final payload = {"session": token, "otp": otp};
      final response = await _baseDio.post(Api.verifySoftToken, data: payload);
      if (response.data["status"] == 200) {
        return BaseResponseModel(
          status: 200,
          message: "Tạo yêu cầu đổi mã token thành công",
        );
      } else {
        return BaseResponseModel(
          status: response.data["status"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(status: 400, message: err.toString());
    }
  }

  Future<BaseResponseModel> verifyBankAccout(String phone, String otp) async {
    try {
      final payload = {"phone": phone, "otp": otp};
      final response = await _baseDio.post(Api.verifyBankAccout, data: payload);
      if (response.data["status"] == 200) {
        return BaseResponseModel(
          status: 200,
          message: "Tạo yêu cầu đổi mã token thành công",
        );
      } else {
        return BaseResponseModel(
          status: response.data["status"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(status: 400, message: err.toString());
    }
  }

  Future<BaseResponseModel> logOut() async {
    try {
      final res = await _baseDio.get(Api.logOut);
      if (res.data["success"] == true) {
        return BaseResponseModel(status: 200);
      } else {
        return BaseResponseModel(
          status: res.data["status"],
          message: res.data["message"],
        );
      }
    } catch (e) {
      return BaseResponseModel(status: 400, message: e.toString());
    }
  }
}
