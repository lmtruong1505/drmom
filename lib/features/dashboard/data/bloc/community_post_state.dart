import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:drmom/core/utilities/enum.dart';
import 'package:drmom/features/dashboard/data/models/community_post_model.dart';

part 'community_post_state.freezed.dart';

@freezed
abstract class CommunityPostState with _$CommunityPostState {
  const factory CommunityPostState({
    @Default([]) List<CommunityPostModel> posts,
    @Default(CubitStatus.init) CubitStatus status,
    @Default('') String message,
  }) = _CommunityPostState;
}
