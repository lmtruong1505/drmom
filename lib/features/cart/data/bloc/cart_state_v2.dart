import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/widgets/dropdown_button.dart';
import 'package:bpg_retail/features/booth/data/models/booth_model.dart';
import 'package:bpg_retail/features/booth/data/models/first_gift_model.dart';
import 'package:bpg_retail/features/cart/data/models/account_bank_model.dart';
import 'package:bpg_retail/features/cart/data/models/cart_model_v2.dart';
import 'package:bpg_retail/features/cart/data/models/delivery_model.dart';
import 'package:bpg_retail/features/cart/data/models/ghtk_model.dart';
import 'package:bpg_retail/features/order/data/models/order_model.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';

import '../models/delivery_price_model.dart';

part 'cart_state_v2.freezed.dart';

@freezed
class CartStateV2 with _$CartStateV2 {
  const factory CartStateV2({
    @Default(null) OrderPayloadModel? orderPayload,
    @Default(null) AddressModel? addressSelected,
    @Default(null) BoothModel? boothSelected,
    @Default([]) List<CartModelV2> products,
    @Default([]) List<BoothModel> booths,
    @Default([]) List<AddressModel>? address,
    @Default(false) bool isSelectAll,
    @Default(false) bool isLoading,
    @Default(false) bool canOrder,
    @Default(DeliveryTypeModel(deliveryShipping: DeliveryShipping.pickUp))
    DeliveryTypeModel? deliverySelected,
    DropdownButtonModel? paymentMethod,
    @Default(CubitStatus.init) CubitStatus status,
    DeliveryPriceModel? priceSelected,
    @Default([]) List<ViettelPostModel> lstviettelPost,
    FirstGiftModel? gift,
    Uint8List? imageQr,
    AccountBankModel? accountBank,
    GHTKModel? ghtk,
  }) = _CartStateV2;
}
