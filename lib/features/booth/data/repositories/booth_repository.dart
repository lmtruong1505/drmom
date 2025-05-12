import 'package:dartz/dartz.dart';
import 'package:BGP_Retail/features/booth/data/models/healthy_care_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/core/base/base_response.dart';
import 'package:BGP_Retail/core/configs/dio_config.dart';
import 'package:BGP_Retail/core/constants/api_constants.dart';
import 'package:BGP_Retail/core/utilities/loading.dart';
import 'package:BGP_Retail/features/booth/data/models/asbc_both_model.dart';
import 'package:BGP_Retail/features/booth/data/models/asbc_both_v2_model.dart';
import 'package:BGP_Retail/features/booth/data/models/booth_model.dart';
import 'package:BGP_Retail/features/booth/data/models/category_model.dart';
import 'package:BGP_Retail/features/booth/data/models/first_gift_model.dart';
import 'package:BGP_Retail/features/profile/data/models/address_asbc_model.dart';

@injectable
class BoothRepository {
  BoothRepository(this._dio);

  // final BoothService _boothService;
  final BaseDio _dio;

  // Future<Either<dynamic, dynamic>> shopList({
  //   int page = 0,
  //   int? filtered,
  //   int? pageSize,
  //   String? keyword,
  //   String? address,
  //   double latitude = 0,
  //   double longitude = 0,
  // }) async {
  //   try {
  //     final response = await _boothService.shopList(
  //       filtered: filtered,
  //       keyword: keyword,
  //       address: address,
  //       page: page,
  //       pageSize: pageSize,
  //       latitude: latitude,
  //       longitude: longitude,
  //     );
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

  // Future<BaseResponseModel<List<BoothModel>>> getShopList({
  //   int page = 0,
  //   int? filtered,
  //   int? pageSize,
  //   String? keyword,
  //   String? address,
  //   double latitude = 0,
  //   double longitude = 0,
  // }) async {
  //   try {
  //     final response = await _dio.post(
  //       Api.shopList,
  //       data: {
  //         "filtered": filtered,
  //         "keyword": keyword,
  //         "address": address,
  //         "page": page,
  //         "page_size": pageSize,
  //         "latitude": latitude,
  //         "longitude": longitude,
  //       },
  //     );
  //     if (response.data['code'] == 200) {
  //       final booths =
  //           (response.data["data"]["results"] as List<dynamic>).map((e) {
  //         return BoothModel.fromJson(e);
  //       }).toList();
  //       return BaseResponseModel(code: 200, data: booths);
  //     } else {
  //       return BaseResponseModel(code: response.data["code"], data: []);
  //     }
  //   } catch (err) {
  //     return BaseResponseModel(code: 400, data: []);
  //   }
  // }

  Future<BaseResponseModel<FirstGiftModel>> getFirstPurchaseGift({
    required int accountId,
  }) async {
    try {
      showLoading();
      final data = {"object_account_id": accountId};
      final response = await _dio.post(
        Api.getFirstPurchaseGift,
        data: data,
      );
      EasyLoading.dismiss();
      if (response.data['code'] == 200) {
        final detail = response.data["data"];
        final booths = FirstGiftModel.fromJson(detail);
        return BaseResponseModel(code: 200, data: booths);
      } else {
        return BaseResponseModel(
          code: response.data["code"],
        );
      }
    } catch (err) {
      EasyLoading.dismiss();
      return BaseResponseModel(code: 400);
    }
  }

  Future<BaseResponseModel<List<HealthCareModel>>> getListHospital({
    int page = 0,
    String? keyword,
  }) async {
    try {
      final data = {
        "search": keyword,
      };
      data.removeWhere((key, value) => value == null || value == '');
      final response = await _dio.get(
        Api.healthcare,
        data: data,
      );
      if (response.data['success'] == true) {
        final booths = (response.data["data"] as List<dynamic>).map((e) {
          return HealthCareModel.fromJson(e);
        }).toList();
        return BaseResponseModel(code: 200, data: booths);
      } else {
        return BaseResponseModel(
          code: response.data["code"],
        );
      }
    } catch (err) {
      return BaseResponseModel(code: 400);
    }
  }

  Future<BaseResponseModel<AbbcBothV2Model>> getBoth(int id) async {
    try {
      final response = await _dio.get('${Api.getAsbcShop}$id');
      if (response.data['code'] == 200) {
        final both = AbbcBothV2Model.fromJson(response.data["data"]);

        return BaseResponseModel(code: 200, data: both);
      } else {
        return BaseResponseModel(
          code: response.data["code"],
        );
      }
    } catch (err) {
      print(err);
      return BaseResponseModel(code: 400);
    }
  }

  Future<BaseResponseModel<List<CategoryModel>>> getBothCategory(int id) async {
    try {
      final data = {"company": id};
      final response = await _dio.get(Api.bothCategory, data: data);
      if (response.data['code'] == 200) {
        final listCategory = (response.data["data"] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();

        return BaseResponseModel(code: 200, data: listCategory);
      } else {
        return BaseResponseModel(
          code: response.data["code"],
        );
      }
    } catch (err) {
      print(err);
      return BaseResponseModel(code: 400);
    }
  }
}
