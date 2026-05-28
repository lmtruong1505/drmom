import 'package:drmom/core/configs/dio_config.dart';
import 'package:drmom/core/constants/api_constants.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class PostService {
  final BaseDio _baseDio;

  PostService(this._baseDio);

  Future<dynamic> getFeaturedPosts({
    int page = 1,
    int pageSize = 9,
    String status = 'published',
  }) async {
    final res = await _baseDio.get(
      Api.newsPost,
      data: {
        'page': page,
        'page_size': pageSize,
        'status': status,
      },
    );
    return res.data;
  }
}
