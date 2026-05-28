import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:drmom/core/utilities/enum.dart';
import 'package:drmom/features/dashboard/data/models/post_model.dart';

part 'post_state.freezed.dart';

@freezed
abstract class PostState with _$PostState {
  const factory PostState({
    @Default([]) List<PostModel> posts,
    @Default(CubitStatus.init) CubitStatus status,
    @Default('') String message,
  }) = _PostState;
}
