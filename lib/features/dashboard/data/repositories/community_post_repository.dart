import 'package:drmom/core/base/base_response.dart';
import 'package:drmom/features/dashboard/data/models/community_post_model.dart';
import 'package:drmom/features/dashboard/data/services/community_post_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class CommunityPostRepository {
  final CommunityPostService _communityPostService;

  CommunityPostRepository(this._communityPostService);

  Future<BaseResponseModel<List<CommunityPostModel>>> getCommunityPosts({
    int page = 1,
    int pageSize = 20,
    int status = 2,
  }) async {
    try {
      final resData = await _communityPostService.getCommunityPosts(
        page: page,
        pageSize: pageSize,
        status: status,
      );

      final int? resStatus = resData['status'];
      final bool? success = resData['success'];
      final String? message = resData['message'];
      final dynamic metadata = resData['metadata'];

      List<CommunityPostModel> posts = [];
      if (resData['data'] is List) {
        posts = (resData['data'] as List)
            .map((item) => CommunityPostModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      return BaseResponseModel<List<CommunityPostModel>>(
        status: resStatus,
        success: success,
        message: message,
        data: posts,
        metadata: metadata,
      );
    } catch (err) {
      return BaseResponseModel<List<CommunityPostModel>>(
        status: 400,
        message: 'Đã có lỗi xảy ra khi tải bài viết cộng đồng',
        success: false,
        data: [],
      );
    }
  }
}
