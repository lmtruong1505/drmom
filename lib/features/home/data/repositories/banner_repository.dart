import 'package:BGP_Retail/core/base/base_response.dart';
import 'package:BGP_Retail/core/configs/dio_config.dart';
import 'package:BGP_Retail/core/constants/api_constants.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/features/booth/data/models/doctor_model.dart';
import 'package:BGP_Retail/features/home/data/model/banner_model.dart';

class BannerRepository {
  final _dio = getIt<BaseDio>();
  Future<BaseResponseModel<List<BannerModel>>> getBanners({int id = 1}) async {
    final List<BannerModel> list = [];
    try {
      final res = await _dio.get(Api.banners, data: {'type': id});

      for (final json in res.data['data'] ?? []) {
        list.add(BannerModel.fromJson(json));
      }

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<DoctorModel>>> getDoctors() async {
    final List<DoctorModel> list = [];
    try {
      final res = await _dio.get(Api.getDoctors);

      for (final json in res.data['data'] ?? []) {
        list.add(DoctorModel.fromJson(json));
      }

      return BaseResponseModel(
        code: res.data['status'],
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
