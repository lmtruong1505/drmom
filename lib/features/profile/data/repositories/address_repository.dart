import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/base/base_response.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/features/profile/data/models/address_asbc_model.dart';
import 'package:bpg_retail/features/profile/data/models/address_map_model.dart';

@LazySingleton()
class AddressRepository {
  AddressRepository(this._baseDio);

  // final AddressService _addressService;
  final BaseDio _baseDio;

  // Future<Either<dynamic, dynamic>> getListAddress() async {
  //   try {
  //     final response = await _addressService.getListAddress();
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

  // Future<Either<dynamic, dynamic>> createAddress(
  //   String? fullname,
  //   String? phoneNumber,
  //   bool isDefault,
  //   dynamic address,
  // ) async {
  //   try {
  //     final response = await _addressService.createAddress(
  //       fullname,
  //       phoneNumber,
  //       isDefault,
  //       address,
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

  // Future<Either<dynamic, dynamic>> updateAddress(
  //   String id,
  //   String? fullname,
  //   String? phoneNumber,
  //   bool isDefault,
  //   dynamic address,
  // ) async {
  //   try {
  //     final response = await _addressService.updateAddress(
  //       id,
  //       fullname,
  //       phoneNumber,
  //       isDefault,
  //       address,
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

  // Future<Either<dynamic, dynamic>> updateStatusAddress(
  //   String id,
  //   bool isDefault,
  // ) async {
  //   try {
  //     final response = await _addressService.updateStatusAddress(
  //       id,
  //       isDefault,
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

  // Future<Either<dynamic, dynamic>> deleteAddress(String id) async {
  //   try {
  //     final response = await _addressService.deleteAddress(id);
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

  Future<BaseResponseModel<AddressMapModel>> getAddressFromLatLong(
    String latlng,
  ) async {
    try {
      final data = {
        "latlng": latlng,
        "key": "AIzaSyDMpLdwzRWo90pvohoMvrH9dinBcoy7mg4",
      };
      final res = await _baseDio.get(Api.getAddressGoogleMap, data: data);
      if (res.statusCode == 200) {
        final lstAddress = (res.data["results"] as List<dynamic>)
            .map((e) => AddressMapModel.fromJson(e))
            .toList();
        if (lstAddress.isNotEmpty) {
          return BaseResponseModel(code: 200, data: lstAddress.first);
        }

        return BaseResponseModel(code: 400, message: "Không tìm thấy địa chỉ");
      } else {
        return BaseResponseModel(code: 400, message: "Không tìm thấy địa chỉ");
      }
    } catch (err) {
      return BaseResponseModel(code: 400, message: "Đã có lỗi xảy ra");
    }
  }

  Future<BaseResponseModel> createGroceryAddress({
    required int? province,
    required int? district,
    required int? ward,
    required String? address,
    required num? lat,
    required num? long,
    required String? manager,
    required String? phone,
    required String? title,
    required String? tax,
  }) async {
    try {
      final data = {
        "warehouse": {
          "address": {
            "province": province,
            "district": district,
            "ward": ward,
            "title": address,
            "lat": lat,
            "long": long,
          },
          "manager": manager,
          "phone": phone,
        },
        "title": title,
        "tax_number": tax,
      };
      data.removeWhere((key, value) => value == null || value == "");
      final res = await _baseDio.post(Api.opendShop, data: data);
      if (res.data["code"] == 201) {
        return BaseResponseModel(
          code: 200,
        );
      } else {
        return BaseResponseModel(
          code: 400,
          message: "Đăng kí shop không thành công",
        );
      }
    } catch (err) {
      return BaseResponseModel(
        code: 400,
        message: "Đăng kí shop không thành công",
      );
    }
  }

  Future<BaseResponseModel> createASBCAddress({
    required String? fullname,
    required String? phoneNumber,
    required bool isDefault,
    required int? ward,
    required int? district,
    required int? province,
    required String? title,
    required double? lat,
    required double? long,
  }) async {
    final data = {
      "fullname": fullname,
      "phone": phoneNumber,
      "address": {
        "ward": ward,
        "district": district,
        "province": province,
        "lat": lat,
        "long": long,
        "title": title,
      },
      'is_default': isDefault,
    };
    final res = await _baseDio.post(Api.aSBCAddress, data: data);
    if (res.data["code"] == 200) {
      return BaseResponseModel(code: 200);
    } else {
      return BaseResponseModel(
        code: 400,
        message: "Đăng kí shop không thành công",
      );
    }
  }

  Future<BaseResponseModel> updateASBCAddress({
    required String? fullname,
    required String? phoneNumber,
    required int id,
    required int? ward,
    required int? district,
    required int? province,
    required String? title,
    required double? lat,
    required double? long,
    required bool? isDefault,
  }) async {
    final data = {
      "fullname": fullname,
      "phone": phoneNumber,
      "address": {
        "ward": ward,
        "district": district,
        "province": province,
        "lat": lat,
        "long": long,
        "title": title,
      },
      'is_default': isDefault ?? false,
    };
    final res = await _baseDio.put('${Api.aSBCAddress}$id/', data: data);
    if (res.data["code"] == 200) {
      return BaseResponseModel(code: 200);
    } else {
      return BaseResponseModel(
        code: 400,
        message: "Cập nhật shop không thành công",
      );
    }
  }

  Future<BaseResponseModel<List<AsbcAddressModel>>> getASBCListAddress() async {
    try {
      final res = await _baseDio.get(Api.aSBCAddress);
      if (res.data["code"] == 200) {
        final list = (res.data["data"] as List)
            .map((e) => AsbcAddressModel.fromJson(e))
            .toList();
        return BaseResponseModel(code: 200, data: list);
      } else {
        return BaseResponseModel(
          code: 400,
          message: res.data["message"],
        );
      }
    } catch (err) {
      return BaseResponseModel(
        code: 400,
        message: err.toString(),
      );
    }
  }
}
