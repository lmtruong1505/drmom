import 'package:drmom/core/configs/dio_config.dart';
import 'package:drmom/core/constants/api_constants.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class CommunityPostService {
  final BaseDio _baseDio;

  CommunityPostService(this._baseDio);

  Future<dynamic> getCommunityPosts({
    int page = 1,
    int pageSize = 20,
    int status = 2,
  }) async {
    final res = await _baseDio.get(
      Api.posts,
      data: {
        'page': page,
        'page_size': pageSize,
        'status': status,
      },
    );
    return res.data;
  }
}
