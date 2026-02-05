import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/order/data/models/order_count_asbc_model.dart';

part 'total_order_state.freezed.dart';

@freezed
abstract class TotalOrderState with _$TotalOrderState {
  const factory TotalOrderState({
    @Default(CubitStatus.init) CubitStatus status,
    List<OrderCountAsbcModel>? totalOrder,
  }) = _TotalOrderState;
}
