import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drmom/core/utilities/enum.dart';
import 'package:drmom/features/dashboard/data/repositories/community_post_repository.dart';
import 'package:injectable/injectable.dart';

import 'community_post_state.dart';

@LazySingleton()
class CommunityPostCubit extends Cubit<CommunityPostState> {
  final CommunityPostRepository _communityPostRepository;

  CommunityPostCubit(this._communityPostRepository)
      : super(const CommunityPostState());

  Future<void> fetchCommunityPosts({int pageSize = 20, bool force = false}) async {
    if (!force && state.posts.isNotEmpty) return;
    emit(state.copyWith(status: CubitStatus.loading));
    try {
      final res =
          await _communityPostRepository.getCommunityPosts(pageSize: pageSize);
      if (res.success == true || res.status == 200) {
        emit(state.copyWith(
          status: CubitStatus.success,
          posts: res.data ?? [],
          message: res.message ?? '',
        ));
      } else {
        emit(state.copyWith(
          status: CubitStatus.error,
          message: res.message ?? 'Lấy danh sách bài viết cộng đồng thất bại',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: CubitStatus.error,
        message: e.toString(),
      ));
    }
  }
}
