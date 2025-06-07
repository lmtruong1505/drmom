import 'package:bpg_retail/core/constants/api_constants.dart';
import 'package:bpg_retail/core/configs/dio_config.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeService {
  HomeService(
    this._baseDio,
  );

  final BaseDio _baseDio;

  // Future<dynamic> formulaEcommerceList() async {
  //   final res = await _baseDio.post(
  //     Api.formulaEcommerceList,
  //     data: {},
  //   );
  //   return res.data;
  // }

  // Future<dynamic> categoryEcommerceList() async {
  //   final res = await _baseDio.get(
  //     Api.categoryEcommerceList,
  //     data: {},
  //   );
  //   return res.data;
  // }

  // Future<dynamic> formulaRatingTm(List<int> formulaIds) async {
  //   final res = await _baseDio.post(
  //     Api.formulaRatingTm,
  //     data: {
  //       "formula_id": formulaIds,
  //     },
  //   );
  //   return res.data;
  // }

  Future<dynamic> getCategories() async {
    final res = await _baseDio.get(Api.categories);
    return res.data;
  }

  Future<dynamic> getProducts(
    String? search,
    int page,
    int? boothId,
    int? categoryId,
  ) async {
    final data = {
      "search": search,
      "page": page,
      "limit": 10,
    };

    final res = await _baseDio.get(Api.productsV2, data: data);
    return res.data;
  }

  Future<dynamic> getProductDetail(int id) async {
    final res = await _baseDio.get("${Api.productsV2}/$id");
    return res.data;
  }
}
