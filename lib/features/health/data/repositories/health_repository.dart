import 'package:drmom/core/base/base_response.dart';
import 'package:drmom/features/health/data/models/health_post_model.dart';
import 'package:drmom/features/health/data/models/news_category_model.dart';
import 'package:drmom/features/health/data/services/health_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class HealthRepository {
  final HealthService _healthService;

  HealthRepository(this._healthService);

  Future<BaseResponseModel<List<HealthPostModel>>> getHealthPosts() async {
    try {
      final resData = await _healthService.getHealthPosts();

      final int? resStatus = resData['status'];
      final bool? success = resData['success'];
      final String? message = resData['message'];
      final dynamic metadata = resData['metadata'];

      List<HealthPostModel> posts = [];
      if (resData['data'] is List) {
        posts = (resData['data'] as List)
            .map((item) => HealthPostModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      return BaseResponseModel<List<HealthPostModel>>(
        status: resStatus,
        success: success,
        message: message,
        data: posts,
        metadata: metadata,
      );
    } catch (err) {
      return BaseResponseModel<List<HealthPostModel>>(
        status: 400,
        message: 'Đã có lỗi xảy ra khi tải bài viết sức khỏe',
        success: false,
        data: [],
      );
    }
  }

  Future<BaseResponseModel<List<NewsCategoryModel>>> getNewsCategories() async {
    try {
      final resData = await _healthService.getNewsCategories();

      final int? resStatus = resData['status'];
      final bool? success = resData['success'];
      final String? message = resData['message'];
      final dynamic metadata = resData['metadata'];

      List<NewsCategoryModel> categories = [];
      if (resData['data'] is List) {
        categories = (resData['data'] as List)
            .map((item) => NewsCategoryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      return BaseResponseModel<List<NewsCategoryModel>>(
        status: resStatus,
        success: success,
        message: message,
        data: categories,
        metadata: metadata,
      );
    } catch (err) {
      return BaseResponseModel<List<NewsCategoryModel>>(
        status: 400,
        message: 'Đã có lỗi xảy ra khi tải danh mục tin tức',
        success: false,
        data: [],
      );
    }
  }
}
