import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/features/booth/data/models/booth_model.dart';
import 'package:bpg_retail/features/order/data/models/order_model.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';

import '../models/delivery_price_model.dart';

part 'cart_state.freezed.dart';

@freezed
abstract class CartState with _$CartState {
  const factory CartState({
    @Default(null) OrderPayloadModel? orderPayload,
    @Default(null) AddressModel? addressSelected,
    @Default(null) BoothModel? boothSelected,
    @Default([]) List<BoothModel> booths,
    @Default(false) bool isLoading,
    @Default(DeliveryType.pickUp) DeliveryType deliverySelected,
    DeliveryPriceModel? priceSelected,
  }) = _CartState;
}

enum DeliveryType {
  pickUp,
  shipping,
}

// enum CubitStatus {
//   init,
//   loading,
//   loaded,
//   success,
//   error,
//   loadMore,
//   sendSuccess,
//   sendFaild
// }
