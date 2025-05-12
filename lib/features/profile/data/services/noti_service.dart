import 'package:BGP_Retail/core/constants/api_constants.dart';
import 'package:BGP_Retail/core/configs/dio_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class NotiService {
  NotiService(
    this._baseDio,
  );

  final BaseDio _baseDio;

  Future<dynamic> getListNoti(
    Map<String, dynamic> payload,
  ) async {
    final res = await _baseDio.post(
      '${Api.notiURL}/list_notifi',
      data: payload,
    );
    return res.data;
  }
}
