import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/base/base_response.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/features/home/data/model/product_model.dart';
import 'package:bpg_retail/features/home/data/model/rating_model.dart';
import 'package:bpg_retail/features/home/data/services/home_service.dart';

@injectable
class HomeRepository {
  HomeRepository(this._homeService, this._dio);

  final HomeService _homeService;
  final BaseDio _dio;

  // Future<Either<dynamic, dynamic>> formulaEcommerceList() async {
  //   try {
  //     final response = await _homeService.formulaEcommerceList();
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

  // Future<Either<dynamic, dynamic>> categoryEcommerceList() async {
  //   try {
  //     final response = await _homeService.categoryEcommerceList();
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

  // Future<Either<dynamic, dynamic>> formulaRatingTm(List<int> formulaIds) async {
  //   try {
  //     final response = await _homeService.formulaRatingTm(formulaIds);
  //     if (response['code'] == 400) {
  //       return left(response);
  //     } else {
  //       return right(response);
  //     }
  //   } catch (err) {
  //     return left({
  //       "message": err.toString(),
  //       "code": 400,
  //     });
  //   }
  // }

  Future<Either<dynamic, dynamic>> getCategories() async {
    try {
      final response = await _homeService.getCategories();
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

  Future<Either<dynamic, dynamic>> getProducts(
    String? search,
    int page, {
    int? boothId,
    int? categoryId,
  }) async {
    try {
      final response =
          await _homeService.getProducts(search, page, boothId, categoryId);
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

  Future<Either<dynamic, dynamic>> getProductDetail(int id) async {
    try {
      final response = await _homeService.getProductDetail(id);
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

  Future<BaseResponseModel<List<RatingModel>>> getRating(
    int id,
    int page,
    int? star,
  ) async {
    try {
      final data = {
        "product_id": id,
        "page": page,
        "star": star,
        "page_size": 20,
      };
      final res = await _dio.get(Api.getRating, data: data);
      if (res.data["code"] == 200) {
        final lst = (res.data["data"]["ratings"] as List)
            .map((e) => RatingModel.fromJson(e))
            .toList();
        return BaseResponseModel(
          code: 200,
          data: lst,
          extra: res.data["data"]["total_search"],
        );
      } else {
        return BaseResponseModel(
          code: res.data["code"],
          message: res.data["message"],
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<ProductModel>>> getTopProduct() async {
    try {
      final res = await _dio.get(Api.topRatingProduct);
      if (res.data["code"] == 200) {
        final products = (res.data["data"] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        return BaseResponseModel(
          code: 200,
          data: products,
          message: res.data["message"],
        );
      } else {
        return BaseResponseModel(
          code: res.data["code"],
          message: res.data["message"],
        );
      }
    } catch (e) {
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  Future<BaseResponseModel> addToCart(
    List<int> optionData,
    num? quantity,
  ) async {
    try {
      final payload = {"option": optionData, "quantity": quantity};
      final res = await _dio.post(Api.addToCartV2, data: payload);
      if (res.data["code"] == 200) {
        return BaseResponseModel(
          code: 200,
          message: 'Thêm sản phẩm thành công',
        );
      } else {
        return BaseResponseModel(
          code: res.data["code"],
          message: res.data["message"],
        );
      }
    } catch (e) {
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }
}
