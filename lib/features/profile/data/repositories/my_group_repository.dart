import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/core/base/base_response.dart';
import 'package:BGP_Retail/core/configs/dio_config.dart';
import 'package:BGP_Retail/core/constants/api_constants.dart';
import 'package:BGP_Retail/features/profile/data/models/my_group_model.dart';

@lazySingleton
class MyGroupRepository {
  final BaseDio _dio;

  MyGroupRepository(this._dio);
  Future<dynamic> getListMember(String? key, int page, {int? id}) async {
    try {
      final data = {"search": key, "page_size": 10, "page": page, 'user': id};
      data.removeWhere((key, value) => value == null);
      final response = await _dio.get(
        Api.myGroup,
        data: data,
      );
      return response;
    } catch (err) {}
  }

  Future<BaseResponseModel<MyGroupModel>> getMyReferrer(int id) async {
    try {
      final payload = {"user": id};
      final response = await _dio.get(
        Api.myReferrer,
        data: payload,
      );
      final data = MyGroupModel.fromJson(response.data["data"]);
      return BaseResponseModel(code: 200, data: data);
    } catch (err) {
      return BaseResponseModel(code: 400, message: err.toString());
    }
  }

  Future<BaseResponseModel> updateReferrer(
    String code,
    int id,
  ) async {
    try {
      final payload = {
        "user": id,
        "referral_code": code,
      };
      final response = await _dio.post(
        Api.updateReferrer,
        data: payload,
      );
      if (response.data["code"] == 200) {
        return BaseResponseModel(code: 200);
      } else {
        return BaseResponseModel(
          code: 400,
          message: "Cập nhật thông tin không thành công",
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: err.toString());
    }
  }
}
