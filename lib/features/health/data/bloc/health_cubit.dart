import 'package:drmom/core/base/base_response.dart';
import 'package:drmom/core/utilities/enum.dart';
import 'package:drmom/features/health/data/models/health_post_model.dart';
import 'package:drmom/features/health/data/models/news_category_model.dart';
import 'package:drmom/features/health/data/repositories/health_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'health_state.dart';

@LazySingleton()
class HealthCubit extends Cubit<HealthState> {
  final HealthRepository _healthRepository;

  HealthCubit(this._healthRepository) : super(const HealthState());

  Future<void> fetchHealthPosts({
    bool force = false,
  }) async {
    if (!force && state.posts.isNotEmpty) return;
    emit(state.copyWith(status: CubitStatus.loading));
    try {
      final results = await Future.wait([
        _healthRepository.getHealthPosts(),
        _healthRepository.getNewsCategories(),
      ]);

      final postsRes = results[0] as BaseResponseModel<List<HealthPostModel>>;
      final categoriesRes = results[1] as BaseResponseModel<List<NewsCategoryModel>>;

      if ((postsRes.success == true || postsRes.status == 200) &&
          (categoriesRes.success == true || categoriesRes.status == 200)) {
        final List<NewsCategoryModel> categories = [
          NewsCategoryModel(name: 'Tất cả', id: -1),
          ...(categoriesRes.data ?? []),
        ];

        emit(
          state.copyWith(
            status: CubitStatus.success,
            posts: postsRes.data ?? [],
            categories: categories,
            message: postsRes.message ?? '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CubitStatus.error,
            message: postsRes.message ??
                categoriesRes.message ??
                'Lấy dữ liệu sức khỏe thất bại',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.error, message: e.toString()));
    }
  }

  void changeCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void updateSearchKeyword(String keyword) {
    emit(state.copyWith(searchKeyword: keyword));
  }
}
