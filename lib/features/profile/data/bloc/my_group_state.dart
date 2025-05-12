import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/features/profile/data/models/my_group_model.dart';
part 'my_group_state.freezed.dart';

@freezed
class MyGroupState with _$MyGroupState {
  const factory MyGroupState({
    final List<MyGroupModel>? listGroup,
    final int? total,
    @Default(true) final bool isLoading,
    @Default(CubitStatus.init) final CubitStatus status,
  }) = _MyGroupState;
}
