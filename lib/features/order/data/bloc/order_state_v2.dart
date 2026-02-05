import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/widgets/buttons/filter_button.dart';
import 'package:bpg_retail/features/order/data/models/order_asbc_model.dart';
import 'package:bpg_retail/features/order/data/models/order_count_asbc_model.dart';
import 'package:bpg_retail/features/order/data/models/order_model_v2.dart';

part 'order_state_v2.freezed.dart';

@freezed
abstract class OrderStateV2 with _$OrderStateV2 {
  const factory OrderStateV2({
    @Default(false) bool isLoading,
    @Default(true) bool isShowBg,
    @Default(CubitStatus.loadMore) CubitStatus status,
    @Default(FilterButtonModel(title: "Tất cả", value: null))
    FilterButtonModel filter,
    List<OrderAsbcModel>? orders,
    List<OrderCountAsbcModel>? count,
  }) = _OrderStateV2;
}
