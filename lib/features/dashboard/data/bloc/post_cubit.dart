import 'package:drmom/core/utilities/enum.dart';
import 'package:drmom/features/dashboard/data/repositories/post_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'post_state.dart';

@LazySingleton()
class PostCubit extends Cubit<PostState> {
  final PostRepository _postRepository;

  PostCubit(this._postRepository) : super(const PostState());

  Future<void> fetchFeaturedPosts({
    int pageSize = 9,
    bool force = false,
  }) async {
    if (!force && state.posts.isNotEmpty) return;
    emit(state.copyWith(status: CubitStatus.loading));
    try {
      final res = await _postRepository.getFeaturedPosts(pageSize: pageSize);
      if (res.success == true || res.status == 200) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            posts: res.data ?? [],
            message: res.message ?? '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CubitStatus.error,
            message: res.message ?? 'Lấy danh sách bài viết nổi bật thất bại',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.error, message: e.toString()));
    }
  } 
}
