import 'package:BGP_Retail/core/base/base_response.dart';
import 'package:BGP_Retail/core/configs/dio_config.dart';
import 'package:BGP_Retail/core/constants/api_constants.dart';
import 'package:BGP_Retail/core/injection/injection.dart';

import '../models/card_wallet_model.dart';

class WalletRepository {
  final _dio = getIt<BaseDio>();
  Future<BaseResponseModel<List<CardWalletModel>>> wallets() async {
    final List<CardWalletModel> list = [];
    try {
      final res = await _dio.get(
        Api.wallets,
      );

      for (final json in res.data['data']) {
        list.add(CardWalletModel.formJson(json));
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

  Future<BaseResponseModel> updateBalanceWallets(
    num price,
  ) async {
    try {
      final res = await _dio.post(
        Api.updateWallets,
        data: {"total_money": price},
      );

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> witthdraw(int type) async {
    try {
      final res = await _dio.post(
        Api.withdraw,
        data: {
          'type': type,
        },
      );

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['data'],
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> confirmCashback() async {
    try {
      final res = await _dio.post(Api.confirmCashback);
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
