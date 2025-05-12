import 'package:BGP_Retail/core/base/base_response.dart';
import 'package:BGP_Retail/core/configs/dio_config.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/injection/injection.dart';

import '../../../../core/constants/api_constants.dart';
import '../model/category_mode_v2.dart';
import '../model/product_model_v2.dart';

class PrdRepository {
  final _dio = getIt<BaseDio>();
  Future<BaseResponseModel<List<ProductModelV2>>> getPrds({
    String? search,
    int page = 1,
    int limit = 10,
    int? category,
    int? id,
  }) async {
    final List<ProductModelV2> list = [];
    try {
      final payload = {
        "company": id,
        'search': search,
        'page': page,
        'limit': limit,
        'productcategory': category,
      };
      payload.removeWhere(
        (key, value) => value == null || value.toString().isEmptyOrNull,
      );
      final res = await _dio.get(
        Api.productsV2,
        data: payload,
      );

      for (final json in res.data['data'] ?? []) {
        list.add(ProductModelV2.fromJson(json));
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

  Future<BaseResponseModel<List<CategoryModelV2>>> getProdsByCate() async {
    final List<CategoryModelV2> list = [];
    try {
      // final payload = {};
      final res = await _dio.get(
        Api.productsByCate,
        // data: payload,
      );

      for (final json in res.data['data'] ?? []) {
        list.add(CategoryModelV2.fromJson(json));
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

  Future<BaseResponseModel<List<CategoryModelV2>>> categories({
    String? search,
    int page = 1,
    int limit = 10,
    int? category,
  }) async {
    final List<CategoryModelV2> list = [];
    try {
      final res = await _dio.get(
        Api.categoryAsbc,
      );

      for (final json in res.data['data'] ?? []) {
        list.add(CategoryModelV2.fromJson(json));
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

  Future<BaseResponseModel<List<ProductModelV2>>> favoritePrds({
    String? search,
    int page = 1,
    int limit = 10,
    int? category,
  }) async {
    final List<ProductModelV2> list = [];
    try {
      final res = await _dio.get(
        Api.favorite,
      );

      for (final json in res.data['data']['product_data'] ?? []) {
        list.add(ProductModelV2.fromJson(json));
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

  Future<BaseResponseModel> favoriteAction({
    bool isDelete = false,
    required int prdId,
  }) async {
    try {
      final res = await _dio.post(
        Api.favorite,
        data: {
          "product_id": prdId,
          "type_action": !isDelete ? "ADD" : "DELETE",
        },
      );

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['data'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
