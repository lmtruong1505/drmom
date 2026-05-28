import 'package:drmom/core/base/base_response.dart';
import 'package:drmom/features/dashboard/data/models/hashtag_model.dart';
import 'package:drmom/features/dashboard/data/services/hashtag_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class HashtagRepository {
  final HashtagService _hashtagService;

  HashtagRepository(this._hashtagService);

  Future<BaseResponseModel<List<HashtagModel>>> getHashtags() async {
    try {
      final resData = await _hashtagService.getHashtags();
      
      final status = resData['status'];
      final success = resData['success'];
      final message = resData['message'];
      final metadata = resData['metadata'];
      
      List<HashtagModel> hashtagList = [];
      if (resData['data'] is List) {
        hashtagList = (resData['data'] as List)
            .map((item) => HashtagModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      
      return BaseResponseModel<List<HashtagModel>>(
        status: status,
        success: success,
        message: message,
        data: hashtagList,
        metadata: metadata,
      );
    } catch (err) {
      return BaseResponseModel<List<HashtagModel>>(
        status: 400,
        message: 'Đã có lỗi xảy ra',
        success: false,
        data: [],
      );
    }
  }
}
