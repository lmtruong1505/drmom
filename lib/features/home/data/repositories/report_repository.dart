import 'package:bpg_retail/core/base/base_response.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/features/home/data/model/home_report_model.dart';

class ReportRepository {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel<List<ReportHomeModel>>> getReports(
    String? start,
    String? end,
    int id,
    int? warehouseId,
  ) async {
    final data = {
      'recorded_at__gte': start,
      'recorded_at__lte': end,
      'warehouse_id': warehouseId,
    };
    data.removeWhere((key, value) => value == null);
    final List<ReportHomeModel> list = [];
    try {
      final res = await _dio.get(Api.getReports(id), data: data);

      for (final json in res.data['data'] ?? []) {
        list.add(ReportHomeModel.fromJson(json));
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
