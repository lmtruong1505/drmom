import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/features/cart/data/models/cart_model_v2.dart';
import 'package:bpg_retail/features/cart/data/models/ghtk_model.dart';
import 'package:bpg_retail/features/cart/data/models/payment_success_model.dart';
import 'package:bpg_retail/features/cart/data/models/product_warehouse_model.dart';
import 'package:bpg_retail/features/cart/data/models/qr_order_detail_model.dart';
import 'package:bpg_retail/features/cart/data/models/wallet_model.dart';

import '../../../../core/base/base_response.dart';

@injectable
class CartRepository {
  CartRepository(this._dio);
  final BaseDio _dio;

  Future<BaseResponseModel<List<CartModelV2>>> getProducts() async {
    try {
      final res = await _dio.get(Api.getCarts);
      final data = (res.data['data']['orders_items'] as List)
          .map((e) => CartModelV2.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        // message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> deleteCartProduct(List<int> ids) async {
    try {
      final data = {
        "ids": ids,
      };
      final res = await _dio.post(Api.deleteOrderProduct, data: data);

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> updateCartProduct(
    int id,
    num quantity,
    bool isFromCart,
  ) async {
    try {
      final data = {
        "orders_items": [
          {"product_unit_id": id, "quantity": quantity},
        ],
        "is_update": isFromCart,
      };
      final res = await _dio.post(Api.updateOrderProduct, data: data);

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<ViettelPostModel>>> getListViettelPost({
    required String shopAddress,
    required String userAddress,
    required num? weight,
    required num? length,
    required num? width,
    required num? height,
    required num? price,
  }) async {
    try {
      final payload = {
        'sender_address': shopAddress,
        'receiver_address': userAddress,
        "product_weight": weight,
        "product_length": length,
        "product_width": width,
        "product_height": height,
        "product_price": price,
        "money_collection": 0,
        "company_code": "ASBC",
      };
      final res = await _dio.post(
        Api.viettelPost,
        data: payload,
      );
      final data = (res.data['data']['RESULT'] as List)
          .map((e) => ViettelPostModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<GHTKModel>> getGHTK({
    required String senderAddress,
    required String receiverAddress,
    required num? weight,
    required num? length,
    required num? width,
    required num? height,
    required num? price,
  }) async {
    try {
      final lstSenderAddress = senderAddress.split(",");
      final lstReceiverAddress = receiverAddress.split(",");
      final senderProvince = lstSenderAddress.last;
      final senderDistrict = lstSenderAddress[lstSenderAddress.length - 2];
      final receiverProvince = lstReceiverAddress.last;
      final receiverDistrict =
          lstReceiverAddress[lstReceiverAddress.length - 2];
      final payload = {
        'sender_address': senderAddress,
        'receiver_address': receiverAddress,
        "product_weight": weight,
        "product_length": length,
        "product_width": width,
        "product_height": height,
        "product_price": price,
        "money_collection": 0,
        "company_code": "LH",
        "transport_partner_code": "GHTK",
        "sender_province": senderProvince,
        "sender_district": senderDistrict,
        "receiver_province": receiverProvince,
        "receiver_district": receiverDistrict,
      };
      final res = await _dio.post(
        "https://core.kafa.pro/order/api/getprice-transport-partner/",
        data: payload,
      );
      final data = GHTKModel.fromJson((res.data['data']['data']));
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> updateDeviceToken(
    String token,
    int idUser,
  ) async {
    try {
      String type = "";
      if (Platform.isIOS) {
        type = "ios";
      } else {
        type = "android";
      }
      final data = {
        "device_token": token,
        "user": idUser,
        "system": 2,
        "type": type,
      };
      final res = await _dio.post(Api.updateDeviceToken, data: data);

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<Uint8List>> getQrCode(
    String bank,
    String accountNumber,
    num price,
    String description,
  ) async {
    try {
      final res = await _dio.get(
        "https://img.vietqr.io/image/$bank-$accountNumber-qr_only.jpg?amount=$price&addInfo=$description",
        options: Options(responseType: ResponseType.bytes),
      );

      return BaseResponseModel(
        code: 200,
        data: res.data,
      );
    } catch (e) {
      EasyLoading.dismiss();
      print("===============${e}");
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  // Future<BaseResponseModel<List<AccountBankModel>>> getBankAccountInfo(
  //   int id,
  // ) async {
  //   try {
  //     final res = await _dio.get("${Api.bankInfor}/$id");
  //     final data = (res.data["data"] as List)
  //         .map((e) => AccountBankModel.fromJson(e))
  //         .toList();

  //     return BaseResponseModel(
  //       code: 200,
  //       data: data,
  //     );
  //   } catch (e) {
  //     print("===============${e}");
  //     EasyLoading.dismiss();
  //     return BaseResponseModel(
  //       code: 400,
  //       message: e.toString(),
  //     );
  //   }
  // }

  Future<BaseResponseModel<QrOrderDetailModel>> getOrderDetail(
    String code,
  ) async {
    try {
      final res = await _dio.get("${Api.qrOrderDetail}/$code/");
      final data = QrOrderDetailModel.fromJson(res.data["data"]);
      if (res.data["code"] == 200) {
        return BaseResponseModel(
          code: 200,
          data: data,
        );
      } else {
        return BaseResponseModel(
          code: 400,
          message: "Đã có lỗi xảy ra",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<WalletModel>>> getWallets() async {
    try {
      final res = await _dio.get(Api.wallets);

      if (res.data["code"] == 200) {
        final data = (res.data["data"] as List)
            .map((e) => WalletModel.fromJson(e))
            .toList();
        final payWallets =
            data.where((element) => element.isPayable == true).toList();
        return BaseResponseModel(
          code: 200,
          data: payWallets,
        );
      } else {
        return BaseResponseModel(
          code: 400,
          message: "Đã có lỗi xảy ra",
        );
      }
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<PaymentSuccessModel>> createOrder(
    int id,
    num wallet,
  ) async {
    try {
      final payload = {"id": id, "wallet_type": wallet};
      final res = await _dio.post(Api.confirmPayment, data: payload);
      if (res.data["code"] == 200) {
        final data = PaymentSuccessModel.fromJson(res.data["data"]);

        return BaseResponseModel(
          code: 200,
          data: data,
        );
      } else {
        return BaseResponseModel(
          code: 400,
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

  Future<BaseResponseModel<String>> createOnlineOrder(
    Map<String, dynamic> orderPayload,
  ) async {
    try {
      final res = await _dio.post(Api.createOnlineOrder, data: orderPayload);
      if (res.data["code"] == 200) {
        // final data = PaymentSuccessModel.fromJson(res.data["data"]);

        return BaseResponseModel(
          code: 200,
          data: res.data['data']['code'],
        );
      } else {
        return BaseResponseModel(
          code: 400,
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

  Future<BaseResponseModel<List<ProductWarehouseModel>>> getCart() async {
    try {
      final res = await _dio.get(Api.carts);
      if (res.data["code"] == 200) {
        final list = (res.data['data'] as List)
            .map((e) => ProductWarehouseModel.fromJson(e))
            .toList();
        final updateSelectOptionList = list.map(
          (warehouse) {
            final itemUpdate = warehouse.items!.map(
              (prd) {
                final optionSelect = prd.variant
                    ?.map((variant) => variant.option)
                    .expand((options) => options!)
                    .toList();
                final updateVariant = prd.variant!
                    .map((e) => e.copyWith(options: e.option))
                    .toList();
                return prd.copyWith(
                  optionSelect: optionSelect,
                  variant: updateVariant,
                );
              },
            ).toList();
            return warehouse.copyWith(items: itemUpdate);
          },
        ).toList();
        return BaseResponseModel(
          code: 200,
          data: updateSelectOptionList,
        );
      } else {
        return BaseResponseModel(
          code: 400,
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

  Future<BaseResponseModel> deletePrd({List<int>? ids}) async {
    try {
      final payload = {'ids': ids};

      final res = await _dio.post(Api.deleteCarts, data: payload);
      if (res.data["code"] == 200) {
        return BaseResponseModel(code: 200);
      } else {
        return BaseResponseModel(
          code: 400,
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

  Future<BaseResponseModel<bool>> updatePrd({int? id, num? quantity}) async {
    try {
      final payload = {'id': id, "quantity": quantity};

      final res = await _dio.post(Api.updatePrd, data: payload);
      if (res.data["code"] == 200) {
        return BaseResponseModel(
          code: 200,
          data: true,
        );
      } else {
        return BaseResponseModel(
          code: 400,
          data: false,
          message: res.data["message"],
        );
      }
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        data: false,
        message: e.toString(),
      );
    }
  }
}
