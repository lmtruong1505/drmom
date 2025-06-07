import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/features/cart/data/models/delivery_price_model.dart';
import 'package:bpg_retail/features/cart/data/models/ghtk_model.dart';

import '../../../../core/base/base_response.dart';

@injectable
class DeliveryRepository {
  DeliveryRepository(this._dio);
  final BaseDio _dio;

  Future<BaseResponseModel<List<DeliveryPriceModel>>> listPrice({
    required String senderAddress,
    required String receiverAddress,
  }) async {
    try {
      final payload = {
        'sender_address': senderAddress,
        'receiver_address': receiverAddress,
      };
      final res = await _dio.post(
        '${Api.domain}/order/api/getlistservice/',
        data: payload,
      );
      final data = (res.data['data']['RESULT'] as List)
          .map((e) => DeliveryPriceModel.fromJson(e))
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

  Future<BaseResponseModel<List<ViettelPostModel>>> getListViettelPost({
    required String senderAddress,
    required String receiverAddress,
    required num? weight,
    required num? length,
    required num? width,
    required num? height,
    required num? price,
  }) async {
    try {
      final payload = {
        'sender_address': senderAddress,
        'receiver_address': receiverAddress,
        "product_weight": weight,
        "product_length": length,
        "product_width": width,
        "product_height": height,
        "product_price": price,
        "money_collection": 0,
      };
      final res = await _dio.post(
        'https://core.kafa.pro/order/api/getlistservice/',
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
}
