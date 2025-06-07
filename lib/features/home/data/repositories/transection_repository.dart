import 'package:bpg_retail/core/base/base_response.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/features/booth/data/models/transection_detail_model.dart';
import 'package:bpg_retail/features/booth/data/models/transection_model.dart';
import 'package:bpg_retail/features/home/data/model/banner_model.dart';

class TransectionRepository {
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

  Future<BaseResponseModel<List<TransectionModel>>> getTransaction({
    required int userId,
    required int warehouseId,
    required String? start,
    required String? end,
  }) async {
    final data = {
      'warehouse_id': warehouseId,
      'created_at__gte': start,
      'created_at__lte': end,
    };
    data.removeWhere(
      (key, value) => value == null,
    );
    final List<TransectionModel> list = [];
    try {
      final res = await _dio.get(Api.getTransaction(userId), data: data);

      for (final json in res.data['data'] ?? []) {
        list.add(TransectionModel.fromJson(json));
      }
      final extra = MetaData.fromJson(res.data['metadata']);

      return BaseResponseModel(
        code: res.data['status'],
        message: res.data['message'],
        data: list,
        extra: extra,
      );
    } catch (e) {
      print('=======$e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<TransectionDetailModel>> getDetailTransaction(
    int id,
  ) async {
    try {
      final res = await _dio.get('${Api.transactionDetail}/$id');

      final data = TransectionDetailModel.fromJson(res.data['data']);

      return BaseResponseModel(
        code: res.data['status'],
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
