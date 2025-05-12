import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/features/order/data/models/order_detail_model.dart';
part 'ratting_order_state.freezed.dart';

@freezed
class RattingOrderState with _$RattingOrderState {
  const factory RattingOrderState({
    final OrderDetailModel? order,
    @Default(false) final bool? isLoading,
    @Default(false) final bool? hasUpdate,
    @Default(CubitStatus.init) final CubitStatus? status,
  }) = _RattingOrderState;
}
