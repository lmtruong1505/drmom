import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/features/order/data/models/order_count_asbc_model.dart';

part 'total_order_state.freezed.dart';

@freezed
class TotalOrderState with _$TotalOrderState {
  const factory TotalOrderState({
    @Default(CubitStatus.init) CubitStatus status,
    List<OrderCountAsbcModel>? totalOrder,
  }) = _TotalOrderState;
}
