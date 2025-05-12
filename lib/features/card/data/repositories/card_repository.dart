import 'package:BGP_Retail/core/configs/dio_config.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/features/card/data/models/card_model.dart';

import '../../../../core/base/base_response.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/card_order_model.dart';
import '../models/my_card_model.dart';

class CardRepository {
  final _dio = getIt<BaseDio>();
  Future<BaseResponseModel<List<CardModel>>> cards(int page) async {
    final List<CardModel> list = [];
    try {
      final res = await _dio.get(
        Api.cards,
        data: {'page': page},
      );

      if (res.data['data'] is List) {
        for (final json in res.data['data']) {
          list.add(CardModel.fromJson(json));
        }
      }

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<CardOrderModel>> createOrder({
    required int cardId,
    required int qty,
  }) async {
    try {
      final res = await _dio.post(
        Api.cardOrder,
        data: {
          "card": cardId,
          "quantity": qty,
        },
      );

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data is Map ? CardOrderModel.fromMap(res.data['data']) : null,
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<MyCardModel>>> myCards() async {
    final List<MyCardModel> list = [];
    try {
      final res = await _dio.get(
        Api.myCards,
      );

      for (final json in res.data['data'] ?? []) {
        list.add(MyCardModel.fromJson(json));
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
}
