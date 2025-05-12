import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/core/base/base_response.dart';
import 'package:BGP_Retail/core/configs/dio_config.dart';
import 'package:BGP_Retail/core/constants/api_constants.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/features/cart/data/models/qr_order_detail_model.dart';
import 'package:BGP_Retail/features/order/data/models/order_asbc_model.dart';
import 'package:BGP_Retail/features/order/data/models/order_count_asbc_model.dart';
import 'package:BGP_Retail/features/order/data/models/order_detail_model.dart'
    as v2;
import 'package:BGP_Retail/features/order/data/models/order_model_v2.dart';
import 'package:BGP_Retail/features/order/data/models/total_order_model.dart';
import 'package:BGP_Retail/features/order/data/services/order_service.dart';

@injectable
class OrderRepository {
  OrderRepository(this._orderService, this._dio);

  final OrderService _orderService;
  final BaseDio _dio;

  Future<Either<dynamic, dynamic>> getOrders({
    int page = 0,
    required int accountId,
    String? status,
    int? pageSize,
    String? keyword,
    String? systemKey,
  }) async {
    try {
      final response = await _orderService.getOrders(
        page: page,
        accountId: accountId,
        status: status,
        pageSize: pageSize,
        keyword: keyword,
        systemKey: systemKey,
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

  Future<BaseResponseModel<List<OrderAsbcModel>>> getOrdersV2({
    int page = 1,
    String? status,
    String? search,
  }) async {
    try {
      final data = {
        "page": page,
        "status__code": status,
        "limit": 10,
        "search": search,
      };
      data.removeWhere(
        (key, value) => value == null || value == "",
      );
      final response = await _dio.get(Api.ordersV2, data: data);
      if (response.data['code'] == 200) {
        final orders = (response.data['data'] as List<dynamic>)
            .map((e) => OrderAsbcModel.fromJson(e))
            .toList();
        return BaseResponseModel(code: 200, data: orders);
      } else {
        return BaseResponseModel(
          code: response.data['code'],
          message: response.data['message'],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: err.toString());
    }
  }

  Future<BaseResponseModel<List<OrderCountAsbcModel>>> getCountOrders() async {
    try {
      final response = await _dio.get(Api.ordersCountV2);
      if (response.data['code'] == 200) {
        final orders = (response.data['data'] as List<dynamic>)
            .map((e) => OrderCountAsbcModel.fromJson(e))
            .toList();
        return BaseResponseModel(code: 200, data: orders);
      } else {
        return BaseResponseModel(
          code: response.data['code'],
          message: response.data['message'],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: err.toString());
    }
  }

  Future<Either<dynamic, dynamic>> orderConfirm({
    required int id,
    required String status,
    String? reason,
  }) async {
    try {
      final response = await _orderService.orderConfirm(
        id: id,
        status: status,
        reason: reason,
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

  Future<Either<dynamic, dynamic>> orderCancel({
    required int id,
    required OrderEnum? orderType,
    required DataModel? reason,
  }) async {
    try {
      final response = await _orderService.orderCancel(
        id: id,
        reason: reason,
        orderType: orderType,
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

  Future<Either<dynamic, dynamic>> orderDetail(int id) async {
    try {
      final response = await _orderService.orderDetail(id);
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

  // Future<Either<dynamic, dynamic>> createFormulaRatingTm(
  //   Map<String, dynamic> payload,
  // ) async {
  //   try {
  //     final response = await _orderService.createFormulaRatingTm(payload);
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

  Future<Either<dynamic, dynamic>> orderCreate(
    Map<String, dynamic> orderPayload,
  ) async {
    try {
      final response = await _orderService.orderCreate(orderPayload);
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

  Future<BaseResponseModel<QrOrderDetailModel>> orderDetailV2(
    String code,
  ) async {
    try {
      final response = await _dio.get("${Api.ordersV1}/$code/");
      if (response.data['message'] == "success") {
        final order = QrOrderDetailModel.fromJson(response.data['data']);
        return BaseResponseModel(data: order, code: 200);
      } else {
        return BaseResponseModel(
          data: response.data['message'],
          message: response.data['code'],
        );
      }
    } catch (err) {
      return BaseResponseModel(message: e.toString(), code: 400);
    }
  }

  Future<BaseResponseModel<List<DataModel>>> getReasonCancel(
    String type,
  ) async {
    try {
      final data = {"type": type};
      final response = await _dio.get(
        Api.ordersCancelV2,
        data: data,
      );
      if (response.data['code'] == 200) {
        final reason = (response.data['data'] as List<dynamic>)
            .map((e) => DataModel.fromJson(e))
            .toList();
        return BaseResponseModel(data: reason, code: 200);
      } else {
        return BaseResponseModel(
          data: response.data['message'],
          message: response.data['code'],
        );
      }
    } catch (err) {
      return BaseResponseModel(message: e.toString(), code: 400);
    }
  }

  Future<BaseResponseModel<TotalOrderModel>> getTotalOrder() async {
    try {
      final response = await _dio.get(Api.getTotalOrder);
      if (response.data['code'] == 200) {
        final data = TotalOrderModel.fromJson(response.data["data"]);
        return BaseResponseModel(code: 200, data: data);
      } else {
        return BaseResponseModel(
          code: response.data['code'],
          message: response.data['message'],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: err.toString());
    }
  }

  Future<BaseResponseModel> createRatting(
    v2.OrderItem item,
    int? orderId,
  ) async {
    // try {
    final payload = {
      "order_id": orderId,
      "star": item.ratting?.star ?? 5,
      "product": item.productId,
      "comment": item.ratting?.comment,
    };
    final FormData formData = FormData.fromMap(payload);
    //  = FormData();
    // if (item.ratting?.comment != null) {
    //   payload.fields.add(MapEntry("comment", item.ratting?.comment ?? "note"));
    // }
    if (item.files?.isNotEmpty == true) {
      for (final img in item.files!) {
        final MultipartFile multipartFile = await MultipartFile.fromFile(img);
        formData.files.add(MapEntry("rating_image", multipartFile));
      }
    }

    final response = await _dio.post(Api.rating, data: formData);
    if (response.data['code'] == 200) {
      return BaseResponseModel(code: 200);
    } else {
      return BaseResponseModel(
        code: response.data['code'],
        message: response.data['message'],
      );
    }
    // } catch (err) {
    //   return BaseResponseModel(code: 400, message: err.toString());
    // }
  }

  Future<BaseResponseModel> confirmPayment(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dio.post(Api.uploadOnlineOrder, data: payload);
      if (response.data['code'] == 200) {
        return BaseResponseModel(code: 200);
      } else {
        return BaseResponseModel(
          code: response.data['code'],
          message: response.data['message'],
        );
      }
    } catch (e) {
      return BaseResponseModel(
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> updateStatusOrder(int statusId, int id) async {
    try {
      final payload = {
        "status": statusId,
        "order_ids": [id],
      };
      final response = await _dio.put(Api.updateStatusOrder, data: payload);
      if (response.data['code'] == 200) {
        return BaseResponseModel(code: 200);
      } else {
        return BaseResponseModel(
          code: response.data['code'],
          message: response.data['message'],
        );
      }
    } catch (e) {
      return BaseResponseModel(
        message: e.toString(),
      );
    }
  }
}
