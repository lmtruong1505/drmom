import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/features/booth/data/models/first_gift_model.dart';
import 'package:BGP_Retail/features/home/data/model/product_model.dart';
import 'package:BGP_Retail/features/order/data/models/order_model_v2.dart';
import 'package:BGP_Retail/features/product/data/models/category_model.dart';

part 'order_detail_model.g.dart';
part 'order_detail_model.freezed.dart';

@freezed
class OrderDetailModel with _$OrderDetailModel {
  const factory OrderDetailModel({
    @JsonKey(name: 'order_id') final int? orderId,
    @JsonKey(name: 'order_code') final String? orderCode,
    @JsonKey(name: 'order_status') final String? orderStatus,
    final String? address,
    final String? reason,
    final ShippingModel? shipping,
    @JsonKey(name: 'phone_number') final String? phoneNumber,
    @JsonKey(name: 'total_price') final num? totalPrice,
    @JsonKey(name: 'payment_status') final num? paymentStatus,
    final String? note,
    final num? transport,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    @JsonKey(name: 'reason_date') final String? reasonDate,
    @JsonKey(name: 'customer_id') final CustomerId? customerId,
    final GroceryModel? grocery,
    @JsonKey(name: 'detail_promotions') final FirstGiftModel? gift,
    @JsonKey(name: 'order_items') final List<OrderItem>? orderItems,
  }) = _OrderDetailModel;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailModelFromJson(json);
}

@freezed
class CustomerId with _$CustomerId {
  const factory CustomerId({
    final int? id,
    final String? fullname,
    @JsonKey(name: 'account_code') final String? accountCode,
  }) = _CustomerId;

  factory CustomerId.fromJson(Map<String, dynamic> json) =>
      _$CustomerIdFromJson(json);
}

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    final int? id,
    @JsonKey(name: 'category_name') final String? categoryName,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    @JsonKey(name: 'product_id') final int? productId,
    @JsonKey(name: 'product_name') final String? productName,
    @JsonKey(name: 'product_code') final String? productCode,
    final CategoryModel? category,
    final RattingModel? ratting,
    final ImageModel? image,
    final List<UnitModel>? units,
    final List<String>? files,
    // @Default(false) final bool isUpdate,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
class ShippingModel with _$ShippingModel {
  const factory ShippingModel({
    @JsonKey(name: 'transport_order_number') final String? transportOrderNumber,
    @JsonKey(name: 'transport_fee') final num? transportFee,
    @JsonKey(name: 'transport_partner_code') final String? transportPartnerCode,
    @JsonKey(name: 'transport_name') final String? transportName,
    @JsonKey(name: 'transport_service') final String? transportService,
    @JsonKey(name: 'transport_partner_name') final String? transportPartnerName,
  }) = _ShippingModel;

  factory ShippingModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingModelFromJson(json);
}

@freezed
class RattingModel with _$RattingModel {
  const factory RattingModel({
    final int? id,
    @JsonKey(name: 'product_id') final int? productId,
    @Default(5.0) final double? star,
    final String? comment,
    @JsonKey(name: 'user_created') final String? userCreated,
    final List<ImageModel>? images,
    @JsonKey(includeFromJson: false) final TextEditingController? note,
  }) = _RattingModel;

  factory RattingModel.fromJson(Map<String, dynamic> json) =>
      _$RattingModelFromJson(json);
}
