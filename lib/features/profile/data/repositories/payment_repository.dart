import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/base/base_response.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/features/profile/data/models/bank_model.dart';

import 'package:bpg_retail/features/profile/data/models/deposit_history_model.dart';
import 'package:bpg_retail/features/profile/data/models/deposit_qr_code_model.dart';
import 'package:bpg_retail/features/profile/data/models/payment_detail_model.dart';
import 'package:bpg_retail/features/profile/data/models/payment_model.dart';
import 'package:bpg_retail/features/card/data/models/bank_model.dart' as v2;

@Injectable()
class PaymentRepository {
  final BaseDio _dio;

  PaymentRepository({required BaseDio dio}) : _dio = dio;

  Future<BaseResponseModel<List<PaymentModel>>> getPaymentHistory(
    int page,
    int? wallet,
    int? type,
    String? search,
    String? from,
    String? to,
  ) async {
    try {
      final data = {
        "page": page,
        "page_size": 10,
        "wallet_type": wallet,
        "transaction_type": type,
        "search": search,
        "from": from,
        "to": to,
      };
      data.removeWhere((key, value) => value == "" || value == null);

      final response = await _dio.get(Api.transactions, data: data);
      if (response.data["code"] == 200) {
        final data = (response.data["data"] as List)
            .map((e) => PaymentModel.fromJson(e))
            .toList();
        return BaseResponseModel(code: 200, data: data);
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: "Đã có lỗi xảy ra");
    }
  }

  Future<BaseResponseModel<PaymentDetailModel>> getPaymentDetail(
    String code,
  ) async {
    try {
      final response = await _dio.get("${Api.transactions}/$code/");
      if (response.data["code"] == 200) {
        final data = PaymentDetailModel.fromJson(response.data["data"]);
        return BaseResponseModel(code: 200, data: data);
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: "Đã có lỗi xảy ra");
    }
  }

  Future<BaseResponseModel<DepositQrCodeModel>> createDeposit(
    num amount, {
    num? orderId,
  }) async {
    try {
      final data = {
        "amount": amount,
        "content": "Chuyen khoan",
        'order': orderId,
      };
      data.removeWhere(
        (key, value) => value == null,
      );

      final response = await _dio.get(Api.generateQR, data: data);
      if (response.data["code"] == 200) {
        final data = DepositQrCodeModel.fromJson(response.data["data"]);
        return BaseResponseModel(code: 200, data: data);
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: "Đã có lỗi xảy ra");
    }
  }

  Future<BaseResponseModel<List<DepositHistoryModel>>> getHistoryDeposit(
    int page,
    int? status,
    String? key,
  ) async {
    try {
      final data = {
        "page": page,
        "page_size": 10,
        "status": status,
        "search": key,
      };
      data.removeWhere((key, value) => value == null);
      final response = await _dio.get(Api.historyWithdraws, data: data);
      if (response.data["code"] == 200) {
        final data = (response.data["data"] as List)
            .map((e) => DepositHistoryModel.fromJson(e))
            .toList();
        return BaseResponseModel(code: 200, data: data);
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: "Đã có lỗi xảy ra");
    }
  }

  Future<BaseResponseModel<List<BankModel>>> getListBank(
    String? search,
    int page,
  ) async {
    try {
      final data = {
        "page": page,
        "page_size": 10,
        "search": search,
      };
      final response = await _dio.get(Api.listBank, data: data);
      if (response.data["code"] == 200) {
        final data = (response.data["data"] as List)
            .map((e) => BankModel.fromJson(e))
            .toList();
        return BaseResponseModel(code: 200, data: data);
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: "Đã có lỗi xảy ra");
    }
  }

  Future<BaseResponseModel> createBankAccount(
    String name,
    String bankNumber,
    int? id,
    bool? isDefault,
  ) async {
    try {
      final payload = {
        "account_name": name,
        "account_number": bankNumber,
        "bank": id,
        "is_default": isDefault,
      };
      final response = await _dio.post(Api.createBankAccount, data: payload);
      if (response.data["code"] == 201) {
        return BaseResponseModel(
          code: 200,
          message: "Tạo tài khoản ngân hàng thành công",
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
      );
    }
  }

  Future<BaseResponseModel<List<MyBankModel>>> getListMyBank() async {
    try {
      final data = {"page": 1, "page_size": 1000};
      final response = await _dio.get(Api.listMyBank, data: data);
      if (response.data["code"] == 200) {
        final data = (response.data["data"] as List)
            .map((e) => MyBankModel.fromJson(e))
            .toList();
        return BaseResponseModel(code: 200, data: data);
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: "Đã có lỗi xảy ra");
    }
  }

  Future<BaseResponseModel<String>> sendRequestChangeToken(String text) async {
    try {
      final payload = {"soft_token": text};
      final response =
          await _dio.post(Api.requestChangeSoftToken, data: payload);
      if (response.data["code"] == 200) {
        return BaseResponseModel(
          code: 200,
          message: "Tạo yêu cầu đổi mã token thành công",
          data: response.data["data"]["session"],
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
      );
    }
  }

  Future<BaseResponseModel> requestWithdraw(int money, int bankId) async {
    try {
      final payload = {
        "request_type": 2,
        "status": 1,
        "bank": bankId,
        "amount": money,
      };
      final response = await _dio.post(Api.requestWithdraw, data: payload);
      if (response.data["code"] == 201) {
        return BaseResponseModel(
          code: 200,
          message: "Tạo yêu rút tiền thành công",
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
      );
    }
  }

  Future<BaseResponseModel> verificationToken(String token) async {
    try {
      final payload = {"soft_token": token};
      final response = await _dio.post(Api.checkToken, data: payload);
      if (response.data["code"] == 201) {
        return BaseResponseModel(
          code: 200,
          message: "Xác nhận thành công",
        );
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: "Mã token không đúng",
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: err.toString());
    }
  }

  Future<BaseResponseModel<MyBankModel>> getBankDetail(int id) async {
    try {
      final response = await _dio.get("${Api.listMyBank}/$id");
      if (response.data["code"] == 200) {
        final data = MyBankModel.fromJson(response.data["data"]);
        return BaseResponseModel(code: 200, data: data);
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: "Đã có lỗi xảy ra");
    }
  }

  Future<BaseResponseModel> updateBankAccount(
    String name,
    String bankNumber,
    int? idBank,
    bool? isDefault,
    int? id,
  ) async {
    try {
      final payload = {
        "account_name": name,
        "account_number": bankNumber,
        "bank": idBank,
        "is_default": isDefault,
      };
      final response =
          await _dio.put("${Api.createBankAccount}/$id", data: payload);
      if (response.data["code"] == 201 || response.data["code"] == 200) {
        return BaseResponseModel(
          code: 200,
          message: "Tạo tài khoản ngân hàng thành công",
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
      );
    }
  }

  Future<BaseResponseModel<v2.BankModel>> getBankASBC() async {
    try {
      final response = await _dio.get(Api.getBankASBC);
      if (response.data["code"] == 200) {
        final data = v2.BankModel.fromJson(response.data["data"]);
        return BaseResponseModel(code: 200, data: data);
      } else {
        return BaseResponseModel(
          code: response.data["code"],
          message: response.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: "Đã có lỗi xảy ra");
    }
  }
}

class FilterArgModel {
  final int? wallet;
  final int? transaction;
  final String? start;
  final String? end;

  FilterArgModel({
    required this.wallet,
    required this.transaction,
    required this.start,
    required this.end,
  });
}
