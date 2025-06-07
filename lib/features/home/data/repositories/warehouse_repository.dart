import 'package:bpg_retail/core/base/base_response.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/features/home/data/model/warehouse_model.dart';

class WarehouseRepository {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel<List<WarehouseModel>>> getWarehouses(
    String? search,
    int? page,
    int id,
  ) async {
    final data = {
      // 'page': page,
      // 'list': 1,
      // 'limit': 10,
      // 'keyword': search,
      'user_id': id,
    };
    data.removeWhere((key, value) => value == null);
    final List<WarehouseModel> list = [];
    try {
      final res = await _dio.get(Api.getWarehouses);

      for (final json in res.data['data'] ?? []) {
        list.add(WarehouseModel.fromJson(json));
      }

      return BaseResponseModel(
        code: res.data['status'],
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      print('======$e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
