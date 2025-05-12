import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/core/base/base_response.dart';
import 'package:BGP_Retail/core/configs/dio_config.dart';
import 'package:BGP_Retail/core/constants/api_constants.dart';
import 'package:BGP_Retail/features/profile/data/models/promotion_detail_model.dart';
import 'package:BGP_Retail/features/profile/data/models/promotion_model.dart';

@LazySingleton()
class PromotionRepository {
  PromotionRepository(this._dio);

  final BaseDio _dio;

  Future<BaseResponseModel<List<PromotionModel>>> getPromotion() async {
    try {
      final response = await _dio.get(Api.promotion);
      if (response.data["code"] == 200) {
        final data = (response.data["data"] as List)
            .map((e) => PromotionModel.fromJson(e))
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

  Future<BaseResponseModel<PromotionDetailModel>> getPromotionDetail(
    int id,
  ) async {
    try {
      final response = await _dio.get("${Api.promotionDetail}/$id");
      if (response.data["code"] == 200) {
        final data = PromotionDetailModel.fromJson(response.data["data"]);
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

  Future<BaseResponseModel> updatePromotion(int id, int status) async {
    try {
      final data = {"status": status};
      final response = await _dio.put("${Api.updatePromotion}/$id", data: data);
      if (response.data["code"] == 200) {
        return BaseResponseModel(code: 200, message: "Bạn đã xác nhận quà");
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
