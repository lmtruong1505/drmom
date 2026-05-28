import 'package:drmom/core/configs/dio_config.dart';
import 'package:drmom/core/constants/api_constants.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class HashtagService {
  final BaseDio _baseDio;

  HashtagService(this._baseDio);

  Future<dynamic> getHashtags() async {
    final res = await _baseDio.get(Api.hashtag);
    return res.data;
  }
}
