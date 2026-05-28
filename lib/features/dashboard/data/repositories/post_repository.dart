import 'package:drmom/core/base/base_response.dart';
import 'package:drmom/features/dashboard/data/models/post_model.dart';
import 'package:drmom/features/dashboard/data/services/post_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class PostRepository {
  final PostService _postService;

  PostRepository(this._postService);

  Future<BaseResponseModel<List<PostModel>>> getFeaturedPosts({
    int page = 1,
    int pageSize = 9,
    String status = 'published',
  }) async {
    try {
      final resData = await _postService.getFeaturedPosts(
        page: page,
        pageSize: pageSize,
        status: status,
      );

      final int? resStatus = resData['status'];
      final bool? success = resData['success'];
      final String? message = resData['message'];
      final dynamic metadata = resData['metadata'];

      List<PostModel> posts = [];
      if (resData['data'] is List) {
        posts = (resData['data'] as List)
            .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      return BaseResponseModel<List<PostModel>>(
        status: resStatus,
        success: success,
        message: message,
        data: posts,
        metadata: metadata,
      );
    } catch (err) {
      return BaseResponseModel<List<PostModel>>(
        status: 400,
        message: 'Đã có lỗi xảy ra khi tải bài viết',
        success: false,
        data: [],
      );
    }
  }
}
