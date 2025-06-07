import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bpg_retail/features/product/data/models/formula_model.dart';
import 'package:bpg_retail/features/product/data/models/unit_price_model.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderResponseModel {
  final int total;
  final List<OrderModel> results;
  @JsonKey(name: 'total_draft')
  final int totalDraft;
  @JsonKey(name: 'total_approved')
  final int totalApproved;
  @JsonKey(name: 'total_shipping')
  final int totalShipping;
  @JsonKey(name: 'total_delivered')
  final int totalDelivered;
  @JsonKey(name: 'total_done')
  final int totalDone;
  @JsonKey(name: 'total_return')
  final int totalReturn;
  @JsonKey(name: 'total_cancel')
  final int totalCancel;

  OrderResponseModel({
    required this.total,
    required this.results,
    required this.totalDraft,
    required this.totalApproved,
    required this.totalShipping,
    required this.totalDelivered,
    required this.totalDone,
    required this.totalReturn,
    required this.totalCancel,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseModelToJson(this);
}

@JsonSerializable()
class LineItemModel {
  final double price;
  @JsonKey(name: 'product_id')
  final int productId;
  @JsonKey(name: 'product_name')
  final String productName;
  @JsonKey(name: 'price_formula_id')
  final int priceFormulaId;
  @JsonKey(name: 'formula_id')
  final int formulaId;
  @JsonKey(name: 'unit_select')
  final UnitPriceModel unitSelect;
  @JsonKey(name: 'total_quantity')
  final double totalQuantity;
  @JsonKey(name: 'formula_name')
  final String formulaName;
  final String? barcode;
  @JsonKey(name: 'mass_in')
  final double? massIn;
  @JsonKey(name: 'mass_out')
  final double? massOut;
  final List<UnitPriceModel> unit;
  final String? image;

  LineItemModel({
    required this.price,
    required this.productId,
    required this.productName,
    required this.priceFormulaId,
    required this.formulaId,
    required this.unitSelect,
    required this.totalQuantity,
    required this.formulaName,
    this.barcode,
    this.massIn,
    this.massOut,
    required this.unit,
    this.image,
  });

  factory LineItemModel.fromJson(Map<String, dynamic> json) =>
      _$LineItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$LineItemModelToJson(this);
}

@JsonSerializable()
class OrderModel {
  final int id;
  final String? note;
  final String? address;
  final double? distance;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'order_code')
  final String orderCode;
  final String? reason;
  @JsonKey(name: 'reason_date')
  final String? reasonDate;
  @JsonKey(name: 'total_price')
  final double totalPrice;
  @JsonKey(name: 'total_delivery_cost')
  final double? totalDeliveryCost;
  @JsonKey(name: 'total_formula')
  final int totalFormula;
  final dynamic grocery;
  final dynamic customer;
  @JsonKey(name: 'flow_status')
  final dynamic flowStatus;
  @JsonKey(name: 'line_items')
  final List<LineItemModel> lineItems;
  @JsonKey(name: 'order_ratings')
  final FormulaRatingModel? orderRatings;
  @JsonKey(name: 'customer_info')
  OrderModel({
    required this.id,
    this.note,
    this.address,
    this.distance,
    required this.createdAt,
    required this.orderCode,
    this.reason,
    this.reasonDate,
    required this.totalPrice,
    this.totalDeliveryCost,
    required this.totalFormula,
    this.grocery,
    this.customer,
    required this.flowStatus,
    required this.lineItems,
    this.orderRatings,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  OrderModel copyWith({
    int? id,
    String? note,
    String? address,
    double? distance,
    String? createdAt,
    String? orderCode,
    String? reason,
    String? reasonDate,
    double? totalPrice,
    int? totalFormula,
    dynamic grocery,
    dynamic customer,
    dynamic flowStatus,
    List<LineItemModel>? lineItems,
    FormulaRatingModel? orderRatings,
  }) {
    return OrderModel(
      id: id ?? this.id,
      note: note ?? this.note,
      address: address ?? this.address,
      distance: distance ?? this.distance,
      createdAt: createdAt ?? this.createdAt,
      orderCode: orderCode ?? this.orderCode,
      reason: reason ?? this.reason,
      reasonDate: reasonDate ?? this.reasonDate,
      totalPrice: totalPrice ?? this.totalPrice,
      totalFormula: totalFormula ?? this.totalFormula,
      grocery: grocery ?? this.grocery,
      customer: customer ?? this.customer,
      flowStatus: flowStatus ?? this.flowStatus,
      lineItems: lineItems ?? this.lineItems,
      orderRatings: orderRatings ?? this.orderRatings,
    );
  }
}

@JsonSerializable()
class LineItemPayloadModel {
  @JsonKey(name: 'price_formula_id')
  final int priceFormulaId;
  final double quantity;

  LineItemPayloadModel({
    required this.priceFormulaId,
    required this.quantity,
  });

  factory LineItemPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$LineItemPayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$LineItemPayloadModelToJson(this);
}

@JsonSerializable()
class OrderPayloadModel {
  @JsonKey(name: 'grocery_id')
  final int groceryId;
  final String address;
  @JsonKey(name: 'customer_id')
  final int customerId;
  final double? distance;
  final String? note;
  @JsonKey(name: 'total_price')
  final double? totalPrice;
  @JsonKey(name: 'line_items')
  final List<LineItemPayloadModel> lineItems;
  @JsonKey(name: 'customer_info')
  dynamic customerInfo;
  @JsonKey(name: 'total_delivery_cost')
  final double? totalDeliveryCost;

  OrderPayloadModel({
    required this.groceryId,
    required this.address,
    required this.customerId,
    this.distance,
    this.note,
    this.totalPrice,
    required this.lineItems,
    this.customerInfo,
    this.totalDeliveryCost,
  });

  factory OrderPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$OrderPayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPayloadModelToJson(this);

  OrderPayloadModel copyWith({
    int? groceryId,
    String? address,
    int? customerId,
    double? distance,
    String? note,
    double? totalPrice,
    List<LineItemPayloadModel>? lineItems,
    dynamic customerInfo,
    double? totalDeliveryCost,
  }) {
    return OrderPayloadModel(
      groceryId: groceryId ?? this.groceryId,
      address: address ?? this.address,
      customerId: customerId ?? this.customerId,
      distance: distance ?? this.distance,
      note: note ?? this.note,
      totalPrice: totalPrice ?? this.totalPrice,
      lineItems: lineItems ?? this.lineItems,
      customerInfo: customerInfo ?? customerInfo,
      totalDeliveryCost: totalDeliveryCost ?? this.totalDeliveryCost,
    );
  }
}
