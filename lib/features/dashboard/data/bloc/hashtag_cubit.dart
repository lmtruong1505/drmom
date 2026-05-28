import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drmom/core/utilities/enum.dart';
import 'package:drmom/features/dashboard/data/repositories/hashtag_repository.dart';
import 'package:injectable/injectable.dart';

import 'hashtag_state.dart';

@LazySingleton()
class HashtagCubit extends Cubit<HashtagState> {
  final HashtagRepository _hashtagRepository;

  HashtagCubit(this._hashtagRepository) : super(const HashtagState());

  Future<void> fetchHashtags({bool force = false}) async {
    if (!force && state.hashtags.isNotEmpty) return;
    emit(state.copyWith(status: CubitStatus.loading));
    try {
      final res = await _hashtagRepository.getHashtags();
      if (res.success == true || res.status == 200) {
        emit(state.copyWith(
          status: CubitStatus.success,
          hashtags: res.data ?? [],
          message: res.message ?? '',
        ));
      } else {
        emit(state.copyWith(
          status: CubitStatus.error,
          message: res.message ?? 'Lấy danh sách hashtag thất bại',
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
