import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:drmom/core/utilities/enum.dart';
import 'package:drmom/features/dashboard/data/models/hashtag_model.dart';

part 'hashtag_state.freezed.dart';

@freezed
abstract class HashtagState with _$HashtagState {
  const factory HashtagState({
    @Default([]) List<HashtagModel> hashtags,
    @Default(CubitStatus.init) CubitStatus status,
    @Default('') String message,
  }) = _HashtagState;
}
