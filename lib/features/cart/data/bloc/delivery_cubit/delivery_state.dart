import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/features/cart/data/models/delivery_model.dart';
import 'package:bpg_retail/features/cart/data/models/ghtk_model.dart';

import '../../models/delivery_price_model.dart';

part 'delivery_state.freezed.dart';

@freezed
abstract class DeliveryState with _$DeliveryState {
  const factory DeliveryState({
    @Default(true) bool isLoading,
    @Default([]) List<DeliveryPriceModel> list,
    @Default([]) List<ViettelPostModel> lstviettelPost,
    GHTKModel? ghtk,
    DeliveryTypeModel? deliverySelect,
    DeliveryPriceModel? itemSelected,
  }) = _DeliveryState;
}
