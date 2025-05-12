import 'package:BGP_Retail/core/constants/api_constants.dart';
import 'package:BGP_Retail/core/configs/dio_config.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/core/extension/string_extension.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/features/order/data/models/order_asbc_model.dart';

@injectable
class OrderService {
  OrderService(this._baseDio);

  final BaseDio _baseDio;

  Future<dynamic> orderConfirm({
    required int id,
    required String status,
    String? reason,
  }) async {
    final data = {"order_id": id, "status_code": status};
    if (!reason.nullOrEmpty) {
      data["reason"] = reason!;
    }
    final res = await _baseDio.put(Api.updateOrderV2, data: data);
    return res.data;
  }

  Future<dynamic> orderCancel({
    required DataModel? reason,
    required OrderEnum? orderType,
    required int? id,
  }) async {
    var data;

    final isDifferReason =
        (orderType?.code == OrderEnum.CANCEL.code && reason?.id == 6) ||
            (orderType?.code == OrderEnum.COMPLAINT.code && reason?.id == 14);
    if (isDifferReason) {
      // data.remove("reason");

      data = {
        "reason": {
          "title": reason?.title,
          "type": orderType?.code,
        },
        "cancel_order": {"order": id},
      };
    } else {
      // data.remove("cancel_order");
      data = {
        "cancel_order": {"order": id, "reason": reason?.id},
      };
    }

    final res = await _baseDio.post(Api.ordersCancelV2, data: data);
    return res.data;
  }

  Future<dynamic> orderDetail(int id) async {
    final res = await _baseDio.get(
      "${Api.orderDetail}/$id",
    );
    return res.data;
  }

  Future<dynamic> getOrders({
    int page = 0,
    required int accountId,
    String? status,
    int? pageSize,
    String? keyword,
    String? systemKey,
  }) async {
    final res = await _baseDio.post(
      Api.orderList,
      data: {
        "page": page,
        "account_id": accountId,
        "status": status,
        "page_size": pageSize,
        "keyword": keyword,
        "system_key": systemKey,
      },
    );
    return res.data;
  }

  Future<dynamic> orderCreate(Map<String, dynamic> orderPayload) async {
    final res = await _baseDio.post(Api.ordersV2, data: orderPayload);
    return res.data;
  }

  // Future<dynamic> createFormulaRatingTm(Map<String, dynamic> payload) async {
  //   final res = await _baseDio.post(
  //     Api.createFormulaRatingTm,
  //     data: payload,
  //   );
  //   return res.data;
  // }
}
