import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/base/base_response.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/features/profile/data/services/noti_service.dart';

@LazySingleton()
class NotiRepository {
  NotiRepository(this._notiService, this._dio);

  final NotiService _notiService;
  final BaseDio _dio;

  Future<Either<dynamic, dynamic>> getListNoti(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _notiService.getListNoti(
        payload,
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

  Future<BaseResponseModel> seenNoti(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dio.post(Api.seenNoti, data: payload);
      if (response.data["code"] == 200) {
        return BaseResponseModel(code: 200);
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

  Future<BaseResponseModel> deleteNoti(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dio.post(Api.deleteNoti, data: payload);
      if (response.data["code"] == 200) {
        return BaseResponseModel(code: 200);
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
