import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:bpg_retail/core/base/base_response.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/features/authentication/data/models/user_model_v2.dart';
import 'package:bpg_retail/features/authentication/data/models/user_model_v3.dart';
import 'package:bpg_retail/features/authentication/data/services/authentication_service.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/features/booth/data/models/asbc_both_v2_model.dart';
import 'package:bpg_retail/features/cart/data/models/qr_order_detail_model.dart';
import 'package:bpg_retail/features/profile/data/models/referall_model.dart';

@LazySingleton()
class AuthenticationRepository {
  AuthenticationRepository(
    this._authenticationService,
    this._baseDio,
  );

  final AuthenticationService _authenticationService;

  final BaseDio _baseDio;

  Future<BaseResponseModel> login(
    String phoneNumber,
    String password,
  ) async {
    try {
      final res = await _baseDio.post(
        Api.login,
        data: {
          "email": phoneNumber,
          "password": password,
        },
      );
      if (res.data['success'] == true) {
        return BaseResponseModel(code: 200, data: res.data);
      } else {
        return BaseResponseModel(
          code: res.data['status'],
          message: res.data['message'],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  Future<BaseResponseModel> register({
    required String phoneNumber,
    required String password,
    required String fullName,
    String? referralCode,
  }) async {
    try {
      final data = {
        'phone_number': phoneNumber,
        "is_register": true,
        "type": "PATIENT",
      };

      final res = await _baseDio.post(
        Api.register,
        data: data,
      );
      if (res.data['success'] == true) {
        return BaseResponseModel(code: 200, data: res.data);
      } else {
        return BaseResponseModel(
          code: res.data['status'],
          message: res.data['message'],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  Future<Either<dynamic, dynamic>> sendOTPPhone(
    String phoneNumber,
  ) async {
    try {
      final response = await _authenticationService.sendOTPPhone(
        phoneNumber,
      );
      if (response['code'] == 400) {
        return left(response);
      } else {
        return right(response);
      }
    } catch (err) {
      return left({
        "message": err.toString(),
        "code": 400,
      });
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
      // final response = await _authenticationService.verifyOTPPhone(
      //   otp,
      //   phoneNumber,
      //   fullName,
      // );
      final payload = {
        'phone_number': phoneNumber,
        'full_name': fullName,
        "password": password,
        "referral_code": referralCode,
        "otp_code": otp,
      };

      final response = await _baseDio.post(
        Api.verifyOtpPhone,
        data: payload,
      );
      if (response.data['success'] == true) {
        return BaseResponseModel(code: 200, data: response.data);
      } else {
        return BaseResponseModel(
          code: response.data['status'],
          message: response.data['message'],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: err.toString());
    }
  }

  // Future<Either<dynamic, dynamic>> sendOTP(
  //   String email,
  //   String phoneNumber,
  //   int type,
  // ) async {
  //   try {
  //     final response = await _authenticationService.sendOTP(
  //       email,
  //       phoneNumber,
  //       type,
  //     );
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

  // Future<Either<dynamic, dynamic>> sendOTPSubject(
  //   bool isForgot,
  //   String? email,
  //   String subject,
  //   String message,
  //   String? phoneNumber,
  //   int? id,
  //   int sendOtpCode,
  // ) async {
  //   try {
  //     final response = await _authenticationService.sendOTPSubject(
  //       isForgot = isForgot,
  //       email = email,
  //       subject = subject,
  //       message = message,
  //       phoneNumber = phoneNumber,
  //       id = id,
  //       sendOtpCode,
  //     );
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

  // Future<Either<dynamic, dynamic>> verifyOTP(
  //   String otp,
  //   int optCode,
  //   String? email,
  //   String? phoneNumber,
  // ) async {
  //   try {
  //     final response = await _authenticationService.verifyOTP(
  //       otp,
  //       optCode,
  //       email,
  //       phoneNumber,
  //     );
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

  Future<Either<dynamic, dynamic>> forgotPassword(
    String phoneNumber,
  ) async {
    try {
      final response = await _authenticationService.forgotPassword(
        phoneNumber,
      );
      if (response['code'] == 400) {
        return left(response);
      } else {
        return right(response);
      }
    } catch (err) {
      return left({
        "message": err.toString(),
        "code": 400,
      });
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
      return left({
        "message": err.toString(),
        "code": 400,
      });
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
      return left({
        "message": err.toString(),
        "code": 400,
      });
    }
  }

  // Future<Either<dynamic, dynamic>> updatePhoneNumber(
  //   String otp,
  //   String phoneNumber,
  //   int id,
  // ) async {
  //   try {
  //     final response = await _authenticationService.updatePhoneNumber(
  //       otp,
  //       phoneNumber,
  //       id,
  //     );
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

  // Future<Either<dynamic, dynamic>> updateProfile(
  //   int id,
  //   FormData formData,
  // ) async {
  //   try {
  //     final response = await _authenticationService.updateProfile(
  //       id,
  //       formData,
  //     );
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

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
      return left({
        "message": err.toString(),
        "code": 400,
      });
    }
  }

  Future<BaseResponseModel> deactive(int? id) async {
    try {
      final res = await _baseDio.put(
        '${Api.disableAccount}/$id',
      );
      if (res.data["code"] == 200) {
        return BaseResponseModel(code: 200);
      } else {
        return BaseResponseModel(
          code: res.data["code"],
          message: res.data["message"],
        );
      }
    } catch (e) {
      return BaseResponseModel(code: 400, message: "Đã có lỗi xảy ra");
    }
  }

  Future<BaseResponseModel<AbbcBothV2Model>> checkOpenShop() async {
    try {
      final res = await _baseDio.get(Api.checkOpendShop);
      if (res.data["data"] != null) {
        final data = AbbcBothV2Model.fromJson(res.data["data"]);
        return BaseResponseModel(code: 200, data: data);
      } else {
        return BaseResponseModel(
          code: res.data["code"],
          message: res.data["message"],
        );
      }
    } catch (e) {
      print(e);
      return BaseResponseModel(code: 400, message: "Đã có lỗi xảy ra");
    }
  }

  Future<BaseResponseModel> sendRequestChangeToken(
    String token,
    String otp,
  ) async {
    try {
      final payload = {"session": token, "otp": otp};
      final response = await _baseDio.post(Api.verifySoftToken, data: payload);
      if (response.data["code"] == 200) {
        return BaseResponseModel(
          code: 200,
          message: "Tạo yêu cầu đổi mã token thành công",
        );
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(
        code: 400,
        message: err.toString(),
      );
    }
  }

  Future<BaseResponseModel<ReferallModel>> verifyReferralCode(
    String code, {
    int? id,
  }) async {
    try {
      final payload = {"referral_code": code, 'user': id};
      payload.removeWhere((key, value) => value == null);
      final response =
          await _baseDio.get(Api.verifyReferralCode, data: payload);
      if (response.data["code"] == 200) {
        final referallModel = ReferallModel(
          accountCode: response.data["data"]["phone"],
          accountName: response.data["data"]["full_name"],
        );
        return BaseResponseModel(
          code: 200,
          data: referallModel,
        );
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(
        code: 400,
        message: err.toString(),
      );
    }
  }

  Future<BaseResponseModel> verifyBankAccout(
    String phone,
    String otp,
  ) async {
    try {
      final payload = {"phone": phone, "otp": otp};
      final response = await _baseDio.post(Api.verifyBankAccout, data: payload);
      if (response.data["code"] == 200) {
        return BaseResponseModel(
          code: 200,
          message: "Tạo yêu cầu đổi mã token thành công",
        );
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(
        code: 400,
        message: err.toString(),
      );
    }
  }

  Future<BaseResponseModel<UserModelV2>> onAsbcUpdate(
    FormData formData,
    int id,
  ) async {
    try {
      final res = await _baseDio.post(
        Api.asbcProfile,
        data: formData,
      );
      if (res.data["code"] == 200) {
        final user = UserModelV2.fromJson(res.data["data"]);
        return BaseResponseModel(code: 200, data: user);
      } else {
        return BaseResponseModel(
          code: res.data["code"],
          message: res.data["message"],
        );
      }
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<UserModelV3>> getUserData(int id) async {
    try {
      final res = await _baseDio.get(Api.getUser);
      if (res.data["success"] == true) {
        final user = UserModelV3.fromJson(res.data["data"]);
        return BaseResponseModel(
          code: 200,
          data: user,
        );
      } else {
        return BaseResponseModel(
          code: res.data["code"],
          message: res.data["message"],
        );
      }
    } catch (e) {
      print('=====getUserModelV3=====$e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> logOut() async {
    try {
      final res = await _baseDio.get(Api.logOut);
      if (res.data["success"] == true) {
        return BaseResponseModel(code: 200);
      } else {
        return BaseResponseModel(
          code: res.data["code"],
          message: res.data["message"],
        );
      }
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
