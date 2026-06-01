import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:drmom/core/utilities/enum.dart';
import 'package:drmom/features/health/data/models/health_post_model.dart';
import 'package:drmom/features/health/data/models/news_category_model.dart';

part 'health_state.freezed.dart';

@freezed
abstract class HealthState with _$HealthState {
  const factory HealthState({
    @Default([]) List<HealthPostModel> posts,
    @Default([]) List<NewsCategoryModel> categories,
    @Default('Tất cả') String selectedCategory,
    @Default('') String searchKeyword,
    @Default(CubitStatus.init) CubitStatus status,
    @Default('') String message,
  }) = _HealthState;
}
