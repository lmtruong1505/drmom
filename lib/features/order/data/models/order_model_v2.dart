import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/features/authentication/data/models/user_model.dart';
import 'package:BGP_Retail/features/product/data/models/category_model.dart';

part 'order_model_v2.g.dart';
part 'order_model_v2.freezed.dart';

@freezed
class OrderModelV2 with _$OrderModelV2 {
  const factory OrderModelV2({
    final int? id,
    @JsonKey(name: 'total_price') final num? totalPrice,
    @JsonKey(name: 'order_code') final String? orderCode,
    @JsonKey(name: 'user_created') final UserModel? userCreated,
    final StatusModel? status,
    @JsonKey(name: 'flow_path') final String? flowPath,
    final GroceryModel? grocery,
    @JsonKey(name: 'order_items') final List<OrderItem>? orderItems,
    @JsonKey(name: 'total_items') final num? totalItems,
  }) = _OrderModelV2;

  factory OrderModelV2.fromJson(Map<String, dynamic> json) =>
      _$OrderModelV2FromJson(json);
}

@freezed
class GroceryModel with _$GroceryModel {
  const factory GroceryModel({
    final int? id,
    final String? fullname,
    @JsonKey(name: 'account_code') final String? accountCode,
    @JsonKey(name: 'phone_number') final String? phoneNumber,
    final String? address,
  }) = _GroceryModel;

  factory GroceryModel.fromJson(Map<String, dynamic> json) =>
      _$GroceryModelFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    @JsonKey(name: 'price_list_unit_id') final int? priceListUnitId,
    @JsonKey(name: 'product_unit_id') final int? productUnitId,
    final num? quantity,
    @JsonKey(name: 'product_name') final String? productName,
    final ImageModel? image,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
class StatusModel with _$StatusModel {
  const factory StatusModel({
    final String? label,
    final String? value,
  }) = _StatusModel;

  factory StatusModel.fromJson(Map<String, dynamic> json) =>
      _$StatusModelFromJson(json);
}
